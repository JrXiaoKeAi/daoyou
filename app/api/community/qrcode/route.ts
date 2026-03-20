import { readFile } from 'fs/promises';
import { join } from 'path';

/**
 * 本地群二维码图片
 */
const QR_CODE_PATH = join(process.cwd(), 'public/assets/community-qrcode.jpg');

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const shouldDownload = searchParams.get('download') === '1';

  try {
    const image = await readFile(QR_CODE_PATH);
    const headers = new Headers({
      'Content-Type': 'image/jpeg',
      'Cache-Control': 'public, max-age=3600',
      'Content-Disposition': `${shouldDownload ? 'attachment' : 'inline'}; filename="daoyou-community-qrcode.jpg"`,
    });

    return new Response(image, { status: 200, headers });
  } catch {
    return Response.json(
      { success: false, error: '二维码加载失败' },
      { status: 404 },
    );
  }
}
