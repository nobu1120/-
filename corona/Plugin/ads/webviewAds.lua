-- ProjectName : 
--
-- Filename : webviewAds.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-07-08
--
-- Comment : 
--
----------------------------------------------------------------------------------


-- local ads = require( "ads" )
local this = object.new()

this.header        = nil
this.footer        = nil
this.icon          = nil
this.wall          = nil
this.interstitial  = nil

this.header_isVisible        = false
this.footer_isVisible        = false
this.icon_isVisible          = false  
this.wall_isVisible          = false 
this.interstitial_isVisible  = false

---------------------------------
-- ads
--
-- ads[ads_type] = {}
-- ads[ads_type]['option']
-- ads[ads_type]['view']
-- ads[ads_type]['phase']
-- ads[ads_type]['isVisible']
---------------------------------
local ads = {}

-- 表示位置のサンプル
local position = {}
position['icon']         = {x=0, y=_H/2+5, width=_W, height=140}
position['header']       = {x=0, y=0,      width=_W, height=100}
position['footer']       = {x=0, y=_H-100, width=_W, height=100}
position['wall']         = {x=0, y=0,      width=_W, height=_H}
position['interstitial'] = {x=0, y=0,      width=_W, height=_H}

-----------------------------------
-- イニシャライズ
--
-- @params table option : 
-----------------------------------
function this.init(option)
	ads = {}
	for k, v in pairs(option) do
		ads[k] = {}
		ads[k]['url'] = v
	end
end


----------------
-- 表示判定
----------------
local function visible(ads_type, set)
	if not ads[ads_type] then
		ads[ads_type] = {}
	end	

	if set == true or set == false then
		ads[ads_type]['isVisible'] = set
	end
	return ads[ads_type]['isVisible']
end

-- 広告リスナー
local isVisible = false
local function urlListener(event)

	local shouldLoad = true

	if event.errorCode then
		shouldLoad = false
		isVisible = false
	end

	-----------------------
	-- applipromotionの場合
	-----------------------

	if event.url:find("ad.applipromotion.com") then
		print(event.target.type)
		print(event.url, event.type)
		print(shouldLoad, isVisible)
		if event.url:find("wall") and event.type == "link" and system.getInfo( "platformName" ) == 'Android' then
			if isVisible then
				shouldLoad = false
				isVisible = false
			else
				isVisible = true
			end
		elseif event.url:find("wall") and system.getInfo( "platformName" ) == 'iPhone OS' then
			if isVisible then
				shouldLoad = false
				isVisible = false
			else
				isVisible = true
			end
		elseif event.url:find("open") then
			shouldLoad = false
			isVisible = false
			-- this.reload()
			system.openURL(event.url)			
		end
		if shouldLoad == false then
			if ads['wall'] then
				ads['wall']['view']:removeSelf()
			end
			if ads['wall']['view'] then
				ads['interstitial']['view']:removeSelf()
			end
			isVisible = false
		end
	elseif(event.type == "link") and not event.url:find("html#") then
		system.openURL(event.url)
		this.reload()
		isVisible = false
	end

	return shouldLoad
end

---------------------------------
-- 表示している広告をリロードする
---------------------------------
function this.reload()
	if this.header then
		this.header:removeSelf( )
		this.get('header')
	end
	if this.footer then	
		this.footer:removeSelf( )
		this.get('footer')
	end
	if this.icon then
		this.icon:removeSelf( )
		this.get('icon')
	end
	if this.interstitial then
		this.interstitial:removeSelf()
		this.get('interstitial')
	end
end

--------------------------------------------------------
-- 表示する広告の取得
--
-- @params string ads_type : 広告の種類(php側と一致させる)
-- @params table  option   : 
--------------------------------------------------------
function this.prepare_prev(ads_type, option)
	local function listener(event)

		local data = json.decode(event.response)
		if data then
			local ad_option = {
				 url = data.url
			}

			ads[ads_type]['url'] = data.url
			ads[ads_type]['prepared'] = true

			-- prepare終了
			local dispatchEvent = {
				name = 'webviewAds',
				response = 'prepared',
				phase = 'prepared',
				ads_type = ads_type
			}
			this:dispatchEvent(dispatchEvent)			
		end
	end

	assert(ads_type, 'ERROR : ads_typeを指定してください')

	if not ads[ads_type] then
		ads[ads_type] = {}
	end
	ads[ads_type]['prepared'] = false

	--付加するパラメータ
	local params = {}
	params['type'] = ads_type
	params['platform'] = system.getInfo( "platformName" )
	fnetwork.request(urlBase .. "ads/init.php", "POST",listener, params)		

	local target = visible(type, true)
end


function this.prepare(ads_type, option)

	assert(ads_type, 'ERROR : ads_typeを指定してください')
	local target = visible(type, true)

	if ads[ads_type]['url'] then
		-- prepare終了
		local dispatchEvent = {
			name = 'webviewAds',
			response = 'prepared',
			phase = 'prepared',
			ads_type = ads_type
		}
	else
		local dispatchEvent = {
			name = 'webviewAds',
			response = 'fail',
			phase = 'fail',
			ads_type = ads_type
		}
	end
	this:dispatchEvent(dispatchEvent)
end


-----------------------------------------------
-- 広告の表示
--
-- @params str type : 広告のタイプ
-- @params table  option : 表示位置などの設定
-----------------------------------------------
function this.show(ads_type, option)
	local x, y, w, h = nil, nil, nil, nil

	if position[ads_type] then
		local p = position[ads_type]
		x, y = p.x, p.y
		w, h = p.width, p.height
	end

	if option then
		x = option.x or x
		y = option.y or y
		w = option.width or w
		h = option.height or h
		print("x"..x.." y"..y.." w"..w.." h"..h)
	end
	print("ads_type" .. ads_type)

	assert(x and y and w and h, 'ERROR : 座標、サイズが指定されていません')
	assert(ads_type, 'ERROR : ads_typeを指定して下さい')

	visible(ads_type, true)

	local function showAds()
		-- 表示していいか判定
		local view = visible(ads_type)

		local url = ads[ads_type]['url']
		print("-------- url ----------")
		print(url)

		-- applipromotion用
		if url:find("ad.applipromotion.com") then
			print("isVisible = ", isVisible)
			if isVisible == false then
				view = false
			end
		end

		if view == true then
			ads[ads_type]['view'] = native.newWebView(0, 0, w, h)
			ads[ads_type]['view'].x, ads[ads_type]['view'].y = x + w/2 , y + h/2
			ads[ads_type]['view'].hasBackground = false
			ads[ads_type]['view']['ads_type'] = ads_type
			ads[ads_type]['view']:addEventListener("urlRequest", urlListener)
			ads[ads_type]['view']:request(url, system.ResourceDirectory)

			local dispatchEvent = {
				name = 'webviewAds',
				phase = 'showed',
				ads_type = ads_type
			}
			this:dispatchEvent(dispatchEvent)
		end
	end

	-- prepare前かどうか
	if not ads[ads_type]['url'] then
		local function showListener(event)
			if event.response == 'prepared' then
				showAds()
				this:removeEventListener( showListener )
			end
		end
		this:addEventListener( showListener )
		this.prepare(ads_type)
	else
		showAds()
	end	
	
	return target
end


function this.remove(ads_type)
	assert(ads_type, 'ERROR : ads_typeを指定して下さい')
	if ads[ads_type] and ads[ads_type]['view'] then
		local target = ads[ads_type]['view'] 
		if target then
			local flag, ret = pcall(target.removeSelf, target)
			if not flag then
				print("error", ret)
			end
		end
		target = nil

		visible(ads_type, false)
	end
end

return this