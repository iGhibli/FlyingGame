--
-- Author: iGhibli
-- Date: 2017-04-21 10:10:10
--

-- 载入Player文件
local Player = require("app.objects.Player")

local GameScene = class("GameScene", function (  )
	return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
	-- 获取场景绑定的物理世界对象, 获取的 self.world 默认是有带重力的, 大小为(0.0f, -98.0f)
	self.world = self:getPhysicsWorld()
	-- 通过的setGravity()方法来改变重力大小
	self.world:setGravity(cc.p(0, -98.0))
	-- setDebugDrawMask 方法是在调试物理世界时使用的，该方法可以开启调试模
	-- 能把物理世界中不可见的body，shape，joint等元素可视化。当调试结束时，需要把该功能关闭。
	-- self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)

	local backgroundLayer = BackgroundLayer.new()
		:addTo(self)

	-- 创建Player对象
	self.player = Player.new()
	-- 设置初始显示位置
	self.player:setPosition(-20, display.height*2/3)
	-- 将Player对象添加到当前Scene
	self:addChild(self.player)
	-- 将Player对象移动到场景指定位置
	self:playerFlyToScene()
end

function GameScene:playerFlyToScene()

	local function startDrop()
		self.player:getPhysicsBody():setGravityEnable(true)
		self.player:drop()
		self.backgroundLayer:startGame()
	end

	-- 从动画缓存中取出需要动画
	local animation = display.getAnimationCache("flying")
	-- 使self.player不停的播放这个动画
	transition.playAnimationForever(self.player, animation)
	-- 创建动作(action)让self.player执行
	-- transition.sequence() 方法能创建一个 Sequence 动作序列对象，
	-- Sequence 类型的对象能使一个 Node 顺序执行一批动作。
	local action = transition.sequence({
		-- 先执行MoveTo动作(先移动到屏幕的(display.cx, display.height * 2 / 3)点)
		cc.MoveTo:create(4, cc.p(display.cx, display.height*2/3)),
		-- MoveTo执行完再执行CallFunc动作(调用 startDrop 方法)
		-- CallFunc 动作是个函数回调动作，它用来在动作中进行方法的调用
		cc.CallFunc:create(startDrop)
		})
	-- 执行动作
	self.player:runAction(action)
end

--[[ NOTE:
			MoveBy 动作能使节点从当前坐标点匀速直线运动到相对偏移了一定向量的位置上。
			而 MoveTo 则能使节点从当前坐标点匀速直线运动到指定的位置坐标上。
			它们的移动位置一个是相对的，一个是绝对的，
			这也是Cocos 引擎中所有以 To，By 为后缀的动作的主要区别。
]]

function GameScene:onEnter()
	-- body
end

function GameScene:onExit()
	-- body
end

return GameScene