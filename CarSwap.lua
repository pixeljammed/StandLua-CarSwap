--[[

        _          _  _                 
  _ __ (_)_  _____| |(_) __ _ _ __ ___  
 | '_ \| \ \/ / _ \ || |/ _` | '_ ` _ \ 
 | |_) | |>  <  __/ || | (_| | | | | | |
 | .__/|_/_/\_\___|_|/ |\__,_|_| |_| |_|
 |_|               |__/                 
                                CarSwap // v1.0

]]--

SCRIPT_NAME = "CarSwap"
VERSION = 1.0

-- CarSwap is a Lua script for the GTA Online Stand menu.
-- It allows use of "Custom DLC" cars as if they were normal (official) GTA online cars.
-- This includes things like driving them into your garage, saving and modding* them.
-- It works by reading from a .txt file, that contains the car to be swapped, and the custom dlc car you want you want.

-- Example: "reaper:aventador"
-- The above would be on one line in the carswap.txt, without the quotes.
-- This would swap the Pegassi Reaper with a Lamborghini Aventador addon mod.

-- Features:
----- Swap GTA cars with their real-world addon mods.
----- Save "Custom DLC" cars in GTAO.
----- Auto load "Custom DLCs".
----- *Save colour, tuning, etc as long as supported by replaced vehicle.
----- Hopefully doesn't blow up.


--[[ THE CODE LOL ]]--

local scriptsDir = filesystem.scripts_dir()

util.require_natives("3095a")
util.toast("Loaded " .. SCRIPT_NAME .. " v" .. VERSION)

local function enableDLCs()
    local command
    for DLC_name, _ in pairs(FILESYSTEM.GET_DIR_CONTENTS(scriptsDir .. "/DLC")) do
        print(DLC_name)
        local DLC_commandRef = menu.ref_by_path("Game>Custom DLCs>" .. DLC_name)
        menu.trigger_command(DLC_commandRef)
    end
end

local function replaceVehiclesWithModel(originalModel, replacementModel)
    -- Get model hashes
    local originalModelHash = MISC.GET_HASH_KEY(originalModel)
    local replacementModelHash = MISC.GET_HASH_KEY(replacementModel)

    -- Iterate through all existing vehicles
    for _, vehicle in ipairs(entities.get_all_vehicles_as_handles()) do
        -- Get the model hash of the current vehicle
        local vehicleModelHash = entities.get_model_hash(vehicle)

        -- Check if the model matches the original model
        if originalModelHash == vehicleModelHash then
            -- Get the coordinates of the vehicle
            local coords = ENTITY.GET_ENTITY_COORDS(vehicle, true)
            local heading = ENTITY.GET_ENTITY_HEADING(vehicle)

            -- Move the vehicle 10 meters below the map to avoid garage retardation
            local newCoords = v3.new(coords.x, coords.y, coords.z - 10)

            -- Teleport the vehicle to the new coordinates
            ENTITY.SET_ENTITY_COORDS(vehicle, newCoords.x, newCoords.y, newCoords.z, false, false, false, false)

            -- Load the replacement model
            STREAMING.REQUEST_MODEL(replacementModelHash)
            while not STREAMING.HAS_MODEL_LOADED(replacementModelHash) do
                util.yield()
            end

            -- Create a new vehicle with the replacement model at the same location
            local newVehicle = entities.create_vehicle(replacementModelHash, coords, heading)

            -- Set the model as no longer needed
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(replacementModelHash)
        end
    end
end


-- Load vehicle swap mappings from a configuration file
local function loadVehicleSwapConfig()
    local swapFile = scriptsDir .. "/lib/CarSwap/CarSwap.txt"
    local vehicleSwaps = {}

    local file = io.open(swapFile, "r")
    if not file then
        util.toast("Failed to open CarSwap.txt")
        return vehicleSwaps
    end

    for line in file:lines() do
        -- Split the line by ':' to separate original and swap cars
        local original, swap = line:match("^(.-):(.+)$")
        if original and swap then
            table.insert(vehicleSwaps, { original = original, swap = swap })
        else
            util.toast("Invalid line format: " .. line)
        end
    end

    file:close()

    return vehicleSwaps
end

util.create_tick_handler(function()
    local vehicleSwaps = loadVehicleSwapConfig()
    for _, swap in ipairs(vehicleSwaps) do
        replaceVehiclesWithModel(swap.original, swap.swap)
    end
    util.yield(30000) -- Wait for 30 second loop just to test rn ig
end)


