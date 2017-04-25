local Heart = require("app.objects.Heart")

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
		:addTo(self, -3)

		table.insert(self.distanceBg, bg1)
		table.insert(self.distanceBg, bg2)

	self.map = cc.TMXTiledMap:create("image/map.tmx")
		:align(display.BOTTOM_LEFT, display.left, display.bottom)
		:addTo(self, -1)

	self:addHeart()
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

	if self.map:getPositionX() <= display.width - self.map:getContentSize().width then
		-- 禁用帧事件，停止整个背景层滚动
		self:unscheduleUpdate()
	end

	local x5 = self.map:getPositionX() - 130*dt
	self.map:setPositionX(x5)

end

function BackgroundLayer:startGame()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
	self:scheduleUpdate()
end

function BackgroundLayer:addHeart()
	--[[ 1, getObjectGroup 方法从地图中获取到指定的对象层（也就是个 ObjectGroup 对象组对象），
			对象组 ObjectGroup 中包含了多个对象，所以我们可以通过 getObjects 方法从 ObjectGroup 中获得所有的对象。
			objects 在这里就相当于一个存放了多个对象的数组。
	]]
	local objects = self.map:getObjectGroup("heart"):getObjects()
	-- 2, dict 是个临时变量，用它来存储单个的对象；table.getn 方法能得到数组的长度。
	local dict = nil
	local i = 0
	local len = table.getn(objects)
	-- 3, 遍历 objects 数组。
	for i = 0, len - 1, 1 do
		dict = objects[i + 1]
		-- 4, 如果对象 dict 为空，则跳出 for 循环。
		if dict == nil then
			break
		end
		--[[ 5, 取出相应的属性值，即对象坐标。因为对象组中的对象在 TMX 文件中是以键值对的形式存在的，
				所以我们可以通过它的 key 得到相应的 value。
		]]
		local key = "x"
		local x = dict["x"]
		key = "y"
		local y = dict["y"]
		-- 6, 在获取到的坐标上创建 Heart 对象，并把它添加到 TiledMap 背景层上。这样创建的心心才能跟随着背景层的滚动而滚动。
		local coinSprite1 = Heart.new(x, y)
		self.map:addChild(coinSprite1)
	end
end

function BackgroundLayer:onEnter()

end

return BackgroundLayer