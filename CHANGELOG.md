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

---

## 引き継ぎ時の注意
- 作業前に必ず最新のコードをGitHubから確認すること
- 編集後はCHANGELOG.mdに記録してpushすること
- 同時編集はコンフリクトの原因になるため、交互に作業すること
