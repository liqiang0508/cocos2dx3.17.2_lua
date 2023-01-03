--[[
Author: LiQiang
Date: 2022-03-10 18:47:22
LastEditors: LiQiang
LastEditTime: 2022-03-10 18:48:22
FilePath: \srcc:\Users\Admin\Desktop\TableView.lua
Description: 

Copyright (c) 2022 by 用户/公司名, All Rights Reserved. 
--]]

--方便快捷使用tableView 使用方法
-- self.mTableViews = TableView.create(self.quest_container) --传入节点大小创建tableview
-- self.mTableViews:setColumns(1)--设置列数
-- self.mTableViews:setCellSpacing(25)--设置x间隔
-- self.mTableViews:onLoadCellCallback(function()--根据外部传入的节点设置cell的大小
--     return self:createItem()
-- end)
-- self.mTableViews:setCellNumber(7) --设置数据量数量
-- self.mTableViews:reloadData(keepOffset, asyncLoad)) --刷新tableview


local TABLEVIEW_ALIGN = {
    --左边
    LEFT = 1,
    --居中
    CENTER = 2,
    --右边
    RIGHT = 3,
    --顶部
    TOP = 4,
    --底部
    BOTTOM = 5,
}
local TableView = class("TableView")

function TableView.create(node,dir)
     return TableView.new(node,dir)
end

local Action_Tag = 999

function TableView:ctor(node,dir)
    self.mDirection = dir or cc.SCROLLVIEW_DIRECTION_VERTICAL--默认上下滑动
    self.mColumns = 1--默认列数
	self.mNumber = 0--cell数量
    self.mNode = node --父节点
	self.mIndex = 1 --当前index

    local size = node:getContentSize()
	self.mTableview = cc.TableView:create(size)
	self.mNode:addChild(self.mTableview)

    self.mTableview:setDelegate()
	self.mTableview:setDirection(self.mDirection)
	self.mTableview:setVerticalFillOrder(1 - self.mDirection)

    self.mTableview:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.mTableview:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
	self.mTableview:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
	self.mTableview:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL)
end


function TableView:scrollViewDidScroll(tableview)
end

function TableView:numberOfCellsInTableView(tableview)
    return math.ceil(self.mNumber / self.mColumns)
end

function TableView:cellSizeForTable(table, idx)
	if self.mBgCellSize == nil then
		local cell = self.mOnLoadCellCallback()
		local size = cell:getContentSize()
		size.width = size.width * cell:getScaleX()
		size.height = size.height * cell:getScaleY()
		local width = self.mColumns * size.width + self.mColumns * (self.mSpacingX or 0)
		local height = size.height + (self.mSpacingY or 0)
		self.mBgCellSize = cc.size(width, height)
		self.mCellSize = size
	end
	return self.mBgCellSize.width, self.mBgCellSize.height
end

function TableView:tableCellAtIndex(tableview, idx)
	local bgCell = tableview:dequeueCell()
	if bgCell == nil then
		bgCell = cc.TableViewCell:new()
		bgCell:setCascadeOpacityEnabled(true)
	end
	self:updateCell(bgCell, idx)
	return bgCell
end

function TableView:runNodeShowAnimation(aNode,aScale)
    if not tolua.isnull(aNode)  then
        aScale = aScale or 1
		local time = 0.1
        local action = cc.ScaleTo:create(time,aScale)
        aNode:setScale(0)
        aNode:stopAllActions()
        aNode:runAction(action)
    end
end

function TableView:updateCell(bgCell, idx, asyncIndex)
	local createCell = function(number, isAsync)
		local item = bgCell:getChildByName("cell_item_" .. number)
		local index = idx * self.mColumns + number
		local isShow = (index <= self.mNumber) and self.mIndex>=index
		if not item and isShow then
			item = self.mOnLoadCellCallback()
			if item then
				item:setName("cell_item_" .. number)
				local posx = (number - 0.5) * (self.mCellSize.width + (self.mSpacingX or 0))
				local posy = (self.mCellSize.height + (self.mSpacingY or 0)) / 2
				item:setPosition(posx, posy)
				bgCell:addChild(item)
			end
		end
		
		if item and item.updateCell then
			if isShow then
				item:setVisible(true)
				item.updateCell(item, index, isAsync)
				if  isAsync  then
					self:runNodeShowAnimation(item,item:getScale())
				end
				
			else
				item:setVisible(false)
			end
		end
	end
	if asyncIndex then
		local number = (asyncIndex-1)%self.mColumns + 1
		createCell(number, true)
	else
		for i = 1, self.mColumns do
			createCell(i)
		end
	end
end

function TableView:clearSchdule()
	if self.mTableview then
		self.mTableview:stopActionByTag(Action_Tag)
	end
end

function TableView:startAsyncLoad(startAsyncLoad)
	if startAsyncLoad then
		self:clearSchdule()
		if self.mTableview then
			local seq = cc.Sequence:create(cc.CallFunc:create(function()
				local idx = math.ceil(self.mIndex / self.mColumns) - 1
				local bgCell = self.mTableview:cellAtIndex(idx)
				if bgCell then
					self:updateCell(bgCell, idx, self.mIndex)
					self.mIndex = self.mIndex + 1
				end
				if self.mIndex > self.mNumber then
					self:clearSchdule()
				end
			end), cc.DelayTime:create(0.05))
			local action= cc.RepeatForever:create(seq)
			action:setTag(Action_Tag)
			self.mTableview:runAction(action)
		end
	else
		for index = 0, self.mNumber do
			local idx = math.ceil(index / self.mColumns) - 1
			local bgCell = self.mTableview:cellAtIndex(idx)
			if bgCell then
				self:updateCell(bgCell, idx)
			end
		end
	end

end

--========================↓↓↓====外部调用====↓↓↓========================

---设置cell数量
function TableView:setCellNumber(number)
	if self.mLastNum then
		self.mLastNum = self.mNumber
	else
		self.mLastNum = number
	end
	self.mNumber = number
end

---设置滑动方向
function TableView:setDirection(direction)
	self.mDirection = direction
	self.mTableview:setDirection(self.mDirection)
	self.mTableview:setVerticalFillOrder(1 - self.mDirection)
end

---设置列数(限垂直滑动)
function TableView:setColumns(number)
	if self.mDirection == cc.SCROLLVIEW_DIRECTION_VERTICAL then
		self.mColumns = number
	else
		self.mColumns = 1
	end
end

---设置间距
function TableView:setCellSpacing(spacingX, spacingY)
	self.mSpacingX = spacingX
	self.mSpacingY = spacingY or spacingX
end

---加载组件(必须返回组件)
function TableView:onLoadCellCallback(callfunc)
	self.mOnLoadCellCallback = callfunc
end

---加载tableview
---@param keepOffset 是否保持位移
---@param asyncLoad 异步加载
function TableView:reloadData(keepOffset, asyncLoad)

	keepOffset = keepOffset or true
	asyncLoad = asyncLoad or true
	local offset = self.mTableview:getContentOffset()
	self:startAsyncLoad(asyncLoad)
	self.mTableview:reloadData()

	--保持偏移
	if keepOffset then
		if self.mDirection == cc.SCROLLVIEW_DIRECTION_VERTICAL then
			if offset.y <= 0 then
				local deltaY = self.mBgCellSize.height * (math.ceil(self.mNumber/self.mColumns) - math.ceil(self.mLastNum/self.mColumns))
				self:setOffset(cc.p(offset.x, offset.y - deltaY))
			end
		elseif self.mDirection == cc.SCROLLVIEW_DIRECTION_HORIZONTAL then
			self:setOffset(offset)
		end
	end
end

---刷新TableView(仅限cell数量不变的情况下使用)
function TableView:refreshData()
	if self.mLastNum == self.mNumber then
		local children = self.mTableview:getContainer():getChildren()
		for i,bgCell in ipairs(children) do
			local idx = bgCell:getIdx()
			for i = 1, self.mColumns do 
				local item = bgCell:getChildByName("cell_item_" .. i)
				local index = idx * self.mColumns + i
				if item and item.updateCell then
					item.updateCell(item, index)
				end
			end
		end
	end
end

---设置偏移(pos坐标都为负数)
function TableView:setOffset(pos, scrollAnim)
	local minOffset = self.mTableview:minContainerOffset()
	if minOffset.x > 0 or minOffset.y > 0 then
		return
	end
	pos.y = pos.y < minOffset.y and minOffset.y or pos.y
	pos.x = pos.x < minOffset.x and minOffset.x or pos.x
	pos.y = pos.y > 0 and 0 or pos.y
	pos.x = pos.x > 0 and 0 or pos.x
	self.mTableview:setContentOffset(pos, scrollAnim)
end

---滚动到指定位置
function TableView:scrollToIndex(index, exData)
	exData = exData or {}
	local align = exData.align
	local scrollAnim = exData.scrollAnim or false
	if index > 0 and index <= self.mNumber then
		local minOffset = self.mTableview:minContainerOffset()
		local offset = self.mTableview:getContentOffset()
		local size = self.mTableview:getViewSize()
		local number = math.ceil(index/self.mColumns)
		local posX, posY = offset.x, offset.y 
		if self.mDirection == cc.SCROLLVIEW_DIRECTION_VERTICAL then
			align = align or TABLEVIEW_ALIGN.TOP--默认滑到顶部
			posY = minOffset.y + (number-1) * self.mBgCellSize.height
			if align == TABLEVIEW_ALIGN.CENTER then
				posY = posY - size.height/2 + self.mBgCellSize.height/2
			elseif align == TABLEVIEW_ALIGN.BOTTOM then
				posY = posY - size.height + self.mBgCellSize.height
			end
		elseif self.mDirection == cc.SCROLLVIEW_DIRECTION_HORIZONTAL then
			align = align or TABLEVIEW_ALIGN.LEFT--默认滑到左部
			posX = - (number-1) * self.mBgCellSize.width
			if align == TABLEVIEW_ALIGN.CENTER then
				posX = posX + size.width/2 - self.mBgCellSize.width/2
			elseif align == TABLEVIEW_ALIGN.RIGHT then
				posX = posX + size.width - self.mBgCellSize.width
			end
		end
		self:setOffset(cc.p(posX, posY), scrollAnim)
	end
end

function TableView:setTouchEnabled(state)
	self.mTableview:setTouchEnabled(state)
end

function TableView:setSwallowTouches(enabled)
	self.mTableview:setSwallowTouches(enabled)
end

function TableView:setBounceable(enabled)
	self.mTableview:setBounceable(enabled)
end

return TableView