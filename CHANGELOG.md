# 変更履歴 / CHANGELOG

このファイルはClaude・Codex間の引き継ぎ用です。
編集のたびに変更内容をここに記録してください。

---

## 2026-06-16 Claude
- GitHubリポジトリ（Majohng）を作成
- `mahjong-table-3d.html` をpush
- GitHub Pages を有効化
  - URL: https://kireibeya-nakamura.github.io/majohng/
- `index.html` を追加（GitHub Pages用）
- `CHANGELOG.md` を作成

---

## 2026-06-16 Claude（UI変更）
- 背景を暗いグレー系に変更（参考画像に合わせる）
  - `#stage` のグラデーション、3Dフェルトの色を変更
- 上部バーをスッキリ化（タイトル・ステータスを中央寄せ、戻す/クリア/効果音/設定ボタンを撤去）
- 戻す・クリア・効果音・設定ボタンを画面下部中央（パレット上）に移動
  - `#palbar` を縦並びに変更、`#ctrlrow`（操作ボタン行）と `#palrow`（牌パレット行）に分割
- リモートURLの大文字小文字を修正（majohng）

## 2026-06-16 Claude（重なり修正＋スタート画面）
- ①インターフェースと牌の重なりを修正
  - `CAM.stand` のカメラ位置/視点を調整（pos y:3.2→3.9、look y:0.9→0.3）し牌を画面上寄りに表示
- ②スタート画面を追加
  - `#startscreen`：すりガラス（backdrop-filter blur）のオーバーレイ＋「使用スタート」ボタン
  - スタート押下で `body.started` クラス付与 → ガラスが晴れる（blur→0）→ 牌が見える → 1秒遅れでUI（上部バー/パレット/カウント）がフェード＆ライズイン
  - 開始前はUIを非表示（opacity:0/pointer-events:none）

## 2026-06-16 Claude（カメラ＋DoF）
- カメラを正面寄り・低めに変更（ほぼ真正面から牌を見る）
  - `CAM.stand` pos:[0,1.25,12]、look:[0,0.42,1.2]
- FOVを望遠側に（`FOV=26`）して牌を大きく表示。fitCam/sizeResultPlaneの固定値42も`FOV`に統一
- 被写界深度（DoF）を追加：Three.js postprocessing の BokehPass
  - `loadPost()` でCDN（jsdelivr three@0.128.0 examples/js）からスクリプト読込→`initComposer()`でEffectComposer構築
  - `bokehPass` focus は毎フレーム注視点（curLook）までの距離に追従、aperture:0.018 maxblur:0.009
  - 読込/初期化失敗時は通常描画にフォールバック（usePost=false）
  - 注: BokehPassはモバイルGPU負荷あり。重い/効果が強すぎる場合は aperture/maxblur を調整

## 2026-06-16 Claude（ピンチズーム＋一人称視点の揺れ）
- ピンチイン/アウトでズーム（`userZoom` 0.55〜1.8、注視点からの距離をスケール）、PCはホイールでもズーム
- タッチ/カーソル追従の微小なカメラ揺れ（一人称視点風）
  - `swayX/swayY` を `tgtSwayX/Y`（ポインタ正規化座標×0.3/0.2）へ毎フレームイージング、`applyCam`で反映
  - スタンド時（camP<0.0001）のみ適用。リビール演出中は無効
- ポインタ管理 `ptrs`(Map) で多点タッチを追跡、`onPtrDown/Move/Up` 追加、wheelイベントでズーム

## 2026-06-16 Claude（揺れ強化＋待機時ゆらぎ）
- カメラ揺れの追従量を増加（ポインタ係数 0.3/0.2 → 0.55/0.36）
- 待機中も常にゆっくり揺れる「呼吸」ゆらぎを追加（loop内で時間ベースのsin/cos合成を target に加算）
- DoF・目線は IMG_0023.jpeg を理想として現状維持

## 2026-06-16 Claude（牌を上に＋ボタン配置）
- 牌を画面上寄りに（`CAM.stand` look y:0.42→0.12）
- 操作ボタン（戻す/クリア/効果音/設定 = `#ctrlrow`）を牌選択パレット（`#palrow`）の下に移動。牌との重なりを解消

## 2026-06-16 Claude（スクロール先に設定ボタン追加）
- 結果パネル（スクロール先 `#resultpanel`）に設定 `#rp-settings` を追加
  - 親/子（`who2`）、ロン/ツモ（`win2`）… 既存のgear内 who/win と双方向同期（`syncSeg`/`setDealer`/`setTsumo`）
  - 特殊役トグル `.tog`：海底摸月（haitei）、河底撈魚（houtei）、一発（ippatsu）
  - 海底/河底は排他。海底ON→ツモ自動、河底ON→ロン自動
- 状態に `haitei/houtei/ippatsu` を追加、`buildCtx` で反映（従来は固定false）
  - 一発は門前＋立直時のみ、海底はツモ時のみ、河底はロン時のみスコアに反映（採点エンジンの条件）

## 2026-06-16 Claude（パレット＆和了後レイアウト調整）
①パレット系
- 牌パレットを小さく（.pal button 56→42px、.calc も42pxに）
- パレットを中央揃え（.pal/.palrow に justify-content:center）
- 背景をぼかす：#palbar に backdrop-filter blur(14px) を追加＋DoF強化（aperture 0.018→0.032、maxblur 0.009→0.016）
②和了後
- スクロール案内「メニュー」(#scrollcue) を左下に小さく配置（中央→左下、フォント縮小、bobアニメ修正）
- スクロール先 #resultpanel 背景を緑→灰色（卓と同色）。役満時背景も灰系に
- 役名を横一列（牌の上 y≈0.16H）に表示、点数は下（y≈0.955H）、rankはその上
- 倒れた牌を1列に整列し中央より少し下（baseZ=2.25）、あがり牌は右端に隙間（extra）を空けて配置
- 牌のめり込み軽減：T.GAP 0.06→0.1、配置ジッターを縮小

## 2026-06-16 Claude（斜め配置＋ぼかしオフ＋パレット幅）
- あがり牌を右下手前に分離して配置（前の挙動に戻す）、牌列を右上がりの斜めに（IMG_0021再現）
  - buildHand: theta=-0.13でcos/sin配置、あがり牌は列右端より右下手前(z+0.95)・yaw0.42
- ぼかしを一旦すべてオフ：#palbar の backdrop-filter 削除、DoFを `DOF_ON=false` で無効化（コードは残置、trueで復活）
- パレット幅を縮小：.pal を flex:1 → flex:0 1 auto（中身幅にフィット、中央寄せ維持）
- 注：スタート画面のすりガラスは別機能のため維持（不要なら指示で消せます）

## 2026-06-16 Claude（牌配置を元に戻す）
- 斜め配置が不自然すぎたため、元のレイアウト（まっすぐな一列＋あがり牌を手前z+0.95に分離、牌ごとに微小なyawジッター）に戻す

---

## 引き継ぎ時の注意
- 作業前に必ず最新のコードをGitHubから確認すること
- 編集後はCHANGELOG.mdに記録してpushすること
- 同時編集はコンフリクトの原因になるため、交互に作業すること
