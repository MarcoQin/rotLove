--[[ Rogue ]]
ROT=require 'vendor/rotLove/rotLove'

function love.load()
    f  =ROT.Display(80, 24)
    rog=ROT.Map.Rogue(f:getWidth(), f:getHeight())
    map={}
    for i=1,f:getWidth() do map[i]={} end
    rog:create(calbak)
    while true do
        local x=math.random(1,80)
        local y=math.random(1,24)

        if map[x][y]=='.' then
            write(x..','..y)
            dijkMap=ROT.DijkstraMap:new(x,y,f:getWidth(),f:getHeight(),dijkCalbak)
            break
        end
    end
    dijkMap:compute()
    dijkMap:iterateThroughMap(dispCalbak)
end
function love.draw() f:draw() end
function calbak(x, y, val) map[x][y]=val==1 and '#' or '.' end
function dijkCalbak(x,y) return map[x][y]=='.' end
function dispCalbak(x,y)
    val=dijkMap._map[x][y]<23 and dijkMap._map[x][y] or dijkMap._map[x][y]/23+64
    if val<1 then val=1 end
    val=val+64
    f:write(string.char(val),x,y)

end
