import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';

export const POST = async (request: NextRequest) => {
  try {
    const supabase = await createClient();
    const body = await request.json();
    const { currentPassword, newPassword } = body;

    if (!currentPassword || !newPassword) {
      return NextResponse.json({ error: '缺少必要参数' }, { status: 400 });
    }

    if (newPassword.length < 6) {
      return NextResponse.json({ error: '新密码至少6位' }, { status: 400 });
    }

    const { data: { user }, error: getUserError } = await supabase.auth.getUser();
    
    if (getUserError || !user) {
      return NextResponse.json({ error: '未登录' }, { status: 401 });
    }

    const { error: signInError } = await supabase.auth.signInWithPassword({
      email: user.email || '',
      password: currentPassword,
    });

    if (signInError) {
      return NextResponse.json({ error: '当前密码不正确' }, { status: 400 });
    }

    const { error: updateError } = await supabase.auth.updateUser({
      password: newPassword,
    });

    if (updateError) {
      return NextResponse.json({ error: '修改密码失败' }, { status: 500 });
    }

    return NextResponse.json({ success: true, message: '密码修改成功' });
  } catch (error) {
    console.error('修改密码失败:', error);
    return NextResponse.json({ error: '修改密码失败' }, { status: 500 });
  }
};