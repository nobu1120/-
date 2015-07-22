#ads.lua
----

###Overview
広告機能について。実装方法や登録方法についてまとめる。

### 実装の前に
1. 広告の登録
2. phpの実装
3. アプリ側の実装

#### 広告の登録
* アプリを申請に出す
* 広告を登録して申請に出す
* コードを取得する

#### PHP側の実装
* ヘッダーやフッターなど必要な物を準備する  

**※PHPはまだパッケージ化できていないのでしばらくお待ちください**

####アプリ側の実装
1. main.luaのadsのコメントアウトを外す  
```
ads = require(PluginDir .. 'ads.ads')
```
2. 表示したい場所で広告を呼び出す  
```
ads.get('interstatial')
```
3. 消すタイミングでremoveを呼ぶ
```
ads.remove('interstatial')
```

**広告のタイプは以下の通り**
> header  : 画面上部バナー広告  
> footer  : 画面下部バナー広告  
> icon  : アイコン広告  
> interstatial  : インターステイシャル広告  

**※現在(2015-06-30)まだ位置調整用の関数を用意していないためadsを直接弄って大丈夫です。**

****

#### 申請時の注意
※iOSは審査期間中必ずウォール広告・アイコン広告は非表示にして下さい

**非表示方法**

> php
  
```
if(isset($platform) && $platform == 'iPhone OS'){ 
   $ret['hidden_wall'] = false;      
}     

```

> lua

```
----------------
-- 広告のリスナ
----------------
local function adsListener(event)
    if event.name == 'hidden_wall' then
        if not scene.view then return end
        if event.result == true then
            scene.view.wall_btn.isVisible = false
        else
            scene.view.wall_btn.isVisible = true
        end
    end
end

function scene:enterScene( event )
    local group = self.view
    gameover_view:addEventListener( listener )
    ads:addEventListener( adsListener )
end
```