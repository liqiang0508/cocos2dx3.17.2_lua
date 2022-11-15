--[[
Author: liqiang
Date: 2022-11-14 19:15:35
LastEditors: liqiang
LastEditTime: 2022-11-14 19:15:35
FilePath: \src\app\views\test.lua
Description: 

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]
local TestLayer = class("TestLayer", function()
    return cc.Layer:create();
end)

function TestLayer:ctor( ... )

    self:initUI()
end


function TestLayer:initUI(  )
    self.csbResNode = cc.CSLoader:createNode("Layer.csb");
    self:addChild( self.csbResNode );
    --适配调试
    self.csbResNode:setContentSize(display.size);
    ccui.Helper:doLayout(self.csbResNode);

    
    self.background = self.csbResNode:getChildByName("background")
    local safe_container = self.csbResNode:getChildByName("safe_container")
    self.background:setScale(display.getMaxScale())
    
    safe_container:setContentSize(display.getSafeAreaRect());
    ccui.Helper:doLayout(safe_container);
    local x = display.getSafeAreaRect().x + safe_container:getContentSize().width*safe_container:getAnchorPoint().x
    local y = display.getSafeAreaRect().y + safe_container:getContentSize().height*safe_container:getAnchorPoint().y
    safe_container:setPosition(x, y)
    

end

return TestLayer
