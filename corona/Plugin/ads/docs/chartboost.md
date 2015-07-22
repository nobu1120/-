#Chartboost

## できること
* 動画広告
* インターステイシャル

またインセンティブを付与して広告を配信できる（動画広告）  
**※ゲーム以外のアプリは、パブリッシング・キャンペーンの実行が許可されていません。**

### パブリッシング・キャンペーン
>広告主がつける入札価格に応じて、ユーザーによるクリック、インストールおよびビデオ視聴完了ごとに収益が得られる  
>[詳細](https://answers.chartboost.com/hc/ja/articles/201219605-Publishing-Campaigns)はこちら


### アドバタイジング・キャンペーン
>自社アプリを宣伝

### クロスプロモーション（自社広告）
>自社ゲーム内で自社の他のゲームの宣伝  
>[詳細](https://answers.chartboost.com/hc/ja/articles/201219635-Cross-Promotion-Campaigns)はこちら

### ダイレクトディール 
>仲介者を介さずに、デベロッパー同士が直接1対1で広告枠の取引

但し条件あり  

```  
・App Store、Google Playストア、またはAmazon Androidアプリストアに登録済みの1つ以上のゲームに、適切なSDKが導入されている
・ダイレクトディール・マーケットプレイスにプロフィールが公開されている
・1日のゲーム起動数が20,000回以上のゲームが1つ以上ある
```

## アプリ・広告登録方法

### アプリ登録

1. [https://dashboard.chartboost.com](https://dashboard.chartboost.com/all/advertising)よりChartboostにログインする
2. [こちら](https://answers.chartboost.com/hc/ja/articles/200797729-%E3%82%A2%E3%83%97%E3%83%AA%E3%81%A8%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%9A%E3%83%BC%E3%83%B3%E3%81%AE%E6%89%8B%E5%A7%8B%E3%82%81)に沿って登録

### 広告発行(パブリッシング・キャンペーン)

1. [パブリッシング・キャンペーン説明ページ](https://answers.chartboost.com/hc/ja/articles/201219605-Publishing-Campaigns)を参考

### テストモード
![](https://dl.pushbulletusercontent.com/jcBNEHrkBPumrNXi182woSDUW9Zg7bnf/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202015-07-08%2015.26.16.png)

**アプリ設定＞基本設定＞テストモードをONにする。ONにする際はテストの時間を設定**

## アプリ側実装

###build.setting

```
settings =
{
    plugins =
    {
        ["plugin.chartboost"] =
        {
            publisherId = "com.swipeware"
        },

        ["plugin.google.play.services"] =
        {
            publisherId = "com.coronalabs",
            supportedPlatforms = { android = true }
        }
    },      
}
```