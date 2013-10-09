---------------------------------------------------------------------------------
--
-- scene13.lua
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


local function blackholeRotate()
	blackholeSprite:rotate(0.8)
	blackholeSprite2:rotate(-0.8)
	blackholeSprite3:rotate(0.8)
	blackholeSprite4:rotate(-0.8)
	blackholeSprite5:rotate(0.8)
end




-- Called when the scene's view does not exist:
function scene:createScene( event )
	screenGroup = self.view
	global.initialize(240,14,'maze13.png')
	maze.isVisible = false
	maze2.isVisible = false
	physics.start(); 
	physics.setGravity( 0,0 )
	planetSprite:play()
	
	

	local blackholeoptions = {
   		width = 32,
   		height = 24,
   		numFrames = 4
		}

	local blackholeSheet = graphics.newImageSheet( "blackholesheet.png", blackholeoptions )

	local blackholeSequenceData =
			{
    		name="blackholeflashing",
		    start=1, --Starting loop
		    count=4,
		    time=800,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 0,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "forward"    -- Optional. Values include: "forward","bounce"
			}

	blackholeSprite = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite.x = display.contentCenterX+30
	blackholeSprite.y = display.contentCenterY
	blackholeSprite.name = "blackholeSprite"
	blackholeSprite:play()

	blackholeSprite2 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite2.x = 175
	blackholeSprite2.y = display.contentCenterY+45
	blackholeSprite2.name = "blackholeSprite"
	blackholeSprite2:play()

	blackholeSprite3 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite3.x = display.contentCenterX-35
	blackholeSprite3.y = display.contentCenterY
	blackholeSprite3.name = "blackholeSprite"
	blackholeSprite3:play()

	blackholeSprite4 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite4.x = display.contentCenterX-10
	blackholeSprite4.y = display.contentCenterY-100
	blackholeSprite4.name = "blackholeSprite"
	blackholeSprite4:play()

	blackholeSprite5 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite5.x = display.contentCenterX+50
	blackholeSprite5.y = display.contentCenterY-105
	blackholeSprite5.name = "blackholeSprite"
	blackholeSprite5:play()
	
	physics.addBody (planetSprite, "dynamic",physicsData:get("earthphysics"))
	planetSprite.isSleepingAllowed = false
	physics.addBody (blackholeSprite, "static",physicsData:get("blackhole"))
	blackholeSprite.isSleepingAllowed = false
	physics.addBody (blackholeSprite2, "static",physicsData:get("blackhole"))
	blackholeSprite2.isSleepingAllowed = false
	physics.addBody (blackholeSprite3, "static",physicsData:get("blackhole"))
	blackholeSprite3.isSleepingAllowed = false
	physics.addBody (blackholeSprite4, "static",physicsData:get("blackhole"))
	blackholeSprite4.isSleepingAllowed = false
	physics.addBody (blackholeSprite5, "static",physicsData:get("blackhole"))
	blackholeSprite5.isSleepingAllowed = false
	physics.addBody (maze, "static",physicsData:get("mazelevel13_1"))
	physics.addBody (maze2, "static",physicsData:get("mazelevel13_2"))
	physics.addBody (borderleft, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderright, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderup, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderdown, "static",{ friction=0.5, bounce=0 })
	physics.addBody (exitscn, "static",physicsData:get("exitscn"))
	
	Runtime:addEventListener("enterFrame", global.checkTime)
	Runtime:addEventListener( "accelerometer", global.onTilt )
	Runtime:addEventListener( "collision", global.onCollision )
	Runtime:addEventListener( "collision", global.onCollisionDrawCircle )

	
	screenGroup:insert( background )
	screenGroup:insert(displayTime)
	screenGroup:insert( planetSprite )
	screenGroup:insert( maze )
	screenGroup:insert( maze2 )
	screenGroup:insert( blackholeSprite )
	screenGroup:insert( blackholeSprite2 )
	screenGroup:insert( blackholeSprite3 )
	screenGroup:insert( blackholeSprite4 )
	screenGroup:insert( blackholeSprite5 )
	screenGroup:insert( borderleft )
	screenGroup:insert( borderright )
	screenGroup:insert( borderdown)
	screenGroup:insert( borderup)
	screenGroup:insert( exitscn )
	screenGroup:insert( explosionSprite )

	
	
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
    Runtime:removeEventListener( "collision", global.onCollisionDrawCircle )

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )

	print( "((destroying scene 1's view))" )
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