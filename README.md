# timeline-list-sync

あなたがフォローしているユーザーを全てリストにぶち込み、同期するようにします。一回の実行でにユーザの追加と削除処理をそれぞれ100件を上限に行う。

## 注意

API叩きすぎてTwitterに怒られると、アカウントが一時的に制限されたりする可能性があるので調子に乗りすぎないように注意しましょう。
このプログラムを使って何らかのトラブルが起こった場合、私は一切の責任を負いません。使用は自己責任でお願いします。

## How To Use (なんかそれっぽいの)

### 1. buildして適当な場所に置く

```
swift build -c release
sudo cp .build/release/timeline-list-sync /usr/local/bin/
```

### 2. .envで設定する

```.env_sample```を参考に.envファイルにAPI Keyなどを書いて設定する。

```
cp .env_sample ~/.timeline-list-sync.env
```

編集する.

#### TWITTER_LIST_IDが不明の場合

```TWITTER_LIST_ID```を設定せずに実行すればリスト名とlist idの一覧が表示される。

### 3. 実行する

```
source ~/.timeline-list-sync.env
timeline-list-sync
```

#### cronに設定してもいい

15分おきにRate limiteがあるので、最低15分は間隔を設ける。やりすぎると制限されるかも。

下の例では30分間隔

```
*/30 * * * * source ~/.timeline-list-sync.env > /usr/local/bin/timeline-list-sync
```
