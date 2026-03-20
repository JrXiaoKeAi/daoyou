'use client';

import { useState, useEffect, useCallback } from 'react';

interface Player {
  id: string;
  userId: string;
  name: string;
  title: string | null;
  gender: string | null;
  realm: string;
  realmStage: string;
  age: number;
  status: string;
  spiritStones: number;
  createdAt: string;
  updatedAt: string;
}

interface PlayerFormData {
  name: string;
  title: string;
  gender: string;
  realm: string;
  realm_stage: string;
  age: string;
  lifespan: string;
  vitality: string;
  spirit: string;
  wisdom: string;
  speed: string;
  willpower: string;
  spirit_stones: string;
  status: string;
}

const REALMS = ['炼气', '筑基', '金丹', '元婴', '化神', '炼虚', '合体', '大乘', '渡劫', '仙人'];
const REALM_STAGES = ['初期', '中期', '后期', '圆满'];
const GENDERS = ['男', '女', '无'];
const STATUS_OPTIONS = ['active', 'dying', 'dead', 'ascended'];

export default function PlayersPage() {
  const [players, setPlayers] = useState<Player[]>([]);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [search, setSearch] = useState('');
  const [editingPlayer, setEditingPlayer] = useState<Player | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchPlayers = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams({
        page: page.toString(),
        pageSize: '20',
      });
      if (search) params.set('search', search);

      const response = await fetch(`/api/admin/players?${params.toString()}`, {
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) throw new Error('Failed to fetch');
      const data = await response.json();
      
      setPlayers(data.players || []);
      setTotalPages(data.totalPages || 1);
    } catch (err) {
      console.error('获取玩家列表失败:', err);
    } finally {
      setLoading(false);
    }
  }, [page, search]);

  useEffect(() => {
    fetchPlayers();
  }, [fetchPlayers]);

  const handleSave = async () => {
    if (!editingPlayer) return;
    setSaving(true);
    try {
      const updates = {
        name: editingPlayer.name,
        title: editingPlayer.title,
        gender: editingPlayer.gender,
        realm: editingPlayer.realm,
        realm_stage: editingPlayer.realmStage,
        age: editingPlayer.age,
        status: editingPlayer.status,
        spirit_stones: editingPlayer.spiritStones,
      };

      const response = await fetch('/api/admin/players', {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id: editingPlayer.id, updates }),
      });

      if (!response.ok) throw new Error('Failed to save');
      setEditingPlayer(null);
      fetchPlayers();
    } catch (err) {
      console.error('保存失败:', err);
      alert('保存失败');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <header className="border-ink/15 bg-paper/90 rounded-xl border p-6">
        <p className="text-ink-secondary text-xs tracking-[0.22em]">PLAYERS</p>
        <h2 className="font-heading text-ink mt-2 text-4xl">玩家管理</h2>
        <p className="text-ink-secondary mt-3 max-w-2xl text-sm leading-7">
          查看和修改玩家数据
        </p>
      </header>

      {/* 搜索栏 */}
      <div className="flex gap-4">
        <input
          type="text"
          placeholder="搜索玩家名称或ID..."
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

      {/* 玩家列表 */}
      <div className="border-ink/15 bg-paper/90 rounded-xl border overflow-hidden">
        {loading ? (
          <div className="p-8 text-center text-ink-secondary">加载中...</div>
        ) : players.length === 0 ? (
          <div className="p-8 text-center text-ink-secondary">暂无玩家数据</div>
        ) : (
          <table className="w-full">
            <thead className="bg-ink/5">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">名称</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">境界</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">年龄</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">灵石</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">状态</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">更新时间</th>
                <th className="px-4 py-3 text-left text-xs font-medium text-ink-secondary uppercase">操作</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-ink/10">
              {players.map((player) => (
                <tr key={player.id} className="hover:bg-ink/5">
                  <td className="px-4 py-3">
                    <div className="font-medium text-ink">{player.name}</div>
                    <div className="text-xs text-ink-secondary">{player.userId.slice(0, 8)}...</div>
                  </td>
                  <td className="px-4 py-3 text-ink">{player.realm} · {player.realmStage}</td>
                  <td className="px-4 py-3 text-ink">{player.age}</td>
                  <td className="px-4 py-3 text-ink">{player.spiritStones.toLocaleString()}</td>
                  <td className="px-4 py-3">
                    <span className={`px-2 py-1 text-xs rounded ${
                      player.status === 'active' ? 'bg-green/20 text-green' :
                      player.status === 'dead' ? 'bg-red/20 text-red' :
                      'bg-yellow/20 text-yellow'
                    }`}>
                      {player.status === 'active' ? '活跃' : 
                       player.status === 'dead' ? '死亡' : 
                       player.status === 'dying' ? '垂死' : '飞升'}
                    </span>
                  </td>
                  <td className="px-4 py-3 text-ink-secondary text-sm">
                    {new Date(player.updatedAt).toLocaleString('zh-CN')}
                  </td>
                  <td className="px-4 py-3">
                    <button
                      onClick={() => setEditingPlayer(player)}
                      className="text-crimson hover:underline text-sm"
                    >
                      编辑
                    </button>
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

      {/* 编辑弹窗 */}
      {editingPlayer && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-paper rounded-xl border border-ink/15 max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-ink/10">
              <h3 className="text-xl font-semibold text-ink">编辑玩家 - {editingPlayer.name}</h3>
              <p className="text-sm text-ink-secondary mt-1">ID: {editingPlayer.id}</p>
            </div>
            <div className="p-6 space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">名称</label>
                  <input
                    type="text"
                    value={editingPlayer.name}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, name: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">称号</label>
                  <input
                    type="text"
                    value={editingPlayer.title || ''}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, title: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">境界</label>
                  <select
                    value={editingPlayer.realm}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, realm: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  >
                    {REALMS.map(r => <option key={r} value={r}>{r}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">境界阶段</label>
                  <select
                    value={editingPlayer.realmStage}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, realmStage: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  >
                    {REALM_STAGES.map(s => <option key={s} value={s}>{s}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">性别</label>
                  <select
                    value={editingPlayer.gender || ''}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, gender: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  >
                    {GENDERS.map(g => <option key={g} value={g}>{g}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">年龄</label>
                  <input
                    type="number"
                    value={editingPlayer.age}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, age: parseInt(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">灵石</label>
                  <input
                    type="number"
                    value={editingPlayer.spiritStones}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, spiritStones: parseInt(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  />
                </div>
                <div>
                  <label className="block text-sm text-ink-secondary mb-1">状态</label>
                  <select
                    value={editingPlayer.status}
                    onChange={(e) => setEditingPlayer({ ...editingPlayer, status: e.target.value })}
                    className="w-full px-3 py-2 border border-ink/20 rounded-lg"
                  >
                    {STATUS_OPTIONS.map(s => (
                      <option key={s} value={s}>
                        {s === 'active' ? '活跃' : s === 'dead' ? '死亡' : s === 'dying' ? '垂死' : '飞升'}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
            </div>
            <div className="p-6 border-t border-ink/10 flex justify-end gap-3">
              <button
                onClick={() => setEditingPlayer(null)}
                className="px-4 py-2 border border-ink/20 rounded-lg"
              >
                取消
              </button>
              <button
                onClick={handleSave}
                disabled={saving}
                className="px-4 py-2 bg-crimson text-white rounded-lg hover:bg-crimson/80 disabled:opacity-50"
              >
                {saving ? '保存中...' : '保存'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
