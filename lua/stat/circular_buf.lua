ngx.header.content_type = "application/json"
local keys = {}
keys = ngx.shared.count:get_keys()
local max = table.getn(keys)
local str = ""
str = str .. "["
for key,value in pairs(keys) do
    if key == max then
        str = str .. value .. ngx.shared.count:get(value) .. '"}]'
    else
        str = str .. value .. ngx.shared.count:get(value) .. '"},'
    end
end

local json = require "libcjson"
local test = json.decode(str)
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      ngx.print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      ngx.print(formatting .. tostring(v))
    else
     ngx.print(formatting .. v)
    end
  end
end
local m_tbl = {}
function jmerge (tbl)
  local contains = false
  if table.getn(m_tbl) > 0 then 
    for key,v in pairs(m_tbl) do
      if v["host"] == tbl["host"] then
        contains = true
        contains_upstr = false
        for k, value in pairs(v["upstream_addr"]) do
          if (tbl["upstream_addr"]) == k  then 
            contains_upstr = true
            value[(tbl["status"])] = tbl["count"] -- "504" : "1"    "304":3
            local upstr =  v["upstream_addr"]--  "192.168.191.1" : "504" : "1"   
            upstr[k] = value -- "192.168.191.1" : "504" : "1"     "304":3 
            m_tbl[key] = {["host"] = tbl["host"],["upstream_addr"] = upstr}
            return 0
          end
        end
        if contains_upstr == false then
          local upstr =  v["upstream_addr"]  
          upstr[(tbl["upstream_addr"])] = {[(tbl["status"])] = tbl["count"]}
          m_tbl[key]  = {["host"] = tbl["host"],["upstream_addr"] = upstr}
          return 0
        end
      end
    end
  end
  if contains == false then
      local upstr = {}
      upstr[(tbl["upstream_addr"])] = {[(tbl["status"])] = tbl["count"]}
      local tmp = {["host"] = tbl["host"],["upstream_addr"] = upstr} 
      table.insert(m_tbl, tmp)
    end
end
if test == nil then
ngx.print("There is nothing...")
else
  for k,v in pairs(test) do
    jmerge(v)
  end
  ngx.print("[")
  for k,v in pairs(m_tbl) do
    local str =  json.encode(v)
    ngx.print(str)
  end
   ngx.print("]")
end

