local GameScene = class("GameScene", function (  )
	-- body
	return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
	self.world = self:getPhysicsWorld()
	self.world:setGravity(cc.p(0, -98.0))
	self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDESW_ALL)

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