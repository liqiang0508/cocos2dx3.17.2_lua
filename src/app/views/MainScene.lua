
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local  TestLayer = require("app.views.TestLayer")
function MainScene:onCreate()
    local layer = TestLayer.new()
    self:addChild(layer)
end

return MainScene
