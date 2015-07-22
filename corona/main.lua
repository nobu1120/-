require('Module.main_config')

-- マルチタッチ対応
system.activate( "multitouch" )
------------------------
-- 広告関連
------------------------
ads = require(PluginDir .. 'ads.ads')

-- イニシャライズ（ ※ 必須です）
ads.init()

---------------------------------------
-- リワード広告
--
-- 動画広告を見るとインセインティブもらえる
--------------------------------------

-- 動画広告用リスナー
local function rewardedVideoListener(event)
	if event.name == 'reward' then
		-- 広告を見た時（インセンティブ付与などはここに記載）

	elseif event.name == 'cancel' then
		-- 中断した時
	elseif event.name == 'close' then
		-- 広告を閉じた時に呼ばれる
		ads.prepare('rewardedVideo')

	elseif event.name == 'faild' then
		-- 失敗
		-- ここに広告が見つからなかった時の処理を記載
	end
end


-- リワード動画広告 準備(optional)
-- ads.show('rewardedVideo', {listener = rewardedVideoListener, service='chartboost'})

-----------------
-- 解析 (Flurry)
-----------------
analytics = require(PluginDir..'analytics.analytics')

-----------------------
-- スコア
-----------------------
score = require(PluginDir..'score.score')

-----------------------
-- シェア
-----------------------
share = require(PluginDir..'share.share')

--------------------
-- ゲームネットワーク
--------------------
gamecenter = require(PluginDir.."gamecenter.gamecenter" )
gamecenter.init(gamecenter.login)
if system.getInfo( 'platformName' ) == 'iPhone OS' then
	gamecenter.category = 'jp.co.freep.destroyJar.high_score'
else
	gamecenter.category = 'CgkInczJ3pwNEAIQAQ'
end

------------------------
-- BGM設定
----------------------
-- local bgm = audio.loadSound( "Sound/countDownBgm.wav" )
-- local bgmChannel
-- bgmChannel = audio.play( bgm , {loops=-1})

----------------------
-- ゲームの初期設定を読み込む
----------------------
local function networkListener( event )

    if ( event.isError ) then
        print( "Network error!" )
    else
        print ( "RESPONSE: " .. event.response )
        local setting_data = json.decode(event.response)

        -- 残り時間と画像を切り替えるタップ数を読み込む
        game_time = setting_data.time or 30
        taps_change_image = setting_data.taps_change_image or 5
        up_point = setting_data.up_point or 11

    end
end
network.request( urlBase .. "ads/conf.php" , "GET" , networkListener )

----------------------
-- 画面遷移
----------------------
local storyboard = require "storyboard"
local physics = require("physics")

-- シーンを毎回消す
storyboard.purgeOnSceneChange = true

-- 最初のページ遷移
storyboard.gotoScene( ContDir .. "topPage" , { time = 1000 , effect = "fade" } )
