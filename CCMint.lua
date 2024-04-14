-- Setup peripherals
local drive = peripheral.wrap("back")
local monitor = peripheral.wrap("top")
monitor.setTextScale(0.5)

-- Load APIs and set up button library
os.loadAPI("button.lua")
button.setMonitor(monitor)

-- Track the current page
local currentPage = "home"

-- Function to create buttons
local function createButton(label, posx, posy, callback)
    local newButton = button.create(label)
    newButton.setPos(posx, posy)
    newButton.onClick(callback) -- Pass the callback function without invoking it
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

local function withdrawPage()
    monitor.clear()
    button.await(
        createButton("-1", 1, 2, function() print("-1") end),
        createButton("+1", 1, 6, function() print("+1") end) 
    )
end

-- Main loop to manage page transitions
while true do
    if disk.isPresent("back") then
        if currentPage == "home" then
            homePage()
        elseif currentPage == "withdraw" then
            withdrawPage()
        end
    else
        if currentPage ~= "splash" then
            splashPage()
            currentPage = "splash" -- Prevent re-running splashPage
        end
    end
    sleep(0.1) -- Short delay to prevent overloading the CPU
end
