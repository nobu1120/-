-- ProjectName : 
--
-- Filename : gamecenter.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-06-30
--
-- Comment : 
--
----------------------------------------------------------------------------------
--  -- Sample
-- gamecenter = require(PluginDir .. 'gemecenter.gamecenter')

-- -- イニシャライズ
-- gamecenter.init()

-- -- ログイン	
-- gamecenter.login()

-- -- ハイスコアを投稿するボードの設定(iOS, Androidそれぞれ)
-- gamecenter.category = ''
-- gamecenter.setHighScore(100)

-- -- ランキング表示
-- gamecenter.showRankingBoard()
----------------------------------------------------------------------------------

local gameNetwork = require "gameNetwork"
local this = object.new()

-- パラメータ
local platform = nil
local initialized = false

-- リーダーボードのid	
this.category = nil

if system.getInfo( 'platformName' ) == 'iPhone OS' then
	platform = 'iOS'
elseif system.getInfo( 'platformName' ) == 'Android' then
	platform = 'Android'
end
--------------------------
-- listner
--------------------------
local function requestCallback(event)
	print("requestCallback")
	print(event)
	if event.type == 'login' then
		if event.isError ~= true then
			this.logined = true
			print("login")
		end
	end
end

----------------------------
-- アラートのポップアップ
----------------------------
local function onComplete(event)
	if event.action == "clicked" then
		local i = event.index
		if i == 1 then
			-- OKボタンは自動で閉じる
		end
	end
end

---------------------- 
-- ログインする
---------------------- 
function this.login()
	if initialized == true then
		if platform == 'iOS' then
			gameNetwork.request( "loadLocalPlayer", { listener=requestCallback } )
		elseif platform == 'Android' then
			gameNetwork.request( "login",{userInitiated = true, listener = requestCallback})
		end
	else
		this.init(this.login)
	end
end

--------------------------
-- ランキングボードを見る
--------------------------
function this.showRankingBoard()
	if this.logined == true then
		gameNetwork.show( "leaderboards" )
	else
		if platform == 'iOS' then
			local alert = native.showAlert( "ランキング", "GameCenterにログインして下さい。", { "OK"}, onComplete )
		end
		this.login()
	end
end


---------------------------
-- ハイスコアを送信する
---------------------------
function this.setHighScore(score)
	assert(this.category, "ERROR : NOT FOUND this.category")
	if initialized == true then
		if this.category then
			print('-----lll----')
			print(score)
			gameNetwork.request( "setHighScore",
			 	{
			 		localPlayerScore = { category=this.category, value=score },
			 		listener = requestCallback
			 	}
			)
		end
	else
		this.init(this.setHighScore)
	end
end


---------------------------
-- イニシャライズする
---------------------------
function this.init(endAction)
	print("gamecenter init")
	local function initCallback( event )
		-- Androidログイン
		if platform == 'Android' then
			print(event)
			if not event.isError then
				initialized = true
				if endAction then
					endAction()
				end
			else
				native.showAlert( "Failed!", event.errorMessage, { "OK" } )
				print( "Error Code:", event.errorCode )
			end
		end

		-- iOSログイン
		if platform == 'iOS' then
			print(event)
			if ( event.type == "showSignIn" ) then
				-- This is an opportunity to pause your game or do other things you might need to do while the Game Center Sign-In controller is up.
			elseif ( event.data ) then
				initialized = true
				this.logined = true
				if endAction then
					endAction()
				end
			end
		end
	end

	if platform == 'iOS' then
		gameNetwork.init( "gamecenter", initCallback )
	elseif platform == 'Android' then
		gameNetwork.init( "google", initCallback )
	end
end

return this