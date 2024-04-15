-- Setup peripherals
local monitor = peripheral.wrap("top")
local drive = peripheral.wrap("back")
monitor.setTextScale(0.5)

-- Button definitions
local buttons = {}

-- Function to draw a button
function drawButton(id, text, x, y, width, height, textColor, bgColor)
    monitor.setBackgroundColor(bgColor)
    monitor.setTextColor(textColor)
    monitor.setCursorPos(x, y)
    for i = 1, height do
        if i == 1 or i == height then
            monitor.write(string.rep(" ", width))
        else
            monitor.write(" " .. text .. string.rep(" ", width - string.len(text) - 2) .. " ")
        end
        if i < height then
            monitor.setCursorPos(x, y + i)
        end
    end
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
    monitor.setCursorPos(1, 2)
    monitor.write("Please Insert")
    monitor.setCursorPos(2, 3)
    monitor.write("Card/Disk")
    -- Reset buttons
    buttons = {}
end

-- Function to display the home page
function homePage()
    monitor.clear()
    drawButton("withdraw", "WWithdraw Funds", 1, 1, 10, 3, colors.white, colors.blue)
    drawButton("deposit", "Deposit Funds", 1, 3, 10, 3, colors.white, colors.blue)
    drawButton("balance", "Check Balance", 1, 6, 10, 3, colors.white, colors.blue)
    -- Reset buttons not needed here since we redefine buttons in drawButton
end

-- Function to display the withdraw page
function withdrawPage()
    monitor.clear()
    monitor.setCursorPos(2, 2)
    monitor.write("Withdrawal Page")
    -- Example function, no buttons defined here for simplicity
    -- Add functionality as needed
end

-- Initial display
splashPage()

-- Event loop
while true do
    local event, side, x, y = os.pullEvent()
    if event == "disk" or event == "disk_eject" and side == "back" then
        if disk.isPresent("back") then
            homePage()
        else
            splashPage()
        end
    elseif event == "monitor_touch" then
        checkButtonPress(x, y)
    end
end
