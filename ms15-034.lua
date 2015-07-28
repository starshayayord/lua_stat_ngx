if ngx.var.http_range then
	local start, finish = string.match(ngx.var.http_range, "bytes=(%d+)-(%d+)")
	if start and finish then
		if tonumber(finish) > (tonumber(start) + 1073741824) then
			return ngx.exit(416)
		end
	end
end