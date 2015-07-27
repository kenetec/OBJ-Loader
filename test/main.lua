package.path = "./;" .. package.path;

local wavefront = require "OBJ"

local mesh = wavefront.load("test/cube.obj");

--[[
local output = io.open("test/output.txt", "w");
local tabs = 0;
local function recursePrint(t)
    local tab_buffer = '';
    
    for i = 0, tabs do
        tab_buffer = tab_buffer .. '\t';
    end
    
    for i, v in next, t do
        output:write(tab_buffer .. type(v) .. ' ' .. i .. (type(v) ~= "table" and ": " .. tostring(v) or "") .. '\n')
        if (type(v) == "table") then
            tabs = tabs+1;
            recursePrint(v)
        end
    end
    
    tabs = tabs - 1;
end

output:flush();

recursePrint(mesh);
--]]