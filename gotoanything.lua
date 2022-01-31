local os_ = import("os")
local path = import("path")
local strings = import("strings")
local micro = import("micro")
local action = import("micro/action")
local buffer = import("micro/buffer")
local config = import("micro/config")
local shell = import("micro/shell")


function init()
	config.MakeCommand("gotofile", gotofile, config.NoComplete)
	--config.MakeCommand("gotosymbol", gotosymbol, config.NoComplete)
	--config.MakeCommand("gotogrep", gotogrep, config.NoComplete)

    config.AddRuntimeFile("gotoanything", config.RTHelp, "README.md")
end



function gotofile(bp, args)
	local file, buf, error
	
	file, error = shell.RunInteractiveShell("bash -c \"rg --files | fzf --preview='batcat {} --color always'\"", false, true)
	if error ~= nil then
		micro.InfoBar():Error(error)
		return
	elseif file == "\n" then
		return
	end

	file = path.Join(os_.Getwd(), strings.Trim(file, "\n"))
	micro.InfoBar():Message(file)

	buf, error = buffer.NewBufferFromFile(file)
	if error ~= nil then
		micro.InfoBar():Error(error)
		return
	elseif buf:Size() == 0 then
		--micro.InfoBar():Error("File not found or empty.")
	end

	bp:AddTab()
	micro.CurPane():OpenBuffer(buf)
end

function gotosymbol(bp, args)
end

function gotogrep(bp, args)
end

