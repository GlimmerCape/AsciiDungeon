---@diagnostic disable: lowercase-global
local composer = require "composer"
require("com.ponywolf.joykey").start()
local widget = require "widget"

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

TopTextGroup = display.newGroup()
local textOptions =
{
    text = "Get closer to a chest",
    x = display.contentCenterX,
    y = display.contentHeight * 0.2,
    font = native.systemFont,
    fontSize = 40,
    align = center

}

uiGroup = display.newGroup()
TopBgBox = display.newRect(TopTextGroup, display.contentCenterX, 100, display.contentWidth, 200)
TopBgBox:setFillColor(0, 0, 0, 0)
TopText = display.newText(textOptions)
TopTextGroup:insert(TopText)
TopTextGroup:toFront()
TopTextGroup.alpha = 0

LocalScore = 0
Score = 0
Level = 0

gameComplete = display.newImage("gameCompleted2.png")
gameComplete.x, gameComplete.y = display.contentCenterX, display.contentCenterY * 0.8
gameComplete:scale(display.contentWidth / gameComplete.width, 1)
gameComplete.alpha = 0
local textOptions =
{
    text = Score + LocalScore,
    x = display.contentWidth * 0.5,
    y = display.contentHeight * 0.62,
    font = native.systemFontBold,
    fontSize = 90,
    align = center

}
scoreText = display.newText(textOptions)
Score = 500
scoreText.alpha = 0




button = joykey.newButton(72)
button.x, button.y = display.contentWidth - 128, display.contentHeight - 128

composer.gotoScene("levelExample", { params = {} })
