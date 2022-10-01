local composer = require "composer"
require("com.ponywolf.joykey").start()

display.setStatusBar(display.HiddenStatusBar)

system.activate("multitouch")
local joykey = require("com.ponywolf.vjoy")
stick = joykey.newStick(3)
stick.x, stick.y = 128, display.contentHeight - 128
button = joykey.newButton()
button.x, button.y = display.contentWidth - 128, display.contentHeight - 128

audio.reserveChannels(1)

composer.gotoScene("levelExample", { params = {} })
