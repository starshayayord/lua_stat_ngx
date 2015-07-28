function string:split(sep)
        local sep, fields = sep or ", ", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end
local uptable = ngx.var.upstream_addr:split()
--[[processing last upstream ]]
local up_key = string.format('{"host":"%s","upstream_addr":"%s","status":"%s","count":"',ngx.var.http_host,uptable[table.getn(uptable)],ngx.var.status)
--ngx.shared.tempd:add(upkey,1)
local var,err = ngx.shared.count:incr(up_key,1)
if var == nil and err == "not found" and not (uptable[table.getn(uptable)] == nil) then
	ngx.shared.count:add(up_key,1)
end
table.remove(uptable)
--[[processing previous fail upstreams]]
for key, value in pairs(uptable) do
	local upkey =  string.format('{"host":"%s","upstream_addr":"%s","status":"fail","count":"', ngx.var.http_host, value)
	local var,err = ngx.shared.count:incr(upkey,1)
	if var == nil and err == "not found" and not (value  == nil) then
        	ngx.shared.count:add(upkey,1)
	end
end

