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
local admob = require("ads")

local this = object.new()

this.initialized = false
this.data = {}

------------------------------
-- イベントのリスナー
------------------------------
local function adListener(event)
	print(event)
	if event.name == 'adsRequest' then
		if not event.event.isError then
			
		end
	end

	local dispatchEvent = {
		name = event.response,
	}
	this:dispatchEvent( dispatchEvent )
end

-------------------------
-- initialize
-------------------------
function this.init(appId, option)
	this.data = option
	admob.init('admob', appId, adListener)
	this.initialized = true
end

-------------------------
-- prepare
-------------------------
function this.prepare(ads_type)
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')

	-- prepare
	admob.load( ads_type, {appId = this.data[ads_type]['appId'], testMode=this.data[ads_type]['testMode']})
end


-------------------------
-- show
-------------------------
function this.show(ads_type, option)
	local ads_type_prev = ads_type
	if ads_type == 'header' or ads_type == 'footer' then
		ads_type = 'banner'
	end
	assert(this.initialized == true, 'ERROR : ads.init() をして下さい')
	assert(ads_type, 'ERROR : ads_typeが指定されていません')
	assert(ads_type == 'interstitial' or ads_type == 'banner', 'ERROR : 存在しないads_type('..ads_type..')です(admob.lua)')

	-- prepare
	admob.show( ads_type, {x = option.x or 0, y = option.y or 0, appId = this.data[ads_type_prev]['appId'], testMode=this.data[ads_type_prev]['testMode']})
end


--------------------------
-- remove
--------------------------
function this.remove()
	admob.hide()
end
return this