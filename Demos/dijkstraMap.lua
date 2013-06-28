--[[ Rogue ]]
ROT=require 'vendor/rotLove/rotLove'
movers={}
clr=ROT.Color:new()
colors={}
table.insert(colors, clr:fromString('blue'))
table.insert(colors, clr:fromString('red'))
table.insert(colors, clr:fromString('green'))
table.insert(colors, clr:fromString('yellow'))
function love.load()
    f  =ROT.Display(149, 86, .575)
    dothething()
end
function love.keypressed()
    dothething()
end
tsl=0
tbf=1/30
function love.update(dt)
    tsl=tsl+dt
    if tsl>tbf then
        tsl=tsl-tbf
        for _,mover in pairs(movers) do
            local dir=dijkMap:dirTowardsGoal(mover.x, mover.y)
            if dir then
                f:write(map[mover.x][mover.y], mover.x, mover.y, nil, clr:interpolate(mover.color, mover.oc))
                mover.x=mover.x+dir[1]
                mover.y=mover.y+dir[2]
                local oc=f:getBackgroundColor(mover.x, mover.y)
                mover.oc=oc==f:getDefaultBackgroundColor() and clr:fromString('dimgrey') or oc
                f:write('@', mover.x, mover.y, nil, mover.color)
            end
        end
    end
end

function dothething()
    rog=ROT.Map.EllerMaze(f:getWidth(), f:getHeight())
    map={}
    for i=1,f:getWidth() do map[i]={} end
    --rog:randomize(.5)
    --while rog:create(calbak) do end
    rog:create(calbak)
    while true do
        local x=math.random(1,f:getWidth())
        local y=math.random(1,f:getHeight())

        if map[x][y]=='.' then
            dijkMap=ROT.DijkstraMap:new(x,y,f:getWidth(),f:getHeight(),dijkCalbak)
            break
        end
    end
    dijkMap:compute()
    movers={}
    while #movers<40 do
        local x=math.random(1,f:getWidth())
        local y=math.random(1,f:getHeight())

        if map[x][y]=='.' then
            table.insert(movers, {x=x,y=y,color=getRandomColor(),oc=f:getDefaultBackgroundColor()})
        end
    end

    --[[while true do
        local dir=dijkMap:dirTowardsGoal(mover.x, mover.y)
        if not dir then break end
        mover.x=mover.x+dir[1]
        mover.y=mover.y+dir[2]
        local x=mover.x
        local y=mover.y
        f:write(map[x][y], x, y, nil, {r=125,g=15,b=15,a=255})
    end--]]
end


function love.draw() f:draw() end
function calbak(x, y, val)
    map[x][y]=val==1 and '#' or '.'
    f:write(map[x][y], x, y)
end
function dijkCalbak(x,y) return map[x][y]=='.' end

rng=ROT.RNG.Twister:new()
rng:randomseed()
function getRandomColor()
    return { r=math.floor(rng:random(0,255)),
             g=math.floor(rng:random(0,255)),
             b=math.floor(rng:random(0,255)),
             a=255}
end
