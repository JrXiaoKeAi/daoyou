import { createClient } from '@supabase/supabase-js';
import 'dotenv/config';

// 使用 service role key 来创建用户（绕过 RLS）
const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://wgukhqgdmxmkqzxcnqxl.supabase.co',
  process.env.SUPABASE_AUTH_SERVICE_KEY || 'sb_secret_VVTiSk5fVcTRLZgvMN39Ow_Vh6cIAro'
);

async function setUserPassword() {
  const email = '1957002283@qq.com';
  const newPassword = 'Daoyou2024!';

  // 先获取用户ID
  const { data: users, error: listError } = await supabaseAdmin.auth.admin.listUsers();
  
  if (listError) {
    console.error('获取用户列表失败:', listError.message);
    return;
  }

  const user = users.users.find(u => u.email === email);
  
  if (!user) {
    console.error('用户不存在');
    return;
  }

  console.log('找到用户:', user.id, user.email);

  // 设置密码
  const { error } = await supabaseAdmin.auth.admin.updateUserById(
    user.id,
    { password: newPassword }
  );

  if (error) {
    console.error('设置密码失败:', error.message);
    return;
  }

  console.log('密码设置成功!');
  console.log('邮箱:', email);
  console.log('密码:', newPassword);
}

setUserPassword();
