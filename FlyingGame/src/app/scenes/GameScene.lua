local GameScene = class("GameScene", function (  )
	-- body
	return display.newScene("GameScene")
end)

function GameScene:ctor()
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