-- topPage.lua
-- Comment : アプリの最初の画面
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

-- Library 
local storyboard = require("storyboard")

-- シーン作成
local scene = storyboard.newScene()

-- Bgm
local startBgm = audio.loadSound( SoundDir .. "start_or_end.mp3" )
local bgmChannel

-- View 
local topPage_view = require(ViewDir.."topPage_view")
local view = topPage_view.new()

-- 広告タイマー
local adsTimer = {}

----------------
-- 広告のリスナ
----------------
local function adsListener(event)
    if event.name == 'hidden_wall' then
        if event.result == true then
            topPage_view.wall_btn.isVisible = false
        else
            topPage_view.wall_btn.isVisible = true
        end
    end
end

-- ボタンの各挙動
local function listener( event )
	if event.name == "start-game" then
		storyboard.gotoScene( ContDir .. "countDown" , { time = 300 , effect = "fade" } )
	elseif event.name == "review" then
        local option = {
            iOSAppId = '1016157542',
            androidAppPackageName = 'jp.co.freep.destroy.jar',
            supportedAndroidStores = {"google"}
        }
        native.showPopup('appStore', option)
    elseif event.name == 'wall' then
    	ads.show('wall')
    elseif event.name == "ranking" then
    	ads.show("interstatial")
    	gamecenter.showRankingBoard()
    end
end

function scene:createScene( event )

	local sceneGroup = self.view

end

function scene:willEnterScene( event )

	local sceneGroup = self.view

	-- bgm
	bgmChannel = audio.play( startBgm , {loops=-1})


	local topView = view.create()
	sceneGroup:insert(topView)

	topPage_view:addEventListener( listener )
	ads:addEventListener( adsListener )

end

function scene:enterScene( event )

	local sceneGroup = self.view
	-- adsTimer = timer.performWithDelay( 10000 , function() ads.show("interstatial") end , 0 )

	ads.show('header', {x=0, y=0, width=_W, height=100, service='nend'})
	ads.show('footer', {x=0, y=_H-100, width=_W, height=100, service='nend'})

end

function scene:exitScene( event )

	local sceneGroup = self.view
	audio.stop( bgmChannel )

	-- timer.cancel(adsTimer)

	topPage_view:removeEventListener( listener )
	ads:removeEventListener( adsListener )

	ads.remove('header')
	ads.remove('footer')

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