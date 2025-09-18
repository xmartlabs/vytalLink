import { spawnSync } from 'node:child_process';
import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const projectRoot = path.join(path.dirname(__filename), '..');

const paths = {
  sourceIcon: path.join(projectRoot, '..', 'mobile', 'icons', 'ic_launcher.png'),
  tempIcon: path.join(projectRoot, '.icon.tmp.png'),
  targetIcon: path.join(projectRoot, 'icon.png'),
  targetDir: projectRoot,
};

function ensureSipsAvailable() {
  const result = spawnSync('which', ['sips'], { encoding: 'utf8' });
  if (result.status !== 0 || !result.stdout.trim()) {
    throw new Error('The `sips` command is required to generate the icon but was not found on this system.');
  }
}

function runSips(args) {
  const result = spawnSync('sips', args, { encoding: 'utf8' });
  if (result.status !== 0) {
    throw new Error(`sips ${args.join(' ')} failed: ${result.stderr || result.stdout}`);
  }
}

async function verifySourceExists() {
  try {
    await fs.access(paths.sourceIcon);
  } catch {
    throw new Error(`Source icon not found at ${paths.sourceIcon}`);
  }
}

async function cleanup() {
  await fs.rm(paths.tempIcon, { force: true });
}

async function main() {
  ensureSipsAvailable();
  await verifySourceExists();

  await cleanup();
  await fs.mkdir(paths.targetDir, { recursive: true });

  // Crop the central square (50% of original on each dimension).
  runSips(['-c', '512', '512', paths.sourceIcon, '--out', paths.tempIcon]);

  // Resize to 256x256 keeping transparency.
  runSips(['-z', '256', '256', paths.tempIcon]);
  runSips(['-s', 'format', 'png', paths.tempIcon, '--out', paths.targetIcon]);

  await cleanup();
  console.info(`Icon regenerated at ${paths.targetIcon}`);
}

main().catch(async (error) => {
  console.error(error.message);
  await cleanup();
  process.exit(1);
});
