-- Setup peripherals
local drive = peripheral.wrap("back")
local monitor = peripheral.wrap("top")
monitor.setTextScale(0.5)

-- Load APIs and set up button library
os.loadAPI("button.lua")
button.setMonitor(monitor)

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

local function waitForDiskEvent()
    while true do
        local event, side = os.pullEvent()
        if (event == "disk" or event == "disk_eject") and side == "back" then
            return disk.isPresent(side)
        end
    end
end

-- Initial page based on current disk state
if disk.isPresent("back") then
    homePage()
else
    splashPage()
end

-- Event-driven loop to manage page transitions based on disk presence
while true do
    local diskPresent = waitForDiskEvent()
    if diskPresent then
        homePage()
    else
        splashPage()
    end
end