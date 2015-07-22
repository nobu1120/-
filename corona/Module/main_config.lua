-- ProjectName : 
--
-- Filename : main_config.lua
--
-- Creater : 
--
-- Date : 
--
-- Comment : 
--
-- 
------------------------------------------------------------------------------------
--ステータスバーの設定
display.setStatusBar( display.TranslucentStatusBar )
display.setStatusBar( display.HiddenStatusBar )

--画面幅を_W、画面高さを_H、ステータスバー高さを_SHとする
_W  = display.contentWidth
_H  = display.actualContentHeight

if system.getInfo("platformName") == "Android" then
	_SH = 45
else
	_SH = (display.actualContentHeight - display.contentHeight)*0.5
end

--urlのベース部分
urlBase = "http://app.talkspace-web.com/side/destroyJar/"


-- 開発用にAPIのPATH変更	
if _apiDeveloped == true then
	urlBase = ""
end

--呼び出すディレクトリ
ImgDir     = 'Images/'
ViewDir    = "View."
ModelDir   = "Model."
ContDir    = "Controller."
ModDir     = "Module."
PluginDir  = "Plugin."
SoundDir   = "Sound/"

-- ファイル呼び出し
require(ModDir .. 'print.print')
require(ModDir .. "tsutil.tsutil")
require(ModDir .. "library.library")
require(ModDir .. "display.display")

fnetwork   = require(ModDir.."network.network")
object     = require(ModDir.."object.object")
btn        = require(ModDir.."btn.btn")
json       = require("json")
-- storyboard = require("storyboard")
mime 	   = require("mime")
http 	   = require("socket.http")
ltn12	   = require("ltn12")