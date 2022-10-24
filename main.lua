---@diagnostic disable: lowercase-global
local composer = require "composer"
require("com.ponywolf.joykey").start()

display.setStatusBar(display.HiddenStatusBar)

system.activate("multitouch")
local joykey = require("com.ponywolf.vjoy")
-- stick = joykey.newStick(3)
-- stick.x, stick.y = 128, display.contentHeight - 128

fakeButton = joykey.newButton(0, "auf")
upButton = joykey.newButton(48, "buttonU")
downButton = joykey.newButton(48, "buttonD")
leftButton = joykey.newButton(48, "buttonL")
rightButton = joykey.newButton(48, "buttonR")
upButton.x, upButton.y = 64, display.contentHeight - 288
downButton.x, downButton.y = 64, display.contentHeight - 178
leftButton.x, leftButton.y = display.contentWidth - 128 - 100, display.contentHeight - 218
rightButton.x, rightButton.y = display.contentWidth - 128 + 100, display.contentHeight - 218

button = joykey.newButton()
button.x, button.y = display.contentWidth - 128, display.contentHeight - 128
bgMusic = audio.loadStream("2nd_track.mp3")
audio.reserveChannels(1)
audio.play(bgMusic, { channel = 1, loops = -1 })

composer.gotoScene("levelExample", { params = {} })
