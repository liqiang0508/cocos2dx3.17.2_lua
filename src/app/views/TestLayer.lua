--[[
Author: liqiang
Date: 2022-11-14 19:15:35
LastEditors: liqiang
LastEditTime: 2022-11-14 19:15:35
FilePath: \src\app\views\test.lua
Description: 

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]
local TableView = require("app.common.TableView")
local TestLayer = class("TestLayer",require("app.common.BaseLayer"))
TestLayer.CsbFile = "csb/test_layer.csb";

function TestLayer:ctor( ... )
    self.super.ctor(self);
    self:initUI()
end


function TestLayer:initUI(  )
    
    self.scroll_cotainer = self.safe_container.scroll_cotainer
    self.btn_close = self.safe_container.btn_close
    self.item  = self.safe_container.item
    self.item:setVisible(false)

    registerBtnClickCall(self.btn_close,function()
       self:close()
    end)
    self.mTableViews = TableView.create(self.scroll_cotainer) --传入节点大小创建tableview
    self.mTableViews:setColumns(6)--设置列数
    self.mTableViews:setCellSpacing(22)--设置x间隔
    self.mTableViews:onLoadCellCallback(function()--根据外部传入的节点设置cell的大小
        return self:createItem()
    end)
    self.mTableViews:setCellNumber(200) --设置数据量数量
    self.mTableViews:reloadData(false,true) --刷新tableview
end


function TestLayer:createItem( )
    local item = self.item:clone()
    item:setVisible(true)
    item.updateCell = function(item, index, isAsync)
       
    end
    return item
end

return TestLayer
