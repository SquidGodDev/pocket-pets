import "scripts/battle/battleScene"
import "scripts/fishing/fishingScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameList').extends(gfx.sprite)

function GameList:init()
    Signals:subscribe("openGameList", self, function()
        self:openList()
    end)
    self.listview = pd.ui.gridview.new(78, 26)
    self.listview:setContentInset(0, 0, 0, 0)
    self.listview:setCellPadding(9, 9, 5, 5)
    self.listWidth = 96
    self.listHeight = 240

    self.listviewObject = getmetatable(self.listview)
    self.rowToGame = {"Battle", "Fishing"}
    self.gameToScene = {
        Battle = BattleScene,
        Fishing = FishingScene
    }
    self.listview:setNumberOfRows(#self.rowToGame)
    self.listviewObject.rowToGame = self.rowToGame

    self.listviewObject.selectImage = gfx.image.new("images/garden/seedListSelector")

    self.animationTime = 300

    function self.listview:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            local selectOffset = 5
            self.selectImage:draw(x - selectOffset, y - selectOffset)
        end
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(x, y, width, height, 3)
        gfx.setColor(gfx.kColorBlack)
        local gameName = self.rowToGame[row]
        local gameTextWidth = gfx.getTextSize(gameName)
        local yOffset = (height - 16)/2
        gfx.drawText(gameName, (width - gameTextWidth) / 2, y + yOffset)
    end

    self.listOut = false

    self.listX = 304
    self:setCenter(0, 0)
    self:moveTo(400, 0)
    self:setZIndex(500)

    self.slideSound = pd.sound.sampleplayer.new("sound/UI/transitionWhoosh")
    self.clickSound = pd.sound.sampleplayer.new("sound/UI/mouseClick")
end

function GameList:update()
    if self.listAnimator then
        self:moveTo(self.listAnimator:currentValue(), self.y)
        if self.listAnimator:ended() then
            self.listAnimator = nil
            if not self.listOut then
                self:remove()
            end
        end
    end

    if self:navigationButtonPressed() and self.listOut then
        self.slideSound:play()
        self:animateOffScreen()
        self.listOut = false
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        local _, row = self.listview:getSelection()
        local selectedGame = self.rowToGame[row]
        local gameScene = self.gameToScene[selectedGame]
        SceneManager:switchScene(gameScene)
    end

    if self.listOut then
        local crankTicks = pd.getCrankTicks(4)
        if crankTicks == -1 or pd.buttonJustPressed(pd.kButtonUp) then
            self.clickSound:play()
            self.listview:selectPreviousRow(true)
        elseif crankTicks == 1 or pd.buttonJustPressed(pd.kButtonDown) then
            self.clickSound:play()
            self.listview:selectNextRow(true)
        end
    end

    if self.listview.needsDisplay then
        local listviewImage = gfx.image.new(self.listWidth, self.listHeight, gfx.kColorBlack)
        gfx.pushContext(listviewImage)
            self.listview:drawInRect(0, 0, self.listWidth, self.listHeight)
        gfx.popContext()
        self:setImage(listviewImage)
    end
end


function GameList:openList()
    if not self.listOut then
        self.slideSound:play()
        self:add()
        self:animateOnScreen()
        self.listOut = true
    end
end

function GameList:animateOffScreen()
    local animateOffset = (1 - (400 - self.x) / (400 - self.listX)) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX + self.listWidth, pd.easingFunctions.inOutCubic, animateOffset)
end

function GameList:animateOnScreen()
    local animateOffset = (400 - self.x) / (400 - self.listX) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX, pd.easingFunctions.inOutCubic, animateOffset)
end

function GameList:navigationButtonPressed()
    local btnPress = pd.buttonJustPressed
    return btnPress(pd.kButtonLeft) or btnPress(pd.kButtonRight) or btnPress(pd.kButtonB)
end