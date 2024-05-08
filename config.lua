Config = {}

--------------
-----UTILS----
--------------
Config.checkForUpdates = true -- Recommended to leave on 'true'
Config.Debug = true -- For debugging purposes

---------------
---INVENTORY---
---------------
Config.Inventory = 'ox_inventory' -- Options: 'normal', 'ox_inventory'
Config.ItemName = 'repairkit' -- Name of the item in the database

--------------
------JOB-----
--------------
Config.MechanicJob = "mechanic" -- The job name for mechanics
Config.RequiredMechanicsOnline = 2 -- Number of mechanics needed online to disable repair kit usage

--------------
----REPAIR----
--------------
Config.RepairTime = 15000 -- Time in milliseconds it takes to repair the vehicle

--------------
----NOTIFY----
--------------
Config.Notify = 'ox_lib' -- Use either 'okokNotify' or 'ox_lib' for the notifycation style