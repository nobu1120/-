-- imageDestroy_model.lua
-- Comment : 画像遷移の画像を保持
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

module( ... , package.seeall )

local this = object.new()

local function listener()

	local self = object.new()
	local imageTable = {}
	local randomImage = {}

	-------------------------------------------------
	local function initImage()
		imageTable = nil
		imageTable = {}
	end
	-------------------------------------------------

	-- 画像をセットする
	function self.setImageToTable()

		initImage()

		for i = 1, 21 do
			imageTable[i] = ImgDir .. "destroy/" .. tostring(i) .. ".png"
		end
	end


	-- 画像を順番に変えていく
	function self.changeImage()

		local image = imageTable[1]

		if #imageTable ~= 1 then
			table.remove( imageTable , 1 )
		end
		print(image)

		return image
	end

	-- 画像をランダムに変えていく
	function self.displayRandomImage()

		local selected = math.random( 1 , #randomImage )

		return randomImage[selected]
	end

	return self

end


function this.new()
	return listener()
end

return this