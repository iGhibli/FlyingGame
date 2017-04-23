local GameScene = class("GameScene", function (  )
	-- body
	return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
	-- 获取场景绑定的物理世界对象, 获取的 self.world 默认是有带重力的, 大小为(0.0f, -98.0f)
	self.world = self:getPhysicsWorld()
	-- 通过的setGravity()方法来改变重力大小
	self.world:setGravity(cc.p(0, -98.0))
	-- setDebugDrawMask 方法是在调试物理世界时使用的，该方法可以开启调试模
	-- 能把物理世界中不可见的body，shape，joint等元素可视化。当调试结束时，需要把该功能关闭。
	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	local backgroundLayer = BackgroundLayer.new()
		:addTo(self)
end

function GameScene:onEnter()
	-- body
end

function GameScene:onExit()
	-- body
end

return GameScene