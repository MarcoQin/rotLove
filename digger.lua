--[[ Digger ]]
ROT=require 'vendor/rotLove/rotLove'

function love.load()
	f  =ROT.Display(100, 50)
    dgr=ROT.Map.Digger(f:getWidth(), f:getHeight(), {roomWidth={8, 10},nocorridorsmode=true, dugPercentage=0.3, timeLimit=500})
	-- dgr=ROT.Map.Dungeon(f:getWidth(), f:getHeight())
	map = dgr:create(calbak)
end
local world = {}
function drawRoom()
    for k, v in ipairs(map:getRooms()) do
        print(v:getLeft())
        print(v:getRight())
        print(v:getTop())
        print(v:getBottom())
        print(unpack(v:getCenter()))
        print("\n")
        world[tostring(k)] = {box = {x1=v:getLeft(), y1=v:getTop(), x2=v:getRight(), y2=v:getBottom()}, tiles={}, doors={}}
        v:create(world[tostring(k)], cbk)
        f:write(tostring(k), unpack(v:getCenter()))
    end
    for i, room in pairs(world) do
        for j, door in pairs(room.doors) do
            local x, y = door.x, door.y
            local tile = room.tiles[(x-1)..','..y]
            if tile and tile.type == "floor" then
                door.toward = "east"
                door.outOneStep = {x=x + 1, y=y}
            end

            if not door.toward then
                tile = room.tiles[(x+1)..','..y]
                if tile and tile.type == "floor" then
                    door.toward = "west"
                    door.outOneStep = {x=x - 1, y=y}
                end
            end

            if not door.toward then
                tile = room.tiles[x..','..(y-1)]
                if tile and tile.type == "floor" then
                    door.toward = "south"
                    door.outOneStep = {x=x, y=y + 1}
                end
            end

            if not door.toward then
                tile = room.tiles[x..','..(y+1)]
                if tile and tile.type == "floor" then
                    door.toward = "north"
                    door.outOneStep = {x=x, y=y - 1}
                end
            end

            for k, room1 in pairs(world) do
                if inBox(door.outOneStep.x, door.outOneStep.y, room1.box) then
                    door.to = tostring(k)
                    room.tiles[door.x..","..door.y].to = tostring(k)
                    break
                end
            end  -- for k, room1 in pairs(world) do
            -- f:write(door.to, x, y)
            -- print(door.to)
            print("room: "..tostring(i).." - door: "..tostring(j).." ----(to)--->".."room: "..door.to)
        end  -- for j, door in pairs(room.doors) do
    end --for i, room in pairs(world) do
end

function inBox(x, y, box)
    if x >= box.x1 and x <= box.x2 and y >= box.y1 and y <= box.y2 then
        return true
    end
    return false
end

function cbk(room, x, y, v)
    if v == "door" or v == 2 then
        room.tiles[x..','..y] = {type="door", to=nil}
        table.insert(room.doors, {x=x, y=y, type="door", to=nil})
        f:write('-', x, y)
    elseif v == "west" or v == 3 then
        room.tiles[x..','..y] = {type="wall", direction="west"}
        f:write("W", x, y)
    elseif v == "east" or v == 4 then
        room.tiles[x..','..y] = {type="wall", direction="east"}
        f:write("E", x, y)
    elseif v == "north" or v == 5 then
        room.tiles[x..','..y] = {type="wall", direction="north"}
        f:write("N", x, y)
    elseif v == "south" or v == 6 then
        room.tiles[x..','..y] = {type="wall", direction="south"}
        f:write("S", x, y)
    elseif v == "left-top-corner" or v == 7 then
        f:write('#', x, y)
        room.tiles[x..','..y] = {type="corner", direction="left-top"}
    elseif v == "left-down-corner" or v == 8  then
        f:write('#', x, y)
        room.tiles[x..','..y] = {type="corner", direction="left-down"}
    elseif v == "right-top-corner" or v == 9 then
        f:write('#', x, y)
        room.tiles[x..','..y] = {type="corner", direction="right-top"}
    elseif v == "right-down-corner" or v == 10 then
        f:write('#', x, y)
        room.tiles[x..','..y] = {type="corner", direction="right-down"}
    else
        room.tiles[x..','..y] = {type="floor"}
        f:write(' ', x, y)
    end
end

function love.draw() f:draw() end
-- function calbak(x, y, val) f:write(val==1 and '#' or '.', x, y) end
function calbak(x, y, val) 
    -- f:write(val==1 and '#' or '.', x, y) 
    f:write(' ', x, y)
end
local update=false
function love.update()
	if update then
        update=false
        map = dgr:create(calbak)
        drawRoom()
        -- dgr:create()
    end
end
function love.keypressed(key) update=true end
