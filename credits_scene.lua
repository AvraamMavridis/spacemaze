-----------------------------------------------------------------------------------------
--
-- credits_scene.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local buttonClickSound = audio.loadSound("button_click.wav")
local widget = require "widget"



local function onBackBtnRelease()
	-- go to menu
	audio.play ( buttonClickSound  )
	storyboard.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end

local backBtn

function scene:createScene( event )
	local group = self.view
	
		-- display a background image
	local background = display.newImageRect( "background.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	-- display a developer image
	local developer = display.newImageRect( "developer.png", display.contentWidth, display.contentHeight )
	developer:setReferencePoint( display.TopLeftReferencePoint )
	developer.x, developer.y = 0, 0

    -- display a facebook image
	local facebook = display.newImageRect( "Facebook.png",64,64)
	facebook.x = display.contentCenterX - 70
	facebook.y = display.contentCenterY 
	facebook:addEventListener( "tap", function() system.openURL( "https://www.facebook.com/avraammakis" ) end )

	-- display a linkedin image
	local linkedin = display.newImageRect( "Linkedin.png",64,64)
	linkedin.x = display.contentCenterX
	linkedin.y = display.contentCenterY 
	linkedin:addEventListener( "tap", function() system.openURL( "http://www.linkedin.com/pub/avraam-mavridis/31/b65/53a" ) end )

	-- display a twitter image
	local twitter = display.newImageRect( "Twitter.png",64,64)
	twitter.x = display.contentCenterX + 70
	twitter.y = display.contentCenterY 
	twitter:addEventListener( "tap", function() system.openURL( "https://twitter.com/avraamakis" ) end )


	
		backBtn = widget.newButton{
		label="Menu",
		fontSize=25,
		labelColor = { default={255}, over={128} },
		defaultFile="button2.png",
		overFile="button-over2.png",
		width=154, height=40,
		onRelease = onBackBtnRelease	-- event listener function
	}
	backBtn:setReferencePoint( display.CenterReferencePoint )
	backBtn.x = display.contentWidth*0.5
	backBtn.y = display.contentHeight - 75
	
	group:insert( background )
	group:insert( backBtn )
	group:insert( developer )
	group:insert( facebook )
	group:insert( linkedin )
	group:insert( twitter )

	

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