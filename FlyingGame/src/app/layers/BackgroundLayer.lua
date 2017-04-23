BackgroundLayer = class("BackgroundLayer",function()
	return display.newLayer()
end)

function BackgroundLayer:ctor()
	print("BackgroundLayer:ctor")
	self.distanceBg = {}
	self.nearbyBg = {}
	self.titleMapBg = {}

	self:createBackgrounds()

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
	self:scheduleUpdate()
end

function BackgroundLayer:createBackgrounds()
	print("创建布幕背景")
	local bg = display.newSprite("image/bj1.jpg")
		:pos(display.cx, display.cy)
		:addTo(self, -4)

	print("创建远景背景")
	local bg1 = display.newSprite("image/b2.png")
		:align(display.BOTTOM_LEFT, display.left, display.bottom + 10)
		:addTo(self, -3)

	local bg2 = display.newSprite("image/b2.png")
		:align(display.BOTTOM_LEFT, display.left + bg1:getContentSize().width, display.bottom + 10)
		:addTo(self, -2)

		table.insert(self.distanceBg, bg1)
		table.insert(self.distanceBg, bg2)

end

function BackgroundLayer:scrollBackgrounds(dt)
	if self.distanceBg[2]:getPositionX() <= 0 then
		self.distanceBg[1]:setPositionX(0)
	end

	-- 50*dt 相当于速度
	local x1 = self.distanceBg[1]:getPositionX() - 50*dt
	local x2 = x1 + self.distanceBg[1]:getContentSize().width

	self.distanceBg[1]:setPositionX(x1)
	self.distanceBg[2]:setPositionX(x2)


end

function BackgroundLayer:onEnter()

end

return BackgroundLayer