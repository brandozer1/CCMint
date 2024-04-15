-- Setup peripherals
local drive = peripheral.wrap("back")
local monitor = peripheral.wrap("top")
monitor.setTextScale(0.5)

-- Load APIs and set up button library
os.loadAPI("button.lua")
button.setMonitor(monitor)

-- Track the current state
local lastDiskPresent = not disk.isPresent("back") -- Initialize to the opposite state to force update

-- Function to create buttons
local function createButton(label, posx, posy, callback)
    local newButton = button.create(label)
    newButton.setPos(posx, posy)
    newButton.onClick(callback) -- Pass callback correctly
    newButton.setAlign("center")
    return newButton
end

-- Define page functions
local function splashPage()
    monitor.clear() 
    monitor.setCursorPos(1,1)
    monitor.write("Please Insert")
    monitor.setCursorPos(1,2) 
    monitor.write("Your Card/Disk")
end

local function homePage()
    monitor.clear()
    monitor.setCursorPos(1,1)
    button.await(
        createButton("Insert Funds", 1, 2, function() print("Inserting Funds...") end),
        createButton("Withdraw Funds", 1, 4, function() currentPage = "withdraw" end),     
        createButton("Check Balance", 1, 6, function() print("Checking Balance...") end)
    )
end

-- Main loop to manage page transitions based on disk presence
while true do
    local diskPresent = disk.isPresent("back")
    -- Check if the disk presence state has changed
    if diskPresent ~= lastDiskPresent then
        if diskPresent then
            -- Disk has been inserted
            homePage()
        else
            -- Disk has been removed
            splashPage()
        end
        -- Update the last known disk presence state
        lastDiskPresent = diskPresent
    end
    sleep(0.1) -- Short delay to prevent overloading the CPU
end
