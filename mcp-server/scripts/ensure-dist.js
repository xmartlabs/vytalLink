import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const projectRoot = path.join(path.dirname(__filename), '..');
const distPath = path.join(projectRoot, 'dist');

fs.mkdirSync(distPath, { recursive: true });
