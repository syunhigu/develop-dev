# Git Flowコマンド
参考サイト  
https://www.atlassian.com/ja/git/tutorials/comparing-workflows/gitflow-workflow  
https://dev.classmethod.jp/articles/introduce-git-flow/  
https://qiita.com/CarlBrown23/items/84a6c1ce82f602eaa5a6  
https://qiita.com/KosukeSone/items/514dd24828b485c69a05  

## ヘルプ
```
git flow help
```

## 1. 初期化
```
git flow init -d

hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint:   git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint:   git branch -m <name>
Initialized empty Git repository in /Users/syunhigu/github/git-flow-test/.git/
Using default branch names.
No branches exist yet. Base branches must be created now.
Branch name for production releases: [master] 
Branch name for "next release" development: [develop] 

How to name your supporting branch prefixes?
Feature branches? [feature/] 
Release branches? [release/] 
Hotfix branches? [hotfix/] 
Support branches? [support/] 
Version tag prefix? [] 
```
-dオプションはディフォルトのブランチ名が自動で付けられるオプション。  
git branchコマンドを使ってブランチの情報を確認する。  
```
git branch
* develop
  master
```

以下はリポジトリ初期作成時にリポジトリ作成して行う  
```
git checkout master
git branch -M master
git remote add origin git@github.com:ユーザーID/リポジトリ名.git
git push -u origin master
git checkout develop
git push origin develop
```

------------------------------------
## 2. featureブランチで機能開発  
### 2.1. featureブランチの作成  
featureブランチは**developブランチ**から作成する  
```
git flow feature start <feature name>

例）
git flow feature start test                                    
Switched to a new branch 'feature/test'

Summary of actions:
- A new branch 'feature/test' was created, based on 'develop'
- You are now on branch 'feature/test'

Now, start committing on your feature. When done, use:

     git flow feature finish test
```
git branchコマンドを実行して確認すると、  
```
git branch
  develop
* feature/test
  master
```

`feature/<feature name>` のブランチが作成され、自動にcheckoutされる。  
`<feature name>`は開発する機能がわかるように設定する。  

GitHubなどのプラットフォームを使って他の開発者とコラボレーションをしている場合は  
**publish**コマンドを使ってリポジトリにfeatureブランチをpushすることもできる。  
```
git flow feature publish <feature name>

例）
git flow feature publish test
```

* 逆にリポジトリからfeatureブランチを持ってくる場合はpullコマンドを使う。  
```
git flow feature pull origin <feature name>
```

このブランチで新しい機能の開発をする。  
今回はテキストファイルを一つ作ることで代替する。  
```
touch hogehoge.txt
```

### 2.2. 開発作業完了時  
開発作業がある程度完了して、Pushできる状態になったら、addとcommit、pushを行う。  
```
git add hogehoge.txt
git commit -m "hogehoge"
git push origin feature/test
```

rejectされてpushができない場合。rebaseする必要がある。  
他のメンバーが先に編集をpushしたため、fast-forwardでないから。  
* RejectされてPushできない場合  
Rebaseを行う。
Rebaseを行うことで、自身の変更を基準にして、branchにマージできる。
分からない方は下記のLigの記事を参考。  
https://liginc.co.jp/web/tool/79390#m1  
Rebaseは下記のコマンドで実行できる。  
```
git pull --rebase origin feature/test
```

pull --rebaseを行うとコンフリクトする事がある。  
競合のあった箇所には、Gitが差分を挿入している。  
この場合は、手動で変更データを変更する必要がある。  
変更すべき点は、各メンバーと連携をとりながら変更する。  
コンフリクトを解消したら、git addしてgit rebase --continueする。  
```
git add test.txt
git rebase --continue
```

実施後、レビュワーに確認してもらう  

------------------------------------
### 2.3. developブランチにマージ  
機能開発が完了したら**finish**コマンドでdevelopブランチにマージする。  
```
git flow feature finish <feature name>

例）
git flow feature finish test
```

このコマンドを実行することで、以下の作業が自動に行われる。  
* developブランチにcheckout
* featureブランチをマージ
* featureブランチの削除

### 2.4. マージしたdevelopブランチのプッシュ  
マージしたdevelopブランチをリモートリポジトリにプッシュする  
```
git push origin develop
```

------------------------------------
### 2.5. releaseブランチでリリースを準備
リリースのための全ての機能をdevelopブランチにマージしたら、releaseブランチでQAを行う。  
releaseブランチを作成する。  
* releaseブランチを作成  
```
git flow release start <version>

例）
git flow release start test
```

**git branch**で確認すると
```
git branch 
  develop
  master
* release/test
```
このように`release/<version>`のブランチが作成され、自動にcheckoutされている。  
このブランチでQA作業を行う。  
QA作業も終わったらリリースする準備は完了。  

featureブランチと同じように他の開発者とコラボレーションしている場合はpublishコマンドでリポジトリにpushできる。  
```
git flow release publish <version>

例）
git flow release publish test
```

リポジトリからreleasaeブランチを持ってくる場合はtrackコマンドを使う。  
pullではないので、気をつけること。  
```
git flow release track <version>
```

------------------------------------
### 2.5. master, developブランチにマージ
finishコマンドでmaster, developブランチにマージする。  
```
git flow release finish <version>

例）
git flow release finish test

下記のメッセージ表示されるが、問題なければ「:q 」を入力
①
Merge branch 'release/test'
# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
②
#
# Write a message for tag:
#   test
# Lines starting with '#' will be ignored.
```

**※環境によってはされない場合がある**
* releaseブランチをmasterブランチにマージ
* releaseブランチをdevelopブランチにマージ
* releaseブランチを削除　※

releaseブランチを手動で削除する場合  
```
git branch -D release/test
```

### 2.6. マージしたdevelopブランチのプッシュ  
マージしたdevelopブランチをリモートリポジトリにプッシュする  
```
git push origin develop
```

------------------------------------
### 2.7. リリース  
ここまですると、masterブランチは新しいリリースバージョンのソースコードを持っている。  
最後にmasterブランチをリポジトリにpushしてリリースする。  
```
git push origin master 
```

------------------------------------
## 3. リリース後の緊急バグ対応  
### 3.1. hotfixブランチの作成  
リリースされたバージョンに緊急のバグが発生するとhotfixブランチで対応する。  
hotfixブランチは**masterブランチ**から作成する  
```
git flow hotfix start <version>

例）
git flow hotfix start test2
Switched to a new branch 'hotfix/test2'

Summary of actions:
- A new branch 'hotfix/test2' was created, based on 'master'
- You are now on branch 'hotfix/test2'

Follow-up actions:
- Bump the version number now!
- Start committing your hot fixes
- When done, run:

     git flow hotfix finish 'test2'
```

### 3.2. 開発作業完了時  
作業がある程度完了して、Pushできる状態になったら、addとcommit、pushを行う。  
```
git add test2.txt
git commit -m "test2"
git push origin hotfix/test2
```

### 3.3. masterブランチにマージ  
作成したhotfixブランチで緊急のバグを修正した後、finishコマンドを使ってmasterブランチにマージする。
```
git flow hotfix finish <version>

例）
git flow hotfix finish test2
下記のメッセージ表示されるが、問題なければ「:q 」を入力
①
Merge branch 'hotfix/test2'
# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
#
# Lines starting with '#' will be ignored, and an empty message aborts
# the commit.
②
#
# Write a message for tag:
#   test2
# Lines starting with '#' will be ignored.
```

このコマンドを実行することで、以下の作業が自動に行われる。  
**※環境によってはされない場合がある**  
* hotfixブランチをmasterブランチにマージ
* hotfixブランチをdevelopブランチにマージ　※
* hotfixブランチを削除　※  
developブランチにマージされていない場合は、developブランチにmasterブランチをマージ及びプッシュすること  

releaseブランチを手動で削除する場合  
```
git branch -D hotfix/test2
```

### 3.4. リリース  
ここまですると、masterブランチは新しいリリースバージョンのソースコードを持っている。  
最後にmasterブランチをリポジトリにpushしてリリースする。  
```
git push origin master 
```

------------------------------------  
## release、hotfixブランチの複数作成できない場合の対応  
https://qiita.com/tomgoodsun/items/7a9e6c115f758d54f254  
releaseブランチ、hotfixブランチで新たにブランチ作成で下記メッセージが表示され複数作成できない場合がある  
後述のconfig設定を行う  
* releaseブランチ  
```
git flow release start test3 
There is an existing release branch (test). Finish that one first.
```
* hotfixブランチ  
```
git flow hotfix start test4   
There is an existing hotfix branch (test2). Finish that one first.
```
config設定  
Git管理しているディレクトリで以下のコマンドを実行する。（GitBashとかで実行） 
* releaseブランチ   
```
git config --add gitflow.multi-release true

グローバルに設定する場合
git config --global --add gitflow.multi-release true
```
* hotfixブランチ  
```
git config --add gitflow.multi-hotfix true

グローバルに設定する場合
git config --global --add gitflow.multi-hotfix true
```