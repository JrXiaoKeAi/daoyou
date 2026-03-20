'use client';

import { useState } from 'react';
import { createClient } from '@/lib/supabase/client';
import { useRouter } from 'next/navigation';

export default function SettingsPage() {
  const supabase = createClient();
  const router = useRouter();
  
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  const handleChangePassword = async () => {
    if (!currentPassword || !newPassword || !confirmPassword) {
      setMessage({ type: 'error', text: '请填写所有字段' });
      return;
    }

    if (newPassword !== confirmPassword) {
      setMessage({ type: 'error', text: '两次输入的密码不一致' });
      return;
    }

    if (newPassword.length < 6) {
      setMessage({ type: 'error', text: '新密码至少6位' });
      return;
    }

    setLoading(true);
    setMessage(null);

    try {
      const response = await fetch('/api/user/change-password', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ currentPassword, newPassword }),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || '修改密码失败');
      }

      setMessage({ type: 'success', text: '密码修改成功！' });
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    } catch (err) {
      setMessage({ type: 'error', text: err instanceof Error ? err.message : '修改密码失败' });
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push('/');
  };

  return (
    <div className="max-w-2xl mx-auto p-6 space-y-6">
      <div className="border-ink/15 bg-paper/90 rounded-xl border p-6">
        <h2 className="font-heading text-ink text-2xl mb-4">账号设置</h2>
        
        <div className="space-y-4">
          <div>
            <label className="block text-sm text-ink-secondary mb-1">当前密码</label>
            <input
              type="password"
              value={currentPassword}
              onChange={(e) => setCurrentPassword(e.target.value)}
              className="w-full px-3 py-2 border border-ink/20 rounded-lg bg-paper text-ink"
              placeholder="请输入当前密码"
            />
          </div>

          <div>
            <label className="block text-sm text-ink-secondary mb-1">新密码</label>
            <input
              type="password"
              value={newPassword}
              onChange={(e) => setNewPassword(e.target.value)}
              className="w-full px-3 py-2 border border-ink/20 rounded-lg bg-paper text-ink"
              placeholder="请输入新密码（至少6位）"
            />
          </div>

          <div>
            <label className="block text-sm text-ink-secondary mb-1">确认新密码</label>
            <input
              type="password"
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              className="w-full px-3 py-2 border border-ink/20 rounded-lg bg-paper text-ink"
              placeholder="请再次输入新密码"
            />
          </div>

          {message && (
            <div className={`p-3 rounded-lg ${
              message.type === 'success' ? 'bg-green/20 text-green' : 'bg-red/20 text-red'
            }`}>
              {message.text}
            </div>
          )}

          <button
            onClick={handleChangePassword}
            disabled={loading}
            className="w-full py-2 bg-crimson text-white rounded-lg hover:bg-crimson/80 disabled:opacity-50"
          >
            {loading ? '修改中...' : '修改密码'}
          </button>
        </div>
      </div>

      <div className="border-ink/15 bg-paper/90 rounded-xl border p-6">
        <h2 className="font-heading text-ink text-2xl mb-4">退出登录</h2>
        <button
          onClick={handleLogout}
          className="w-full py-2 border border-ink/20 rounded-lg hover:bg-ink/5"
        >
          退出登录
        </button>
      </div>
    </div>
  );
}
