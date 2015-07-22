-- point_class.lua
-- Comment : ポイントを管理する
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

local this = object.new()

local point = 0

local function listener()

	local self = object.new()

	local function pointReset()
		point = nil
		point = 0
	end

	function self.pointManageStart()

		pointReset()

		local event = {

			name = "pointManage-started",
			point = point,
		}
		this:dispatchEvent( event )
	end

	function self.pointUp( score )

		point = point + score

		local event = {

			name = "point-upped",
			point = point
		}
		this:dispatchEvent( event )
	end

	-- ポイント情報を返す
	function self.pointGet()
		return point
	end


	return self
end

function this.new()
	return listener()
end

return this