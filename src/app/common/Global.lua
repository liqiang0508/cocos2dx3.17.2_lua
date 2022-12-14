--[[Author: liqiang
Date: 2022-12-14 09:50:40
LastEditors: liqiang
LastEditTime: 2022-12-14 09:50:40
FilePath: \src\app\common\Global.lua
Description: 全局函数

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]
cc.exports.getAllChildren = function(__node)
    for _, v in pairs(__node:getChildren()) do
        __node[v:getName()] = v
        getAllChildren(v)
    end
end

cc.exports.createCSBNote = function(csb_name)
    print(csb_name)
    local node = cc.CSLoader:createNode(csb_name)
    getAllChildren(node)
    return node
end

cc.exports.registerBtnClickCall = function(button_node, clickCallBack, showClickAction)
    if tolua.isnull(button_node) then return end
    button_node.init_scale = button_node:getScale()
    button_node:addTouchEventListener(function(sender, event_type)
        if showClickAction then
            local scale = sender._init_scale
            if event_type == ccui.TouchEventType.began then
                sender:stopAllActions()
                sender:runAction(cc.ScaleTo:create(0.05, 1.1 * scale))
            elseif event_type == ccui.TouchEventType.ended then
                sender:stopAllActions()
                sender:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 0.95 * scale), cc.ScaleTo:create(0.1, scale)))
            elseif event_type == ccui.TouchEventType.canceled then
                sender:stopAllActions()
                sender:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1, 0.95 * scale), cc.ScaleTo:create(0.1, scale)))
            end
        end

        if event_type == ccui.TouchEventType.ended then
            if clickCallBack then
                clickCallBack(sender, event_type)
            end
        end
    end)
end

cc.exports.addLayer = function(class,parent)
    parent = parent or  display.getRunningScene()
    local layer = class.new()
    if layer then
        layer:addTo(parent)
    end

end