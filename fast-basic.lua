function string.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02x', string.byte(c))
    end))
end

if ngx.var.http_authorization then
 local m = ngx.re.match(ngx.var.http_authorization, 'Basic\\s(.+)')
 if m and table.maxn(m) == 1 then
    if ngx.shared.a:get(m[1]) then
        return
    end
    local userpass = ngx.decode_base64(m[1])
    if userpass then
        local u = ngx.re.match( userpass, '(.+):(.+)'  )
        if u and table.maxn(u) == 2 then
            local s1 = ngx.shared.sha1:get(u[1])
            if s1 then
                if s1 == ngx.sha1_bin(u[2]):tohex() then
                    ngx.shared.a:add(m[1], 1)
                    return
                end
            end
        end
    end
 end
end

ngx.header['WWW-Authenticate'] = 'Basic realm="skbkontur"'
ngx.exit(ngx.HTTP_UNAUTHORIZED)