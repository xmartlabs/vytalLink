import { execSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';

const __filename = fileURLToPath(import.meta.url);
const projectRoot = path.join(path.dirname(__filename), '..');

async function packageExtension() {
  console.log('📦 Packaging vytalLink MCP extension...');
  
  const packageJsonPath = path.join(projectRoot, 'package.json');
  const manifestJsonPath = path.join(projectRoot, 'manifest.json');
  
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, 'utf-8'));
  const manifestJson = JSON.parse(fs.readFileSync(manifestJsonPath, 'utf-8'));

  let manifestUpdated = false;

  const buildAuthor = () => {
    const existing = manifestJson.author;
    const author = packageJson.author;

    if (!author) {
      return existing;
    }

    if (typeof author === 'string') {
      const match = author.match(/^(.*?)\s*(<([^>]+)>)?\s*(\(([^)]+)\))?$/);
      const name = match?.[1]?.trim() || existing?.name;
      const email = match?.[3]?.trim() || existing?.email;
      const url = existing?.url || packageJson.homepage || undefined;

      return {
        ...(name ? { name } : {}),
        ...(email ? { email } : {}),
        ...(url ? { url } : {}),
      };
    }

    if (typeof author === 'object') {
      return {
        ...(author.name ? { name: author.name } : existing?.name ? { name: existing.name } : {}),
        ...(author.email ? { email: author.email } : existing?.email ? { email: existing.email } : {}),
        ...(author.url ? { url: author.url } : existing?.url ? { url: existing.url } : {}),
      };
    }

    return existing;
  };

  const syncField = (pathSegments, value) => {
    if (value === undefined) {
      return;
    }

    const currentValue = pathSegments.reduce((acc, key) => (acc ? acc[key] : undefined), manifestJson);
    const serializedCurrent = JSON.stringify(currentValue);
    const serializedNext = JSON.stringify(value);

    if (serializedCurrent === serializedNext) {
      return;
    }

    let target = manifestJson;
    for (let i = 0; i < pathSegments.length - 1; i += 1) {
      const key = pathSegments[i];
      if (typeof target[key] !== 'object' || target[key] === null) {
        target[key] = {};
      }
      target = target[key];
    }

    const leafKey = pathSegments[pathSegments.length - 1];
    target[leafKey] = value;
    manifestUpdated = true;
    console.log(`🔄 Synced manifest field ${pathSegments.join('.')} → ${serializedNext}`);
  };

  syncField(['version'], packageJson.version);
  syncField(['keywords'], packageJson.keywords);
  syncField(['homepage'], packageJson.homepage);
  syncField(['repository'], packageJson.repository);
  syncField(['documentation'], packageJson.documentation);
  syncField(['support'], packageJson.bugs?.url ?? manifestJson.support);
  syncField(['author'], buildAuthor());

  if (manifestUpdated) {
    fs.writeFileSync(manifestJsonPath, JSON.stringify(manifestJson, null, 2) + '\n');
  }
  
  try {
    const packCommand = `npx @anthropic-ai/mcpb pack`;
    console.log(`Running: ${packCommand} in ${projectRoot}`);
    
    execSync(packCommand, { 
      cwd: projectRoot, 
      stdio: 'inherit',
      encoding: 'utf-8'
    });
    
    const defaultMcpbFile = path.join(projectRoot, 'mcp-server.mcpb');
    const distDir = path.join(projectRoot, 'dist');
    const finalMcpbFile = path.join(distDir, 'vytallink-mcp-server.mcpb');
    
    if (fs.existsSync(defaultMcpbFile)) {
      if (!fs.existsSync(distDir)) {
        fs.mkdirSync(distDir, { recursive: true });
      }
      
      fs.renameSync(defaultMcpbFile, finalMcpbFile);
      
      const stats = fs.statSync(finalMcpbFile);
      const sizeInMB = (stats.size / (1024 * 1024)).toFixed(1);
      console.log(`✅ Extension packaged successfully!`);
      console.log(`📁 Output: ${finalMcpbFile}`);
      console.log(`📏 Size: ${sizeInMB} MB`);
    } else {
      console.log(`✅ Extension packaged successfully!`);
      console.log(`📁 Output: Check current directory for .mcpb file`);
    }
    
  } catch (error) {
    console.error('❌ Packaging failed:', error.message);
    process.exit(1);
  }
}

packageExtension();
