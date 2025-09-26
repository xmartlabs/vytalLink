import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const projectRoot = path.join(path.dirname(__filename), '..');

const readmePath = path.join(projectRoot, 'README.md');
const backupPath = path.join(projectRoot, '.README.md.prepack-backup');

const mode = process.argv[2];

function exists(filePath) {
  try {
    fs.accessSync(filePath);
    return true;
  } catch {
    return false;
  }
}

function prepare() {
  if (!exists(readmePath)) {
    console.info('No README.md found to move before packing.');
    return;
  }

  if (exists(backupPath)) {
    console.info('Backup README already present; skipping move.');
    return;
  }

  fs.renameSync(readmePath, backupPath);
  console.info('📄 README.md temporarily excluded from npm payload.');
}

function restore() {
  if (!exists(backupPath)) {
    return;
  }

  if (exists(readmePath)) {
    fs.unlinkSync(readmePath);
  }

  fs.renameSync(backupPath, readmePath);
  console.info('📄 README.md restored after packing.');
}

if (mode === 'prepare') {
  prepare();
} else if (mode === 'restore') {
  restore();
} else {
  console.error(`Unknown toggle mode: ${mode ?? '<none>'}`);
  process.exit(1);
}
