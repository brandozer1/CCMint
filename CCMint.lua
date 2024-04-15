-- Setup peripherals
local monitor = peripheral.wrap("top")
local drive = peripheral.wrap("back")
monitor.setTextScale(0.5)

local width, height = monitor.getSize()

-- Button definitions
local buttons = {}

-- Function to wrap and print text
function printText(x, y, text, limit)
    local function wrap(str, limit)
        limit = limit or width
        local lines = {}
        local line = ""
        for word in str:gmatch("%S+") do
            if #line + #word <= limit then
                line = line..word.." "
            else
                table.insert(lines, line)
                line = word .. " "
            end
        end
        table.insert(lines, line)
        return lines
    end

    local lines = wrap(text, limit)
    for i, line in ipairs(lines) do
        monitor.setCursorPos(x, y + (i - 1))
        monitor.write(line)
    end
end

-- Function to draw a button (simplified for demonstration)
function drawButton(id, text, x, y)
    local width = string.len(text) + 2  -- Simple calculation for button width
    printText(x, y, text, width)
    buttons[id] = {x = x, y = y, width = width, height = 1} -- Assuming single line buttons for simplicity
end

-- Function to check button press
function checkButtonPress(x, y)
    for id, button in pairs(buttons) do
        if x >= button.x and x <= button.x + button.width - 1 and y == button.y then
            if id == "withdraw" then
                withdrawPage()
            end
            -- Add more conditions for other buttons here
        end
    end
end

-- Page display functions
function splashPage()
    monitor.clear()
    printText(2, 2, "Please insert your disk into the drive.", width - 4)
    buttons = {}
end

function homePage()
    monitor.clear()
    drawButton("withdraw", "Withdraw Funds", 2, 4)
end

function withdrawPage()
    monitor.clear()
    printText(2, 2, "Welcome to the Withdrawal Page. Please follow the instructions.", width - 4)
end

-- Initial display
splashPage()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent()
    if (event == "disk" or event == "disk_eject") and side == "back" then
        if disk.isPresent("back") then
            homePage()
        else
            splashPage()
        end
    elseif event == "monitor_touch" then
        checkButtonPress(x, y)
    end
end
