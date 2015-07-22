-- ProjectName : ads
--
-- Filename : chartboost.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-07-08
--
-- Comment :
---------------------------------------------------------
local chartboost = require("plugin.chartboost")

local this = object.new()

this.initialized = false
this.chartboost_appID = ''
this.chartboost_appSignature = ''

------------------------------
-- イベントのリスナー
------------------------------
local function adChartboostListener(event)
	if event.response == 'cached' then
		-- キャッシュ完了

	elseif event.response == 'willDisplay' then
		-- 広告表示前

	elseif event.response == 'didDisplay' then
		-- 広告表示完了

	elseif event.response == 'closed' then
		-- 広告を閉じた

	elseif event.response == 'clicked' then
		-- 広告インストールボタンを押した

	elseif event.response == 'reward' then
		-- 広告を見終わった時

	elseif event.response == 'failed' then
		-- 表示するコンテンツがありません
		print("chartboost : 失敗しました。", event.info)
	end

	local dispatchEvent = {
		name = event.response,
	}
	this:dispatchEvent( dispatchEvent )
end

-------------------------
-- initialize
-------------------------
function this.init(option)
	local appID = option.chartboost_appID or this.chartboost_appID
	local appSignature = option.chartboost_appSignature or this.chartboost_appSignature

	assert(appID, 'ERROR : chartboost_appIDのIDを設定してください')
	assert(appSignature, 'ERROR : chartboost_appSignatureのIDを設定してください')

	-- chartboostイニシャライズ
	chartboost.init{
		appID=appID,
		appSignature=appSignature, 
		listener=adChartboostListener
	}
	chartboost.startSession( appID, appSignature )

	this.initialized = true
end

-------------------------
-- prepare
-------------------------
function this.prepare(ads_type)
	if ads_type == 'wall' then
		ads_type = 'moreApps'
	end
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')
	assert(ads_type == 'interstitial' or
			ads_type == 'rewardedVideo' or 
			ads_type == 'moreApps', 'ERROR : 存在しないads_type('..ads_type..')です(chartboost1)')

	-- prepare
	chartboost.cache( ads_type )
end


-------------------------
-- show
-------------------------
function this.show(ads_type)
	if ads_type == 'wall' then
		ads_type = 'moreApps'
	end
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')
	assert(ads_type == 'interstatial' or
			ads_type == 'rewardedVideo' or 
			ads_type == 'moreApps', 'ERROR : 存在しないads_type('..ads_type..')です(chartboost2)')

	-- prepare
	print("chartboost : "..ads_type)
	chartboost.show( ads_type )
end


--------------------------
-- remove
--------------------------
function this.remove()
	chartboost.closeImpression()
end
return this