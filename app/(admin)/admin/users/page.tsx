'use client';

import { useState, useEffect, useCallback } from 'react';

interface User {
  id: string;
  email: string;
  created_at: string;
  email_confirmed_at: string | null;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [search, setSearch] = useState('');
  const [resettingUser, setResettingUser] = useState<User | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchUsers = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({
        page: page.toString(),
        pageSize: '20',
      });
      if (search) params.set('search', search);

      const response = await fetch(`/api/admin/users?${params.toString()}`, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) throw new Error('Failed to fetch');
      const data = await response.json();
      
      setUsers(data.users || []);
      setTotalPages(data.totalPages || 1);
    } catch (err) {
      console.error('获取用户列表失败:', err);
    } finally {
      setLoading(false);
    }
  }, [page, search]);

  useEffect(() => {
    fetchUsers();
  }, [fetchUsers]);

  const handleResetPassword = async () => {
    if (!resettingUser) return;
    setSaving(true);
    try {
      const response = await fetch('/api/admin/users', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ userId: resettingUser.id }),
      });

      if (!response.ok) throw new Error('Failed to reset password');
      alert('密码已重置为 123456');
      setResettingUser(null);
    } catch (err) {
      console.error('重置密码失败:', err);
      alert('重置密码失败');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <header className="border-ink/15 bg-paper/90 rounded-xl border p-6">
        <p className="text-ink-secondary text-xs tracking-[0.22em]">USERS</p>
        <h2 className="font-heading text-ink mt-2 text-4xl">用户账户管理</h2>
        <p className="text-ink-secondary mt-3 max-w-2xl text-sm leading-7">
          管理用户账号和密码重置
        </p>
      </header>

      {/* 搜索栏 */}
      <div className="flex gap-4">
        <input
          type="text"
          placeholder="搜索用户邮箱或ID..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && setPage(1)}
          className="flex-1 px-4 py-2 border border-ink/20 rounded-lg bg-paper text-ink"
        />
        <button
          onClick={() => setPage(1)}
          className="px-6 py-2 bg-crimson text-white rounded-lg hover:bg-crimson/80"
        >
          搜索
        </button>
      </div>

      {/* 用户列表 */}
      <div className="border-ink/15 bg-paper/90 rounded-xl border overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-ink-secondary">加载中...</div>
        ) : users.length === 0 ? (
          <div className="p-8 text-center text-ink-secondary">暂无用户数据</div>
        ) : (
          <table className="w-full">
            <thead className="bg-ink/5">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">用户ID</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">邮箱</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">注册时间</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">邮箱验证</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">操作</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-ink/10">
              {users.map((user) => (
                <tr key={user.id} className="hover:bg-ink/5">
                  <td className="px-4 py-3">
                    <div className="font-medium text-ink text-sm">{user.id.slice(0, 8)}...</div>
                  </td>
                  <td className="px-4 py-3 text-ink">
                    {user.email || '-'}
                  </td>
                  <td className="px-4 py-3 text-ink-secondary text-sm">
                    {user.created_at ? new Date(user.created_at).toLocaleString('zh-CN') : '-'}
                  </td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 text-xs rounded ${
                      user.email_confirmed_at ? 'bg-green/20 text-green' : 'bg-yellow/20 text-yellow'
                    }`}>
                      {user.email_confirmed_at ? '已验证' : '未验证'}
                    </span>
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex gap-2">
                      <button
                        onClick={() => setResettingUser(user)}
                        className="text-crimson hover:underline text-sm"
                      >
                        重置密码
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      {/* 分页 */}
      {totalPages > 1 && (
        <div className="flex justify-center gap-2">
          <button
            onClick={() => setPage(p => Math.max(1, p - 1))}
            disabled={page === 1}
            className="px-4 py-2 border border-ink/20 rounded-lg disabled:opacity-50"
          >
            上一页
          </button>
          <span className="px-4 py-2 text-ink-secondary">
            第 {page} / {totalPages} 页
          </span>
          <button
            onClick={() => setPage(p => Math.min(totalPages, p + 1))}
            disabled={page === totalPages}
            className="px-4 py-2 border border-ink/20 rounded-lg disabled:opacity-50"
          >
            下一页
          </button>
        </div>
      )}

      {/* 重置密码弹窗 */}
      {resettingUser && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-paper rounded-xl border border-ink/15 max-w-md w-full">
            <div className="p-6 border-b border-ink/10">
              <h3 className="text-xl font-semibold text-ink">重置密码</h3>
              <p className="text-sm text-ink-secondary mt-1">用户ID: {resettingUser.id.slice(0, 8)}...</p>
            </div>
            <div className="p-6">
              <p className="text-ink">
                确定要将该用户密码重置为 <strong>123456</strong> 吗？
              </p>
            </div>
            <div className="p-6 border-t border-ink/10 flex justify-end gap-3">
              <button
                onClick={() => setResettingUser(null)}
                className="px-4 py-2 border border-ink/20 rounded-lg"
              >
                取消
              </button>
              <button
                onClick={handleResetPassword}
                disabled={saving}
                className="px-4 py-2 bg-crimson text-white rounded-lg hover:bg-crimson/80 disabled:opacity-50"
              >
                {saving ? '重置中...' : '确认重置'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
