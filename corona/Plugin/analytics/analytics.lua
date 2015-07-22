-- Filename : analytics.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2015-06-28
--
-- Comment : 
--
---------------------------------------------------------------------
local analytics = require('analytics')

-------------------------------
-- FlurryサイトよりAPI Keyを取得
-------------------------------
local app_key = nil
if system.getInfo( "platformName" ) == 'Android' then
	app_key = 'PCF4KKSGRW2248D2YJVX'
elseif system.getInfo( "platformName" ) == 'iPhone OS' then
	app_key = 'YP3FSWTWNWBTJMS9HVGT '
end
analytics.init(app_key)

return analytics