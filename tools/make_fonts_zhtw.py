"""
Re-render both FontSmall_zh-TW.png (12x12) and FontBig_zh-TW.png (16x16)
using WQY Zen Hei Sharp (Apache 2.0).

Pipeline per font:
  1. Parse Font.dat to get the right chars string.
  2. Render each glyph to an oversized temp canvas with PIL/freetype.
  3. Crop to ink box, clip to cell, paste centred.
  4. Write 8bpp paletted PNG (idx 0 = bg, idx 1 = fg).
"""

import os
import shutil
import yaml
from PIL import Image, ImageDraw, ImageFont

LANG     = r"D:\openxcom\OpenXcom\bin\common\Language"
FONT_DAT = os.path.join(LANG, "Font.dat")
WQY_TTC  = r"D:\openxcom\fontsrc\wqy-zenhei.ttc"
WQY_FACE = 2     # 0=Zen Hei, 1=Mono, 2=Sharp

# (font_id, image_file, cell_w, cell_h, glyph_px, cols)
# Compromise: cell 14/18 — bigger than baseline 12/16 (more legible) but
# small enough not to overflow vanilla 320x200 UI buttons (cell 24 did).
# xBRZ filter is disabled (broke mouse hit testing on main menu).
JOBS = [
    # v2.13: cell 12 — 16 overflows row layouts in many vintage states
    # (INTERCEPTION, UFOpedia article, etc). Trade-off: smaller chars but
    # rows don't overlap. User explicitly asked for smaller in 2026-05-31 14:??.
    ("FONT_SMALL",    "FontSmall_zh-TW.png",    12, 12, 12, 50),
    ("FONT_BIG",      "FontBig_zh-TW.png",      12, 12, 12, 50),
    # FONT_GEO_SMALL at 12×12: legibility good. Widget height 8 in vanilla
    # source causes minor「星期五」bottom-pixel clip, but cell 10 was too
    # aggressive (71% clip). Document as known limitation.
    # FontGeoSmall must stay 12 — it's used by Geoscape right-side menu
    # (攔截/基地/圖表/幽浮百科/選項/資金). Cell 10 + glyph 9 caused 71 char
    # clipping which broke those button labels.
    ("FONT_GEO_SMALL","FontGeoSmall_zh-TW.png", 12, 12, 12, 50),
]

def extract_chars(font_id: str, image_file: str) -> str:
    with open(FONT_DAT, encoding="utf-8") as f:
        doc = yaml.safe_load(f)
    for font in doc["fonts"]:
        if font["id"] != font_id:
            continue
        for img in font["images"]:
            if img["file"] == image_file:
                return "".join(img["chars"].split())
    raise SystemExit(f"{font_id} / {image_file} not found in Font.dat")

def render(chars: str, cell_w: int, cell_h: int, glyph_px: int, cols: int) -> Image.Image:
    rows  = (len(chars) + cols - 1) // cols
    img_w = cols * cell_w
    img_h = rows * cell_h

    img  = Image.new("L", (img_w, img_h), 0)
    font = ImageFont.truetype(WQY_TTC, glyph_px, index=WQY_FACE)

    pad = max(cell_w, cell_h) * 2
    overflow = 0

    for i, ch in enumerate(chars):
        tmp = Image.new("L", (pad, pad), 0)
        ImageDraw.Draw(tmp).text((pad // 4, pad // 4), ch, font=font, fill=255)
        bbox = tmp.getbbox()
        if bbox is None:
            continue
        crop = tmp.crop(bbox)

        if crop.width > cell_w or crop.height > cell_h:
            overflow += 1
            crop = crop.crop((0, 0, min(crop.width, cell_w), min(crop.height, cell_h)))

        cx = (i % cols) * cell_w + (cell_w - crop.width) // 2
        cy = (i // cols) * cell_h + (cell_h - crop.height) // 2
        img.paste(crop, (cx, cy))

    if overflow:
        print(f"  warning: {overflow}/{len(chars)} glyphs clipped to {cell_w}x{cell_h}")

    bw  = img.point(lambda v: 1 if v >= 128 else 0)
    out = Image.new("P", bw.size, 0)
    out.putpalette([0, 0, 0, 255, 255, 255] + [0] * (256 - 2) * 3)
    out.putdata(bw.tobytes())
    return out

def main():
    for font_id, image_file, cw, ch, gpx, cols in JOBS:
        print(f"=== {font_id} / {image_file} ({cw}x{ch}, glyph={gpx}px) ===")
        chars = extract_chars(font_id, image_file)
        print(f"  chars: {len(chars)}")
        out = render(chars, cw, ch, gpx, cols)
        print(f"  output: {out.size[0]}x{out.size[1]}")

        path = os.path.join(LANG, image_file)
        bak  = path + ".bak"
        if os.path.exists(path) and not os.path.exists(bak):
            shutil.copy2(path, bak)
            print(f"  backup: {bak}")
        out.save(path, optimize=True)
        print(f"  wrote:  {path}")

if __name__ == "__main__":
    main()
