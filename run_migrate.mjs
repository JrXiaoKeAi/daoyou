import { readFileSync } from 'fs';
import postgres from './node_modules/.pnpm/postgres@3.4.8/node_modules/postgres/src/index.js';

const sql = postgres('postgresql://postgres:lijiuan88..@db.wgukhqgdmxmkqzxcnqxl.supabase.co:5432/postgres', {
  ssl: 'require',
  max: 1,
});

const content = readFileSync('./migrate_all.sql', 'utf8');
const statements = content.split('--> statement-breakpoint').map(s => s.trim()).filter(s => s.length > 0);

console.log(`共 ${statements.length} 条语句，开始执行...`);

let ok = 0, skip = 0, errors = 0;
for (const stmt of statements) {
  try {
    await sql.unsafe(stmt);
    ok++;
  } catch (e) {
    if (e.message.includes('already exists') || e.message.includes('does not exist')) {
      skip++;
    } else {
      errors++;
      console.error('错误: ' + e.message.substring(0, 120));
    }
  }
}

console.log(`完成！成功=${ok}  跳过(已存在)=${skip}  错误=${errors}`);
await sql.end();
