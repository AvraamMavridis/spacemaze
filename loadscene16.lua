---------------------------------------------------------------------------------
--
-- scene16.lua
--
---------------------------------------------------------------------------------


storyboard = require( "storyboard" )
scene = storyboard.newScene()


system.setIdleTimer( false )
system.setAccelerometerInterval( 100 )

physics = require "physics"
physicsData = (require "myphysics").physicsData(1.0)
physics.setReportCollisionsInContentCoordinates( true )
---------------------------------------------------------------------------------
-- BEGINNING OF  IMPLEMENTATION
---------------------------------------------------------------------------------
global = require( "globals" )


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
    storyboard.gotoScene( "gameover", "fade", 300)
	
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene