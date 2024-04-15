-- Setup peripherals
local monitor = peripheral.wrap("top")
local drive = peripheral.wrap("back")
monitor.setTextScale(0.5)

-- Button storage
local buttons = {}

-- Utility functions for buttons
local function createButton(label, x, y, width, height, callback)
    table.insert(buttons, {label = label, x = x, y = y, width = width, height = height, callback = callback})
end

local function drawButtons()
    for _, btn in pairs(buttons) do
        monitor.setCursorPos(btn.x, btn.y)
        monitor.write(btn.label)
    end
end

local function checkButtonClick(x, y)
    for _, btn in pairs(buttons) do
        if x >= btn.x and x <= (btn.x + btn.width - 1) and y >= btn.y and y <= (btn.y + btn.height - 1) then
            btn.callback()
            break
        end
    end
end

-- Page functions
local function splashPage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Please Insert Disk")
    buttons = {}
end

local function homePage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Home Page")
    buttons = {}
    createButton("Withdraw Funds", 2, 3, 14, 1, function()
        withdrawPage()
    end)
    drawButtons()
end

local function withdrawPage()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Withdraw Page")
    buttons = {}
    -- Add more functionality or buttons for withdraw page here
end

-- Main program
local function main()
    if disk.isPresent("back") then
        homePage()
    else
        splashPage()
    end

    while true do
        local event, side, x, y = os.pullEvent()
        
        if (event == "disk" or event == "disk_eject") and side == "back" then
            if disk.isPresent("back") then
                homePage()
            else
                splashPage()
            end
        elseif event == "monitor_touch" then
            checkButtonClick(x, y)
        end
    end
end

main()
