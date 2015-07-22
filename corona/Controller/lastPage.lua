-- lastPage.lua
-- Comment : アプリの最後の画面
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

-- Library 
local storyboard = require("storyboard")

-- Class 
local point_class = require( ModDir ..  "point_class" )
pointManager = point_class.new()

-- BGM
local endBgm = audio.loadSound( SoundDir .. "start_or_end.mp3" )
local bgmChannel

-- View
local lastPage_view = require( ViewDir .. "lastPage_view" )
local view = lastPage_view.new()
local lastPage
local count = 0

-- シーン作成
local scene = storyboard.newScene()

----------------
-- 広告のリスナ
----------------
ads.init()
local function adsListener(event)
    if event.name == 'hidden_wall' then
        if event.result == true then
            lastPage_view.wall_btn.isVisible = false
        else
            lastPage_view.wall_btn.isVisible = true
        end
    end
end


local function listener( event )

	local post_score = pointManager.pointGet() or 0
	if event.name == "gameover_view-twitterBtn" then
		-- twitterへシェア
		share.post({
			message='やったぜ最高点'.. tostring(post_score), 
			url=urlBase..'twitter.php', 
			image={filename=ImgDir..'twitter.png', baseDir=system.ResourceDirectory}
		})
	elseif event.name == 'gameover_view-playBtn' then
		storyboard.gotoScene( ContDir .. "countDown" , { time = 300 , effect = "fade" } )
	elseif event.name == "gameover_view-homeBtn" then
		ads.show("interstatial")
		storyboard.gotoScene( ContDir .. "topPage" , { time = 300 , effect = "fade" } )
	elseif event.name == "gameover_view-rankingBtn" then
		ads.show("interstatial")
		gamecenter.showRankingBoard()
	elseif event.name == "gameover_view-wallBtn" then
		ads.show("wall")
	end
end

function scene:createScene( event )

	local sceneGroup = self.view

end

function scene:willEnterScene( event )

	local sceneGroup = self.view

	-- bgm
	bgmChannel = audio.play( endBgm , {loops=-1})

	-- スコアを表示する
	local point = pointManager.pointGet()

	-- ハイスコア算出
	local high_score = score.get()

	if high_score == false then
		high_score = 0
	end
	view.create( point , high_score )

	lastPage_view:addEventListener( listener )
	ads:addEventListener( adsListener )
end

function scene:enterScene( event )

	local sceneGroup = self.view

	if count%4 == 0 then
		ads.show("interstatial")
	end
	count = count + 1

	ads.show("icon")
	ads.show('header', {x=0, y=0, width=_W, height=100, service='nend'})
	ads.show('footer', {x=0, y=_H-100, width=_W, height=100, service='nend'})

end

function scene:exitScene( event )

	local sceneGroup = self.view

	audio.stop(bgmChannel)

	-- ページのボタン等削除
	display.remove(view.group) ; view.group = nil

	ads.remove('icon')
	ads.remove('header')
	ads.remove('footer')

	lastPage_view:removeEventListener( listener )
	ads:removeEventListener( adsListener )

end

function scene:didExitScene( event )
	local sceneGroup = self.view
end

function scene:destroyScene( event )
	local sceneGroup = self.view
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene