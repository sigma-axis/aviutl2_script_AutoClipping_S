Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float width, thresh;
};
static const uint w = uint(width);

float4 find_minmax(float4 pos : SV_Position) : SV_Target
{
	const uint y = uint(pos.x);
	int pos_min = int(w), pos_max = -1;
	for (uint x = 0; x < w; x++) {
		if (thresh < src[uint2(x, y)].a) {
			pos_min = min(pos_min, int(x));
			pos_max = max(pos_max, int(x));
		}
	}
	if (pos_max < 0) return 0;
	const float4 c = uint4(
		pos_min & 0xff,
		(pos_min >> 8) & 0x7f,
		pos_max & 0xff,
		0x80 | ((pos_max >> 8) & 0x7f)) / 255.0;
	return float4(c.a * c.rgb, c.a);
}
