# 変更履歴 / CHANGELOG

このファイルはClaude・Codex間の引き継ぎ用です。
編集のたびに変更内容をここに記録してください。

---

## 2026-07-02 Claude（電脳磨き込み：ランク位置/リング強化/遠近UI/アンダーライト/DoF調整）
- アガリ表示：点数パネルを下へ（py H*0.44→0.63, ph 0.46→0.34）＝ランク小箱（倍満等）が倒れた牌と被らないように。点数フォント比率は維持
- 電脳ディティール追加（結果画面）：役バー下のマイクロテキスト「YAKU ANALYSIS COMPLETE」、パネル四隅のゴールドブラケット、脇にシリアル「SYS v2.5 // CALC:OK」「ID:0x7F2A」、目盛りティック間隔調整
- 投影リング強化：足元グローディスク(放射グラデ)＋二重リング（輝度UP 1.0/0.8）＋逆回転アーク×2(スキャナ風)。g1/g2で正逆回転
- 牌のアンダーライト：手前卓面すれすれに青白PointLight×2（0x7fd8ff, cyberMix追従）＝下から照らされるホログラム感
- DoF弱め：aperture 0.02→0.013, maxblur 0.011→0.008（手前の縁は軽いピント、牌が最鋭、背景も軽めのボケ）
- 遠近UI（試験）：const PAL_PERSP=true で #palfolder 全体を perspective(640px) rotateX(17deg)（手前広・奥窄まり）。JSパララックスと合成。palbodyのholoFloatは無効化。**戻すには PAL_PERSP=false**
- 注: 「URLから電脳ボタンが効かない」件はブラウザキャッシュ（?v付きURLをホーム画面/履歴から開くと旧版のまま）。コード側は前回のz-index修正で対応済み

## 2026-07-02 Claude（fix: 電脳ボタンが反応しない）
- 原因: #holobtn(z-index:3, 右下) が全幅の #palbar(z-index:3, DOMで後) に覆われタップを奪われていた（ボタン拡大で palbar が高くなり完全に被覆）
- 対処: #holobtn を右上へ移動＋z-index:7に。topbar等より前面で確実にタップ可能に

## 2026-07-02 Claude（電脳アガリ演出／浮遊ホロUI刷新／通常卓の質UP／ボタン反応改善）
- 電脳アガリ演出（参考画像C準拠）：cyberOn時 drawResultTexture→drawResultTextureCyber に分岐
  - 上部に役バー（面取り枠・役名=白/翻数=金・シアン区切り）、中央下に面取りホロパネル（外枠シアン＋内枠ゴールド＋目盛りティック）
  - ランク（倍満等）はパネル上辺に食い込む小箱、点数は巨大ゴールド発光＋小さい「点」、下段に 翻符/親子/ツモロン（シアン小）
  - あがり牌の着地点に回転する二重投影リング showWinRing/hideWinRing（fallAndReveal 落下完了+120msで表示、buildHand/hideResult/電脳OFFで解除）
- 電脳UIを「空中に浮くホログラム板」へ刷新：
  - フォルダ見出しをやめタブ=独立浮遊チップ（全周面取り・発光・落ち影）。palbody は perspective rotateX(5.5deg)＋holoFloat(4.4s)でゆっくり浮遊
  - #palbar の帯背景をほぼ透明化して板が浮いて見えるように。cbtn/icも板化（グラデ＋drop-shadow）
  - 視線(sway)連動パララックス：loop内で #palfolder/#callrow を微移動（電脳時のみ、OFFで解除）
  - 3Dに浮遊ホロボード追加（牌の後ろ＝前後感）：解析モニタ(右奥)/手役候補(左奥)/牌譜解析ストリップ(手牌のすぐ後ろ)。浮遊アニメ＋opacityはcyberMix追従。中身は現状ダミー数値
- 全体を青く：body.cyber の #stage/#vig を濃紺に。3D側は applyCyberMix で amb/spot/fill/fog を暖色→寒色へ補間（ambL/spotL/fillL を initScene で捕捉）
- 通常卓の質UP：buildTableRim() 卓の縁レール（黒革風・clearcoat、四辺のBox）を追加（両モード共通）
- ボタン反応改善：button{touch-action:manipulation;user-select:none}（タップ遅延と誤スクロール取りこぼし対策）＋ cbtn/ic のpadding拡大・pal/calc高さ42→46px
- 要確認：電脳アガリの見た目、浮遊UIの気持ちよさ（酔わないか）、ボタンの効き、通常卓の縁レールの見え方

## 2026-07-02 Claude（V2着手：電脳モード切替＋手牌選択画面のホログラムUI＋3D質向上）
- 参考画像（8505B80D/FF0E73F6/87A2424D…電脳卓の完成予想図）を基準にV2開始。通常卓がデフォルト、右下の「電脳」ホロボタン(#holobtn)で電脳モードにトグル
- UI電脳スキン（body.cyber で切替、CSSは全て body.cyber プレフィックス）:
  - トークン --cyan/#48d6ff, --cgold/#f0c56a, --holo-fill 等。パネル/ボタンは角丸→面取り(clip-path八角)、シアン枠＋暗い半透明＋薄スキャンライン
  - .palbody=ホロパネル化、.ftabs=シアン枠(アクティブはゴールド)、.cbtn/.ic=面取りシアン、.calc=ゴールド枠パネル、#cntpill/#status=チップ化、#systag「算符計算システム v2.5」を左上に表示
  - 覚醒演出: .awaken(::afterのスイープ光)をON時に付与。@keyframes traceRun
- 3D電脳レイヤー（buildCyberLayer、初回ON時に生成、tweenでフェード）:
  - 卓面の回路投影(makeCircuitTexture: 面取りフレーム＋コーナーブラケット＋マンハッタン配線、AdditiveBlending)
  - 手牌下の接地光(makeGlowStripTexture)、四隅エミッタ(小シリンダー)、シアンのリム光＋前方冷光(点灯はcyberMixに追従)
  - setCyber(on): body.cyber切替＋UIスイープ＋cyberSound(起動ハム＋ピング)＋3Dフェード。setModeでholobtn/systagも結果時非表示
- 3D質向上: renderer.setPixelRatio上限 2→2.5、全テクスチャのanisotropyを端末最大(maxAniso())に（牌の柄・フェルトの斜め見の解像感UP）
- 要確認: 電脳ON時の見た目（参考画像との方向性）、パフォーマンス（DPR2.5+MSAAが重い場合は2.25に戻す）、通常モードが従来通りか

## 2026-06-19 Claude（あがり牌の強調を復活：手前右に斜め置き）
- あがり牌の flat を {x:1.9, z:T.Z+T.H*0.95+0.2, yaw:0.5} に（手前右へ出して斜めに）。伏せ手牌は“その場で倒す”ままなので、あがり牌は前(z)に出るぶん鳴きと重ならない

## 2026-06-19 Claude（鳴き：倒しても重ならない＆裏向き維持／隙間少し詰め）
- 倒した後に伏せ手牌(再整列)と鳴き(その場)が重なる問題を修正：伏せ手牌も「その場で倒す」方式に統一（flat=stand位置）。グループ/隙間を維持。あがり牌だけ少し手前(z+0.45)＋傾けて強調
- 暗カンの裏向き牌が倒すと表になる問題を修正：place()に dir=t.faceDown?1:-1 を追加し、裏向きは逆回転(mesh.rotation.x=+90)で「裏」を上にして倒す
- ブロック間の隙間を少し詰め：groupGap T.W*0.6→0.45
- 旧：あがり牌をx=1.9へ移動＋others中央一列、は廃止（鳴きと重なるため）

## 2026-06-19 Claude（鳴きを3D手牌に組み込み：右に別グループのブロック表示）
- 鳴き（ポン/チー/カン）を手牌の右に3Dブロックで表示。手牌とは groupGap(=T.W*0.6) の隙間を空けて別グループと分かるように。ブロック内は密着(meldStep=T.W+0.02)
- ポン/チー=3枚、明カン/暗カン=4枚。暗カン(kou,kan,!open)は両端(0番,3番)を裏向き(outer.rotation.y=π)
- 全体(手牌＋鳴き)を中央寄せ。buildHandに meldTiles[] を追加（手牌tiles[]とは別管理）
- 倒れ演出：鳴き牌もその場で倒す（place()に baseYaw 保持を追加、fallAndRevealで meldTiles も animate）
- テキストのチップ(#calls)は削除用として残置
- 既知：裏向き牌の見た目はFBX牌の裏面依存（変なら裏面マテリアルを差し替え）。倒れ時の裏向きは簡略（その場で倒れる）

## 2026-06-19 Claude（UIをコンパクト化：フォルダ縮小中央寄せ／ボタン1列／手牌を中央へ）
- フォルダを牌幅にコンパクト＆中央寄せ：#palfolder width:fit-content（旧 width:100%/max680で横いっぱい＝牌が左寄りだったのを解消）。.ftabs は justify-content:center
- タブの飛び出しを短く：.ftabs button padding 7px20px→3px15px、font .92→.82rem、角丸11→9
- 鳴き行＋操作行を1列に統合：#ctrlrow を廃し #callrow に ポン/チー/明カン/暗カン｜戻す/クリア/効果音/設定 をまとめる（.vsep区切り）。各idは不変でJS流用
- 余白圧縮：#palbar gap8→5、padding8→6。手牌を中央寄りに：CAM.stand pos.y1.65→1.38, look.y-0.42→-0.12
- 要確認：1列がはみ出さないか（はみ出すとwrap）、手牌位置、フォルダ幅

## 2026-06-19 Claude（鳴きも牌の下へ／牌選択を横並びフォルダ風タブに）
- 下部UIを再構成：palbar順を「palfolder（フォルダ風タブ＋牌パレット）→ callrow（鳴き）→ ctrlrow（操作・設定）」に。ポン/チー/カンも設定と同じく牌（パレット）の下へ
- 牌選択タブを縦→横並びのフォルダ風タブに：.ftabs（上に飛び出すタブ、角丸上のみ、選択中は本体と同色で連結）＋.palbody（パレット本体パネル）。タブはパレットの上。id="tabs"のままなので既存ハンドラ流用
- UIが縦に高くなりパレットが上に来るため、手牌が再び被らないよう見下ろしを微増（CAM.stand pos.y1.5→1.65, look.y-0.25→-0.42）。fit幅は11.8維持
- 旧 #palrow / .tabs(縦) CSSは撤去
- 要確認：手牌の高さ/大きさ、各UI行の被り。被るならカメラかUI高さ(行統合)を再調整

## 2026-06-19 Claude（設定ボタンを手牌選択の下へ＆手牌に左右の余白）
- #palbar 行順を callrow→palrow→ctrlrow に変更（戻す/クリア/効果音/設定＝ctrlrowを手牌選択palrowの下＝最下段へ）。設定ボタンの牌被りを解消
- 手牌の左右がギリギリ→余白を追加：fitCam の収め幅 10.2→11.8（最小ds 7.6→8.4）。14枚(幅約9.7)に対し左右約1枚分の余白。見下ろし角度(look.y -0.25)は維持
- 調整：まだ被る/余白過多なら ctrlrow位置・fitCam収め幅を再調整

## 2026-06-19 Claude（パレット絵柄をRTTで正しく＆直立カメラを見下ろしに）
- パレットボタンの絵柄崩れ・縦横比異常を修正：アトラスのUV切り出し（縁/ベベルまで拾い崩れていた）をやめ、実際のFBX牌の面をオフスクリーン描画(RTT)して画像化。向き・縦横比・絵柄が3D牌と完全一致
  - getPalTex(atlasImg由来のTexture, flipY/sRGB)＋OrthographicCameraで面(+z)を正面120×168で描画→readRenderTargetPixels→上下反転してcanvas→dataURL。失敗時は faceCanvas にフォールバック
- 直立時に「戻す/クリア」等(ctrlrow)が牌に被る問題：標準カメラを見下ろし気味に（CAM.stand pos.y1.25→1.5, look.y0.12→-0.25）→手牌が画面上寄りになり下部UIと干渉しにくく
- 調整：被りがまだなら look.y をさらに下げる。絵柄サイズ/余白は OrthographicCamera 枠や rw/rh で調整可

## 2026-06-19 Claude（手牌選択ボタンを下段へ＆3D牌と同じ絵柄に）
- レイアウト：#palbar の行順を ctrlrow→callrow→palrow に変更（手牌選択＝palrowを最下段へ）。3D牌との被りを解消
- パレット画像を3D牌と同じ Mahjong.png の絵柄に：
  - tileFaceUVRect(i)：FBX牌ジオメトリの「面(+z)」頂点のUV bboxを取得
  - palImg(i)：atlasImg(Mahjong.png) から該当矩形を切り出してボタン画像化（flipY=trueを考慮しy=(1-v)*H）。FBX/アトラス未読込時は従来の faceCanvas にフォールバック
  - loadAtlasImg＋refreshPalette：FBX読込後にアトラスを読み込みパレットを作り直す。curSuit で現在のタブを保持
- 注意：アトラスで絵柄が回転している牌があれば横向きになる可能性（その時は要調整）

## 2026-06-19 Claude（DoFをレイヤー分離：手牌は常にくっきり／背景だけボケ）
- 切り分け：倒れる「瞬間」だけチラつく＝動く牌の細かい柄が後処理DoFでシマー。直立時の手牌が薄い/ピント甘いも、コンポーザが前景の牌まで巻き込んでいたため
- 対策（レイヤー分離レンダリング）：
  - 手牌メッシュ(makeTile)と結果プレーン(initResultPlane)を layer1（前景）へ。背景(felt/山牌/河)は layer0
  - loop：(1) camera.layers.set(0) で背景のみ composer(DoF) 描画 →(2) autoClear=false+clearDepth して camera.layers.set(1) で手牌・結果を renderer で「くっきり」上描き
  - ライトは enableAll で前景も照らす。raycaster も enableAll でクリック判定維持。失敗時は usePost=false にして通常描画へフォールバック（try/catch）
  - これで「手牌くっきり＋背景ボケ＋倒れる時もチラつかない＋薄くならない」を同時に達成する狙い
- 背景ボケ量(aperture0.02/maxblur0.011)・near0.5/far70 は据え置き

## 2026-06-18 Claude（カメラ深度精度を改善：テクスチャのチラつき＆手牌ピント対策）
- 推定原因：camera near/far が 0.1/200 と極端で深度バッファ精度が低く、モバイルで奥の山牌/河/卓がZファイティング→「テクスチャがバグる/チラつく」。DoFの深度判定も不正確で手牌のピントが甘くなる
- 対策：PerspectiveCamera の near 0.1→0.5、far 200→70（実シーンの距離に合わせる）。深度精度が大幅UP。BokehPassは毎フレーム camera.near/far を nearClip/farClip に反映するのでDoFの焦点判定も正確化
- これで(1)モバイルのテクスチャのバグ/チラつき、(2)手牌のピントの甘さ、の両方の改善を狙う。背景ボケ量(aperture0.02/maxblur0.011)は据え置き（ユーザー評価良好）
- まだ駄目なら次手：DoFを一旦切って別方式、もしくはMSAA/エンコード(GammaCorrection)対応

## 2026-06-18 Claude（DoF：ボケ弱め・ピント正確化・モバイルのチラつき修正）
- ボケが強すぎ→弱める：aperture 0.05→0.02、maxblur 0.03→0.011
- 手牌にピントが合わない→修正：BokehShaderのfocusは「ビュー空間の奥行き(-viewZ)」を要求。ユークリッド距離ではなく camera.matrixWorldInverse で焦点点(手牌の列/注視点)をビュー空間へ変換して -z を渡すよう変更（_fpt）
- モバイルのテクスチャのチラつき(ジャギ)→修正：EffectComposer経由でMSAAが外れ牌の細かい柄がエイリアスしていた。WebGL2で WebGLMultisampleRenderTarget(samples=4) をコンポーザに渡してMSAA有効化。setPixelRatio(pr)で端末解像度を維持。resize時に bokeh深度RTとaspectも更新
- 調整：ボケ量は aperture/maxblur。さらに弱く/強くは数値で対応可

## 2026-06-18 Claude（DoFが実は無効だった不具合を修正／スタート画面さらに弱く）
- ★重要修正：DoF（背景ボケ）はこれまで一度も有効になっていなかった。loadPostの読込順で THREE.Pass を定義する Pass.js が無く、ShaderPass/MaskPass が `extends THREE.Pass` 実行時に失敗→EffectComposer生成で例外→usePost=false に。
  - 対策：loadPostの先頭に `postprocessing/Pass.js` を追加（THREE.Pass/FullScreenQuad を先に定義）。これで実際にDoFが動く＝奥の河/山牌がボケる
  - これまでの aperture/maxblur/focus の調整は無効だったのが、今回から効くようになった
- DoFを強めに：aperture 0.046→0.05、maxblur 0.022→0.03（手牌ピント・奥ボケが明確に）
- スタート画面のフロストをさらに弱く：blur 10px→5px（saturate 118→115%）

## 2026-06-18 Claude（スタート画面のぼかし減・手牌選択でDoFを手牌ピントに固定）
- スタート画面のフロストガラスを弱める：backdrop-filter blur 20px→10px（saturate 120→118%）。立ち上げ時のボカシ過多を解消
- 手牌選択（建てモード camP≈0）でDoFのピントを手牌の列(z=T.Z, y=T.H/2)に固定。注視点(z=1.2)ではなく手牌そのものに合うので、手前くっきり・奥（河/山牌）ボケが明確に。演出（俯瞰）時は従来どおり注視点ピント
  - loop内のfocus計算を分岐（建てモード=手牌距離 / それ以外=curLook距離）

## 2026-06-18 Claude（点棒演出を無効化／卓の光を強化／DoFを手牌ピント・奥ぼかしに調整）
- 点棒アニメーション無効化（ユーザー要望）：showResult の throwTenbo 呼び出し2か所を削除。関数群(throwTenbo等)は未使用で残置、clearTenboは無害
- 卓の光を少し強化：メインスポット 2.0→2.45、オレンジのピンライト 1.8→2.3
- DoF（背景ピンボケ）を強める：aperture 0.03→0.046、maxblur 0.015→0.022。focusは注視点（建てモードでは手牌付近）に追従済みなので、手前の手牌にピント・奥（河/山牌）が強めにボケる
- 調整：ボケ過多なら aperture/maxblur を、明るすぎ/暗すぎなら spot/pin/exposure を再調整

## 2026-06-18 Claude（リアリティ向上：環境光・オレンジピンライト・山牌/河・ピンボケ・質感UP）
- ※Codexアレンジ版を探したが git(main/リモート)・ディスク・OneDriveのどこにも見当たらず。ユーザー選択により現行版(3da946f)の上で実装
- 環境マップ(IBL)追加：buildEnvTexture()で簡易グラデequirect→PMREMGenerator→scene.environment。象牙/点棒/卓に柔らかな映り込み（try-catchで保護）
- オレンジのピンライト追加：SpotLight(0xff8a38,1.8) を左前から卓へ。暖色の溜まりを作る（影は落とさない＝負荷軽減）
- 手牌選択時に柄が暗くなりすぎないよう前方フィルを強化（0.22→0.34・暖色・位置(0,7,11)）
- 背景を賑やかに：buildWalls()を山牌2段積みに（奥17/左右11、影なし）。buildKawa()で河（捨て牌）を対面6×3・左右6×2、柄を上にして配置（makeFlatTile, texFor流用）
- 背景ピンボケ：DOF_ON=true に。BokehPass aperture0.03/maxblur0.015、focusは注視点距離に追従。fog(0x0c0d10,17,34)で奥行きの空気感。DoF初期化失敗時は通常描画にフォールバック
- 牌(象牙)質感UP：MeshPhysical color0xfdf6e9・roughness0.5・clearcoat0.45・clearcoatRoughness0.3・envMapIntensity0.6（白飛びは抑制のまま）
- 卓(ベロア)質感UP：色を深く0x1b2a23・roughness0.9・normalScale0.72・envMapIntensity0.22、起毛ノーマルを2オクターブ化
- 要確認：モバイル負荷（メッシュ増＋DoF）、白飛び/暗さ、ピンボケの強さ、ピンライトの色味。重ければ河の枚数/DoF/影を削減

## 2026-06-17 Claude（鳴き・カンUI追加／点数表示を拡大）
- 牌選択タブの下に「鳴き」バー(#callrow)を追加：ポン/チー/明カン/暗カン。前プロト(mahjong-hand-calc.html)の操作を移植
  - スコアエンジンは元から calls 対応。compute() で calcHand(hand, calls, ctx) を呼ぶよう変更
  - 操作：ボタンをタップ→armed→パレットの牌をタップで確定。チーは数牌1〜7（順子の先頭）。calls形式 {type:'shun'|'kou',t,open,kan}
  - 必要手牌枚数 needConc()=14-3*calls.length。cntpill を「現在/需要(cntneed)」表示に。addTile は needConc 上限＆同種4枚ガード
  - 宣言した鳴きはチップ表示(#calls)。タップで削除。undo は armed解除→手牌pop→callspop の順。clear で全リセット
  - paletteTap() で callMode 中はaddCall、通常はaddTile に振り分け
  - ※未対応/今後調整：3D卓には鳴き牌を未表示（伏せ手牌のみ落下）。明カン/暗カンの面子表現・ターツ位置は要相談（ユーザーと一緒に調整予定）
- 点数表示を拡大（満貫等のランクとの隙間調整）：font H*0.15→0.27・y0.96→0.97（※まず大きめ。要バランス調整）

## 2026-06-17 Claude（点棒を上げて右へ／スクロール先に全設定を統合）
- 点棒が下すぎて見切れる問題：cx 2.6→3.3, cz 3.9→3.0（上げて右へ）。アガリ牌(x≈1.9)とは x 方向で分離し非接触
- スクロール先(resultpanel #rp-settings)に前プロト相当の全設定を統合：
  - 親子 / あがり / 立直(なし・立直・ダブル) / 場風 / 自風 / 状況役(一発・海底・河底・嶺上・槍槓) / ドラ(±)
  - 嶺上(rinshan)・槍槓(chankan)を新規UI化。スコアエンジンは元から対応済みで buildCtx を S.rinshan/S.chankan に接続、S にも追加
  - 状況役の海底/河底/嶺上/槍槓は排他（同時に一つ）。選ぶとツモ/ロンを自動設定。一発は独立、立直OFFで自動解除
  - ギア内モーダル(setwrap)の設定ともすべて同期（bindBoth/setRiichi/setRound/setSeat/setDora/refreshSit を追加。dora表示は dv/dv2 両方更新）
- 調整：点棒が右で切れる場合は cx を戻す。設定UIは #rp-settings に集約（ギアは従来通り併存・同期）

## 2026-06-17 Claude（アガリ牌・点棒をさらに右へ／牌と点棒を非接触に）
- アガリ牌：flat.x 1.1→1.9、z を +0.5→+0.2（手前に出しすぎず）。点棒とはz方向に隙間を作り非接触
- 点棒：cx 1.9→2.6、cz 3.55→3.9、maxRows 6→5。アガリ牌(z~1.9〜2.9)と点棒(z~3.1〜)で z が分離し被らない
  - x はアガリ牌(〜2.36)と点棒(1.85〜)が一部重なるが z 分離で立体的には非接触
- 調整：右に出しすぎて切れる時は cx/flat.x を戻す。被る時は cz を大きく（点棒を手前へ）

## 2026-06-17 Claude（点棒の重なり防止・戻り時ズーム固定・アガリ牌右寄せ・点数表示の重なり修正）
- 点棒同士が重ならないように：ほぼ平行(yaw±0.08)＋z等間隔(dz=0.30)の段組みへ。6本ごとに上の段へ積む(layer)。着地後の転がりも控えめに(rollExtra±0.06, slide0.04〜0.12)
  - throw内のローカル進行方向ベクトルは外側の段間隔dzと名前衝突しないよう dzz に改名
- 演出後に手牌へ戻ると拡大しすぎる問題：rp-edit / rp-again で userZoom=1 にリセット（ピンチズーム値が残っていた）
- アガリ牌を右寄せ：flat.x 0.55→1.1（点棒(cx=1.9)より左、牌列に被らない手前）
- 倍満/満貫などの rank と点数の重なり修正：rank y 0.83→0.70、点数 font 0.16→0.15・y 0.955→0.96

## 2026-06-17 Claude（点棒の散らばり控えめ＆右下配置）
- 転がって止まる動きはそのまま、散らばりを控えめに：tx ±1.3→±0.45 / tz ±0.6→±0.4 / yaw ±0.8π→±0.45π
- 着地中心を中央→右下へ：cx 0→1.9, cz 3.5→3.6（倒れた牌に被らない手前右の空きスペース）
- 調整ポイント：被る/見えない時は cx,cz、散らばりは tx,tz,yaw のランダム幅

## 2026-06-17 Claude（点棒FBX差し替え／自然な転がり／照明調整）
- 点棒をFBXモデルに差し替え：`assets/Mahjong_Tenbow.fbx`（中身は TenBow_100/1000/5000/10000/White の5本、テクスチャは牌と同じ Mahjong.png）
  - `loadTenboFBX()` を追加。名前で額面メッシュを取得→中心化→最薄軸をy(厚み)・長辺をxに正規化→TENBO寸法へスケール
  - `makeTenbo()` は FBXジオメトリがあれば使用、無ければ従来の手作り箱にフォールバック
  - `clearTenbo()` は共有FBXジオメトリを破棄しないよう変更（手作り箱=ownGeoのみdispose）
  - 読込：loadFBXTiles成功後に loadTenboFBX を呼ぶ
- 投げ込み後の挙動を自然に：規則正しい整列→バラけた着地（位置・向きをランダム化）＋着地後に進行方向へ少し滑って小バウンド＆回転して止まる
- 照明/スペキュラ調整（牌の白飛び対策・光源を卓の奥へ）：
  - メインスポット位置 z=6（手前）→ z=-5（奥）、target z=2.2→1.4、強度2.7→2.1、penumbra0.55→0.6
  - 前方フィル光 強度0.32→0.22・位置(0,6,14)→(0,7,9)
  - toneMappingExposure 1.05→0.92
  - 牌マテリアル roughness0.44→0.58 / clearcoat0.35→0.15 / clearcoatRoughness0.34→0.5（テカリ抑制）
- 調整ポイント：FBX向きがおかしい時は loadTenboFBX の軸正規化、印字が裏なら追加でX/Z 180度。照明は spot.position / intensity / exposure

## 2026-06-17 Claude（点棒が見えない→中央手前に着地へ修正）
- 点棒が画面に見えない問題：着地位置が右下寄り(cx=2.4,cz=2.9)で画面外/牌の陰だったのが原因
- 中央手前(cx=0, cz=3.5＝倒れた牌より手前の空きスペース)に着地するよう変更。牌(高さ~0.36)に隠れない位置
- 点棒を大きく：TENBO L1.25→1.5 / W0.12→0.17 / H0.07→0.09。着地yも少し浮かせて卓の絵柄に埋もれないように
- 投げ出し位置を画面下端のすぐ外(sz 6.8→5.6)に、放物線を低く(1.4→0.9)して確実に画面内へ入るよう調整
- ※ローカル検証用に C:\.claude\serve.ps1 + launch.json を用意したが、CDN依存の3DページはプレビューMCPがアタッチできず未使用。携帯のGitHub Pagesで確認

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
