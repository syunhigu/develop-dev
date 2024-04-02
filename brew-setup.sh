#!bin/sh

#インストール一覧
brew install git
brew install zsh
brew install zsh-completions
#brew install docker-machine
brew install docker-compose
#brew install postgresql
brew install awscli
brew install git-flow
brew install tree
#cask
brew install --cask google-chrome
brew install --cask sourcetree
brew install --cask visual-studio-code
brew install --cask firefox
brew install --cask skype
brew install --cask dropbox
#brew install --cask google-backup-and-sync
brew install --cask google-drive-file-stream
brew install --cask github
brew install --cask microsoft-office
brew install --cask docker
brew install --cask virtualbox
brew install --cask vagrant
brew install --cask slack
#brew install --cask transmit
brew install --cask oracle-jdk
brew install --cask thunderbird
brew install --cask iterm2
#brew install --cask pgadmin4
brew install --cask tableplus
#brew install --cask dbeaver-community
#brew install --cask postico
#brew install --cask comparemerge
brew install --cask discord
brew install --cask zoom
brew install --cask microsoft-teams
brew install --cask gather
brew install --cask adobe-creative-cloud
brew install --cask adobe-creative-cloud-cleaner-tool

<< COMMENTOUT
Docker Desktopがインストールできないため、再インストール
※参考
https://devops-blog.virtualtech.jp/entry/20230719/1689734993
brew install docker          #Docker CLI
brew install --cask docker   #Docker Desktop for mac

・Docker Desktopを再インストールしたい時
brew uninstall --cask docker
brew install --cask docker

※Docker Desktopが不明なエラーのせいで起動しなくなったとか、
/usr/local/bin/のリンクファイルを誤って上書きしてしまった時とか。

・インストール
brew install --cask docker
==> Downloading https://formulae.brew.sh/api/cask.jws.json
######################################################################### 100.0%
==> Downloading https://raw.githubusercontent.com/Homebrew/homebrew-cask/27ba396
######################################################################### 100.0%
==> Downloading https://desktop.docker.com/mac/main/amd64/139021/Docker.dmg
######################################################################### 100.0%
==> Installing Cask docker
〜略〜
==> Backing App 'Docker.app' up to '/usr/local/Caskroom/docker/4.28.0,139021/Doc
==> Removing App '/Applications/Docker.app'
==> Purging files for version 4.28.0,139021 of Cask docker
Error: It seems there is already a Binary at '/usr/local/bin/docker-index'.

・GitHub issue
https://github.com/Homebrew/homebrew-cask/issues/146078
要約すると、--forceをつけて全部削除してインストールし直すだけで解決できる

brew uninstall --cask docker --force
・アンインストール
brew uninstall --cask docker --force
==> Downloading https://raw.githubusercontent.com/Homebrew/homebrew-cask/27ba396
Already downloaded: /Users/syunhigu/Library/Caches/Homebrew/downloads/e14331c9d1357dd040db6a2e94eaf5ea692da8bd174bfe05aa4ac9cd3d69da87--docker.rb
==> Uninstalling Cask docker
==> Removing launchctl service com.docker.helper
Password:
〜略〜
==> Unlinking Binary '/usr/local/bin/docker-index'
==> Purging files for version 4.28.0,139021 of Cask docker
brew install --cask docker
・インストール
brew install --cask docker          
==> Downloading https://formulae.brew.sh/api/cask.jws.json
######################################################################### 100.0%
==> Downloading https://raw.githubusercontent.com/Homebrew/homebrew-cask/27ba396
Already downloaded: /Users/syunhigu/Library/Caches/Homebrew/downloads/e14331c9d1357dd040db6a2e94eaf5ea692da8bd174bfe05aa4ac9cd3d69da87--docker.rb
==> Downloading https://desktop.docker.com/mac/main/amd64/139021/Docker.dmg
Already downloaded: /Users/syunhigu/Library/Caches/Homebrew/downloads/3fe36a1cf82614ae8b3ccadaf04ddaf091d92e6a5cc43b18773ecc2638b1d43d--Docker.dmg
==> Installing Cask docker
==> Moving App 'Docker.app' to '/Applications/Docker.app'
〜略〜
==> Linking Binary 'docker-compose.bash-completion' to '/usr/local/etc/bash_comp
🍺  docker was successfully installed!
COMMENTOUT