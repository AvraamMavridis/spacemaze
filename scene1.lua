---------------------------------------------------------------------------------
--
-- scene1.lua
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

	global.initialize(40,2,'maze1.png')
	physics.start(); 
	physics.setGravity( 0,0 )
	planetSprite:play()
	-- planetSprite:addEventListener("touch", global.nextScene)


	instructions=display.newImage( "instructions_level1.png" )
	instructions.x=display.contentCenterX
	instructions.y=display.contentCenterY
	instructions.name="instructions"

	transition.to( instructions, { time=8000, alpha=0, y = 100} )


	physics.addBody (planetSprite, "dynamic",physicsData:get("earthphysics"))
	planetSprite.isSleepingAllowed = false
	physics.addBody (maze, "static",physicsData:get("mazelevel1_1"))
	physics.addBody (maze2, "static",physicsData:get("mazelevel1_2"))
    physics.addBody (borderleft, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderright, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderup, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderdown, "static",{ friction=0.5, bounce=0 })
	physics.addBody (exitscn, "static",physicsData:get("exitscn"))

	Runtime:addEventListener("enterFrame", global.checkTime)
	Runtime:addEventListener( "accelerometer", global.onTilt )
	Runtime:addEventListener( "collision", global.onCollision )

	screenGroup:insert( background )
	screenGroup:insert(displayTime)
	screenGroup:insert( planetSprite )
	screenGroup:insert( explosionSprite )
	screenGroup:insert( maze )
	screenGroup:insert( maze2 )
	screenGroup:insert( borderleft )
	screenGroup:insert( borderright )
	screenGroup:insert( borderdown)
	screenGroup:insert( borderup)
	screenGroup:insert( exitscn )
	screenGroup:insert( instructions )
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	physics.start()
    audio.play(backgroundMusicSound,{channel = 1,loops=-1})
	startTime = os.time()
	transition.to ( displayTime, {alpha=1,time=500} )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	physics.stop( )
    audio.stop()
	Runtime:removeEventListener( "enterFrame", global.checkTime )
    Runtime:removeEventListener( "accelerometer", global.onTilt )
    Runtime:removeEventListener( "collision", global.onCollision )
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