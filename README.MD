# HW Scripts - Repairkit

**Description**
This is a repairkit script with ox_inventory support and okokNotify support

**Author**
- HW Development | HenkW

**Changelog:**
- Added lib locale to client and server
- Added locales to okokNotify exports
- Added locales/json with EN, DE, FR and NL as default
- Added a option in config.lua to change notify style
- Rewrote client.lua for more performance
- Rewrote server.lue for more performance

🛠 **Requirements**
- ESX Server
- okokNotify
- ox_inventory --> Only if Config.Inventory = ox_inventory

🌐 **Requirements Download links**
- okokNotify: [https://forum.cfx.re/t/okoknotify-standalone-paid/3907758]
- ox_inventory: [https://github.com/overextended/ox_inventory]

✅ **Features**
- Vehicle repairing

![default]

🔧 **Download & Installation**

Follow these steps to set up the repair script on your ESX server:

1. **Download the Files**: Download the script files from the provided source.

2. **Copy to Server Resource Directory**: Place the `hw_repairkit` folder in the server resource directory.

3. **Update `server.cfg`**: Add the following line to your `server.cfg` file:

    ```cfg
    start hw_repairkit
    ```

4. **Start Your Server**: Restart or start your ESX server to load the `hw_repairkit` resource.

Enjoy the script! <3
