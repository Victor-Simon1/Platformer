Map = require("map")
local Game = {}

sprites = {} -- LISTE CONTENANT TOOT LES SPRITES
ennemies = {}
shoots = {}
isRecovables = {}
inventaire = {}



-----------VARIABLE---------------
nbCoins = 0 
nbBalle = 0 
affiFPS = false
inventory = love.graphics.newImage("Images/inventory.png")
widthCase = 60.235294117647
heightCase = 48
coeur = love.graphics.newImage("Images/coeur.png")
inventoryIsSelect = love.graphics.newImage("Images/inventorySelect.png")
------------ANIMATION-----------

shop_idle = {}
shop_idle["box"] = {}

pickaxe_idle = {}
pickaxe_idle["box"] = {}

ennemie_idle = {}
ennemie_idle["box"] = {}

shoot_idle = {}
shoot_idle["box"] = {}

coins_idle = {}
coins_idle["box"] = {}

----------------ANIMATION PICKAXE------------------------------
pickaxe_idle[1] = love.graphics.newImage("Images/pickaxe.png")
pickaxe_idle["box"][1] = {x = 0,y = 0,w = widthCase , h =heightCase} 
pickaxe_width =  pickaxe_idle[1]:getWidth()
pickaxe_heigth =  pickaxe_idle[1]:getHeight()
----------------ANIMATION Shop---------------------------------
shop_idle[1] = love.graphics.newImage("Images/shop.png")
shop_idle["box"][1] = {x = 0,y = 0,w = widthCase , h =heightCase} 
shop_width =  shop_idle[1]:getWidth()
shop_heigth =  shop_idle[1]:getHeight()
----------------ANIMATION SHOOTS-------------------------------
shoot_idle[1] = love.graphics.newImage("Images/tir.png")
shoot_idle["box"][1] = {x = 0,y = 0,w = 16 , h =16} 

----------------ANIMATION COINS----------------------------
for i=1,4 do
    coins_idle[i] = love.graphics.newImage("Images/coin"..i..".png")
    coins_idle["box"][i] = {x = 0,y = 0,w = widthCase / 2  , h = heightCase / 2} 
end
 coins_width =  coins_idle[1]:getWidth()
 coins_heigth =  coins_idle[1]:getHeight()
--------------ANIMATION ENNEMIE-----------------------


for i=1,5 do
    ennemie_idle[i] = love.graphics.newImage("Images/walk"..(i-1)..".png")
    ennemie_idle["box"][i] = {x = 6,y = 5,w = widthCase -12 , h = heightCase -6} 
end
ennemie_width = ennemie_idle[1]:getWidth()
ennemie_heigth = ennemie_idle[1]:getHeight()

--------------ANIMATION PLAYER -----------------------------------------
TileSheet = love.graphics.newImage("Images/player.png")
player_width = 271 / 8
player_height = 300 / 12
nbColumns = TileSheet:getWidth() / player_width
nbLines = TileSheet:getHeight() / player_height
id = 1
player_textures = {}  -- regroupe tous les animation
player_textures[0] = nil
  for l=1,nbLines do
    for c=1,nbColumns do
      player_textures[id] = love.graphics.newQuad( (c-1)*player_width, (l-1)*player_height,player_width, player_height, TileSheet:getWidth(), TileSheet:getHeight() )
      id = id + 1
    end
  end

player_idle = {} -- ANIMATION idle
player_idle["box"] = {}

player_run = {} -- ANIMATION idle
player_run["box"] = {}

for i=1, 4 do
  player_idle[i] = player_textures[i]
  player_idle["box"][i] = {x=10, y=10, w=40, h= 40 }
end

for i=9,13 do
  player_run[i-8] = player_textures[i]
  player_run["box"][i-8] = {x=10, y=10, w=40, h= 40 }
end

function chargerBox(sprite) 
  sprite.hitbox = {x=sprite.animation["box"][math.floor(sprite.frame)].x +sprite.x ,
  y = sprite.animation["box"][math.floor(sprite.frame)].y+sprite.y,
w = sprite.animation["box"][math.floor(sprite.frame)].w,
h = sprite.animation["box"][math.floor(sprite.frame)].h}
end
--CREE SPRITE NORMAL 
function createSprite(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)
	local sprite = {}
  sprite.nom = pImg
	sprite.img = love.graphics.newImage("Images/"..pImg..".png")
	sprite.x = pX
	sprite.y = pY
  sprite.w = pW
  sprite.h = pH
	sprite.vx = pVx
	sprite.vy = pVy
	sprite.friction = 2
	sprite.gravity = 5
	sprite.maxSpeed = 6.1
	sprite.jump = true
  sprite.double_jump = true
	-- IMAGES
	sprite.frame = 1
	sprite.animation = pAnim
  sprite.hitbox = pAnim["box"][math.floor(sprite.frame)]
	sprite.scalaire = 1
	
  sprite.supprime = false
  sprite.regard = "right"

	table.insert(sprites,sprite)
	return sprite
end

function createEnnemie(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)
  local ennemie = createSprite(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)

  table.insert(ennemies,ennemie)
  return ennemie
end

function createShoot(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)
  local shoot = {}

  shoot = createSprite(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)
  shoot.type = "tir"
  table.insert(shoots,shoot)
  return shoot 
end

function  createSpriteRecovable( pImg,pX,pY,pW,pH,pVx,pVy,pAnim,pRecup )
  local isRecovable = {}
  isRecovable =  createSprite(pImg,pX,pY,pW,pH,pVx,pVy,pAnim)

  isRecovable.recup = pRecup
  isRecovable.vie = 1
  table.insert(isRecovables,isRecovable)
  return isRecovable
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
  	local x1 = getTile(sprite.x + sprite.w+1 ,sprite.y +10)
  	local x2 = getTile(sprite.x + sprite.w+1,sprite.y + sprite.h - 10)
  	return collideWall(x1) or collideWall(x2)
end
function leftCollide(sprite)
 	local x1 = getTile(sprite.x -1,sprite.y +10 )
  local x2 = getTile(sprite.x -1,sprite.y +sprite.h- 10)
 	return collideWall(x1) or collideWall(x2)
end
function downCollide(sprite)
  	local x1 = getTile(sprite.x+10 ,sprite.y + sprite.h +1)
  	local x2 = getTile(sprite.x + sprite.w - 10,sprite.y + sprite.h+1 )
  	return collideWall(x1) or collideWall(x2)
end
function upCollide(sprite)

  	local x1 = getTile(sprite.x + 10  ,sprite.y-1)
  	local x2 = getTile(sprite.x + sprite.w -10,sprite.y-1 )
 	return collideWall(x1) or collideWall(x2)
end

function objectInCollide(o1,o2)
  if o1.x <= o2.x + o2.w and o2.x <= o1.x + o1.w and o1.y <= o2.y + o2.h and o2.y <= o1.y+o1.h then
    return true
  end
  return false
end
function isCollide()
  for x=1,#ennemies do
    p = player
    e = ennemies[x]
    if objectInCollide(e,p) then
      return true
    end
  end
  return false
end
function deleteInList(liste)
    for i=#liste ,1 , -1 do
      if liste[i].supprime then
        table.remove(liste,i)
      end
    end
end

function Game.load()
	Map.load()
	player = createSprite("player",widthCase*5,heightCase*3,player_width,player_height,5,5,player_idle)
  player.img = player.animation[math.floor(player.frame)]
  player.vie = 5
  player.supprime = true
  player.immunite = false
  chargerBox(player)
end

function Game.update(dt)
	Map.update(dt)
  
  ---------------------GESTION PLAYER-------------------------------
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
    if love.keyboard.isDown("space") and player.jump == true and downCollide(player.hitbox) then -- si appuie sur espace
      player.jump = false
      player.vy = player.vy - 5 
    end
   -- if love.keyboard.isDown("space")  and player.jump == false then
     -- player.double_jump = false
      --player.vy = player.vy - 0.4
    --end
    if love.keyboard.isDown("space") == false then
      --player.double_jump = true
      player.jump = true
    end

    if player.regard == "left" then
      player.scalaire = -1 
    else
      player.scalaire = 1 
    end
  local collide = false
    if player.vy <0 then -- COLLISSION HAUT
      collide = upCollide(player.hitbox)
      if collide then
        player.vy = 0 
        player.jump = false
      end
    end
    collide = false
    if player.vy >= 0 then -- COLLISION BAS
      collide = downCollide(player.hitbox)
      if collide then
        player.vy = 0
        local ligne = math.floor(( player.hitbox.y + player.hitbox.h+1) / heightCase) 
        player.y = ligne * heightCase - player.hitbox.h +(player.y - player.hitbox.y)
      end  
    end
    collide =false
    if player.vx > 0 then -- COLLISION DROIT
      collide = rightCollide(player.hitbox)
      if collide then
        player.vx  = 0
        local colonne = math.floor(( player.hitbox.x + player.hitbox.w + 1) / widthCase) 
        player.x = colonne * widthCase - player.hitbox.w +(player.x - player.hitbox.x)
      end
    elseif player.vx <0 then-- COLLISION GAUCHE
      collide = leftCollide(player.hitbox)
      if collide then
        player.vx  = 0
        local colonne = math.floor((player.hitbox.x - 1) / widthCase) 
        player.x = (colonne+1) * widthCase +(player.x - player.hitbox.x)
      end
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
      player.animation = player_idle
    elseif player.vx ~= 0 then
      player.animation = player_run
  	end
    player.img = player.animation[math.floor(player.frame)]
    player.frame =  player.frame + 10 * dt
    if player.frame > #(player.animation) then
      player.frame = 1
    end

    if isCollide() and player.immunite == false then
        player.vie = player.vie - 1 
        player.immunite = true
      end
    if player.immunite == true and not isCollide() then
       player.immunite = false
    end
    if getTile(player.hitbox.x , player.hitbox.y) ==  "m" then
      local colonne = math.floor(player.hitbox.x / widthCase)
      local ligne = math.floor(player.hitbox.y / heightCase)
      niveau1[ligne+1][colonne+1] = 0 
      nbBalle = nbBalle +5 
    end
    player.vy = player.vy + player.gravity * dt
    player.x = player.x + player.vx 
    player.y = player.y + player.vy
    chargerBox(player)
------------------------------GESTION SHOOTS-------------------------
    if #shoots > 0 then
      for i=#shoots,1,-1 do
        local sh = shoots[i]

        if sh.regard == "left" then
          sh.x = sh.x - sh.vx * dt
        else
          sh.x = sh.x + sh.vx * dt
        end
        if rightCollide(sh.hitbox) or leftCollide(sh.hitbox) then
          shoots[i].supprime = true
          deleteInList(shoots)
        end
      end
    end
----------------------GESTION ENNEMIE----------------------------
    for i=#ennemies,1,-1 do
      local e = ennemies[i]
      if getTile(e.hitbox.x,e.hitbox.y + e.hitbox.h) ~= 1 and downCollide(e.hitbox) then
        e.vx = math.abs(e.vx)
      elseif getTile(e.hitbox.x + e.hitbox.w,e.hitbox.y + e.hitbox.h) ~= 1 and downCollide(e.hitbox) then
         e.vx = -math.abs(e.vx)
      end
      if e.vx < 0 then
        if leftCollide(e.hitbox) then
          e.vx = math.abs(e.vx)
        end
      end
      if e.vx > 0 then
        if rightCollide(e.hitbox) then
          e.vx = -math.abs(e.vx)
        end
      end
      if not downCollide(e.hitbox) then
        e.vy = e.vy + e.gravity*dt
        e.y = e.y + e.vy * dt
      else
        e.y = math.floor((e.hitbox.y + e.hitbox.h+1) / heightCase) * heightCase - e.hitbox.h +(e.y - e.hitbox.y)
      end
      if e.vx > 0 then
        e.regard = "right"
      else 
        e.regard = "left"
      end
      e.x = e.x + e.vx *dt
    end
----------------------COLLISION ENNEMIS SPRITE--------------------

for i=#shoots,1,-1 do
  for y=#ennemies,1,-1 do
    if objectInCollide(shoots[i].hitbox,ennemies[y].hitbox) then
      shoots[i].supprime = true
      ennemies[y].supprime = true
      createSpriteRecovable("walk0",(ennemies[y].x/ widthCase) * widthCase,(ennemies[y].y / heightCase) * heightCase,coins_width *2,coins_heigth *2,0,0,coins_idle,false)
      isRecovables[#isRecovables].img = isRecovables[#isRecovables].animation[math.floor(isRecovables[#isRecovables].frame)]
      isRecovables[#isRecovables].vie = 1
      table.remove(ennemies,y)
      
    end
  end
  if shoots[i].supprime then 
    table.remove(shoots,i)
  end
end
-------------------GESTION SHOP-------------------------
if not downCollide(shop.hitbox) then
  shop.y = shop.y + shop.gravity
end
-------------------GESTION OBJET RECUP------------------------
for i=#isRecovables,1,-1 do
  local s = isRecovables[i]
  if not downCollide(s.hitbox) then
    s.y = s.y +s.gravity
  end
  if objectInCollide(s.hitbox,player.hitbox) and #inventaire < 6 then
    if s.recup then
      table.insert(inventaire,s)
    end
    s.supprime = true
    table.remove(isRecovables,i)

    if s.animation == coins_idle then
      nbCoins = nbCoins +1 
    end


  end
end
-----------------GESTION INVENTAIRE---------------------
for i=1,#inventaire do
  local inv = inventaire[i]
  inv.img = inv.animation[math.floor(inv.frame)]
  inv.frame =  inv.frame + 5 * dt
  if inv.frame > #(inv.animation) then
    inv.frame = 1
  end
  print(inventaire[i].vie)
  if inv.vie == 0 then
    table.remove(inventaire,i)
  end
end
----------------------GESTION SPRITE-----------------------------
    for i=#sprites,1,-1 do
      local s = sprites[i]
        s.img = s.animation[math.floor(s.frame)]
        s.frame =  s.frame + 10 * dt
      if s.frame > #(s.animation) then
        s.frame = 1
      end
      if s.regard == "left" then
        s.scalaire = -1 
      else 
        s.scalaire = 1
      end
      chargerBox(s)
      if sprites[i].supprime then
        table.remove(sprites,i)
      end
    end

end
function Game.draw()
	Map.draw()
  if player.regard == "left" then
    love.graphics.draw(TileSheet, player.img, player.x  +widthCase, player.y, 0, player.scalaire * widthCase/player.w,heightCase/player.h) -- affichage player
  else
    love.graphics.draw(TileSheet, player.img, player.x , player.y, 0, player.scalaire  * widthCase/player.w,heightCase/player.h) -- affichage player
  end
  love.graphics.rectangle("line",player.hitbox.x,player.hitbox.y,player.hitbox.w,player.hitbox.h)
  for x= 1,#sprites do
    local  s = sprites[x]
	  if s.regard == "left" then
      if s.type == "tir" then
        love.graphics.draw(s.img,s.x + s.hitbox.w,s.y,0, s.scalaire * widthCase / s.w,heightCase / s.h)
      else
		    love.graphics.draw(s.img,s.x + widthCase,s.y,0, s.scalaire * widthCase / s.w,heightCase / s.h)
      end
	  else 
		  love.graphics.draw(s.img,s.x ,s.y,0, s.scalaire * widthCase / s.w,heightCase / s.h)
	  end
  end
	for i=1,#sprites do
		love.graphics.rectangle("line",sprites[i].hitbox.x,sprites[i].hitbox.y,sprites[i].hitbox.w,sprites[i].hitbox.h)
	end
  for i =1,player.vie do
    love.graphics.draw(coeur,0 + widthCase * (i-1),heightCase * 15,0, widthCase /  coeur:getWidth() ,heightCase / coeur:getHeight())
  end
  for i=1,5 do
    inv = inventaire[i]
    love.graphics.draw(inventory,widthCase*7 + widthCase * (i-1) ,heightCase * 15,0, widthCase /  inventory:getWidth() ,heightCase / inventory:getHeight() )
    if inv ~= nil then
      if inv.isSelect == true then
        love.graphics.draw(inventoryIsSelect,widthCase*7 + widthCase * (i-1) ,heightCase * 15,0, widthCase /  inventoryIsSelect:getWidth() ,heightCase / inventoryIsSelect:getHeight() )
      end
      love.graphics.draw(inv.img,widthCase*7 + widthCase * (i-1) ,heightCase * 15,0, widthCase /  inv.img:getWidth() ,heightCase / inv.img:getHeight())
    end
  end
  if affiFPS == true then
    --A GAUCHE DE LECRAN
    love.graphics.print({{255,0,0}, "FPS:"..love.timer.getFPS()}, widthCase,heightCase, 0)
    --A DROITE DE LECRAN
    love.graphics.print({{255,0,0}, "COINS:"..nbCoins},widthCase*14 ,heightCase, 0)
    --love.graphics.print({{255,0,0}, "KILLS:"..kill},widthCase*14 ,heightCase+20, 0)
    --love.graphics.print({{255,0,0}, "SCORE:"..score},widthCase*14 ,heightCase+40, 0)
    love.graphics.print({{255,0,0}, "MUNITIONS:"..nbBalle},widthCase*14 ,heightCase+60, 0)
  end
  
end
function Game.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
  if key == "r" then
    for i=1,#inventaire do
      if inventaire[i].animation == pickaxe_idle and getTile(player.hitbox.x + widthCase,player.hitbox.y) == "bc" and inventaire[i].isSelect then
        local colonne = math.floor(( player.hitbox.x + widthCase )/ widthCase)
        local ligne = math.floor(player.hitbox.y / heightCase)
        niveau1[ligne+1][colonne+1] = 0 
        inventaire[i].vie = inventaire[i].vie - 1
        print(inventaire[i].vie)
      end
    end
  end 
  if key == "u" and nbBalle > 0 then
    nbBalle = nbBalle - 1 
    createShoot("tir",player.x,player.y + heightCase / 2,widthCase,heightCase,100,0,shoot_idle)
    shoots[#shoots].img = shoots[#shoots].animation[math.floor(shoots[#shoots].frame)]
    shoots[#shoots].regard = player.regard
    chargerBox(shoots[#shoots])
  end
  if key == "s" then
    if objectInCollide(player.hitbox,shop.hitbox) then  
      print("shop")
    end
  end
  if key == "z" and affiFPS == false then
     affiFPS = true
  elseif key == "z" and affiFPS == true then 
    affiFPS = false
  end
  for i=1,5 do
    if "kp"..i == key then
      for x = 1, #inventaire do
        inventaire[x].isSelect = false
      end
      if inventaire[i] ~= nil then       
        inventaire[i].isSelect = true
      end
    end
  end
end
return Game
