
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local  MainLayer = require("app.views.MainLayer")
function MainScene:onCreate()
    local layer = MainLayer.new()
    self:addChild(layer)
end

return MainScene
