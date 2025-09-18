import { execSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fs from 'node:fs';

const __filename = fileURLToPath(import.meta.url);
const projectRoot = path.join(path.dirname(__filename), '..');

async function packageExtension() {
  console.log('📦 Packaging vytalLink MCP extension...');
  
  try {
    const packCommand = `npx @anthropic-ai/mcpb pack`;
    console.log(`Running: ${packCommand} in ${projectRoot}`);
    
    execSync(packCommand, { 
      cwd: projectRoot, 
      stdio: 'inherit',
      encoding: 'utf-8'
    });
    
    // Check for generated .mcpb file and move it to dist/
    const defaultMcpbFile = path.join(projectRoot, 'mcp-server.mcpb');
    const distDir = path.join(projectRoot, 'dist');
    const finalMcpbFile = path.join(distDir, 'vytallink-mcp-server.mcpb');
    
    if (fs.existsSync(defaultMcpbFile)) {
      // Create dist directory if it doesn't exist
      if (!fs.existsSync(distDir)) {
        fs.mkdirSync(distDir, { recursive: true });
      }
      
      // Move to dist/ with descriptive name
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