local My_GUI = {}

function My_GUI.newButton(pX,pY,pWidth,pHeight,pImg,pFonc,pPara)
    My_button = {}

    My_button.isVisible = true 
     --TAILLE
    My_button.x = pX
    My_button.y = pY
    My_button.width = pWidth
    My_button.height =pHeight
     --Images
    My_button.img = love.graphics.newImage("Images/Buttons/"..pImg..".png")
    My_button.imgHover = love.graphics.newImage("Images/Buttons/"..pImg.."Hover.png")
    My_button.imgAnim ={} 
    --Activation au clique
    My_button.fonc = pFonc
    My_button.para = pPara
     --FONCTION
    function My_button:setVisible(p_bool)  
        self.isVisible = p_bool
    end
    function My_button:setX(pX)
        self.x = pX
    end
    function My_button:setY(pY)
        self.y = pY
    end
    function My_button:setHeight(pH)
        self.height = pH
    end
    function My_button:setWidth(pW)
        self.width = pW
    end

    table.insert(buttons,My_button)
    
    return My_button
end

function My_GUI.newPerso(pImg,pX,pY,pWidth,pHeight,pSpd)
    Perso = {}
    --TAILLE
    Perso.x = pX
    Perso.y = pY
    Perso.width = pWidth
    Perso.height = pHeight
    --Images
    Perso.img = love.graphics.newImage("Images/"..pImg..".png")

    --CARACTERISTIQUE
    Perso.spd = pSpd
    function Perso:setVisible(p_bool)  
        self.isVisible = p_bool
    end
    function Perso:setX(pX)
        self.x = pX
    end
    function Perso:setY(pY)
        self.y = pY
    end
    function Perso:setHeight(pH)
        self.height = pH
    end
    function Perso:setWidth(pW)
        self.width = pW
    end
end
function My_GUI.newPanel()
    my_panel = {}

    --TAILLE
    my_panel.x = pX
    my_panel.y = pY
    my_panel.width = pWidth
    my_panel.height = pHeight
end

function My_GUI.newObject(pImg,pX,pY,pWidth,pHeight,pSpd)
    my_object = {}

    --TAILLE
    my_object.x = pX
    my_object.y = pY
    my_object.width = pWidth
    my_object.height = pHeight
end
return My_GUI
