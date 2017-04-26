--
-- Author: iGhibli
-- Date: 2017-04-26 16:42:42
--
local Bird = class("Bird", function()
	return display.newSprite("#bird1.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Bird:ctor(x, y)
	local birdBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2, MATERIAL_DEFAULT)
	self:setPhysicsBody(birdBody)
	self:getPhysicsBody():setGravityEnable(false)

	self:setPosition(x, y)

	local frames = display.newFrames("bird%d.png", 1, 9)
	local animation = display.newAnimation(frames, 0.5 / 9)
	animation:setDelayPerUnit(0.1)
	local animate = cc.Animate:create(animation)

	self:runAction(cc.RepeatForever:create(animate))
end

return Bird