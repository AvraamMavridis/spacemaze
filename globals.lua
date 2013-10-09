global = {}

--initialize the global variables
function global.initialize(_leveltime,_nextscene,_maze)
	storyboard = require( "storyboard" )
	scene = storyboard.newScene()
	displayTime = 0 
	background = 0
	maze = 0 
	maze2 = 0 
	borders = 0
	exitscn = 0
	instructions = 0
    startTime = 0
    nextscene = _nextscene
    levelTime = _leveltime
    planetSprite = 0
    blackholeSprite = 0
	blackholeSprite2 = 0
	alienSprite = 0
	alienSprite2 =0
    now = 0
    explosionSprite = 0
    exitSound = audio.loadSound("exit.wav")
    backgroundMusicSound = audio.loadStream ( "background.mp3" )


    displayTime = display.newText(levelTime, display.contentWidth-40, 15)
	displayTime.alpha = 0
	displayTime.size = 20
	displayTime:setTextColor( 0,173, 239 )

	background = display.newImageRect( "background2.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	planetoptions = {
   		width = 24,
   		height = 24,
   		numFrames = 5
		}

	planetSheet = graphics.newImageSheet( "earthsprite.png", planetoptions )

	planetSequenceData =
		{
    		name="planetsequence",
		    start=1,
		    count=5,
		    time=500,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 0,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
		}

	planetSprite = display.newSprite( planetSheet, planetSequenceData )
	planetSprite.x = 75
	planetSprite.y = 15
	planetSprite.x = 30
	planetSprite.y = display.contentCenterY
	planetSprite.name = "planet"

	explosionoptions = {
   		width = 32,
   		height = 32,
   		numFrames = 24
		}
		
	explosionSheet = graphics.newImageSheet( "explosion.png", explosionoptions )

	explosionSequenceData =
		{
    		name="explosionsequence",
		    start=1,
		    count=24,
		    time=2000,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
		    loopCount = 1,    -- Optional. Default is 0 (loop indefinitely)
		    loopDirection = "forward"    -- Optional. Values include: "forward","bounce"
		}



	explosionSprite = display.newSprite( explosionSheet, explosionSequenceData )
	explosionSprite.x = 100
	explosionSprite.y = 50
	explosionSprite.name = "explosion"

	maze=display.newImage( _maze )
	maze.x=display.contentCenterX
	maze.y=display.contentCenterY
	maze.name="maze"

	maze2=display.newImage( _maze )
	maze2.x=display.contentCenterX
	maze2.y=display.contentCenterY
	maze2.name="maze"

	exitscn = display.newImage("exit.png")
	exitscn.x = display.contentWidth-30
	exitscn.y = display.contentCenterY
	exitscn.name ="exitscn"

	borderleft = display.newImage( "borderleftright.png" )
	borderleft.x = 1
	borderleft.y = display.contentCenterY

	borderright = display.newImage( "borderleftright.png" )
	borderright.x = display.contentWidth-1
	borderright.y = display.contentCenterY

	borderup = display.newImage( "borderupdown.png")
	borderup.x = display.contentCenterX
	borderup.y = 1

	borderdown = display.newImage( "borderupdown.png")
	borderdown.x = display.contentCenterX
	borderdown.y = display.contentHeight - 1 
	

end



--change gravity on accelerator eventss
function global.onTilt( event )
	physics.setGravity( (-9.8*event.yGravity), (-9.8*event.xGravity) )
end

function global.nextScene()
	audio.stop()
	audio.play( exitSound  )
	physics.stop()
    storyboard.state.score = storyboard.state.score + (levelTime - (now - startTime)) * ((nextscene-1)*10)
    storyboard.state2.level = nextscene
    storyboard.gotoScene( ('loadscene'.. nextscene))
end


function  global.gameOver( )
	audio.stop()
	storyboard.gotoScene( "gameover", "fade", 300)
end


function global.onCollision( event )
	if ( event.phase == "began" ) then
       if(event.object1.name=="exitscn" or event.object2.name=="exitscn") then
       		timer.performWithDelay ( 200,  global.nextScene)
       end 
       if((event.object1.name =="blackholeSprite" and event.object2.name =="planet") or (event.object2.name =="blackholeSprite" and event.object1.name =="planet")) then
        	planetSprite.isVisible = false
        	explosionSprite.x = event.x
        	explosionSprite.y = event.y
			explosionSprite:play()
			timer.performWithDelay( 1000, global.gameOver )    
       end 
       if((event.object1.name =="alien" and event.object2.name =="planet") or (event.object2.name =="alien" and event.object1.name =="planet")) then
        	planetSprite.isVisible = false
        	explosionSprite.x = event.x
        	explosionSprite.y = event.y
			explosionSprite:play()
			timer.performWithDelay( 1000, global.gameOver )    
        end 
	end
end

function global.onCollisionDrawCircle( event )
	if ( event.phase == "began" ) then
        if((event.object1.name =="maze" and event.object2.name =="planet") or (event.object2.name =="maze" and event.object1.name =="planet")) then
        	local myCircle = display.newCircle( event.x, event.y, 4 )
			myCircle:setFillColor(math.random(0, 255),math.random(0, 255),math.random(0, 255))  
			screenGroup:insert( myCircle )
        end 
        if((event.object1.name =="maze" and event.object2.name =="alien") or (event.object2.name =="maze" and event.object1.name =="alien")) then
        	local myCircle = display.newCircle( event.x, event.y, 4 )
			myCircle:setFillColor(math.random(0, 255),math.random(0, 255),math.random(0, 255))  
			screenGroup:insert( myCircle )
        end 
	end
end





--function to display the time
function global.checkTime(event)
  now = os.time()
  displayTime.text = levelTime - (now - startTime)
  --change the colour of the timer based on how much time is remaining
  if ( levelTime - (now - startTime)==levelTime/2) then
  	transition.to(displayTime,{time=100,size=30})
  	displayTime:setTextColor( 214,223, 32 )
  end
  if ( levelTime - (now - startTime)==5) then
  	transition.to(displayTime,{time=100,size=40})
  	displayTime:setTextColor( 239,89, 40 )
  end
  --gamve over when there is no remaining time
  if ( levelTime - (now - startTime)==0) then
  	explosionSprite.x=planetSprite.x
    explosionSprite.y=planetSprite.y
    explosionSprite:play()
    timer.performWithDelay( 500, global.gameOver )
	-- global.gameOver()
  end
end

function global.changeGravity( )
	if(	planetSprite.y > display.contentCenterY + 10 ) then
	 	physics.setGravity( 0,7 )
	end
	if( planetSprite.y < display.contentCenterY + 10 ) then
		physics.setGravity( 0,0)
	end
end



	

return global