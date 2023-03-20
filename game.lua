Map = require("map")
local Game = {}

sprites = {} -- LISTE CONTENANT TOOT LES SPRITES


player_idle = {}
player_idle["box"] = {}

for i=0,4 do
	player_idle[i] = "walk"..i
	player_idle["box"][i] = {} 
end

function makeHitbox()
	for i=0,4 do
		player_idle[i] = "walk"..i
		player_idle["box"][i] = {x = player.x+6,y = player.y+5,w = widthCase -12 , h = heightCase -6} 
	end
end
--CREE SPRITE NORMAL 
function createSprite(pImg,pX,pY,pVx,pVy,pAnim)
	local sprite = {}

	sprite.img = love.graphics.newImage("Images/"..pImg..".png")
	sprite.x = pX
	sprite.y = pY
	sprite.vx = pVx
	sprite.vy = pVy
	sprite.friction = 2
	sprite.gravity = 5 
	sprite.maxSpeed = 6.1
	sprite.jump = true

	-- IMAGES
	sprite.frame = 0 
	sprite.animation = pAnim
	sprite.scalaire = 1
	
	table.insert(sprites,sprite)
	return sprite
end


function getTile(x,y)
  local col = math.floor((x / widthCase )+1)
  local lig = math.floor((y/ heightCase)+1)

  return niveau1[lig][col]
end

function collideWall(case)
  if case == 1 or case == "bc"then
    return true
  end
  return false
end

function rightCollide(sprite)
  	local x1 = getTile(sprite.x + widthCase ,sprite.y)
  	local x2 = getTile(sprite.x + widthCase,sprite.y + heightCase - 1)
  	return collideWall(x1) or collideWall(x2)
end
function leftCollide(sprite)
 	local x1 = getTile(sprite.x -1,sprite.y)
  	local x2 = getTile(sprite.x -1,sprite.y +heightCase- 1)
 	return collideWall(x1) or collideWall(x2)
end
function downCollide(sprite)
  	local x1 = getTile(sprite.x ,sprite.y + heightCase )
  	local x2 = getTile(sprite.x + widthCase - 1,sprite.y + heightCase )
  	return collideWall(x1) or collideWall(x2)
end
function upCollide(sprite)

  	local x1 = getTile(sprite.x ,sprite.y-1)
  	local x2 = getTile(sprite.x + widthCase -1,sprite.y-1 )
 	return collideWall(x1) or collideWall(x2)
end
function Game.load()
	Map.load()
	largeur = love.graphics.getWidth()
 	hauteur = love.graphics.getHeight()
 	widthCase = largeur / #ligne1
 	heightCase = hauteur / #niveau1 	
	player = createSprite(player_idle[0],widthCase,heightCase,5,5,player_idle)
	makeHitbox()
end
function Game.update(dt)
	Map.update(dt)
	makeHitbox()
	if love.keyboard.isDown ("right") then
      player.regard = "right"
     if player.vx < player.maxSpeed then
        player.vx =  player.vx + 5 * dt
     else 
        player.vx = player.maxSpeed
      end
    end
   if love.keyboard.isDown ("left") then
     player.regard = "left"
     if player.vx > - player.maxSpeed then 
       player.vx = player.vx - 5 * dt
     else 
       player.vx = -player.maxSpeed
     end
   end
  
    if love.keyboard.isDown("space") and player.jump == true and downCollide(player) then -- si appuie sur espace
      player.jump = false
      player.vy = player.vy - 200  * dt
    end
    if love.keyboard.isDown("space") == false then
      player.jump = true
    end
	for i=1,#sprites do
		s = sprites[i]
		if s.vx ~= 0 then
			s.img = love.graphics.newImage("Images/"..s.animation[math.floor(s.frame)]..".png")
    		s.frame =  s.frame + 10 * dt
    	end
    	if s.frame > 5 then
    		s.frame = 0
    	end
    	if s.regard == "left" then
    		s.scalaire = -1 
    	else 
    		s.scalaire = 1
		end
  		local collide = false
  		if s.vy <0 then -- COLLISSION HAUT
   		 	collide = upCollide(s)
   			if collide then
      			s.vy = 0 
    			s.jump = false
   			end
  		end
  		collide = false
 		if s.vy >= 0 then -- COLLISION BAS
  		   collide = downCollide(s)
  			if collide then
     			s.vy = 0
    		    local ligne = math.floor(s.y / heightCase) 
    		    s.y = (ligne) * heightCase
   			end  
  		end
  		collide =false
 		if s.vx > 0 then -- COLLISION DROIT
   		 	collide = rightCollide(s)
    		if collide then
      			s.vx  = 0
      			local colonne = math.floor(s.x / widthCase) 
      			s.x = (colonne) * widthCase
    		end
  		elseif s.vx <0 then-- COLLISION GAUCHE
    		collide = leftCollide(s)
    		if collide then
    	  		s.vx  = 0
      			local colonne = math.floor((s.x+10) / widthCase) 
      			s.x = (colonne) * widthCase
    		end
  		end
  		s.vy = s.vy + s.gravity * dt
     	s.x = s.x + s.vx 
     	s.y = s.y + s.vy
  	end
  	if player.vx > 0 then
  		player.vx = player.vx - player.friction * dt
    	if player.vx < 0 then
    		player.vx = 0 
    	end
  	end
  	if player.vx < 0 then
  		player.vx = player.vx + player.friction * dt
    	if player.vx > 0 then
    		player.vx = 0 
    	end
  	end
  	if player.vx == 0 then
  		player.img = love.graphics.newImage("Images/"..player.animation[0]..".png")
  	end

end

function Game.draw()
	Map.draw()
	if s.regard == "left" then
		love.graphics.draw(player.img,player.x + widthCase,player.y,0, s.scalaire * widthCase / s.img:getWidth(),heightCase / s.img:getHeight())
	else 
		love.graphics.draw(player.img,player.x ,player.y,0, s.scalaire * widthCase / s.img:getWidth(),heightCase / s.img:getHeight())
	end
	for i=0,3 do
		love.graphics.rectangle("line",player_idle["box"][i].x,player_idle["box"][i].y,player_idle["box"][i].w,player_idle["box"][i].h)
	end
	for i=2,#sprites do
		s = sprites[i]
		love.graphics.draw(s.img,s.x,s.y,0,s.scalaire * widthCase / s.img:getWidth(),heightCase / s.img:getHeight())
	end
end
function Game.keypressed( key )
	if key == 'escape' then
		love.event.quit()
	end
end
return Game
