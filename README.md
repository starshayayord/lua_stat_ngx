1. change libcjson.lua
  local cjson = ffi_load("/opt/nginx/libcjson.so")
to your path
2. lua_shared_dict count 10M;   http {...}
3. access_by_lua_file 'ms15-034.lua'; http {...}
4. lua_package_path '/opt/nginx/?.lua'; http {...}
5.  init_by_lua_file 'init.lua'; http {...}
6. log_by_lua_file 'lua/stat/circular_log.lua'; anywhere  u want to monitor {...}
7. content_by_lua_file 'lua/stat/circular_buf.lua'; anywhere location  u want to get statictic {...}

