--[[
Author: liqiang
Date: 2022-12-14 10:04:16
LastEditors: liqiang
LastEditTime: 2022-12-14 10:04:16
FilePath: \src\app\views\MainLayer.lua
Description: 

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]

local MainLayer = class("MainLayer",require("app.common.BaseLayer"))
MainLayer.CsbFile = "csb/main_layer.csb";

function MainLayer:ctor( ... )
    self.super.ctor(self);
    self:initUI()
end

function MainLayer:initUI(  )
    local btn_test = self.safe_container.btn_test
    registerBtnClickCall(btn_test,function()
        addLayer(require("app.views.TestLayer"))
    end)
end

function MainLayer:onEnter(  )

end

function MainLayer:onExit(  )

end

return MainLayer
