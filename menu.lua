-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--keep the score
storyboard.state = {}
storyboard.state.score = 0

--keep the level
storyboard.state2 = {}
storyboard.state2.level = 1

-- include Corona's "widget" library
local widget = require "widget"

--include slq library
local sqlite3 = require "sqlite3"
--determines in which path the db is stored
local path = system.pathForFile("data.db", system.DocumentsDirectory)
--opens the databse
db = sqlite3.open( path ) 

	
--------------------------------------------

-- forward declarations
local playBtn --play Button
local creditsBtn --credits Button
local highscoreBtn --highscore Button
local titleLogo --logo image
--sound click, it is played when the user click a button
local buttonClickSound = audio.loadSound("button_click.wav") 

--this function is triggered when the user clicks the Play Button and loads the chooselevel scene
local function onPlayBtnRelease()
    audio.play ( buttonClickSound  )
	storyboard.gotoScene( "chooselevels", "fade", 500 )
	return true	
end

--this function is triggered when the user clicks the Credits Button and loads the credits scene
local function onCreditsBtnRelease()
	audio.play ( buttonClickSound  )
	storyboard.gotoScene( "credits_scene", "fade", 500 )
	return true
end

--this function is triggered when the user clicks the Highscore Button and loads the credits scene
local function onHighscoreBtnRelease()
	audio.play ( buttonClickSound  )
	storyboard.gotoScene( "highscore", "fade", 500 )
	return true
end


--this function is the first function that triggered when the scene is loaded and created the scene.
function scene:createScene( event )
	local group = self.view


	--this function creates the highscoretabe in the database and inserts the score to it
	db:exec[[CREATE TABLE highscoretable (id INTEGER PRIMARY KEY, content INTEGER);]]
	local highscorefill =[[INSERT INTO highscoretable VALUES (NULL, ']]..storyboard.state.score..[['); ]]
	db:exec( highscorefill )

	--this function creates the levestable in the database and inserts the level to it
	db:exec[[CREATE TABLE levelstable (id INTEGER PRIMARY KEY, content INTEGER);]]
	local levelfill =[[INSERT INTO levelstable VALUES (NULL, ']]..storyboard.state2.level..[['); ]]
	db:exec( levelfill )

	-- display a background image
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
    titleLogo = display.newImageRect( "logo.png", 528, 84 )
	titleLogo:setReferencePoint( display.CenterReferencePoint )
	titleLogo.x = -300
	titleLogo.y = 100
	
	-- create Play Button
	playBtn = widget.newButton{
		label="Play",
		fontSize=30,
		labelColor = { default={255}, over={128} },
		defaultFile="button.png", --image
		overFile="button-over.png", --on-press image
		width=154, height=60,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth+100
	playBtn.y = display.contentHeight - 150
	
	-- create Credits Button
	creditsBtn = widget.newButton{
		label="Credits",
		fontSize=25,
		labelColor = { default={255}, over={128} },
		defaultFile="button2.png",
		overFile="button-over2.png",
		width=154, height=60,
		onRelease = onCreditsBtnRelease	-- event listener function
	}
	creditsBtn:setReferencePoint( display.CenterReferencePoint )
	creditsBtn.x = -100
	creditsBtn.y = display.contentHeight - 100
	
	-- create Highscore Button
	highscoreBtn = widget.newButton{
		label="Highscore",
		fontSize=25,
		labelColor = { default={255}, over={128} },
		defaultFile="button3.png",
		overFile="button-over3.png",
		width=154, height=60,
		onRelease = onHighscoreBtnRelease	-- event listener function
	}
	highscoreBtn:setReferencePoint( display.CenterReferencePoint )
	highscoreBtn.x = display.contentWidth+100
	highscoreBtn.y = display.contentHeight - 50
	
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
	group:insert(creditsBtn)
	group:insert(highscoreBtn)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	--transitions of button to appear on the scene
	transition.to(titleLogo,{x=display.contentWidth * 0.5,time=3000})
	transition.to(playBtn,{x=display.contentWidth*0.5,time=3000})
	transition.to(creditsBtn,{x=display.contentWidth*0.5,time=3000})
	transition.to(highscoreBtn,{x=display.contentWidth*0.5,time=3000})
	--remove previous loaded scenes from the memory
    storyboard.removeAll()
end

-- Called when scene is about to move offscreen
function scene:exitScene( event )
	local group = self.view  
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	-- widgets must be manually removed
	if playBtn then
		playBtn:removeSelf()	
		playBtn = nil
	end
	
	if creditsBtn then
		creditsBtn:removeSelf()
		creditsBtn=nil
	end

	if highscoreBtn then
		highscoreBtn:removeSelf()
		highscoreBtn=nil
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