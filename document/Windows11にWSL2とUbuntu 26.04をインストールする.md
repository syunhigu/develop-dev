# Windows11にWSL2とUbuntu 26.04をインストールする

## 前提条件
- WindowsにVS Codeインストール済み
- Gitインストール及び設定済み

## 参考記事
- [公式](https://learn.microsoft.com/ja-jp/windows/wsl/install)
- [Windows 11にWSL 2/Ubuntu 24.04をインストールする](https://www.mitsue.co.jp/knowledge/blog/x-tech/202507/15_0843.html)
- [WSL2 のインストールとアンインストール](https://qiita.com/zakoken/items/61141df6aeae9e3f8e36#3-wsl2-%E3%81%AE%E3%82%A2%E3%83%B3%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E6%96%B9%E6%B3%95)

## 1. WSL機能の有効化
PowerShellを管理者として実行
1. 画面左下のWindowsロゴ（スタートボタン）を右クリック  
2. 表示されたメニューから「Windows Terminal（管理者）」または「PowerShell（管理者）」を選択  
    続いて、以下のコマンドを実行してWSLとVirtual Machine Platformを有効化
    ```
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart  
    ```
    有効化したらWindowsを再起動し、以下のコマンドを実行してWSL 2を既定バージョンに設定
    ```
    wsl --set-default-version 2
    ```
## 2. Ubuntu 26.04のインストール
1. Linux 用 Windows サブシステムを最新バージョンに更新
    ```
    wsl.exe --update
    ```
2. オンライン ストアからダウンロードできる利用可能な Linux ディストリビューションの一覧を表示
    ```
    wsl.exe --list --online
    ```
    実行結果
    ```
    PS C:\WINDOWS\system32> wsl.exe --list --online
    インストールできる有効なディストリビューションの一覧を次に示します。
    'wsl.exe --install <Distro>' を使用してインストールします。

    NAME                            FRIENDLY NAME
    Ubuntu                          Ubuntu
    Ubuntu-26.04                    Ubuntu 26.04 LTS
    Ubuntu-24.04                    Ubuntu 24.04 LTS
    Ubuntu-22.04                    Ubuntu 22.04 LTS
    openSUSE-Tumbleweed             openSUSE Tumbleweed
    openSUSE-Leap-16.0              openSUSE Leap 16.0
    SUSE-Linux-Enterprise-15-SP7    SUSE Linux Enterprise 15 SP7
    SUSE-Linux-Enterprise-16.0      SUSE Linux Enterprise 16.0
    kali-linux                      Kali Linux Rolling
    Debian                          Debian GNU/Linux
    AlmaLinux-8                     AlmaLinux OS 8
    AlmaLinux-9                     AlmaLinux OS 9
    AlmaLinux-Kitten-10             AlmaLinux OS Kitten 10
    AlmaLinux-10                    AlmaLinux OS 10
    archlinux                       Arch Linux
    FedoraLinux-44                  Fedora Linux 44
    FedoraLinux-43                  Fedora Linux 43
    eLxr                            eLxr 12.12.0.0 GNU/Linux
    OracleLinux_7_9                 Oracle Linux 7.9
    OracleLinux_8_10                Oracle Linux 8.10
    OracleLinux_9_5                 Oracle Linux 9.5
    SUSE-Linux-Enterprise-15-SP6    SUSE Linux Enterprise 15 SP6
    ```
3. Ubuntu 26.04のインストール
    ```
    wsl.exe --install -d Ubuntu-26.04
    ```
    実行結果
    ```
    PS C:\WINDOWS\system32> wsl.exe --install -d Ubuntu-26.04
    ダウンロードしています: Ubuntu 26.04 LTS
    インストールしています: Ubuntu 26.04 LTS
    ディストリビューションが正常にインストールされました。'wsl.exe -d Ubuntu-26.04' を使用して起動できます
    Ubuntu-26.04 を起動しています...
    Provisioning the new WSL instance Ubuntu-26.04
    This might take a while...
    Create a default Unix user account: ubuntu
    New password:
    Retype new password:
    passwd: password updated successfully
    usermod: no changes
    Help improve Ubuntu!

    Help us improve Ubuntu features and compatibility by sharing system reports with Canonical.
    Reports are sent anonymously and do not contain any personal data.
    For legal details, please visit: https://ubuntu.com/legal/systems-information-notice

    We will save your answer to Windows and will only ask you once.

    Would you like to opt-in to platform metrics collection (Y/n)? To see an example of the data collected, enter 'e'.
    [Y/n/e]: y
    ubuntu@syunhigu-t14:/mnt/c/WINDOWS/system32$ exit
    exit
    PS C:\WINDOWS\system32>
    ```
- 実行している WSL のバージョンを確認する
    ```
    wsl --list -v

    実行結果
    PS C:\WINDOWS\system32> wsl --list -v
    NAME            STATE           VERSION
    * Ubuntu-26.04    Running         2
    ```
