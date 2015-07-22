-- imageDestroy_view.lua
-- Comment : 破壊された画像を表示
-- Date : 2015-1-31
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

module( ... , package.seeall )

-- Model
local imageDestroy_model = require( ModelDir .. "imageDestroy_model" )
local model = imageDestroy_model.new()

-- Class
local point_class = require( ModDir .. "point_class")
local pointManager = point_class.new()

-- 音
local cat_panchi_sound = audio.loadSound( SoundDir .. "cat.mp3")
local change_image_sound = audio.loadSound( SoundDir .. "change_image.mp3")
local end_clash_sound = audio.loadSound( SoundDir .. "end_clash.mp3")
local meriken_sound = audio.loadSound( SoundDir .. "meriken.mp3")
local panchi_sound = {}
for i = 1 , 4 do
	panchi_sound[i] = audio.loadSound( SoundDir .. "panchi" .. tostring(i-1) .. ".mp3" )
end
local slap_sound = audio.loadSound( SoundDir .. "slap.mp3" )
local last_clash = audio.loadSound( SoundDir .. "last_clash.mp3" )
local ugly_voice = {}
for i = 1 , 5 do
	ugly_voice[i] = audio.loadSound( SoundDir .. "ugly_voice" .. tostring(i) .. ".mp3" )
end

audio.setVolume(1)

local function listener()

	local self = object.new()
	local group = display.newGroup()

	function self.putImage( cycle )

		local count = 0

		group = display.newGroup()
		local imageGroup = display.newGroup()
		local actionGroup = display.newGroup()
		local pieceGroup = display.newGroup()

		-- 破壊の画像を保持
		model.setImageToTable()
		
		-- Modelから画像のパスを受け取る
		local imageUrl = model.changeImage()
		local image = display.newImage( imageGroup , imageUrl , 0 , 0 )
		image:scale(0.7,0.7)
		image.x , image.y = _W/2 , _H/4 + 100


		-- 殴られ顔
		-- 左から
		local leftDownClash = display.newImage( imageGroup , ImgDir .. "face_clash/left_panchi.png" , 0 , 0 )
		leftDownClash:scale(0.7,0.7)
		leftDownClash.x , leftDownClash.y = _W/2 , _H/4 + 100
		leftDownClash.isVisible = false

		-- 右から
		local rightDownClash = display.newImage( imageGroup , ImgDir .. "face_clash/right_panchi.png" , 0 , 0 )
		rightDownClash:scale(0.7,0.7)
		rightDownClash.x , rightDownClash.y = _W/2 , _H/4 + 100
		rightDownClash.isVisible = false

		-- 下から
		local downClash = display.newImage( imageGroup , ImgDir .. "face_clash/left_clap.png" , 0 , 0 )
		downClash:scale(0.7,0.7)
		downClash.x , downClash.y = _W/2 , _H/4 + 100
		downClash.isVisible = false

		-- 上から
		local upClash = display.newImage( imageGroup , ImgDir .. "face_clash/right_clap.png" , 0 , 0 )
		upClash:scale(0.7,0.7)
		upClash.x , upClash.y = _W/2 , _H/4 + 100
		upClash.isVisible = false

		--右パンチ
		local right_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand1.png" , 0 , 0 )
		right_panchi:scale(0.4,0.4)
		right_panchi.isVisible = false

		-- 左パンチ
		local left_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand1.png" , 0 , 0 )
		left_panchi:scale(-0.4,0.4)
		left_panchi.isVisible = false

		-- 右平手
		local right_slap = display.newImage( actionGroup , ImgDir .. "panchi/hand2.png" , 0 , 0 )
		right_slap:scale(0.5,0.5)
		right_slap.isVisible = false

		-- 左平手
		local left_slap = display.newImage( actionGroup , ImgDir .. "panchi/hand2.png" , 0 , 0 )
		left_slap:scale(-0.5,0.5)
		left_slap.isVisible = false

		-- メリケンパンチ
		local right_meriken_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand3.png" , 0 , 0 )
		right_meriken_panchi:scale(0.4,0.4)
		right_meriken_panchi.isVisible = false

		local left_meriken_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand3.png" , 0 , 0 )
		left_meriken_panchi:scale(-0.4,0.4)
		left_meriken_panchi.isVisible = false

		-- 猫パンチ
		local right_cat_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand4.png" , 0 , 0 )
		right_cat_panchi:scale(0.4,0.4)
		right_cat_panchi.isVisible = false

		local left_cat_panchi = display.newImage( actionGroup , ImgDir .. "panchi/hand4.png" , 0 , 0 )
		left_cat_panchi:scale(-0.4,0.4)
		left_cat_panchi.isVisible = false

		-- 顔のヒビ
		local hibi = {}

		-- ほこり、つば、かけら6こ
		local dust = display.newImage( actionGroup , ImgDir .. "face_clash/dust.png" , 0 , 0 )
		-- 4方向のツバ
		local right_spit = display.newImage( actionGroup , ImgDir .. "face_clash/spit.png" , 0 , 0 )
		right_spit.isVisible = false
		right_spit:rotate(90)
		local left_spit = display.newImage( actionGroup , ImgDir .. "face_clash/spit.png" , 0 , 0 )
		left_spit.isVisible = false
		left_spit:rotate(-90)
		local bottom_spit = display.newImage( actionGroup , ImgDir .. "face_clash/spit.png" , 0 , 0 )
		bottom_spit.isVisible = false
		bottom_spit:rotate(180)
		dust.isVisible = false

		local function imageTapListener( event )

			--------------------------------
			-- パンチなどのアクションを付ける
			--------------------------------

			---------------------------
			--[[
				---------------------
				|   平手  |   平手    |
				|　　反転  |          |
				---------------------
				|   殴る	 | 	 殴る	|
				|	反転  |			|
				---------------------

			]]
			----------------------------


			-----------------------------------------------
			-- タップするごとに画像遷移
			-----------------------------------------------

			if count ~= 0 and count % cycle == 0 then

				print(" ------------------ changeImage ----------------- ")
				display.remove( image )
				image = nil

				audio.play( change_image_sound )

				-- 一定回数のタップによって画像を変化させる
				local imageUrl = model.changeImage()
				image = display.newImage( imageGroup , imageUrl , 0 , 0 )
				image:scale(0.7,0.7)
				image.x , image.y = _W/2 , _H/4 + 100
			end

			-- 最後の壺破壊音
			if count == cycle*20 + 1 then
				audio.play( last_clash )
			end

			count = count + 1 

			------------------------------------------------
			-- タップごとのアクション
			------------------------------------------------

			-- 顔のヒビ
			for i = 1 , 2 do
				hibi[i] = display.newImage( pieceGroup , ImgDir .. "face_clash/hibi" .. tostring(i) .. ".png" , 0 , 0 )
				hibi[i].x , hibi[i].y = event.x , event.y
				hibi[i].isVisible = false
			end
			local selected = math.random(1,2)
			hibi[selected].isVisible = true

			-- ホコリ
			dust.x , dust.y = event.x , event.y
			dust.isVisible = true

			-- 割れる音
			audio.play( end_clash_sound )

			-- 破片発生
			local piece = {}
			for i = 1 , 6 do
				piece[i] = display.newImage( pieceGroup , ImgDir .. "face_clash/piece" .. tostring(i) .. ".png" , 0 , 0 )
				
				local selected = math.random(1,4)
				if selected == 1 then
					piece[i].x , piece[i].y = math.random(0,200) , math.random(0,200)
				elseif selected == 2 then
					piece[i].x , piece[i].y = math.random(400,600) , math.random(0,200)
				elseif selected == 3 then
					piece[i].x , piece[i].y = math.random(400,600) , math.random(500,700)
				else
					piece[i].x , piece[i].y = math.random(0,200) , math.random(500,700)
				end
			end

			-- 破片処理
			timer.performWithDelay(300,
				function()

					local selected = 0
					if count%10 == 0 then
						selected = math.random(1,6)
						piece[selected].x , piece[selected].y = math.random(0,600) , math.random(600,700)
					end

					for i=1 , 6 do
						if i ~= selected then
							print(i)
							display.remove(piece[i])
							piece[i] = nil;
						end
					end
				end
			)


			-- 殴るときの手の動き
			local function handAction( hand , startX , startY , rotate )
				if rotate then

					local function listener()
						hand.isVisible = false
						hand:rotate(-rotate)
					end
					transition.to( hand , { time = 200 , x = startX , y = startY , rotation = rotate , onComplete = listener })
				else

					local function listener()
						hand.isVisible = false
					end
					transition.to( hand , { time = 200 , x = startX , y = startY , onComplete = listener })
				end

			end
			--------------------------------------------------
			-- 壺破壊
			--------------------------------------------------

			-- うめき声
			local random = math.random(1,5)
			audio.play( ugly_voice[random] )
			
			if event.y < image.height then
				print("壺")
				print(event.x)
				print(event.y)

				if 350 < event.y and event.y < image.height - 400 then

					-- 右パンチ
					if event.x > _W/2 then

						local selected = math.random(1,9)

						if selected%5 == 0 then

							print("右メリケンパンチ")
							right_meriken_panchi.isVisible = true
							right_meriken_panchi.x = event.x + 100
							right_meriken_panchi.y = event.y + image.height/2 - 100
							handAction( right_meriken_panchi , event.x + 100 , event.y + image.height/2 - 200 )

							audio.play( meriken_sound )


						else

							local selected = math.random(1,4)
							audio.play( panchi_sound[selected] )

							print("右パンチ")
							right_panchi.isVisible = true
							right_panchi.x = event.x + 100
							right_panchi.y = event.y + image.height/2 - 100
							handAction( right_panchi , event.x + 100 , event.y + image.height/2 - 200 )

						end

						-- 壺があれば
						if  count < cycle*21 - 1 then
							-- ツバ
							left_spit.isVisible = true
							left_spit.x , left_spit.y = _W/4 - 20, image.height/2
							
							-- 殴られ顔
							rightDownClash.isVisible = true
							rightDownClash:toFront()
						end


					-- 左パンチ
					else

						local selected = math.random(1,9)

						if selected%5 == 0 then
							print("左メリケンパンチ")
							left_meriken_panchi.isVisible = true
							left_meriken_panchi.x = event.x - 100
							left_meriken_panchi.y = event.y + image.height/2 - 100
							handAction( left_meriken_panchi , event.x - 100 , event.y + image.height/2 - 200 )

							audio.play( meriken_sound )

						else

							local selected = math.random(1,4)
							audio.play( panchi_sound[selected] )
							
							print("左パンチ")
							left_panchi.isVisible = true
							left_panchi.x = event.x - 100
							left_panchi.y = event.y + image.height/2 - 100
							handAction( left_panchi , event.x - 100 , event.y + image.height/2 - 200)

						end



						if  count < cycle*21 - 1 then
							-- ツバ
							right_spit.isVisible = true
							right_spit.x , right_spit.y = (_W/4)*3 - 20 , image.height/2	

							-- 殴られ顔
							leftDownClash.isVisible = true
							leftDownClash:toFront()
						end
					end

				-- アッパー
				elseif event.y >= image.height - 400 then

					print("アッパー")

					if  count < cycle*21 - 1 then
						-- 殴られ顔
						downClash.isVisible = true
						downClash:toFront()
					end

					if event.x < _W/2 then

						local selected = math.random(1,9)

						if selected%5 == 0 then

							print("左猫パンチ")
							left_cat_panchi.isVisible = true
							left_cat_panchi.x = event.x - 100
							left_cat_panchi.y = event.y + image.height/2 - 100
							handAction( left_cat_panchi , event.x - 100 , event.y + image.height/2 - 200)

							audio.play( cat_panchi_sound )

						else

							print("左パンチ")
							left_panchi.isVisible = true
							left_panchi.x = event.x - 100
							left_panchi.y = event.y + image.height/2 - 100
							handAction( left_panchi , event.x - 100 , event.y + image.height/2 - 200)

							local selected = math.random(1,4)
							audio.play( panchi_sound[selected] )
						end
					else

						local selected = math.random(1,9)

						if selected%5 == 0 then
							print("右猫パンチ")
							right_cat_panchi.isVisible = true
							right_cat_panchi.x = event.x + 100
							right_cat_panchi.y = event.y + image.height/2 - 100
							handAction( right_cat_panchi , event.x + 100 , event.y + image.height/2 - 200 )

							audio.play( cat_panchi_sound )
						else
							print("右パンチ")
							right_panchi.isVisible = true
							right_panchi.x = event.x + 100
							right_panchi.y = event.y + image.height/2 - 100
							handAction( right_panchi , event.x + 100 , event.y + image.height/2 - 200 )

							local selected = math.random(1,4)
							audio.play( panchi_sound[selected] )
						end
					end

				-- 平手
				elseif event.y <= 350 then

					audio.play( slap_sound )

					if  count < cycle*21 - 1 then
						-- ツバ
						bottom_spit.isVisible = true
						bottom_spit.x , bottom_spit.y = _W/2 , image.height - 250
						
						-- 殴られ顔	
						upClash.isVisible = true
						upClash:toFront()
					end
					
					-- 反転
					if event.x > _W/2 then

						-- 右平手
						right_slap.isVisible = true
						right_slap.x = event.x + 240
						right_slap.y = event.y + 200
						right_slap.xScale = 0.4
						handAction( right_slap , event.x + 50 , event.y + 250 , -20 )
					else
						-- 左平手
						left_slap.isVisible = true
						left_slap.x = event.x - 240
						left_slap.y = event.y + 200
						left_slap.xScale = -0.4
						handAction( left_slap , event.x - 50 , event.y + 250 , 20 )
					end
				end
			end

			-- ポイントを加算する @param score -> 加算点
			pointManager.pointUp( up_point )


			timer.performWithDelay( 300 ,
				function()

					-- 殴られアクション
					leftDownClash.isVisible = false
					rightDownClash.isVisible = false
					downClash.isVisible = false
					upClash.isVisible = false

					-- ツバ、ほこり、破片
					bottom_spit.isVisible = false
					left_spit.isVisible = false
					right_spit.isVisible = false
					dust.isVisible = false

					-- 音を止める
					audio.stop(cat_panchi_sound)
					audio.stop(change_image_sound)
					audio.stop(end_clash_sound)
					audio.stop(meriken_sound)
					audio.stop(slap_sound)
					for i = 1 , 3 do
						audio.stop(panchi_sound[i])
					end
					for i = 1 , 5 do
						audio.stop(ugly_voice[i])
					end

				end
			)

			return true
		end

		imageGroup:addEventListener( "tap" , imageTapListener)

		group:insert(pieceGroup)
		group:insert(imageGroup)

		return group
	end

	return self

end

function new()
	return listener()
end