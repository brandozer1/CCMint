local drive = peripheral.wrap("back")

local monitor = peripheral.wrap("top")
monitor.setTextScale(.5)

local currentPage = "home"

os.loadAPI("button.lua")
button.setMonitor(monitor)

function createButton (label, posx, posy, cb)
    newButton = button.create(label)
    newButton.setPos(posx, posy)
    newButton.onClick(cb())
    newButton.setAlign("center")
    return newButton
end

function splashPage()
    monitor.clear() 
    monitor.setCursorPos(1,1)
    monitor.write("Please Insert")
    monitor.setCursorPos(1,2) 
    monitor.write("Your Card/Disk ")
end

function homePage()
    monitor.clear()
    monitor.setCursorPos(1,1)
    button.await(
        createButton("Insert Funds", 1,2,function() print("hello") end),
        createButton("Withdraw Funds", 1,4,function() currentPage = "withdraw" end),     
        createButton("Check Balance", 1,6, function() print("balance") end)
    ) 
        
end

function withdrawPage()
    monitor.clear()
    button.await(
        createButton("-1", 1,2, function() print("-1") end),
        createButton("+1", 1,6, function() print("+1") end) 
    )
end


while true do
    if disk.isPresent("back") then
        if currentPage == "home" then
            homePage()
        end
        if currentPage == "withdraw" then
            withdrawPage()
        end 

    else
        splashPage()
    end
    sleep(.1)
end




