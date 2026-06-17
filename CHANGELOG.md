# 変更履歴 / CHANGELOG

このファイルはClaude・Codex間の引き継ぎ用です。
編集のたびに変更内容をここに記録してください。

---

## 2026-06-17 Claude（点棒の支払い演出を実装）
- アガリ演出の最後に、点数分の点棒を画面手前外の上空から放物線で卓上へ放り投げる演出を追加
- 点棒モデルは手作り（細い箱 BoxGeometry + キャンバステクスチャの点パターン）。`Mahjong_Tenbow.fbx` は未使用（後で差し替え可）
- 額面ごとに点パターンを変更：100=黒点8 / 1000=赤点5 / 5000=青中央+赤 / 10000=金中央+虹
- `tenboBreakdown(total)` で 10000/5000/1000/100 に分解（枚数上限14）
- 着地位置は盤面中央のスコアを避け右下寄り（cx=2.4, cz=2.9）に山状に整列。俯瞰カメラ(up=[0,0,-1])なので+zが画面手前
- 関数群：`tenboTexture / makeTenbo / tenboBreakdown / clearTenbo / throwTenbo(total,instant)`、状態は `tenbos[]`
- 呼び出し：`showResult` 末尾（end+280ms後）に `throwTenbo(r.total,false)`、reduce時(instant)は即配置。`hideResult` と `buildHand` 冒頭で `clearTenbo()`
- 着地ごとに `clack()` を鳴らす。調整ポイント：TENBO寸法 / cx,cz / 放物線の高さ(1.4) / 投げる時間(520ms,90ms間隔)

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

## 2026-06-16 Claude（FBX 3Dモデル検証開始）
- 3D麻雀牌アセット（Maya FBX＋テクスチャ）を `assets/` に追加
  - 元: Desktop\nintend02\新しいフォルダー\Mahjong
  - MahjongPi_Blue / _Blue_Shanghi / _Yellow / Mahjong_Tenbow .fbx、Mahjong.png（テクスチャアトラス）
- 変換ツール（Blender/Node等）が無いため、Three.js FBXLoader でランタイム読込する方針
- 検証用 `fbxtest.html` を追加（本体アプリは未変更）
  - three r128 + fflate + NURBS + FBXLoader + OrbitControls をCDN(jsdelivr 0.128.0)から読込
  - モデル切替/テクスチャflipY/wireframe/texトグル、モデル情報（mesh数/頂点/サイズ/material）表示
  - 目的: モデル構造とUV（34種をどう描き分けるか）を把握してから本体へ統合判断
  - URL: https://kireibeya-nakamura.github.io/majohng/fbxtest.html

## 2026-06-16 Claude（本体に3D FBX牌を統合）
- fbxtest.html の「位置順インデックス」＋検証モードで mesh→牌 の対応を確定
  - 対応: FBX_POS_ORDER=[33,13,26,5,29,24,20,8,1, 18,7,32,30,2,31,15,21,17, 23,22,19,6,11,10,12,27,0, 28,3,14,16,9,4,25]（traversal順index→アプリ牌0..33）
- 本体 mahjong-table-3d.html に MahjongPi_Yellow.fbx を統合
  - loadFBXTiles(): fflate/NURBS/FBXLoader をCDN読込→34メッシュを正規化（中心化→rotateX(90)で面+y→+z立て→T寸法にスケール→法線再計算）し tileGeoms[appIdx] に格納。テクスチャ assets/Mahjong.png（flipY=true）
  - makeTile(): fbxReady時は tileGeoms[i]＋atlasマテリアル、あがり牌は emissive gold。未ロード/失敗時は従来のBox+Canvas描画にフォールバック（USE_FBX=falseで無効化可）
  - 起動時に非同期ロード→完了で render() 再構築
- 既知の不確定: 牌の向き/スケール/質感は実機確認後に調整予定（rotateX符号・scale・roughness等）

## 2026-06-16 Claude（質感＋ライティング）
- 牌の艶アップ：FBX牌マテリアルを MeshStandardMaterial → MeshPhysicalMaterial（roughness0.28, clearcoat0.8, clearcoatRoughness0.16）
- 背景の積み牌（walls）の緑面を象牙色に変更（wallMats の index2/5 を緑→ivory）
- ライティングを「真上スポットライト＋暗め」に：AmbientLight 0.78→0.22(寒色)、Directional×2を撤去し SpotLight(真上 y20, angle≈π/5.2, penumbra0.55) + 弱いフィルライトに。怪しい雰囲気

## 2026-06-17 Claude（艶・ライティング微調整）
- 艶が強すぎて柄が飛ぶ問題 → clearcoat 0.8→0.35、clearcoatRoughness 0.16→0.34、roughness 0.28→0.44
- スポットライトで柄面が真っ黒問題 → 牌の正面（縦の柄面）に光が当たるよう調整
  - AmbientLight 0.22→0.42、SpotLightを少し前傾(pos y18 z7→target z2.4)、前方フィル(0xfff0dc,0.42, z14)を追加。怪しい雰囲気は維持

## 2026-06-17 Claude（リアル化：影・トーンマップ・ベロア卓）
- レンダラー：outputEncoding=sRGB、ACESFilmicToneMapping(exposure1.05)、shadowMap有効(PCFSoft)
- スポットライトに影を付与（castShadow, 2048マップ, bias-0.0004, radius4）、Ambient0.42→0.28でコントラスト強化、spot強度2.0→2.7
- 牌・壁(積み牌)に castShadow/receiveShadow、卓(felt)に receiveShadow
- 卓をベロア/ベルベット質感に：makeFeltTextures()で微細ノイズのアルベド＋ノーマルマップ生成、色0x20302a roughness0.96、normalScale0.5、repeat9
- 背景(#stage)を暗く（コントラスト/リアル感向上）
- 要調整候補: 露出/スポット強度/影の柔らかさ/ベロアの色味は実機で追い込み

## 2026-06-17 Claude（牌の彫り込み表現）
- 牌の文字に彫り込み（凹凸）を追加：buildAtlasNormal() が Mahjong.png の輝度（濃い=文字=凹）から法線マップを生成
  - makeTile のFBXマテリアルに normalMap 適用（normalScale 0.9）。生成完了で render() 再構築
  - 負荷: 読込時に1回だけ法線マップ生成（最大1024）。実行時負荷はほぼ無し
  - 調整候補: 彫りの深さ=normalScale、生成強度 st=2.2。凹凸が逆（浮き出し）に見えたら符号反転で対応
- 凹凸が逆（浮き出し）だったため符号反転＋深く：st 2.2→3.4、normalScale 0.9 → -1.4（彫り込みに）

## 2026-06-17 Claude（文字サイズ調整）
- 牌の文字・絵柄を小さく（面に余白）：scaleFaceUV() で各牌のUVを面中心から拡縮、TEX_CHAR_SCALE=1.14（>1で文字小）
  - 法線マップも同UVなので彫り込みも追従
  - やりすぎると隣セルが映る可能性。調整は TEX_CHAR_SCALE（1.0で等倍、小さくしたいほど大きい値）
  - ※UVスケールは見た目が崩れたため TEX_CHAR_SCALE=1.0 に戻して無効化（UV方式は断念。別案: テクスチャ自体を作り直す等）

## 2026-06-17 Claude（余白追加：テクスチャ再生成方式）
- UVは変えず、テクスチャ画像側で各牌の絵柄を縮小＋象牙余白を追加する方式に変更
  - loadFBXTiles: 元アトラスをImageで読込→各牌の表面セル(UV bbox)を「世界法線が上向き(+y)の頂点」から検出→新キャンバスにセル毎へ余白色(sampleIvory)を敷いて絵柄を ATLAS_SHRINK=0.82 で縮小描画
  - 旧 buildAtlasNormal/scaleFaceUV を撤去。法線マップは buildNormalFromCanvas(縮小後キャンバス) から生成（彫り込みも追従）
  - 調整: ATLAS_SHRINK（小さいほど余白大）。崩れたら 1.0 で実質無効化
  - 壊れ対策: 面検出を厳格化(法線 vv.y>0.9)＋セルが大きすぎ(UV>0.4)なら適用スキップ（壊さず素通し）

---

## 引き継ぎ時の注意

---

## 引き継ぎ時の注意
- 作業前に必ず最新のコードをGitHubから確認すること
- 編集後はCHANGELOG.mdに記録してpushすること
- 同時編集はコンフリクトの原因になるため、交互に作業すること
