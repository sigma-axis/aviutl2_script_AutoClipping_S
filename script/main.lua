--information:AutoClipping_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトの不透明ピクセルを含む最小サイズなるように，上下左右端をクリッピングします．
--label:クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$track:αしきい値, min = 0, max = 100, step = 0.01
local thresh = 0

---$checksection:中心の位置を変更
local move_center = false

--group:余白,false
---$track:上余白, min = -4000, max = 4000, step = 1, scale = 0.05
local pad_u = 0

---$track:下余白, min = -4000, max = 4000, step = 1, scale = 0.05
local pad_d = 0

---$track:左余白, min = -4000, max = 4000, step = 1, scale = 0.05
local pad_l = 0

---$track:右余白, min = -4000, max = 4000, step = 1, scale = 0.05
local pad_r = 0

--group:有効無効,false
---$checksection:上除去
local enable_u = true

---$checksection:下除去
local enable_d = true

---$checksection:左除去
local enable_l = true

---$checksection:右除去
local enable_r = true

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  thresh: number?,
---     :  move_center: boolean|number|nil,
---     :  pad_u: number?,
---     :  pad_d: number?,
---     :  pad_l: number?,
---     :  pad_r: number?,
---     :  enable_u: boolean|number|nil,
---     :  enable_d: boolean|number|nil,
---     :  enable_l: boolean|number|nil,
---     :  enable_r: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@find_minmax:
---$include "find_minmax.hlsl"
]]
local obj, math, tonumber, type, ffi = obj, math, tonumber, type, require("ffi");

--#region PI / normalize parameters.

-- take parameters.
local function as_bool(t, v)
	if type(t) == "boolean" then return t;
	elseif type(t) == "number" then return t ~= 0;
	else return v end
end
pad_u = tonumber(PI.pad_u) or pad_u;
pad_d = tonumber(PI.pad_d) or pad_d;
pad_l = tonumber(PI.pad_l) or pad_l;
pad_r = tonumber(PI.pad_r) or pad_r;
enable_u = as_bool(PI.enable_u, enable_u);
enable_d = as_bool(PI.enable_d, enable_d);
enable_l = as_bool(PI.enable_l, enable_l);
enable_r = as_bool(PI.enable_r, enable_r);
thresh = tonumber(PI.thresh) or thresh;
move_center = as_bool(PI.move_center, move_center);

-- normalize paramters.
pad_u = math.floor(0.5 + pad_u);
pad_d = math.floor(0.5 + pad_d);
pad_l = math.floor(0.5 + pad_l);
pad_r = math.floor(0.5 + pad_r);
thresh = math.min(math.max(thresh / 100, 0), 1 - 2 ^ -24);

--#endregion PI / normalize parameters.

-- early return for obvious cases.
local w, h = obj.w, obj.h;
if not (enable_u or enable_d or enable_l or enable_r) and
	(pad_u == 0 and pad_d == 0 and pad_l == 0 and pad_r == 0) then return end
if w + pad_l + pad_r <= 0 or h + pad_u + pad_d <= 0 then obj.load("text", ""); return end

-- find boudaries.
if enable_u or enable_d or enable_l or enable_r then
	-- prepare for shaders.
	local cache_name = "cache:auto_clipping_s/stat";
	obj.clearbuffer(cache_name, h, 1);
	obj.pixelshader("find_minmax", cache_name, "object", { w, thresh });
	local data = obj.getpixeldata(cache_name);
	local ptr = ffi.cast("uint32_t*", data);

	-- find top and bottom.
	local l, r, u, d = w, -1, h, -1;
	for y = 0, h - 1 do
		local v = ptr[y];
		if v >= 2 ^ 31 then
			v = v - 2 ^ 31;
			local m, M = v % 2 ^ 16, math.floor(v / 2 ^ 16);
			l, r = math.min(l, m), math.max(r, M);
			u, d = math.min(u, y) , math.max(d, y);
		end
	end
	if r < 0 then obj.load("text", ""); return end

	-- calculate the amount to crop / pad.
	if enable_u then pad_u = pad_u - u end
	if enable_d then pad_d = pad_d - (h - (d + 1)) end
	if enable_l then pad_l = pad_l - l end
	if enable_r then pad_r = pad_r - (w - (r + 1)) end
end

-- crop / pad the image.
if w + pad_l + pad_r <= 0 or h + pad_u + pad_d <= 0 then obj.load("text", ""); return;
elseif w + pad_l <= 0 or w + pad_r <= 0 or h + pad_u <= 0 or h + pad_d <= 0 then
	obj.clearbuffer("object", w + pad_l + pad_r, h + pad_u + pad_d);
else
	local U, D, L, R = pad_u, pad_d, pad_l, pad_r;
	while U < 0 or D < 0 or L < 0 or R < 0 do
		local clip_max = 4000;
		local u, d, l, r =
			math.min(math.max(-U, 0), clip_max), math.min(math.max(-D, 0), clip_max),
			math.min(math.max(-L, 0), clip_max), math.min(math.max(-R, 0), clip_max);
		U, D, L, R = U + u, D + d, L + l, R + r;
		obj.effect("クリッピング", "中心の位置を変更", 1,
			"上", u, "下", d, "左", l, "右", r);
	end
	while U > 0 or D > 0 or L > 0 or R > 0 do
		local extend_max = 4000;
		local u, d, l, r =
			math.min(math.max(U, 0), extend_max), math.min(math.max(D, 0), extend_max),
			math.min(math.max(L, 0), extend_max), math.min(math.max(R, 0), extend_max);
		U, D, L, R = U - u, D - d, L - l, R - r;
		obj.effect("領域拡張", "上", u, "下", d, "左", l, "右", r);
	end
end

-- adjust the center.
if not move_center then
	obj.cx, obj.cy = obj.cx + (pad_l - pad_r) / 2, obj.cy + (pad_u - pad_d) / 2;
end
