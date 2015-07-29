* change libcjson.lua  
```
local cjson = ffi_load("/opt/nginx/libcjson.so") 
```
to your path

* http {...}
```
init_by_lua_file 'init.lua';
lua_package_path '/opt/nginx/?.lua';
lua_shared_dict sha1 10M;
lua_shared_dict a 10M;
lua_shared_dict count 10M;
access_by_lua_file 'ms15-034.lua';
lua_code_cache on;
```

* monitoring location:
```
access_by_lua_file 'fast-basic.lua';
```

* statistics report location:
```
content_by_lua_file 'lua/stat/circular_buf.lua';
access_by_lua_file 'fast-basic.lua';
proxy_set_header Authorization "";
```
*P.S.: json lua module: https://github.com/bungle/lua-resty-libcjson
