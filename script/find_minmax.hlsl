Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float width, thresh;
};
static const int w = int(width);

float4 find_minmax(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	int l = w, r = -1;
	for (int x = 0; x < w; x++) {
		if (thresh < src[uint2(x, y)].a) {
			l = min(l, x); r = max(r, x);
		}
	}
	if (r < 0) return 0;
	const float4 c = int4(
		l & 0xff, 0x00 | ((l >> 8) & 0x7f),
		r & 0xff, 0x80 | ((r >> 8) & 0x7f)) / 255.0;
	return float4(c.a * c.rgb, c.a);
}
