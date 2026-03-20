import { withActiveCultivator } from '@/lib/api/withAuth';
import {
  buyMarketItem,
  getCompatibilityDefaults,
  MarketServiceError,
} from '@/lib/services/MarketService';
import { RealmType } from '@/types/constants';
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

const BuySchema = z.object({
  itemId: z.string().optional(),
  listingId: z.string().optional(),
  quantity: z.number().min(1).default(1),
});

/**
 * Deprecated compatibility route.
 * Prefer: POST /api/market/[nodeId]/buy
 */
export const POST = withActiveCultivator(
  async (request: NextRequest, { cultivator }) => {
    try {
      const body = await request.json();
      const parsed = BuySchema.parse(body);
      const listingId = parsed.listingId || parsed.itemId;

      if (!listingId) {
        return NextResponse.json({ error: '缺少 listingId' }, { status: 400 });
      }

      const { nodeId, layer } = getCompatibilityDefaults();
      const result = await buyMarketItem({
        nodeId,
        layer,
        listingId,
        quantity: parsed.quantity,
        cultivatorId: cultivator.id,
        cultivatorRealm: cultivator.realm as RealmType,
      });
      return NextResponse.json(result);
    } catch (error) {
      if (error instanceof MarketServiceError) {
        return NextResponse.json(
          { error: error.message },
          { status: error.status },
        );
      }
      if (error instanceof z.ZodError) {
        return NextResponse.json(
          { error: error.issues[0]?.message || '参数错误' },
          { status: 400 },
        );
      }
      console.error('Market compatibility buy API error:', error);
      return NextResponse.json({ error: '购买失败' }, { status: 500 });
    }
  },
);
