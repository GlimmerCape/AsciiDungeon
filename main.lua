---@diagnostic disable: lowercase-global
local composer = require "composer"
require("com.ponywolf.joykey").start()

display.setStatusBar(display.HiddenStatusBar)

system.activate("multitouch")
local joykey = require("com.ponywolf.vjoy")
-- stick = joykey.newStick(3)
-- stick.x, stick.y = 128, display.contentHeight - 128

fakeButton = joykey.newButton(0, "auf")
upButton = joykey.newButton(72, "buttonU")
downButton = joykey.newButton(72, "buttonD")
leftButton = joykey.newButton(72, "buttonL")
rightButton = joykey.newButton(72, "buttonR")
upButton.x, upButton.y = 64, display.contentHeight - 350
downButton.x, downButton.y = 64, display.contentHeight - 180
leftButton.x, leftButton.y = display.contentWidth - 128 - 100, display.contentHeight - 240
rightButton.x, rightButton.y = display.contentWidth - 128 + 100, display.contentHeight - 240

Score = 0
Level = 0

button = joykey.newButton(72)
button.x, button.y = display.contentWidth - 128, display.contentHeight - 128

composer.gotoScene("levelExample", { params = {} })
