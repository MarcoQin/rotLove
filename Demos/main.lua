--[[ Uncomment the Demo you'd like to run! ]]--

local demos={
    'event',
    'simple',
    'speed',
    'action',
    -- 'engine', --Busted at the moment, don't run
    -- 'stringGen', --Busted at the moment, don't run
    'rng',
    'display',
    'textDisplay',
    'arena',
    'dividedMaze',
    'iceyMaze',
    'ellerMaze',
    'cellular',
    'digger',
    'uniform',
    'rogue',
    'simplex',
    'precise',
    'preciseWithMovingPlayer',
    'bresenham',
    'dijkstraMap',
    'lighting',
}
math.randomseed(os.time())
require (demos[math.random(1,#demos)])
--require 'lighting'
