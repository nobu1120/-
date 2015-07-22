-- score.lua
-- Comment : 
-- Date : 2015-1-31
-- Creater : Ryo Takahashi
-----------------------------------------------

module(..., package.seeall)

filename = "score.txt"

-- ファイル名の決定
function setFilePath(name)
	filename = name
end

function exist()
	-- 同じdeal_tokenのファイルがないか探す
	local path = system.pathForFile( filename, system.DocumentsDirectory )
	local file = io.open( path, 'r' )
	if file then
		-- 既に存在する時
		return true
	else
		-- 存在しない時
		return false
	end 
end

-- 保存
function save(score)
	writeText(filename, tostring(score))
end

-- 取得
function get()
	local exist = exist(deal_token)
	if exist == true then	
		local data = readText(filename)
		return data
	else
		return false
	end
end

-- 破棄
function remove()
	local exist = exist(filename)
	if exist then
		local result = os.remove(filename)
		return result
	end
end