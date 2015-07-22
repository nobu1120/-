-- File : timerManager_class.lua
-- Comment : 時間を測るクラス
-- Date : 2015-06-29
-- Creater : Nobuyoshi Tanaka
-----------------------------------------------

local timerManager_class = {}
local finishTime = 0
local restTime = finishTime
local countTimer = {}
local this = object.new()
-----------------------------------------------

local function setFinishTimer( diff_time )

	if diffTime then
		finishTime = diff_time
		restTime = finishTime
	else
		finishTime = 1000
	end
end


local function listener()

	local self = object.new()

	function self.timerStart( diff_time )

		countTimer = {}

		setFinishTimer( diff_time )

		-- カウントスタート
		restTime = restTime - 1
		countTimer = timer.performWithDelay( 1000 , function() restTime = restTime - 1 end , 0 )

		local event = {

			name = "timer-start",
			diffTime = finishTime,
		}
		this:dispatchEvent( event )

	end

	function self.getTimer()

		if restTime ~= 0 then
		
			local event = {

				name = "timer-changed",
				restTime = restTime,
			}
			this:dispatchEvent( event )

		elseif restTime == 0 then

			timer.cancel( countTimer )

			local event = {

				name = "timer-stopped",
				restTime = restTime
			}
			this:dispatchEvent( event )
		end

	end

	-- 時間切れ以外でタイマーを止めるとき
	function self.stopTimer()

		timer.cancel( countTimer )

		local event = {

			name = "timer-stopped_self",
			restTime = restTime,
		}
		this:dispatchEvent( event )

	end

	return self
end

function this.new()
	return listener()
end

return this