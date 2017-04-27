require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")
require("app.objects.Player")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    display.addSpriteFrames("image/player.plist", "image/player.pvr.ccz")

    -- 为了不产生相同的随机数，我们需要在MyApp:run()中“种”一棵随机数种子。
    math.math.randomseed(os.time())

    self:enterScene("MainScene")
end

return MyApp
