local this = object.new()

-- 音声
local btn_sound = audio.loadSound( SoundDir .. "btn.mp3" )
local btnChannel

local function listener()
	local self = {}

	-- ランキングボタンタッチ時
	local function touchTwitterBtn()
		local event = {
			name = 'gameover_view-twitterBtn',
			phase = 'ended',
		}
		this:dispatchEvent( event )
	end

	-- playボタン時
	local function touchPlayBtn()
		local event = {
			name = 'gameover_view-playBtn',
			phase = 'ended',
		}
		this:dispatchEvent( event )
	end

	-- Homeボタン時
	local function touchHomeBtn()
		local event = {
			name = 'gameover_view-homeBtn',
			phase = 'ended',
		}
		this:dispatchEvent( event )
	end

	local function touchRankingBtn()
		local event = {
			name = 'gameover_view-rankingBtn',
			phase = 'ended',
		}
		this:dispatchEvent( event )
	end

	local function touchWallBtn()
		local event = {
			name = 'gameover_view-wallBtn',
			phase = 'ended',
		}
		this:dispatchEvent( event )
	end
	-----------------
	-- ページ表示
	-----------------
	function self.create(score,high_score)
		self.group = display.newGroup()

		-- 背景
		local bg = display.newImage(self.group, ImgDir .. "lastPage/bg.jpg" , 0 , 0)
		bg.x = _W/2
		bg.y = _H/2
		-- bg:addEventListener( "tap", returnTrue )
		bg:addEventListener( "touch", returnTrue )

		-- スコアボード
		local logo = display.newImage(self.group, ImgDir..'lastPage/score.png')
		logo.x = _W/2
		logo.y = _H/2 - 210

		-- 今回のスコア
		local score = score or 0
		local scoreImage = convertNumberToImage( score )
		scoreImage.x , scoreImage.y = logo.x - 150 - 20*(tostring(score):len()-1) , logo.y + 100
		self.group:insert(scoreImage)

		-- ハイスコア
		local high_score = high_score or 0
		local high_scoreImage = convertNumberToImage( high_score )
		high_scoreImage.x , high_scoreImage.y = logo.x + 95 - 20*(tostring(high_score):len()-1) , logo.y + 100
		self.group:insert(high_scoreImage)

		-- playボタン
		local retry_btn = btn.newPushImage({image=ImgDir.."lastPage/retry.png",group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})
		retry_btn:setReferencePoint()
		retry_btn.x = _W/2
		retry_btn.y = _H - 310
		retry_btn.play_mode = 'single'
		retry_btn:addEventListener( 'tap', touchPlayBtn )		

		-- ホーム
		local home_btn = btn.newPushImage({image=ImgDir.."lastPage/home.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})		
		home_btn.x = 40
		home_btn.y = _H - 230
		home_btn:addEventListener( 'tap', touchHomeBtn )

		-- ランキング
		local ranking_btn = btn.newPushImage({image=ImgDir.."lastPage/ranking.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})		
		ranking_btn.x = 180
		ranking_btn.y = _H - 230
		ranking_btn:addEventListener( 'tap', touchRankingBtn )

		-- share_btn
		local share_btn = btn.newPushImage({image=ImgDir.."lastPage/sns.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})		
		share_btn.x = 320
		share_btn.y = _H - 230
		share_btn:addEventListener( 'tap', touchTwitterBtn )

		-- ウォール広告
		this.wall_btn = btn.newPushImage({image=ImgDir.."lastPage/wall.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})		
		this.wall_btn.x = 460
		this.wall_btn.y = _H - 230
        this.wall_btn.name = 'wall'
		this.wall_btn:addEventListener( 'tap', touchWallBtn )

		return self.group
	end

	return self
end


function this.new()
	return listener()
end

return this