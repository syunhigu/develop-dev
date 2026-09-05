# WSL2: Ubuntu 24.04 → 26.04 LTS アップグレード手順

Ubuntu 26.04 LTS(コードネーム: Resolute Raccoon)は2026年4月23日にリリース済み。
WSL2上のUbuntu 24.04 LTS(Noble Numbat)からアップグレード、または新規導入する方法をまとめる。

## 事前準備

### 1. WSL本体を最新化(PowerShell管理者権限)

```powershell
wsl --update
wsl --version
```

### 2. バックアップを必ず取る(重要)

```powershell
wsl --shutdown
wsl --export Ubuntu-24.04 D:\wsl-backup\ubuntu-2404-before-upgrade.tar
```

復元方法も事前に確認しておく:

```powershell
wsl --import Ubuntu-24.04-Restore C:\WSL\Ubuntu-24.04-Restore C:\backup\ubuntu2404_backup.tar --version 2
```

```powershell
wsl -d Ubuntu-24.04-Restore
```

### 3. Ubuntu側のパッケージを最新化

```bash
sudo apt update && sudo apt full-upgrade -y
```

---

## 方法A: 既存環境を引き継いでアップグレード(do-release-upgrade)

既存の設定・データを引き継ぎたい場合はこちら。

```bash
sudo do-release-upgrade -d
```

- `-d` なしでは、24.04 LTS → 26.04 LTS への通常アップグレード通知がまだ有効になっていない場合がある(その場合は `-d` を付ける)。
- 安定性を優先するなら、急いで `-d` で上げるより **26.04.1 LTS リリース後**、通常アップグレード経路が開放されてから移行する方が安全。

### WSL2特有の注意点: systemd/cgroup設定

WSL2環境ではsystemd関連の設定が不足しているとエラーで止まることがある。事前に以下のファイルを編集しておくと安定する。

```
notepad %USERPROFILE%\.wslconfig
```

```ini
[wsl2]
kernelCommandLine="systemd.unified_cgroup_hierarchy=1 cgroup_no_v1=all"
```

編集後は一度WSL2を再起動してから実行する:

```powershell
wsl --shutdown
```

---

## 方法B: 26.04をクリーンインストール(並行導入)

まっさらな26.04環境が欲しい場合はこちら。

### Microsoft Store経由

```powershell
wsl --install -d Ubuntu-26.04
```

### .wsl形式イメージを直接インストール(ストア一覧にまだない場合)

2026年6月時点では、Ubuntu 26.04 LTSがWSLの標準インストール一覧(Microsoft Store / `wsl --list --online`)にまだ並んでいないケースが報告されている。その場合は新しい `.wsl` 形式の配布イメージを使う。

1. `releases.ubuntu.com` から `ubuntu-26.04-wsl-amd64.wsl` を入手
2. 以下のコマンドでインストール

```powershell
wsl --install --from-file (wslファイルのパス)
```

ダウンロードした `.wsl` ファイルをエクスプローラでダブルクリックしてもインストール可能。

### 古い環境での代替: wsl --import

```powershell
wsl --import Ubuntu-26.04 C:\wsl\ubuntu2604 C:\wsl\ubuntu-26.04-wsl-amd64.wsl --version 2
```

### 導入直後の初回アップデート

```bash
sudo apt update && sudo apt upgrade -y
```

配布イメージは作成時点の内容で固定されているため、導入直後に必ず更新をかける。ここでリポジトリ関連のエラーが出なければ、ネットワークとaptの経路は健全と判断できる。

---

## まとめ

| 注意点 | 内容 |
|---|---|
| バックアップ | `wsl --export` で必ず取る |
| 復元確認 | `wsl --import` の方法も事前に把握しておく |
| 移行時期 | 安定重視なら 26.04.1 LTS 以降が無難 |
| WSL2特有の落とし穴 | `.wslconfig` のcgroup設定が抜けていると `do-release-upgrade` が止まることがある |
| 移行後確認 | Git / SSH / Nushell / nvim などの動作確認、`sudo apt update && sudo apt upgrade` |

---

## 参考記事

- [WSL2のUbuntuを26.04へアップグレード＆新規セットアップ【2026年版】](https://www.visionnurture.com/windows-11-beginners-wsl-2-install/) — do-release-upgradeによる既存環境の引き継ぎと、wsl --install -d Ubuntu-26.04による新規導入の両方を比較。検証環境はWindows 11 25H2、WSL 2.7.8。
- [Ubuntu 26.04 LTSをWSL2に導入する｜wsl --install --from-fileの最新手順と確認ポイント](https://www.linuxmaster.jp/linux_blog/2026/06/ubuntu-2604-lts-wsl2-from-file-install.html) — 2026年6月時点でストア一覧にまだ26.04が出ていない場合の.wsl形式イメージを使った導入手順を解説。
- [Ubuntu 26.04 LTSへのアップデート](https://www.bn-x.net/archives/technology/2026/04/1134/) — WSL2特有のcgroup設定(.wslconfig)を追加しないとdo-release-upgradeが止まる件への対処法。
- [WSL の Ubuntu を 26.04 LTS にアップグレードしてみた](https://zenn.dev/cocoaworks/articles/f690266fc0eaa1) — wsl --exportでのバックアップ・復元手順と、do-release-upgrade -dの使い方を実体験ベースでまとめたメモ。
- [WSLでUbuntuの最新LTSリリース「Ubuntu 26.04 LTS」を動かしてみよう](https://thinkit.co.jp/article/39175) — Microsoft Store経由・wslファイル直接インストール両方の手順を紹介。
