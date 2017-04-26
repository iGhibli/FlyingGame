--
-- Author: iGhibli
-- Date: 2017-04-26 16:28:55
--
local Airship = class("Airship", function()
	return display.newSprite("#airship.png")
end)

local MATERIAL_DEFAULT = cc.PhysicsMaterial(0.0, 0.0, 0.0)

function Airship:ctor(x, y)
	-- 得到airship自身的尺寸大小
	local airshipSize = self:getContentSize()
	local airshipBody = cc.PhysicsBody:createCircle(airshipSize.width / 2, MATERIAL_DEFAULT)

	self:setPhysicsBody(airshipBody)
	self:getPhysicsBody():setGravityEnable(false)

	self:setPosition(x, y)

	local move1 = cc.MoveBy:create(3, cc.p(0, airshipSize.height / 2))
	local move2 = cc.MoveBy:create(3, cc.p(0, -airshipSize.height / 2))
	local SequenceAction = cc.Sequence:create(move1, move2)
	transition.execute(self, cc.RepeatForever:create(SequenceAction))
end

return Airship