-- UI lib
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Frutiger aero tycoon", "GrapeTheme")

local player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local char = player.Character or player.CharacterAdded:Wait()
local obbypos = workspace.Map.Obby.ObbyButton.Position

local AutoObby = false
local Autobuy = false
local AutoRebirth = false
local AutobuyDelay = 1
local antiAfkConnection
local RebirthEvent = game:GetService("ReplicatedStorage").RemoteEvents.BuyRebirth



local function get_player_tycoon(plr:Player)
    plr:WaitForChild("TempValues")
    if plr.TempValues.Plot.Value == nil or plr.TempValues.Plot.Value == 0 then
        for _, tycoon in ipairs(workspace.Plots:GetChildren()) do
            if tycoon:IsA("Model") then
                if tycoon.Claimed.Value == 'None' then 
                    char:SetPrimaryPartCFrame(CFrame.new(tycoon.Door.Claim.Position)) -- Teleports the player slightly above the button to avoid collision
                    task.wait(1)
                    return workspace.Plots[plr.TempValues.Plot.Value]
                end
            end
        end
    else
        return workspace.Plots[plr.TempValues.Plot.Value]
    end
    return nil
end




-- Rebirth Pricing
local v1 = {};
local Value = game:GetService("ReplicatedStorage"):WaitForChild("Game Settings"):WaitForChild("Balancing"):WaitForChild("RebirthPrice").Value;
local u2 = { { 100, 1.059560179277616, 5 }, { 200, 1.044864804052167, 6 }, { 300, 1.028073223830865, 7 }, { 500, 1.019863328401444, 8 }, { 750, 1.0162650893929948, 9 }, { 1000, 1.0092566057964651, 10 }, { 2500, 1.0050795579776497, 11 }, { 5000, 1.0036914240171697, 12 }, { 7500, 1.0029981454618282, 13 }, { 10000, 1.001, 14 } };

local function bracketFor(p3) -- Line: 28
    -- upvalues: u2 (copy)
    if p3 <= 1 then
        return 2, 1;
    end;

    if p3 < 5 then
        return 1.5, 2;
    end;

    if p3 < 30 then
        return 1.1721022973348, 3;
    end;

    if p3 < 100 then
        return 1.097498765493056, 4;
    end;

    local v4 = 1.097498765493056;
    local v5 = 4;

    for _, v in ipairs(u2) do
        if v[1] > p3 then
            break;
        end;

        v4 = v[2];
        v5 = v[3];
    end;

    return v4, v5;
end;

function v1.GetPrice(p6) -- Line: 45
    -- upvalues: bracketFor (copy), Value (copy)
    return Value * bracketFor(p6) ^ p6;
end

--print(v1.GetPrice(player.leaderstats.Rebirths.Value))
local tycoon = get_player_tycoon(player)

task.spawn(function()
    while task.wait(1) do
        if AutoRebirth == true then
            if player.leaderstats.Money.Value >= v1.GetPrice(player.leaderstats.Rebirths.Value) then
                RebirthEvent:FireServer()
            end
        end
    end
end)


-- Teleporting player to obby button
--char:SetPrimaryPartCFrame(CFrame.new(obbypos + Vector3.new(0, 5, 0))) 

--char:SetPrimaryPartCFrame(CFrame.new(tycoon.Door.Come.Position + Vector3.new(0, 5, 0))) 
--char:SetPrimaryPartCFrame(CFrame.new(obbypos + Vector3.new(0, 5, 0))) 

-- Auto-Obby

task.spawn(function()

    while task.wait(1) do
        if AutoObby == true then
            char:SetPrimaryPartCFrame(CFrame.new(obbypos + Vector3.new(0, 5, 0)))
            task.wait(3.5)
            char:SetPrimaryPartCFrame(CFrame.new(tycoon.Door.Come.Position + Vector3.new(0, 5, 0)))
            task.wait(60)
        end
    end
end)

task.spawn(function()

    while task.wait(AutobuyDelay) do
        if Autobuy == true then
            for i, button in ipairs(tycoon.Buttons:GetChildren()) do
                if button:IsA("Part") then
                    if button.Transparency == 0 then
                        local price = button:FindFirstChild("Price")
                        if price then
                            local priceValue = price.Value
                            if player.leaderstats.Money.Value >= priceValue then
                                char:SetPrimaryPartCFrame(CFrame.new(button.Position))
                            else

                            end
                        else

                        end

                    end
                end
            end
        end
    end

end)

-- UI
local Tab = Window:NewTab("Auto Farms")
local Section = Tab:NewSection("Auto")
Section:NewToggle("Auto Rebirth", "Automatically rebirths when you can afford it.", function(state)
    AutoRebirth = state
end)
Section:NewToggle("Auto Obby", "Automatically goes to the obby button.", function(state)
    AutoObby = state
end)
Section:NewToggle("Auto Buy", "Automatically buys items when you can afford them.", function(state)
    Autobuy = state
end)

local Section2 = Tab:NewSection("Auto Farm Settings")

Section2:NewSlider("Auto Buy Cooldown", "Seconds till new buy.", 3, 0.1, function(value)
    AutobuyDelay = value
end)

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Misc")

MiscSection:NewToggle("Anti AFK", "Prevents the player from being marked idle.", function(state)
    if state then
        if not antiAfkConnection then
            antiAfkConnection = player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end
    elseif antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end)

MiscSection:NewToggle("Disable 3D Rendering", "Turns 3D rendering off or on.", function(state)
    game:GetService("RunService"):Set3dRenderingEnabled(not state)
end)

MiscSection:NewButton("All Badges", "Gives you all badges", function()
    for _, badgeGiver in ipairs(workspace:GetDescendants()) do
        if badgeGiver.Name:match("^BadgeGiver%d+$") then
            task.wait(1)
            char:SetPrimaryPartCFrame(CFrame.new(badgeGiver.Position))
        end
    end

    char:SetPrimaryPartCFrame(CFrame.new(tycoon.Door.Come.Position + Vector3.new(0, 5, 0)))

end)