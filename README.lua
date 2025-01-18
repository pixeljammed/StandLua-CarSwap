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
