--
-- Author: iGhibli
-- Date: 2017-04-24 10:07:10
--
local Player = class("Player", function (  )
	return display.newSprite("#flying1.png")
end)

function Player:ctor( )
	-- 调用cc.PhysicsBody::createBox()方法创建了一个矩形的 body
	--[[
		createBox 方法有三个参数，分别是：
			参数1为 cc.size 类型，它表示矩形 body 的尺寸大小。
			参数2为 cc.PhysicsMaterial 类型，表示物理材质的属性，默认情况下为 cc.PHYSICSBODY_MATERIAL_DEFAULT。
					该参数也可自定义，方法如下：
						cc.PhysicsMaterial(density, restitution, friction)
							density：表示密度
							restitution：表示反弹力
							friction：表示摩擦力
			参数3为 cc.p 类型，它也是一个可选参数，表示 body 与中心点的偏移量，默认下为cc.p(0,0)
		与 createBox 方法类似的还有 createCircle(radius, material, offset)，该方法可以创建一个圆形的 body，
		除第一个参数为半径外，其余两参数与 createBox 方法一样。
	]]
	local body = cc.PhysicsBody:creatBox(self:getContentSize()), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0, 0)
	self:setPhysicsBody(body)
end

return Player