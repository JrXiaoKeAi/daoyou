import { withAdminAuth } from '@/lib/api/adminAuth';
import { getExecutor } from '@/lib/drizzle/db';
import { cultivators } from '@/lib/drizzle/schema';
import { eq, desc, sql } from 'drizzle-orm';
import { NextRequest, NextResponse } from 'next/server';

// 获取用户列表（从 Supabase Auth）
export const GET = withAdminAuth(async (request: NextRequest) => {
  const { searchParams } = new URL(request.url);
  const page = parseInt(searchParams.get('page') || '1');
  const pageSize = parseInt(searchParams.get('pageSize') || '20');
  const search = searchParams.get('search') || '';
  const offset = (page - 1) * pageSize;

  try {
    // 获取用户列表
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_SUPABASE_URL}/rest/v1/rpc/get_all_users`,
      {
        headers: {
          'apikey': process.env.SUPABASE_AUTH_SERVICE_KEY!,
          'Authorization': `Bearer ${process.env.SUPABASE_AUTH_SERVICE_KEY}`,
        },
      }
    );

    let users: Array<{
      id: string;
      email: string;
      created_at: string;
      email_confirmed_at: string | null;
    }> = [];

    if (response.ok) {
      users = await response.json();
    }

    // 如果上面失败，尝试直接通过 cultivators 获取用户ID
    if (users.length === 0) {
      const q = getExecutor();
      const cultivatorUsers = await q
        .select({
          userId: cultivators.userId,
        })
        .from(cultivators)
        .groupBy(cultivators.userId);
      
      users = cultivatorUsers.map(c => ({
        id: c.userId,
        email: '',
        created_at: '',
        email_confirmed_at: null,
      }));
    }

    // 搜索过滤
    if (search) {
      users = users.filter(u => 
        u.email.toLowerCase().includes(search.toLowerCase()) ||
        u.id.toLowerCase().includes(search.toLowerCase())
      );
    }

    const total = users.length;
    const paginatedUsers = users.slice(offset, offset + pageSize);

    return NextResponse.json({
      users: paginatedUsers,
      total,
      page,
      pageSize,
      totalPages: Math.ceil(total / pageSize),
    });
  } catch (error) {
    console.error('获取用户列表失败:', error);
    return NextResponse.json({ error: '获取用户列表失败' }, { status: 500 });
  }
});

// 重置用户密码
export const POST = withAdminAuth(async (request: NextRequest) => {
  try {
    const body = await request.json();
    const { userId, newPassword } = body;

    if (!userId || !newPassword) {
      return NextResponse.json({ error: '缺少必要参数' }, { status: 400 });
    }

    // 使用 Supabase Admin API 重置密码
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_SUPABASE_URL}/auth/v1/admin/users/${userId}`,
      {
        method: 'PUT',
        headers: {
          'apikey': process.env.SUPABASE_AUTH_SERVICE_KEY!,
          'Authorization': `Bearer ${process.env.SUPABASE_AUTH_SERVICE_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ password: newPassword }),
      }
    );

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error_message || '重置密码失败');
    }

    return NextResponse.json({ success: true, message: '密码重置成功' });
  } catch (error) {
    console.error('重置密码失败:', error);
    return NextResponse.json({ error: '重置密码失败' }, { status: 500 });
  }
});

// 删除用户
export const DELETE = withAdminAuth(async (request: NextRequest) => {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId');

    if (!userId) {
      return NextResponse.json({ error: '缺少用户ID' }, { status: 400 });
    }

    // 删除用户
    const response = await fetch(
      `${process.env.NEXT_PUBLIC_SUPABASE_URL}/auth/v1/admin/users/${userId}`,
      {
        method: 'DELETE',
        headers: {
          'apikey': process.env.SUPABASE_AUTH_SERVICE_KEY!,
          'Authorization': `Bearer ${process.env.SUPABASE_AUTH_SERVICE_KEY}`,
        },
      }
    );

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error_message || '删除用户失败');
    }

    return NextResponse.json({ success: true, message: '用户已删除' });
  } catch (error) {
    console.error('删除用户失败:', error);
    return NextResponse.json({ error: '删除用户失败' }, { status: 500 });
  }
});
