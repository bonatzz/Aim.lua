local HookBypass = {}

function HookBypass:BypassMetamethods()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local old_index = mt.__index
    local old_newindex = mt.__newindex
    local old_call = mt.__call
    
    mt.__index = function(self, key)
        if type(key) == "string" and key:find("Script") then
            return nil
        end
        return old_index(self, key)
    end
    
    mt.__newindex = function(self, key, value)
        if type(key) == "string" and key:find("Debug") then
            return
        end
        return old_newindex(self, key, value)
    end
    
    setreadonly(mt, true)
end

function HookBypass:HideRemoteEvents()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    if player and player:FindFirstChild("PlayerGui") then
        local remotes = player:FindFirstChild("PlayerGui"):FindFirstChild("Remotes")
        if remotes then
            remotes.Parent = nil
        end
    end
end

function HookBypass:BlockDetectionCalls()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldNamecall = mt.__namecall
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = args[#args]
        
        local blocked = {"GetChildren", "FindFirstChild", "FindFirstChildOfClass", "GetDescendants"}
        
        for _, v in ipairs(blocked) do
            if method == v then
                if tostring(self):find("Script") then
                    return {}
                end
            end
        end
        
        return oldNamecall(self, ...)
    end
    
    setreadonly(mt, true)
end

return HookBypass
