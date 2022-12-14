
cc.FileUtils:getInstance():setPopupNotify(false)

if cc.Application:getInstance():getTargetPlatform() == 0 then
    require("LuaDebug")("localhost", 7003)
end

require "config"
require "cocos.init"
require "app.common.Global"
local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
