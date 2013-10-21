-----------------------------------------------------------------------------------------
--
-- highscore.lua
--
-----------------------------------------------------------------------------------------

-- include the Corona "storyboard" module
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--Load database
local sqlite3 = require "sqlite3"
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open( path )   

-- include Corona's "widget" library
local widget = require "widget"
--game over sound
local gameoverSound = audio.loadStream ( "gameover.mp3" )
--button click sound
local buttonClickSound = audio.loadSound("button_click.wav")


--this function is triggered when the user clicks on the back Button to move back to the menu
local function onBackBtnRelease()
	audio.stop()
	audio.play(buttonClickSound)
	storyboard.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end

--forward declaration
local backBtn,background,leveltext,score

--this function is the first function that triggered when the scene is loaded and created the scene.
function scene:createScene( event )
	local group = self.view
	
	

	-- display a background image
	background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	-- display a highscore image
	highscorePic = display.newImageRect( "highscore.png", display.contentWidth, display.contentHeight )
	highscorePic:setReferencePoint( display.TopLeftReferencePoint )
	highscorePic.x, highscorePic.y = 0, 0


    --finds the highest score and assing it to the score display object
	score = display.newText(" ", display.contentCenterX-100, display.contentCenterY-50)
	for row in db:nrows("SELECT * FROM highscoretable WHERE content=(SELECT max(content) FROM highscoretable)") do
	 score.text = row.content
	 score.size=40
	 score.x = display.contentCenterX
	 score.y = display.contentCenterY
	 score:setTextColor ( 173, 0, 19 ) 
	end

	

		backBtn = widget.newButton{
		label="Menu",
		labelColor = { default={255}, over={128} },
		fontSize=25,
		defaultFile="button3.png",
		overFile="button-over3.png",
		width=154, height=40,
		onRelease = onBackBtnRelease	-- event listener function
	}

	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight - 75
	
	
    group:insert( background )
    group:insert( highscorePic )
    group:insert( score )
    group:insert( backBtn )

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if backBtn then
		backBtn:removeSelf()
		backBtn=nil
	end
end


-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene