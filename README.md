# AutoClipping_S AviUtl ExEdit2 スクリプト

オブジェクトの不透明ピクセルを検索して，最小サイズなるよう上下左右端をクリッピングする AviUtl ExEdit 2 用のスクリプトです．

Mr-Ojii 様の [AutoClipping_M](https://github.com/Mr-Ojii/AviUtl-AutoClipping_M-Script) の移植・機能追加版であり，私の[余白除去σ](https://github.com/sigma-axis/aviutl_CropBlank_S)の移植版です．

[ダウンロードはこちら．](https://github.com/sigma-axis/aviutl2_script_AutoClipping_S/releases)

![使用例](https://github.com/user-attachments/assets/716b4c5e-0af5-4ae6-90e5-cb494a773395)

##  動作要件

- AviUtl ExEdit2

  http://spring-fragrance.mints.ne.jp/aviutl

  - `beta22` で動作確認済み．

##  導入方法

導入状況に応じて，以下のフォルダのいずれかに `AutoClipping_S.anm2` をコピーしてください．

- `aviutl2.exe` のあるフォルダに `data` フォルダが **ない** 場合．
  1.  `%ProgramData%` 内の `aviutl2/Script` フォルダ
      - 通常は `C:/ProgramData/aviutl2/Script` フォルダ
  1.  (1) のフォルダにある任意の名前のフォルダ

- `aviutl2.exe` のあるフォルダに `data` フォルダが **ある** 場合．
  1.  その `data` フォルダ内の `Script` フォルダ
  1.  (1) のフォルダにある任意の名前のフォルダ

初期状態だと「フィルタ効果を追加」メニューの「クリッピング」に AutoClipping_S が追加されています．
- 「オブジェクト追加メニューの設定」の「ラベル」項目で分類を変更できます．

##  パラメタの説明

<img width="500" height="528" alt="スクリプトの GUI" src="https://github.com/user-attachments/assets/1b57c78f-54d0-4f4c-911b-9d707bce45e5" />

### `上余白`, `下余白`, `左余白`, `右余白`

上下左右それぞれの余白幅を指定します．負値を指定するとさらにクリッピングします．

全てピクセル単位で最小値は `-4000`, 最大値は `4000`, 初期値は `0`.

### `上除去`, `下除去`, `左除去`, `右除去`

上下左右それぞれで，透明ピクセルを除去するかどうかを個別に指定します．

初期値は全て ON.

### `αしきい値`

各ピクセルを「不透明」と判断する，アルファ値のしきい値です．このしきい値以下のピクセルは「透明」，しきい値を超えるピクセルは「不透明」とみなされます．

% 単位で最小値は `0.00`, 最大値は `100.00`, 初期値は `0.00`.

- `100.00` を指定しても，アルファ値 100% のピクセルは「不透明」とみなされます．

### `中心の位置を変更`

拡張編集標準の「クリッピング」の「中心の位置を変更」と同様です．チェックを入れると見た目の回転中心が，フィルタ効果適用前と比べて移動します．

初期値は ON.

### `PI`

パラメタインジェクション (parameter injection) です．初期値は空欄. テーブル型の中身として解釈され，各種パラメタの代替値として使用されます．また，任意のスクリプトコードを実行する記述領域にもなります．

```lua
{
  pad_u = pad_u, -- number 型で "上余白" の項目を上書き，または nil.
  pad_d = pad_d, -- number 型で "下余白" の項目を上書き，または nil.
  pad_l = pad_l, -- number 型で "左余白" の項目を上書き，または nil.
  pad_r = pad_r, -- number 型で "右余白" の項目を上書き，または nil.
  enable_u = enable_u, -- boolean 型で "上除去" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  enable_d = enable_d, -- boolean 型で "下除去" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  enable_l = enable_l, -- boolean 型で "左除去" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  enable_r = enable_r, -- boolean 型で "右除去" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
  thresh = thresh, -- number 型で "αしきい値" の項目を上書き，または nil.
  move_center = move_center, -- boolean 型で "中心の位置を変更" の項目を上書き，または nil. 0 を false, 0 以外を true 扱いとして number 型も可能．
}
```
- テキストボックスには冒頭末尾の波括弧 (`{}`) を省略して記述してください．


##  TIPS

1.  [`上除去`, `下除去`, `左除去`, `右除去`](#上除去-下除去-左除去-右除去) を全て OFF にすれば「クリッピング」と「領域拡張」の両方を組み合わせたような，上位互換のフィルタ効果として使用できます．ただし...

    - 「クリッピング」のアンカー操作に相当することはできません．
    - 「領域拡張」の「塗りつぶし」に相当する機能はありません．


##  謝辞

- Mr-Ojii 様

  このスクリプトは，以前私が公開した[拡張編集フィルタプラグイン](https://github.com/sigma-axis/aviutl_CropBlank_S)が元になっていますが，そのアイデア元は Mr-Ojii 様のスクリプト [AutoClipping_M](https://github.com/Mr-Ojii/AviUtl-AutoClipping_M-Script) です．AviUtl ExEdit 2 の公開に伴って同じ機能を実装したものになります．

  実装手順もコードも元のものとは全く異なりますが，根本的な設計は同じです．礎となったスクリプトを開発してくださった Mr-Ojii 様には改めて感謝申し上げます．


## 改版履歴

- **v1.13 (for beta22)** (2025-12-01)

  - 設定項目を並び替え/グループ化して整理．

  - `beta22` での動作確認．

- **v1.12 (for beta15)** (2025-10-14)

  - ピクセルの不透明度を 1 / 255 刻みでしか判定できていなかったのを修正．

  - AviUtl2 本体の更新に伴って手順変更・高速化．

  - `beta15` での動作確認．

- **v1.11 (for beta12)** (2025-09-27)

  - 完全透明な画像に対して，ゴミ画像が残ったりエラーが発生していたのを修正．

  - `beta12` での動作確認．

- **v1.10 (for beta8)** (2025-08-24)

  - 不透明ピクセルの検索手順を変更．

  - `beta8` での動作確認，不要になったバグ対処用コードの削除．

- **v1.00 (for beta3)** (2025-07-27)

  - 初版．


## ライセンス

このプログラムの利用・改変・再頒布等に関しては MIT ライセンスに従うものとします．

---

The MIT License (MIT)

Copyright (C) 2025 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

https://mit-license.org/


#  連絡・バグ報告

- GitHub: https://github.com/sigma-axis
- Twitter: https://x.com/sigma_axis
- nicovideo: https://www.nicovideo.jp/user/51492481
- Misskey.io: https://misskey.io/@sigma_axis
- Bluesky: https://bsky.app/profile/sigma-axis.bsky.social
