## 概要
- railsでのパフォーマンスを意識した実装の学習用

## Version
- ruby 2.7.1
- rails 6.0.3.3
- MySQL 5.7.22

### アプリ初期設定
- 大量に初期データを投入するため完了するまで約30分ほどかかります
```
$ make init
```

## 起動・停止
### 起動コマンド
```
$ make up
```

### 停止コマンド
```
$ make down
```

## 確認
http://localhost:3000/

## テーブル設計
<img width="953" alt="Untitled_DB設計_rails-performance-training_-_Cacoo" src="https://user-images.githubusercontent.com/592230/94331507-e748a180-0007-11eb-87fc-76df2e969700.png">


## 課題
### 課題1
- Bulletで抽出されたN+1を解消しよう
  - [N+1またはBulletとは?](https://morizyun.github.io/ruby/library-bullet.html)
  - ホームにアクセスすると以下の画像が表示されるので、表示された文言に従ってN+1を解消してください
    -  `categories` テーブルへの `SELECT`文の実行がひとつのTask毎に発生してしまっている
<img width="463" alt="localhost_3000_の内容_と_RailsPefromanceTraining" src="https://user-images.githubusercontent.com/592230/94328866-0e47a900-fff1-11ea-9511-fde53b18a4bd.png">

- ヒント： `ActiveRecord` の `includes` メソッドを利用する
- [回答のPR](Bulletで抽出されたN+1を解消しよう)

### 課題2
- 担当者名の表示で発生するN+1を解消しよう
  - ホームにアクセスすると `users` テーブルへの`SELECT`文の実行がひとつのTask毎に発生してしまっている
- ヒント： ユーザ名はハッシュ等の型で全ユーザ分まとめて先に持たせておいて利用する
- [回答のPR](https://github.com/Matsushin/rails-perfomance-training/pull/3)

### 課題3
- テーブルにインデックスを貼ってSQLの速度を改善しよう
  - `Task.waiting_count_group_by_category` メソッドを実行すると1秒以上かかるので1秒以内となるように
    - PCの性能次第でかかる時間は変わります
- ヒント： SQLの `explain` を利用して実行計画を確認しながらインデックスの効果を試そう
  - [explainとは？](https://style.potepan.com/articles/18910.html)

#### 改善前

メソッド実行例)
```
docker-compose bundle exec rails c
> Task.waiting_count_group_by_category
  Task Load (2316.0ms)  SELECT count(*) as count, category_id FROM `tasks` WHERE `tasks`.`status` = 2 GROUP BY `tasks`.`category_id`
slow query detected: SELECT count(*) as count, category_id FROM `tasks` WHERE `tasks`.`status` = 2 GROUP BY `tasks`.`category_id`, duration: 2.317328453063965
  Category Load (0.8ms)  SELECT `categories`.* FROM `categories` WHERE `categories`.`id` IN (1, 2, 3, 4)
"処理時間 2.5068307s"
=> [{:count=>31400, :category_name=>"仕事", :category_id=>1}, {:count=>31172, :category_name=>"学習", :category_id=>2}, {:count=>31376, :category_name=>"プライベート", :category_id=>3}, {:count=>30831, :category_name=>"その他", :category_id=>4}]
```

EXPLAINの確認例)
<img width="986" alt="_MySQL_5_7_22__ローカル_Docker__rails-performance-training_tasks" src="https://user-images.githubusercontent.com/592230/94331277-2e359780-0006-11eb-822a-f3008436787a.png">

#### 改善後

メソッド実行例)
```
docker-compose bundle exec rails c
> Task.waiting_count_group_by_category
  Task Load (120.7ms)  SELECT count(*) as count, category_id FROM `tasks` WHERE `tasks`.`status` = 2 GROUP BY `tasks`.`category_id`
  Category Load (3.0ms)  SELECT `categories`.* FROM `categories` WHERE `categories`.`id` IN (1, 2, 3, 4)
"処理時間 0.2206787s"
=> [{:count=>31400, :category_name=>"仕事", :category_id=>1}, {:count=>31172, :category_name=>"学習", :category_id=>2}, {:count=>31376, :category_name=>"プライベート", :category_id=>3}, {:count=>30831, :category_name=>"その他", :category_id=>4}]
```

- [回答のPR](https://github.com/Matsushin/rails-perfomance-training/pull/4)