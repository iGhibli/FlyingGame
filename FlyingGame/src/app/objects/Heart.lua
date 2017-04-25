--
-- Author: iGhibli
-- Date: 2017-04-25 20:36:32
--
local Heart = class("Heart", function()
	return display.newSprite("image/heart.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Heart:ctor(x, y)
	local heartBody = cc.PhysicsBody:createCircle(self:getContentSize().width / 2, MATERIAL_DEFAULT)
	self:setPhysicsBody(heartBody)
	self:getPhysicsBody():setGravityEnable(false)

	self:setPosition(x, y)
end

return Heart