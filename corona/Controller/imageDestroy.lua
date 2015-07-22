-- imageDestroy.lua
-- Comment : 画像遷移を行う(破壊)
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

-- Library
local storyboard = require("storyboard")

-- 音
local btnSound = audio.play( SoundDir .. "btn.mp3" )
local bgm

-- Model
local imageDestroy_model = require( ModelDir .. "imageDestroy_model" )
local model = imageDestroy_model.new()

-- View 
local imageDestroy_view = require( ViewDir .. "imageDestroy_view" )
local view = imageDestroy_view.new()

-- Class 
local timerManager_class = require( ModDir .. "timerManager_class" )
local timeManager = timerManager_class.new()

local point_class = require( ModDir .. "point_class" )
local pointManager = point_class.new()

-- group
local topGroup = display.newGroup()
local jarGroup = display.newGroup()
local barGroup = display.newGroup()
local bottomBar = nil

-- ポイントを表示
local pointText = nil 
local pointImage = nil
local function listener1( event )
	if event.name == "pointManage-started" then
		pointImage = convertNumberToImage( event.point )
		pointImage.x , pointImage.y = bottomBar.x - 55 , bottomBar.y
		barGroup:insert(pointImage)
	elseif event.name == "point-upped" then
		display.remove(pointImage) ; pointImage = nil
		pointImage = convertNumberToImage( event.point )
		pointImage.x , pointImage.y = bottomBar.x - 55 - 20*(tostring(event.point):len()-1) , bottomBar.y
		barGroup:insert(pointImage)
	end
end


-- タイマーを表示
local showTimer = {}
local timerImage = nil
local function listener2( event )
	if event.name == "timer-start" then
		timerImage = convertNumberToImage( event.diffTime )
		timerImage.x , timerImage.y = bottomBar.x - 260 -20*(tostring(event.diffTime):len()-1), bottomBar.y
		barGroup:insert(timerImage)
	elseif event.name == "timer-changed" then
		display.remove(timerImage) ; timerImage = nil
		timerImage = convertNumberToImage( event.restTime )
		timerImage.x , timerImage.y = bottomBar.x - 260 - 20*(tostring(event.restTime):len()-1), bottomBar.y
		barGroup:insert(timerImage)
	elseif event.name == "timer-stopped" then
		display.remove(timerImage) ; timerImage = nil
		timerImage = convertNumberToImage( event.restTime )
		timerImage.x , timerImage.y = bottomBar.x - 260 - 20*(tostring(event.restTime):len()-1), bottomBar.y
		barGroup:insert(timerImage)
		storyboard.gotoScene( ContDir .. "lastPage" , { time = 300 , effect = "fade" } )
	end
end

-- シーン作成
local scene = storyboard.newScene()

local imageGroup = nil
local notImageGroup = nil

function scene:createScene( event )

	local sceneGroup = self.view
end


function scene:willEnterScene( event )

	local sceneGroup = self.view

	-- 一番上のグループ、壺グループ、スコアなどを表示するバーのグループ、壺以外のグループ
	topGroup = display.newGroup()
	jarGroup = display.newGroup()
	notImageGroup = display.newGroup()
	barGroup = display.newGroup()
	
	local background = display.newImage( notImageGroup , ImgDir .. "bg_light.jpg" , 0 , 0 )
	bottomBar = display.newImage( barGroup , ImgDir .. "bottom.png" , 0 , 0 )
	bottomBar.x , bottomBar.y = _W/2 , _H/2 + 300

    -- 戻る
    local backBtn = btn.newPushImage({image=ImgDir.."backBtn.png", group=barGroup})     
    backBtn.x = bottomBar.x + 140
    backBtn.y = bottomBar.y - 60
    backBtn:addEventListener( 'tap',
    	function()
    		bgm = audio.play(btnSound)
    		ads.show("interstatial")
			storyboard.gotoScene( ContDir .. "topPage" , { time = 300 , effect = "fade" } )
			timeManager.stopTimer()
    	end
    )

	-- ポイント管理
	point_class:addEventListener( listener1 )

	-- 残り時間を表示
	timerManager_class:addEventListener( listener2 )

	-- @param : cycle > 画像を変えるタップ数
	imageGroup = view.putImage( taps_change_image )
	
	topGroup:insert(notImageGroup)
	topGroup:insert(imageGroup)
	topGroup:insert(barGroup)

	-- ポイント管理スタート
	pointManager.pointManageStart()

	-- タイマースタート
	timeManager.timerStart( game_time )

	-- タイマーを表示
	showTimer = timer.performWithDelay( 500 , function() timeManager.getTimer() end , 0 )

end

function scene:enterScene( event )
	local sceneGroup = self.view

	-- 広告
	ads.show('footer', {x=0, y=_H-100, width=_W, height=100, service='nend'})
	ads.show( 'icon_left', { x = 15, y = 15, width = 120, height = 120, service = 'nend' } )
	ads.show( 'icon_right', { x = _W-135, y = 15, width = 120, height = 120, service = 'nend' } )
	ads.show( 'icon_left2', { x = 15, y = 600 , width = 120, height = 120, service = 'nend' } )
	ads.show( 'icon_right2', { x = _W-135, y = 600, width = 120, height = 120, service = 'nend' } )
end

function scene:exitScene( event )

	local sceneGroup = self.view

	-- タイマーの表示のタイマーを止める
	timer.cancel( showTimer )
	timeManager.stopTimer()

	-- 現在のポイントを取得
	local point = pointManager.pointGet()
	gamecenter.setHighScore( point )

	-- ハイスコア設定
	local high_score = score.get()

	if high_score ~= false then
		if tonumber(point) >= tonumber(high_score) then
			score.save(point)
		end
	else
		score.save(point)
	end

	if topGroup then
		display.remove(topGroup); topGroup = nil
	end

	point_class:removeEventListener( listener1 )
	timerManager_class:removeEventListener( listener2 )

	ads.remove('footer')
	ads.remove('icon_left')
	ads.remove('icon_right')
	ads.remove('icon_left2')
	ads.remove('icon_right2')

end

function scene:destroyScene( event )

	local sceneGroup = self.view

end


scene:addEventListener( "createScene" , scene )
scene:addEventListener( "willEnterScene" , scene )
scene:addEventListener( "enterScene" , scene )
scene:addEventListener( "exitScene" , scene )
scene:addEventListener( "destroyScene" , scene )


return scene