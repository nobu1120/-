-- countDown.lua
-- Comment : カウントダウンページ 
-- Date : 2015-1-31
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

-- Library 
local storyboard = require("storyboard")

-- BGM
local countDownBgm = audio.loadSound( SoundDir .. "countDown.wav" )
local gameStartBgm = audio.loadSound( SoundDir .. "game_start.mp3" )
local heartBreakBgm = audio.loadSound( SoundDir .. "heart_break.mp3" )
local bgm,bgm1,bgm2
audio.setVolume( 1.0 , { channel = 2 } )

-- シーン作成
local scene = storyboard.newScene()

-- timer
local timerManager_class = require( ModDir .. "timerManager_class")
local timerManager = timerManager_class.new()

-- カウントダウン
local countDownGroup = display.newGroup()
local countDownTimer = {}
local countDownText = nil
local countDownJar = nil
local count = 3
local transitionTable = {}

local function stopTransition()
	for k,v in pairs(transitionTable) do
		transition.cancel(v)
		k = nil
		v = nil
	end
end

local function shakeListener( obj )

	function listener1()
		local transition1 = transition.to( obj , { time = 100 , x = obj.x + 10 , onComplete = listener2} )
		transitionTable[#transitionTable+1] = transition1
	end
	function listener2()
		local transition2 = transition.to( obj , { time = 100 , x = obj.x - 10 , onComplete = listener1} )
		transitionTable[#transitionTable+1] = transition2
	end

	listener1()
end

local function listener( event )
	if event.name == "timer-start" then

		audio.setVolume(0.5)

		-- カウントダウン音
		bgm = audio.play( countDownBgm )
		bgm2 = audio.play( heartBreakBgm , { channel = 2 })

		-- 壺の絵
		countDownJar = display.newImage( countDownGroup , ImgDir .. "countDown/jar.png" , _W/4 - 30 , _H/4*2 + 50)
		countDownJar:scale(1.3,1.3)
		shakeListener( countDownJar )
		-- カウントダウン
		countDownText = display.newImage( countDownGroup , ImgDir .. "countDown/3.png" , _W/2 - 50 , 300 )
		transition.fadeOut( countDownText ,  { time = 800 , onComplete = 
			function()
				if countDownText then
					display.remove(countDownText) ; countDownText = nil 
				end
			end} 
		)

	elseif event.name == "timer-changed" then
		count = count - 1
		countDownText = display.newImage( countDownGroup , ImgDir .. "countDown/" .. tostring(count) .. ".png" , _W/2 - 50 , 300 )
		if countDownText then
			transition.fadeOut( countDownText ,  { time = 800 , onComplete = 
				function()
					display.remove(countDownText) ; countDownText = nil 
				end} 
			)
		end

		-- 鼓動
		bgm2 = audio.play( heartBreakBgm , { channel = 2 })

		if count == 1 then
			countDownText.x = countDownText.x + 10
			countDownText.y = countDownText.y + 10
		end
		if count == 0 then
			audio.stop(bgm)
			audio.stop(bgm2)
			timer.performWithDelay( 300 , function() bgm1 = audio.play(gameStartBgm) end )
			display.remove(countDownText) ; countDownText = nil
			storyboard.gotoScene( ContDir .. "imageDestroy" , { time = 1000 } )
		end

	elseif event.name == "timer-stopped" then
	elseif event.name == "timer-stopped_self" then
		timer.cancel( countDownTimer )
	end
end


function scene:createScene( event )
	local sceneGroup = self.view
end

function scene:willEnterScene( event )
	local sceneGroup = self.view
end

function scene:enterScene( event )
	local sceneGroup = self.view

	local bg = display.newImage( sceneGroup , ImgDir .. "countDown/bg_light.jpg" , 0 , 0 )	

	countDownGroup = display.newGroup()
	count = 3
	countDownTimer = {}

	timerManager_class:addEventListener(listener)
	
	-- タイマースタート
	timerManager.timerStart(5)
	countDownTimer = timer.performWithDelay( 1000 ,
		function()
			timerManager.getTimer()
		end
	, 0 )
end

function scene:exitScene( event )
	local sceneGroup = self.view

	
	-- カウントダウン終了	
	timerManager.stopTimer()
	timerManager_class:removeEventListener(listener)
	display.remove(countDownGroup); countDownGroup = nil
	stopTransition()

end

scene:addEventListener( "createScene" , scene )
scene:addEventListener( "willEnterScene" , scene )
scene:addEventListener( "enterScene" , scene )
scene:addEventListener( "exitScene" , scene )


return scene