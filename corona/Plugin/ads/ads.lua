-- ProjectName : 
--
-- Filename : ads.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-06-18
--
-- Comment : 
--
-- 利用中の広告
--   * webView系広告
--   * chartboost
--
-- 広告タイプ一覧
-- header : 画面上部のバナー広告
-- footer : 画面下部のバナー広告
-- icon   : アイコン広告
-- wall   : 画面全体の広告
----------------------------------------------------------------------------------
-- chartboost
local chartboost = require(PluginDir .. 'ads.chartboost')
local webviewAds = require(PluginDir .. 'ads.webviewAds')
local admob      = require(PluginDir .. 'ads.admob')

local this = object.new()

local chartboost_appID
local chartboost_appSignaturep

if system.getInfo("platformName") == "iPhone OS" then
	chartboost_appID = '55a09387c909a603389667ab'
	chartboost_appSignature = 'eefd9b05003c2a5b076068dd2fef1598bc1145eb'
elseif system.getInfo("platformName") == "Android" then
	chartboost_appID = '55a094b843150f1b6f7f9dc9'
	chartboost_appSignature = 'f67dfe0ec173b7a550fffef089f74c092a21c6f3'
end

-- 設定
this.option = {
	-- 媒体を設定(optional)
	service = {
		banner = 'nend',
		header = 'nend',
		footer = 'nend',
		icon   = 'nend',
		wall   = 'applipromotion',
		interstitial = 'chartboost',
		rewardedVideo = 'chartboost',
	},
	-- chartboost設定時
	chartboost_appID = chartboost_appID,
	chartboost_appSignature = chartboost_appSignature,
}
this.hidden_wall = false

local is_initialized = false

-----------------------------------
-- イニシャライズ
--
-- Chartboostのイニシャライズを行う	
--
-- @params table option : 
-----------------------------------
local chartboost_isVisible = false
local webView_isVisible = false
local admob_isVisible = false

local function initListener(event)
	local webViewOption = {}
	local admobOption = {}

	if event.isError then

	else
		local data = json.decode(event.response)

		for k, v in pairs(data.ads) do
			this.option.service[v.type] = v.service

			-- webViewAds用
			if v.url then
				webViewOption[v.type] = v.url
			end

			-- chartboost用
			if v.service == 'chartboost' then
				this.option.chartboost_appID = v.appID
				this.option.chartboost_appSignature = v.appSignature
			end

			-- admob用
			if v.service == 'admob' then
				this.option.nend_appID = v.appID
				admobOption[v.type] = {appId=v.appID , testMode=v.testMode}
			end
		end

		-- ウォール広告の有無を送信
		this.hidden_wall = data.hidden_wall
		local dispatchEvent = {
			name = 'hidden_wall',
			result = data.hidden_wall or false
		}
		this:dispatchEvent(dispatchEvent)	
	end

	for k, v in pairs(this.option.service) do
		if v == 'chartboost' then
			chartboost_isVisible = true

		elseif v == 'nend' or v == 'applipromotion' then
			webView_isVisible = true

		elseif v == 'admob' then
			admob_isVisible = true
		end
	end

	-- chartboost用initialize	
	if chartboost_isVisible == true then
		local chartboost_option = {
			chartboost_appID = this.option.chartboost_appID,
			chartboost_appSignature = this.option.chartboost_appSignature
		}
		chartboost.init(chartboost_option)
	end	

	-- admobのinitialize	
	if admob_isVisible == true then
		admob.init( this.option.nend_appID, admobOption)
	end	

	-- admobのinitialize	
	if webView_isVisible == true then
		print(webViewOption)
		webviewAds.init(webViewOption)
	end	

	is_initialized = true
end

function this.init(option)
	--付加するパラメータ
	local params = {}
	params['platform'] = system.getInfo( "platformName" )
	params['height'] = _H
	fnetwork.request(urlBase .. "ads/init.php", "POST",initListener, params)	
end

-------------------------
-- prepare
-- 
-- @params table option : 
--
-- optionの中身
-- listener : eventListener
-------------------------
function this.prepare(ads_type, option)
	-- 会社に分けてprepare
	if this.option.service[ads_type] == 'chartboost' then
		chartboost.prepare(ads_type, option)

	elseif this.option.service[ads_type] == 'nend' then
		webviewAds.prepare(ads_type, option)

	elseif this.option.service[ads_type] == 'admob' then
		admob.prepare(ads_type, option)

	end
end


--------------------------
-- init待ち
--------------------------
local waiting = {}

-------------------------
-- show
-------------------------
function this.show(ads_type, ads_option)


	print("-----------------------------")
	assert( ads_type , "Error not found ads_type!" )
	if is_initialized == false then
		if not waiting[ads_type] then
			waiting[ads_type] = {}	
			waiting[ads_type]['count'] = 0
			waiting[ads_type]['option'] = ads_option
		end
		
		waiting[ads_type]['count'] = waiting[ads_type]['count'] + 1
		if waiting[ads_type]['count'] < 10 then
			waiting[ads_type]['timer'] = timer.performWithDelay( 100, 
				function()
					this.show(ads_type, ads_option)
				end
			)
		else
			if waiting[ads_type]['timer'] then
				timer.cancel( waiting[ads_type]['timer'] )
			end
		end
	else
		print("-----------------------------")

		-- 表示待ちの管理
		waiting[ads_type] = nil

		-- チャンネルが設定されている場合
		if ads_option and ads_option.channel then

		end

		-- 会社に分けてprepare
		if this.option.service[ads_type] == 'chartboost' then
			chartboost.show(ads_type,ads_option)

		elseif this.option.service[ads_type] == 'nend' or this.option.service[ads_type] == 'applipromotion' then
			webviewAds.show(ads_type,ads_option)
			print_r(ads_option)

		elseif this.option.service[ads_type] == 'admob' then
			admob.show(ads_type, option)

		end
	end
end


--------------------------
-- remove
--------------------------
function this.remove(ads_type, option)
	if waiting[ads_type] then
		if waiting[ads_type]['timer'] then
			timer.cancel( waiting[ads_type]['timer'] )
		end
	end

	-- チャンネルが設定されている場合
	if ads_option and ads_option.channel then
		
	end

	-- 会社に分けてprepare
	if this.option.service[ads_type] == 'chartboost' then
		chartboost.remove(ads_type, option)

	elseif this.option.service[ads_type] == 'nend' then
		webviewAds.remove(ads_type, option)

	elseif this.option.service[ads_type] == 'admob' then
		admob.remove(ads_type, option)

	end
end

----------------------------
-- dispatchEvent
----------------------------
local function dispatchEvent(event)
	this:dispatchEvent(event)
end

admob:addEventListener( dispatchEvent )
chartboost:addEventListener( dispatchEvent )
webviewAds:addEventListener( dispatchEvent )

return this