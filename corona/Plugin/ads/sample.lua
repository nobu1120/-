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
ads.prepare('rewardedVideo')-- 必須でない
ads.show('rewardedVideo', {listener = rewardedVideoListener, service='chartboost'})

--------------------------------
-- ヘッダー, フッター, アイコン
--------------------------------
ads.prepare('header')-- 必須でない
ads.show('header', {x=0, y=0, width=_W, height=100, service='nend'})
ads.remove('header')

------------------------------------------------------
-- インターステイシャル
--
-- 全画面広告（chartboostの場合, 画像と動画の２パターン）
------------------------------------------------------
ads.prepare('interstitial') -- 必須でない
ads.show('interstitial', {service='chartboost'})
ads.remove('interstitial')