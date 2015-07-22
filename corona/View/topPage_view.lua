-- topPage_view.lua
-- Comment : アプリ起動時のview
-- Date : 2015-07-04
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

local this = object.new()

-- 音声
local btn_sound = audio.loadSound( SoundDir .. "btn.mp3" )
local btnChannel

local function listener()
    local self = {}

    -- プレイ以外のボタンを押した時
    local function touchMenuBtn(event)
        local t = event.target
        local dispatchEvent = {
            name = t.name,
            phase = 'ended',
        }
        this:dispatchEvent( dispatchEvent )
    end

    -- playボタン時
    local function touchPlayBtn(event)
        local option = {
            name = 'start-game',
            phase = 'ended',
        }
        this:dispatchEvent( option )
    end

    -----------------
    -- ページ表示
    -----------------
    function self.create()
        
        self.group = display.newGroup()

        -- 背景
        local bg = display.newImage(self.group, ImgDir.."startPage/bg.jpg")
        bg.x = _W/2
        bg.y = _H/2
        bg:addEventListener( "tap", returnTrue )
        bg:addEventListener( "touch", returnTrue )

        -- タイトル
        local title = display.newImage( self.group , ImgDir .. "startPage/title.png" , 0 , 0 )
        title.x , title.y = _W/2 , _H/2 - 330

        local jar = display.newImage( self.group , ImgDir .. "startPage/jar_long.png" , 0 , 0 )
        jar.x , jar.y = _W/2 , _H/2 - 45
        -- playボタン
        local play_btn = btn.newPushImage({image=ImgDir.."startPage/start.png",group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})
        play_btn:setReferencePoint()
        play_btn.x = _W/2
        play_btn.y = jar.y + jar.height/2 + 60
        play_btn.play_mode = 'single'
        play_btn:addEventListener( 'tap', touchPlayBtn )

        -- ランキング
        local ranking_btn = btn.newPushImage({image=ImgDir.."startPage/ranking.png", group=self.group ,action = function() btnChannel = audio.play( btn_sound ) end})     
        ranking_btn.x = 100
        ranking_btn.y = play_btn.y + play_btn.height/2
        ranking_btn.name = 'ranking'
        ranking_btn:addEventListener( 'tap', touchMenuBtn )

        -- レビュー
        local review_btn = btn.newPushImage({image=ImgDir.."startPage/review.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})       
        review_btn.x = 250
        review_btn.y = play_btn.y + play_btn.height/2
        review_btn.name = 'review'
        review_btn:addEventListener( 'tap', touchMenuBtn )

        -- ウォール広告
        this.wall_btn = btn.newPushImage({image=ImgDir.."startPage/wall.png", group=self.group , action = function() btnChannel = audio.play( btn_sound ) end})       
        this.wall_btn.x = 400
        this.wall_btn.y = play_btn.y + play_btn.height/2
        this.wall_btn.name = 'wall'
        this.wall_btn:addEventListener( 'tap', touchMenuBtn )

        return self.group
    end

    return self
end


function this.new()
    return listener()
end

return this