import { withAdminAuth } from '@/lib/api/adminAuth';
import { getExecutor } from '@/lib/drizzle/db';
import { cultivators } from '@/lib/drizzle/schema';
import { eq, desc, sql, like, or } from 'drizzle-orm';
import { NextRequest, NextResponse } from 'next/server';

// 获取玩家列表
export const GET = withAdminAuth(async (request: NextRequest) => {
  const q = getExecutor();
  const { searchParams } = new URL(request.url);
  const page = parseInt(searchParams.get('page') || '1');
  const pageSize = parseInt(searchParams.get('pageSize') || '20');
  const search = searchParams.get('search') || '';
  const offset = (page - 1) * pageSize;

  try {
    // 构建查询条件
    const conditions = search
      ? or(
          like(cultivators.name, `%${search}%`),
          like(cultivators.userId, `%${search}%`)
        )
      : undefined;

    // 获取玩家列表（关联用户ID）
    const players = await q
      .select({
        id: cultivators.id,
        userId: cultivators.userId,
        name: cultivators.name,
        title: cultivators.title,
        gender: cultivators.gender,
        realm: cultivators.realm,
        realmStage: cultivators.realm_stage,
        age: cultivators.age,
        status: cultivators.status,
        spiritStones: cultivators.spirit_stones,
        createdAt: cultivators.createdAt,
        updatedAt: cultivators.updatedAt,
      })
      .from(cultivators)
      .where(conditions)
      .orderBy(desc(cultivators.updatedAt))
      .limit(pageSize)
      .offset(offset);

    // 获取总数
    const countResult = await q
      .select({ count: sql<number>`count(*)` })
      .from(cultivators)
      .where(conditions);

    const total = countResult[0]?.count || 0;

    return NextResponse.json({
      players,
      total,
      page,
      pageSize,
      totalPages: Math.ceil(total / pageSize),
    });
  } catch (error) {
    console.error('获取玩家列表失败:', error);
    return NextResponse.json({ error: '获取玩家列表失败' }, { status: 500 });
  }
});

// 更新玩家数据
export const PATCH = withAdminAuth(async (request: NextRequest) => {
  try {
    const q = getExecutor();
    const body = await request.json();
    const { id, updates } = body;

    if (!id || !updates) {
      return NextResponse.json({ error: '缺少必要参数' }, { status: 400 });
    }

    // 检查玩家是否存在
    const existing = await q
      .select()
      .from(cultivators)
      .where(eq(cultivators.id, id))
      .limit(1);

    if (!existing.length) {
      return NextResponse.json({ error: '玩家不存在' }, { status: 404 });
    }

    // 允许更新的字段
    const allowedFields = [
      'name',
      'title',
      'gender',
      'origin',
      'personality',
      'background',
      'realm',
      'realm_stage',
      'age',
      'lifespan',
      'status',
      'vitality',
      'spirit',
      'wisdom',
      'speed',
      'willpower',
      'spirit_stones',
      'max_skills',
    ];

    const filteredUpdates: Record<string, unknown> = {};
    for (const key of allowedFields) {
      if (updates[key] !== undefined) {
        filteredUpdates[key] = updates[key];
      }
    }

    if (Object.keys(filteredUpdates).length === 0) {
      return NextResponse.json({ error: '没有有效的更新字段' }, { status: 400 });
    }

    // 更新玩家数据
    await q
      .update(cultivators)
      .set({
        ...filteredUpdates,
        updatedAt: new Date(),
      })
      .where(eq(cultivators.id, id));

    return NextResponse.json({ success: true, message: '更新成功' });
  } catch (error) {
    console.error('更新玩家数据失败:', error);
    return NextResponse.json({ error: '更新玩家数据失败' }, { status: 500 });
  }
});
