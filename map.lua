local Map = {}

ligne1 =  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} -- 17
ligne2 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne3 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne4 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne5 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne6 =  {1,0,0,0,0,0,0,0,0,"s",0,0,0,0,0,0,1} 
ligne7 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne8 =  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne9 =  {1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}
ligne10 = {1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,1,1} 
ligne11 = {1,0,0,0,0,0,0,0,0,"e",0,0,0,0,0,0,1}  
ligne12 = {1,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,1}  
ligne13 = {1,0,0,"e",0,"c",0,0,0,0,0,0,0,0,1,1,1}  
ligne14 = {1,0,0,1,1,1,1,1,0,0,0,0,0,0,1,0,1}  
ligne15 = {1,1,0,0,"p",0,0,0,"m","e","bc",0,0,0,"bc","pf",1}  
ligne16 = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} 

niveau1 = {ligne1,ligne2,ligne3,ligne4,ligne5,ligne6,ligne7,ligne8,ligne9,ligne10,ligne11,ligne12,ligne13,ligne14,ligne15,ligne16}

tile = {}
tile[1] = love.graphics.newImage("Images/tile1.png")
tile["bc"] = love.graphics.newImage("Images/briqueCasse.png")
tile["m"] = love.graphics.newImage("Images/caisseMunition.png")
tile["pf"] = love.graphics.newImage("Images/door.png")
tile["s"] = love.graphics.newImage("Images/shop.png")


function creerObjet()
	for ligne=1,#niveau1 do
		for colonne=1,#ligne1 do
			id = niveau1[ligne][colonne]
			if id == "e" then
				createEnnemie("walk0",(colonne-1) * widthCase,(ligne-1) * heightCase,ennemie_width,ennemie_heigth,50,50,ennemie_idle)
				ennemies[#ennemies].img = ennemies[#ennemies].animation[math.floor(ennemies[#ennemies].frame)]
			elseif id == "c" then
				createSpriteRecovable("walk0",(colonne-1) * widthCase,(ligne-1) * heightCase,coins_width *2,coins_heigth *2,0,0,coins_idle,false)
				isRecovables[#isRecovables].img = isRecovables[#isRecovables].animation[math.floor(isRecovables[#isRecovables].frame)]
				isRecovables[#isRecovables].vie = 1
			elseif id == "p" then
				createSpriteRecovable("walk0",(colonne-1) * widthCase,(ligne-1) * heightCase,pickaxe_width,pickaxe_heigth,0,0,pickaxe_idle,true)
				isRecovables[#isRecovables].img = isRecovables[#isRecovables].animation[math.floor(isRecovables[#isRecovables].frame)]
			elseif id == "s" then
				shop = createSprite("walk0",(colonne-1) * widthCase,(ligne-1) * heightCase,shop_width,shop_heigth,50,50,shop_idle)
				sprites[#sprites].img = sprites[#sprites].animation[math.floor(sprites[#sprites].frame)]
			end
		end
	end
end
function Map.load()
	largeur = love.graphics.getWidth()
 	hauteur = love.graphics.getHeight()
 	widthCase = largeur / #ligne1
 	heightCase = hauteur / #niveau1 	
 	creerObjet()
end
function Map.update(dt)
end

function Map.draw()
	for ligne=1,#niveau1 do
		for colonne=1,#ligne1 do
			id = niveau1[ligne][colonne]
			xRect = widthCase * (colonne - 1)
      		yRect = heightCase * (ligne - 1)
      		if id ~= 0 and id ~= "e" and id ~= "c"and id ~= "p" and id ~= "s"then
				love.graphics.draw(tile[id],xRect,yRect,0,widthCase / tile[id]:getWidth(),heightCase / tile[id]:getHeight())
			end
		end
	end
end

return Map
