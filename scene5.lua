---------------------------------------------------------------------------------
--
-- scene5.lua
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


local function mazeRotate()
	maze:rotate(0.1)
 	maze2:rotate(0.1)
end


local function blackholeRotate()
	blackholeSprite:rotate(0.8)
	blackholeSprite2:rotate(-0.8)
	blackholeSprite3:rotate(0.8)
end


 


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	global.initialize(25,6,'maze5.png')
	physics.start(); 
	physics.setGravity( 0,0 )
	planetSprite:play()
	-- planetSprite:addEventListener("touch", global.nextScene)

	
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
	blackholeSprite.x = display.contentCenterX+40
	blackholeSprite.y = display.contentCenterY
	blackholeSprite.name = "blackholeSprite"
	blackholeSprite:play()

	blackholeSprite2 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite2.x = display.contentCenterX-30
	blackholeSprite2.y = 30 --display.contentCenterY-80
	blackholeSprite2.name = "blackholeSprite"
	blackholeSprite2:play()

	blackholeSprite3 = display.newSprite( blackholeSheet, blackholeSequenceData )
	blackholeSprite3.x = display.contentCenterX-90
	blackholeSprite3.y = 160 --display.contentCenterY-80
	blackholeSprite3.name = "blackholeSprite"
	blackholeSprite3:play()


	
	physics.addBody (planetSprite, "dynamic",physicsData:get("earthphysics"))
	planetSprite.isSleepingAllowed = false
	physics.addBody (maze, "static",physicsData:get("mazelevel5_1"))
	physics.addBody (maze2, "static",physicsData:get("mazelevel5_2"))
	physics.addBody (blackholeSprite, "static",physicsData:get("blackhole"))
	physics.addBody (blackholeSprite2, "static",physicsData:get("blackhole"))
	physics.addBody (blackholeSprite3, "static",physicsData:get("blackhole"))
	blackholeSprite.isSleepingAllowed = false
	blackholeSprite2.isSleepingAllowed = false
	blackholeSprite3.isSleepingAllowed = false
	physics.addBody (borderleft, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderright, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderup, "static",{ friction=0.5, bounce=0 })
    physics.addBody (borderdown, "static",{ friction=0.5, bounce=0 })
	physics.addBody (exitscn, "static",physicsData:get("exitscn"))
	
	
	Runtime:addEventListener( "enterFrame", blackholeRotate)
	Runtime:addEventListener( "enterFrame", mazeRotate)
	Runtime:addEventListener("enterFrame", global.checkTime)
	Runtime:addEventListener( "accelerometer", global.onTilt )
	Runtime:addEventListener( "collision", global.onCollision )
	
	
	screenGroup:insert( background )
	screenGroup:insert(displayTime)
	screenGroup:insert( planetSprite )	
    screenGroup:insert( blackholeSprite )
	screenGroup:insert( blackholeSprite2 )
	screenGroup:insert( blackholeSprite3 )
	screenGroup:insert( explosionSprite )
	screenGroup:insert( maze )
	screenGroup:insert( maze2 )
	screenGroup:insert( borderleft )
	screenGroup:insert( borderright )
	screenGroup:insert( borderdown)
	screenGroup:insert( borderup)
	screenGroup:insert( exitscn )
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
    Runtime:removeEventListener( "enterFrame", blackholeRotate)
    Runtime:removeEventListener( "enterFrame", mazeRotate )
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