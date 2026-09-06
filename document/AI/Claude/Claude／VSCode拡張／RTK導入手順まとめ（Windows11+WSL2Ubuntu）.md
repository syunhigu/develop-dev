# Claude / VSCode拡張 / RTK 導入手順まとめ（Windows 11 + WSL2 Ubuntu）

対象環境：Windows 11 Pro／WSL2 Ubuntu、Claudeは Pro プラン契約済み、VSCodeは導入済み

---

## 1. Claude アプリ（デスクトップ）のインストール（Windows）

1. https://claude.com/download にアクセス
2. Windows用インストーラをダウンロードして実行
3. インストール後に起動し、Proアカウントでログイン

---

## 2. VSCode拡張機能の導入（Windows / WSL2 Ubuntu 両方）

VSCodeの拡張機能はWindows側とWSL側で別管理（「Remote - WSL」で接続したウィンドウは別ホスト扱い）のため、それぞれ個別にインストールが必要。

### ① Windows側（ネイティブ）
1. 通常のVSCode（WSL未接続）を開く
2. `Ctrl+Shift+X` → 「Claude Code」を検索 → Install
3. CLIも導入（PowerShell）
   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```
4. `claude --version` で確認 → `claude` で起動しブラウザ認証

**トラブル対応：`claude` が認識されない場合**
Windowsはインストール中に開いていたターミナルのPATHを自動更新しないため、多くの場合ターミナルを閉じて開き直すだけで直る。直らない場合は以下でPATHを手動追加。
```powershell
[Environment]::SetEnvironmentVariable("PATH", "$([Environment]::GetEnvironmentVariable('PATH','User'));$env:USERPROFILE\.local\bin", "User")
```
またはGUIから「システムのプロパティ」→「環境変数」→ユーザー環境変数の`Path`に `C:\Users\<ユーザー名>\.local\bin` を追加。その後ターミナルを再起動。

### 補足：Git Bashでも `claude` / `rtk` / `rg` を使えるようにする

Git Bashは通常Windowsのユーザー環境変数PATHを引き継ぐが、反映されないことがある。その場合は `~/.bashrc` に直接追記する。

```bash
echo 'export PATH="$PATH:/c/Users/<ユーザー名>/.local/bin"' >> ~/.bashrc
source ~/.bashrc
```

確認：
```bash
which claude
which rtk
which rg

claude --version
rtk --version
rg --version
```
（`C:\Users\...` はGit Bashでは `/c/Users/...` というスラッシュ表記になる点に注意）

### ② WSL2 Ubuntu側
1. Windows側のVSCodeで「Remote - WSL」拡張機能を使いUbuntuに接続
2. WSL接続状態で `Ctrl+Shift+X` → 「Claude Code」を検索 → Install（Windows側とは別インストール）
3. WSL（Ubuntu）のターミナルでCLIを導入
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```
4. `claude --version` → `claude` で起動して認証

---

## 3. RTK（トークン節約ツール）の導入

rtkはコマンド出力を圧縮してトークン消費を抑えるサードパーティ製CLI（[rtk-ai/rtk](https://github.com/rtk-ai/rtk)）。Windows側・WSL側で別インスタンス扱いのため、両方に導入・両方で `rtk init -g` を実行する必要がある。

### ⚠️ 導入前の注意点
- **効果は環境依存。逆効果の報告もあり。** JetBrainsのベンチマーク（2026年7月）では、低推論エフォート設定でコストが中央値7.6%増加したという結果も報告されている。過信せず、導入後に自分の使い方で実績値を確認してから継続判断するのが望ましい。
- **非公式フォークが多数存在。** `rtk-rtk-ai`、別プロジェクトの`rtk-windows`、`rr-rtk` など類似名リポジトリが乱立。本家 `github.com/rtk-ai/rtk` を使うこと。
- **Windows版バイナリがMicrosoft Defenderにウイルス（Trojan）として誤検知される報告が複数バージョンで発生**（`Trojan:Script/Wacatac.H!ml`、`Trojan:Win32/Bearfoos.B!ml` など）。開発元は誤検知の可能性が高いと説明しているが未解決。
  - 導入時はSHA256ハッシュをリリースページの記載値と照合：
    ```powershell
    Get-FileHash .\rtk-x86_64-pc-windows-msvc.zip -Algorithm SHA256
    ```
  - VirusTotalでもスキャン推奨
  - Defenderがブロックしても、むやみに除外設定をしない
- crates.io / cargo経由だと**別プロジェクト（Rust Type Kit）と名前が衝突**するため、`cargo install` する場合は `--git` でURL指定必須。

### ① Windows（ネイティブ）

1. 依存コマンド ripgrep を導入（wingetがある場合）
   ```powershell
   winget install BurntSushi.ripgrep.MSVC
   ```
   **wingetが無い場合**：公式GitHubから直接ダウンロード
   - https://github.com/BurntSushi/ripgrep/releases から自分のCPUアーキテクチャに合うzipを選ぶ
     - 一般的なIntel/AMD PC → `ripgrep-x.x.x-x86_64-pc-windows-msvc.zip`
     - Copilot+ PC（ARM）→ `ripgrep-x.x.x-aarch64-pc-windows-msvc.zip`
   - 確認コマンド：`$env:PROCESSOR_ARCHITECTURE`（`AMD64` なら x86_64版でOK）
   - 展開して `rg.exe` を `$env:USERPROFILE\.local\bin` にコピー

2. rtk本体をインストール
   - 公式リリースページ https://github.com/rtk-ai/rtk/releases から `rtk-x86_64-pc-windows-msvc.zip` をダウンロード
   - 展開して `rtk.exe` を `$env:USERPROFILE\.local\bin` にコピー
   ```powershell
   New-Item -ItemType Directory -Force "$env:USERPROFILE\.local\bin"
   Copy-Item "$HOME\Downloads\rtk-x86_64-pc-windows-msvc\rtk.exe" "$env:USERPROFILE\.local\bin\rtk.exe"
   ```

3. PATHに追加（claudeと同じ場所なので既に通っていれば不要）
   ```powershell
   [Environment]::SetEnvironmentVariable("PATH", "$([Environment]::GetEnvironmentVariable('PATH','User'));$env:USERPROFILE\.local\bin", "User")
   ```

4. ターミナルを開き直して確認
   ```powershell
   rtk --version
   rg --version
   ```

5. Claude Code用にフック設定
   ```powershell
   rtk init -g
   ```

### ② WSL2 Ubuntu

```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
rtk init -g
```

**確認・仕上げ**
```bash
rtk --version   # バージョンが表示されればインストール成功
rtk gain        # "No tracking data yet" は正常（まだ未使用というだけ）
rtk init --show # フックが登録されているか確認
```

導入後は **Claude Codeを再起動**（フック設定は再起動しないと反映されない）。しばらく使ってから再度 `rtk gain` を実行すると、節約したトークン数が表示される。

### WSL2 Ubuntu側の補足：`claude` / `rtk` / `rg` の確認とripgrep導入

WSL側でも念のため以下で確認する。

```bash
which claude
which rtk
which rg

claude --version
rtk --version
rg --version
```

`claude`・`rtk` は `install.sh` 経由で `~/.local/bin` にインストール済みかつ `~/.bashrc` にPATH追記済みのため、基本的にはそのまま通る。

`rg`（ripgrep）が見つからない場合は、Ubuntuのパッケージマネージャからそのままインストールできる（Windowsのようにzipダウンロード＋PATH追加は不要）。

```bash
sudo apt update
sudo apt install ripgrep
```

インストール後、`which rg`・`rg --version` で確認。`apt`版はやや古いバージョンになることがあるが（例：14.1.0）、動作上は問題ない。最新版が欲しい場合は以下でも可（任意）。

```bash
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep_15.2.0-1_amd64.deb
sudo dpkg -i ripgrep_15.2.0-1_amd64.deb
```

**もし `claude`・`rtk` が見つからない場合**：`~/.bashrc` にPATH追記が反映されていない可能性があるので確認・再追記する。

```bash
cat ~/.bashrc | grep local/bin
# 無ければ追加
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

---

## 参考リンク

- Claude Code 公式セットアップ: https://code.claude.com/docs/en/setup
- Claude Code VS Code拡張 公式ドキュメント: https://code.claude.com/docs/en/vs-code
- rtk-ai/rtk（GitHub 公式リポジトリ）: https://github.com/rtk-ai/rtk
- rtk リリースページ（Windows/Linux/macOSバイナリ）: https://github.com/rtk-ai/rtk/releases
- ripgrep リリースページ: https://github.com/BurntSushi/ripgrep/releases
- rtk効果を疑問視するJetBrainsベンチマーク記事: https://www.zaikei.co.jp/article/20260722/862344.html
- Qiita: Claude Code / GitHub Copilot のトークン消費を手軽に削減する2つのツール: https://qiita.com/rairaii/items/0ea0ebf709eb00230b93
- RTK完全ガイド（導入手順とトークン削減効果の実測例）: https://ai-heartland.com/ai/claude/rtk/
