--[[
Author: liqiang
Date: 2022-11-14 19:15:35
LastEditors: liqiang
LastEditTime: 2022-11-14 19:15:35
FilePath: \src\app\views\test.lua
Description: 

Copyright (c) 2022 by superZ, All Rights Reserved. 
--]]
local CustomTableView = require("app.common.CustomTableView")
local TestLayer = class("TestLayer",require("app.common.BaseLayer"))
TestLayer.CsbFile = "TestLayer.csb";

function TestLayer:ctor( ... )
    self.super.ctor(self);
    self:initUI()
end


function TestLayer:initUI(  )
    
    self.scroll_cotainer = self.safe_container:getChildByName("scroll_cotainer")
    self.item  = self.safe_container:getChildByName("item")
    self.item:setVisible(false)
    print(" self.scroll_cotainer", self.scroll_cotainer)
    self.mTableViews = CustomTableView.create(self.scroll_cotainer) --传入节点大小创建tableview
    self.mTableViews:setColumns(6)--设置列数
    self.mTableViews:setCellSpacing(22)--设置x间隔
    self.mTableViews:onLoadCellCallback(function()--根据外部传入的节点设置cell的大小
        return self:createItem()
    end)
    self.mTableViews:setCellNumber(100) --设置数据量数量
    self.mTableViews:reloadData() --刷新tableview
end

function TestLayer:createItem( )
    local item = self.item:clone()
    item:setVisible(true)
    item.updatecell = function(item, index, isAsync)

    end
    return item
end

return TestLayer
