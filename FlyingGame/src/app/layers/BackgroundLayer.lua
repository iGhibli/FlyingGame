local Heart = require("app.objects.Heart")
local Airship = require("app.objects.Airship")
local Bird = require("app.objects.Bird")

BackgroundLayer = class("BackgroundLayer",function()
	return display.newLayer()
end)

function BackgroundLayer:ctor()
	print("BackgroundLayer:ctor")
	self.distanceBg = {}
	self.nearbyBg = {}
	self.titleMapBg = {}
	-- 定义一个table数组来存放游戏中所有的鸟
	self.bird = {}

	self:createBackgrounds()

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
	self:scheduleUpdate()

	-- 创建两根和 TiledMap 背景一样长的边界线。
	local width = self.map:getContentSize().width
	local height1 = self.map:getContentSize().height * 9 / 10
	local height2 = self.map:getContentSize().height * 3 / 16

	--[[
		createEdgeSegment 方法能创建一个不受重力约束的自由线条，它有四个参数，分别表示：
			参数1为 cc.p 类型，表示线条的起点；
			参数2也为 cc.p 类型，表示线条的终点；
			参数3为 cc.PhysicsMaterial 类型，表示物理材质的属性，默认情况下为 cc.PHYSICSBODY_MATERIAL_DEFAULT；
			参数4为 number 类型，表示线条粗细。
		与之类似的函数还有：createEdgeBox，createEdgePolygon，createEdgeChain。
		它们都能创建不受重力约束的边界。具体的参数可跳转到它们的定义查看，这里我就不多说了。
	]]
	local sky = display.newNode()
	local bodyTop = cc.PhysicsBody:createEdgeSegment(cc.p(0, height1), cc.p(width, height1))
	sky:setPhysicsBody(bodyTop)
	self:addChild(sky)

	local ground = display.newNode()
	local bodyBottom = cc.PhysicsBody:createEdgeSegment(cc.p(0, height2), cc.p(width, height2))
	ground:setPhysicsBody(bodyBottom)
	self:addChild(ground)

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

	self:addBody("heart", Heart)
	self:addBody("airship", Airship)
	self:addBody("bird", Bird)
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
	-- 因为我们需要不停的遍历 self.bird 数组、不停的检测是否给小鸟加上速度，所以我们需要在刷新屏幕时调用以上的 addVelocityToBird() 函数。
	-- 那就偷个懒，直接在 scrollBackgrounds(dt) 函数的最后面调用。
	self:addVelocityToBird()
end

function BackgroundLayer:startGame()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.scrollBackgrounds))
	self:scheduleUpdate()
end

function BackgroundLayer:addBody(objectGroupName, class)
	--[[ 1, getObjectGroup 方法从地图中获取到指定的对象层（也就是个 ObjectGroup 对象组对象），
			对象组 ObjectGroup 中包含了多个对象，所以我们可以通过 getObjects 方法从 ObjectGroup 中获得所有的对象。
			objects 在这里就相当于一个存放了多个对象的数组。
	]]
	local objects = self.map:getObjectGroup(objectGroupName):getObjects()
	-- 2, dict 是个临时变量，用它来存储单个的对象；table.getn 方法能得到数组的长度。
	local dict = nil
	local i = 0
	local len = table.getn(objects)
	print("addBody-len: " .. len)
	-- 3, 遍历 objects 数组。
	for i = 0, len -1, 1 do
		dict = objects[i + 1]
		-- 4, 如果对象 dict 为空，则跳出 for 循环。
		if dict == nil then
			break
		end
		--[[ 5, 取出相应的属性值，即对象坐标。因为对象组中的对象在 TMX 文件中是以键值对的形式存在的，
				所以我们可以通过它的 key 得到相应的 value。
		]]
		local key = "x"
		local x = dict[key]
		key = "y"
		local y = dict[key]
		-- 6, 在获取到的坐标上创建 Heart 对象，并把它添加到 TiledMap 背景层上。这样创建的心心才能跟随着背景层的滚动而滚动。
		local sprite = class.new(x, y)
		self.map:addChild(sprite)
		-- 把所有的鸟都添加到定义的 self.bird 数组中
		print("objectGroupName: " .. objectGroupName)
		if objectGroupName == "bird" then
			table.insert(self.bird, sprite)
		end
	end
end

--[[
	总的来讲，addVelocityToBird 函数的目的就是在小鸟进入屏幕时给它一个速度，让它朝着游戏角色冲过来。
	遍历 self.bird 数组中的所有 Bird 对象，当检测到某个 Bird 对象刚好要进入屏幕，且还没给过它任何速度时，
	我们会给它一个向左的速度，这个速度的范围从(-70, -40)到(-70, 40)。
	通俗一点就是说： Bird 对象将在横坐标上有一个大小为70，方向向左的速度；在纵坐标上有一个大小在(-40, 40)之间，方向不定的速度。
]]
function BackgroundLayer:addVelocityToBird()
	-- print("BackgroundLayer:addVelocityToBird")
	local dict = nil
	local i = 0
	local len = table.getn(self.bird)
	-- print("len" .. len)
	for i = 0, len - 1, 1 do
		dict = self.bird[i + 1]
		if dict == nil then
			break
		end

		local x = dict:getPositionX()
		-- print("x: " .. x)
		if x <= display.width - self.map:getPositionX() then
			-- print("x1: " .. x)
			if dict:getPhysicsBody():getVelocity().x == 0 then
				dict:getPhysicsBody():setVelocity(cc.p(-70, math.random(-40, 40)))
			else
				-- print("x2: " .. x)
				-- 当已经给过某些 Bird 对象速度时，我们要把该对象从 self.bird 数组中移除，这样可以减短遍历数组的时间。
				-- table.remove(table, pos)函数将删除并返回 table 数组中位于 pos 位置上的元素。
				table.remove(self.bird, i + 1)
			end
		end
	end
end

function BackgroundLayer:onEnter()

end

return BackgroundLayer