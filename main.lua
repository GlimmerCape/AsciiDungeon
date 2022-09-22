local composer = require "composer"
require("com.ponywolf.joykey").start()

display.setStatusBar(display.HiddenStatusBar)

system.activate("multitouch")
local vjoy = require("com.ponywolf.vjoy")
local stick = vjoy.newStick()
stick.x, stick.y = 128, display.contentHeight - 128
local button = vjoy.newButton()
button.x, button.y = display.contentWidth - 128, display.contentHeight - 128

audio.reserveChannels(1)

composer.gotoScene("intro", { params = {} })
