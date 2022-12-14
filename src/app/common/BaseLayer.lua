--[[Author: liqiang
Date: 2022-12-13 11:09:02
LastEditors: liqiang
LastEditTime: 2022-12-13 11:09:02
FilePath: \src\app\common\baseLayer.lua
Description: 

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]
--[[XXX.CsbFile = "WarningLayer.csb";   资源文件
]]
local BaseLayer = class("BaseLayer", function()
    return cc.Layer:create();
end)

function BaseLayer:ctor(...)

    
    local res = rawget(self.class, "CsbFile");
    self.csbResNode = createCSBNote(res);
    self:addChild(self.csbResNode);
    --适配调试
    self.csbResNode:setContentSize(display.size);
    ccui.Helper:doLayout(self.csbResNode);

    self.background = self.csbResNode.background
    self.background:setScale(display.getMaxScale())
    self.safe_container = self.csbResNode.safe_container
    if self.safe_container then
        self.safe_container:setContentSize(display.getSafeAreaRect());
        ccui.Helper:doLayout(self.safe_container);
        local x = display.getSafeAreaRect().x + self.safe_container:getContentSize().width * self.safe_container:getAnchorPoint().x
        local y = display.getSafeAreaRect().y + self.safe_container:getContentSize().height * self.safe_container:getAnchorPoint().y
        self.safe_container:setPosition(x, y)
    end

       --事件
       local function onNodeEvent(event)
        if ("enter" == event) then
            if self.onEnter then
                self:onEnter()
            end
        elseif ("exit" == event) then
            if self.onExit then
                self:onExit()
            end
        end
    end
    self:registerScriptHandler(onNodeEvent)

end

function BaseLayer:close()
    self:removeFromParent()

end

return BaseLayer