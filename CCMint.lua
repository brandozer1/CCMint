-- Setup peripherals
local monitor = peripheral.wrap("top")
local drive = peripheral.wrap("back")
monitor.setTextScale(0.5)

-- Load APIs
os.loadAPI("button.lua")
button.setMonitor(monitor)

-- Define global variables
local currentPage = "splash" -- Keep track of the current page

-- Function to create buttons
local function createButton(label, posx, posy, callback)
    local newButton = button.create(label)
    newButton.setPos(posx, posy)
    newButton.onClick(callback)
    newButton.setAlign("center")
    return newButton
end

-- Define page functions
local function splashPage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Please Insert")
    monitor.setCursorPos(1, 2)
    monitor.write("Your Card/Disk")
    currentPage = "splash"
end

local function homePage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    button.await(
        createButton("Insert Funds", 1, 2, function() print("Inserting Funds...") end),
        createButton("Withdraw Funds", 1, 4, function() currentPage = "withdraw" end),
        createButton("Check Balance", 1, 6, function() print("Checking Balance...") end)
    )
    currentPage = "home"
end

local function withdrawPage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Withdraw Page")
    -- Here you might want to create buttons specific to this page, etc.
    currentPage = "withdraw"
end

-- Function to handle button events
local function handleButtonEvent(x, y)
    -- This is a placeholder for the actual button check function you might have
    -- It will check if a button at (x, y) was pressed and then perform the callback
    button.checkButton(x, y)
    -- If currentPage was changed by a button, call the respective page function
    if currentPage == "withdraw" then
        withdrawPage()
    end
end

-- Initial page
if disk.isPresent("back") then
    homePage()
else
    splashPage()
end

-- Main event loop
while true do
    local event, side, x, y = os.pullEvent()
    
    if (event == "disk" or event == "disk_eject") and side == "back" then
        if disk.isPresent("back") then
            homePage()
        else
            splashPage()
        end
    elseif event == "monitor_touch" then
        handleButtonEvent(x, y)
    end
end
