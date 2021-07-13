io.stdout:setvbuf("no")

function love.load()
    love.window.setTitle("Purple LandScape Generation")
    initMontagnes()
end 

function love.draw()

    -- Ciel 
    love.graphics.setColor(0.85, 0.75, 0.6, 1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    -- Soleil 
    love.graphics.setColor(1, 1, 0.9, 1)
    love.graphics.circle("fill", 105, 65, 25)
    love.graphics.setColor(1, 1, 1, 1)

    -- Montagne 
    drawMontagne(1, {157/255, 98/255, 204/255})
    drawMontagne(2, {130/255, 79/255, 138/255})
    drawMontagne(3, {68/255, 28/255, 99/255})
    drawMontagne(4, {49/255, 7/255, 81/255})
 
end

function initMontagnes()
    montagne = {}
    montagne[1] = generateLandscape( love.math.random(150, 250), love.math.random(150, 250), 8, 0.5, 250)
    montagne[2] = generateLandscape( love.math.random(300, 400), love.math.random(300, 400), 7, 0.6, 80)
    montagne[3] = generateLandscape( love.math.random(450, 550), love.math.random(450, 550), 5, 0.5, 50)
    montagne[4] = generateLandscape( love.math.random(500, 600), love.math.random(500, 600), 4, 0.5, 50)
end 

function drawMontagne(pNum, pColor)

    local lstMontagne = {}
    for i=1, #montagne[pNum] do 
        table.insert(lstMontagne, montagne[pNum][i].x)
        table.insert(lstMontagne, montagne[pNum][i].y)
    end
    love.graphics.setColor(pColor[1], pColor[2], pColor[3])
    --love.graphics.line(lstMontagne)

    for i=1, love.graphics.getWidth() - 1 do 
        local h = isUnder(montagne[pNum], i)
        --love.graphics.line(i, h, i, love.graphics.getHeight())
        love.graphics.rectangle("fill", i, h, 1, love.graphics.getHeight() - h)
    end 

    love.graphics.setColor(1, 1, 1, 1)
end 


function love.keypressed(key)
    if key == "g" then 
        initMontagnes()
    end
end 

function generateLandscape(pStartY, pEndY, itterations, smooth, decalage)
    local t = {} 

    table.insert(t, {x = 0, y = pStartY})
    table.insert(t, {x = love.graphics.getWidth(), y = pEndY})

    for i=1, itterations do 

        local traitement = {}
        for j=1, #t - 1 do 
            traitement[j] = { startX = t[j].x, endX = t[j + 1].x, startY = t[j].y, endY = t[j + 1].y }
        end

        for j=1, #traitement do 
            local tr = traitement[j]
            local p1 = { x = tr.startX, y = tr.startY }
            local p2 = { x = tr.endX, y = tr.endY }
            local p = {
                x = (p1.x + p2.x) * 0.5,
                y = (p1.y + p2.y) * 0.5 + love.math.random(-decalage, decalage)
            }
            table.insert(t, j * 2, {x = p.x, y = p.y})
        end 

        decalage = decalage * smooth
    end 

    return t 
end

function isUnder(liste, x)
    local pas = liste[2].x - liste[1].x
    local w = x / pas
    local lambda = w - math.floor(w)
    local A = liste[math.floor(w) + 1].y
    local B = liste[math.floor(w) + 2].y

    return (1 - lambda) * A + lambda * B
end 