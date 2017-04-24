--
-- Author: iGhibli
-- Date: 2017-04-24 10:07:10
--
local Player = class("Player", function ()
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

		body是有很多属性的，当我们有需要时，再调用对应的方法。
	]]
	local body = cc.PhysicsBody:creatBox(self:getContentSize()), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0, 0)
	self:setPhysicsBody(body)
end

function Player:addAnimationCache()
	-- animations，animationFrameNum分别表示角色的三种动画和三种动画分别有的帧总数。
	local animations = {"flying", "drop", "die"}
	local animationFrameNum = {4, 3, 4}

	for i=1,#animations do
		--[[ 1, 创建一个包含animations[i]1.png到animations[i]animationFrameNum[i].png的图像帧对象的数组，
				如i ＝ 1，就是创建一个包含flying1.png到flying4.png的图像帧对象的数组。
				其中..是字符串连接操作符，它可以用来连接两个字符串。当其中一个为其它类型时，它会把该类型也转为字符串。
		]]
		local frames = display.newFrames(animations[i] .. "%d.png",1 ,animationFrameNum[i])
		-- 2, 以包含图像帧的数组创建一个动画 Animation 对象，参数 0.3 / 4 表示 0.3 秒播放完 4 桢。
		local animation = display.newAnimation(frames, 0.3/4)
		--[[ 3, 将2中创建好的 animation 对象以指定的名称（animations[i]）加入到动画缓存中，以便后续反复使用。
				也就是我们在 AnimationCache 中可以通过animations = {"flying", "drop", "die"}
				这三种动画的名称来查找制定的 animation 对象。
		]]
		display.setAnimationCache(animations[i], animation)
	end
end

function Player:flying()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("flying"))
end

function Player:drop()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("drop"))
end

function Player:die()
	transition.stopTarget(self)
	transition.playAnimationForever(self, display.getAnimationCache("die"))
end

return Player