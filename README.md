# 研究観光資源マップ

地域の観光資源に関連する研究を可視化します。

[デモ](https://research-attraction-maps.herokuapp.com/)

このアプリは [【内閣府主催】RESASハッカソン2017 in 鳥取 ～Web・IoTで創る鳥取のミライ～](https://connpass.com/event/67429/)で開発しました。

以下のAPIを使用しています。

* [RESAS API](https://opendata.resas-portal.go.jp/)で取得したキーを指定します。
	* 都道府県一覧
	* 観光資源情報
* [KAKEN API](https://support.nii.ac.jp/ja/kaken/api/api_outline)で取得したキーを指定します。
	* 科学研究費助成事業データベース

## インストール

Herokuボタンより1クリックでHerokuにデプロイできます。

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy?template=https://github.com/mh61503891/research-attraction-maps)

以下の環境変数を設定する必要があります。

* `RESAS_API_KEY`: [RESAS API](https://opendata.resas-portal.go.jp/)で取得したキーを指定します。
* `CINII_API_KEY`: [KAKEN API](https://support.nii.ac.jp/ja/kaken/api/api_outline)で取得したキーを指定します。
