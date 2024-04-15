-- Setup peripherals
local monitor = peripheral.wrap("top")
local drive = peripheral.wrap("back")
monitor.setTextScale(0.5)

local screenWidth, screenHeight = monitor.getSize()

-- Button definitions
local buttons = {}

-- Function to wrap and display text
function writeText(text, x, y, limit)
    local function wrap(str)
        local lines = {}
        local line = ""
        str:gsub("%s+", " "):gsub("%S+", function(word)
            if #line + #word <= limit then
                line = line .. word .. " "
            else
                table.insert(lines, line)
                line = word .. " "
            end
        end)
        table.insert(lines, line)
        return lines
    end

    local lines = wrap(text)
    for i, line in ipairs(lines) do
        monitor.setCursorPos(x, y + i - 1)
        monitor.write(line)
    end
end

-- Function to draw a button
function drawButton(id, text, x, y, width, height, textColor, bgColor)
    monitor.setBackgroundColor(bgColor)
    monitor.setTextColor(textColor)
    monitor.setCursorPos(x, y)
    for i = 1, height do
        monitor.write(string.rep(" ", width))
        if i < height then
            monitor.setCursorPos(x, y + i)
        end
    end
    -- Center the text within the button
    local centeredX = x + math.floor((width - string.len(text)) / 2)
    local centeredY = y + math.floor(height / 2)
    monitor.setCursorPos(centeredX, centeredY)
    monitor.write(text)
    
    buttons[id] = {x = x, y = y, width = width, height = height}
end

-- Function to check button press
function checkButtonPress(x, y)
    for id, button in pairs(buttons) do
        if x >= button.x and x <= button.x + button.width - 1 and y >= button.y and y <= button.y + button.height - 1 then
            if id == "withdraw" then
                withdrawPage()
            end
            -- Add more conditions for other buttons here
        end
    end
end

-- Function to display the splash page
function splashPage()
    monitor.clear()
    -- Using writeText for wrapping
    writeText("Please Insert Disk", 2, 2, screenWidth - 2)
    -- Reset buttons
    buttons = {}
end

-- Function to display the home page
function homePage()
    monitor.clear()
    drawButton("withdraw", "Withdraw Funds", 2, 4, 20, 3, colors.white, colors.blue)
    -- Reset buttons not needed here since we redefine buttons in drawButton
end

-- Function to display the withdraw page
function withdrawPage()
    monitor.clear()
    -- Using writeText for wrapping
    writeText("Withdrawal Page", 2, 2, screenWidth - 2)
    -- Example function, no buttons defined here for simplicity
    -- Add functionality as needed
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
