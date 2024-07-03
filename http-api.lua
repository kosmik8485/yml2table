local httpd                                                                                                                                                                                          [59/1864]
local json = require('json')
local log  = require('log')

local function validate(cfg)
    if cfg.host then
        assert(type(cfg.host) == "string", "'host' should be a string")
    end

    if cfg.port then
        assert(type(cfg.port) == "number", "'port' should be a number")
        assert(cfg.port >= 1 and cfg.port <= 65535, " valid between 1-65535")
    end
end

local function Resp(req,data)
    local resp = req:render({text=json.encode(data)})
    resp.headers['content-type'] = 'application/json'
    resp.status = 200
    return resp
end

local function apply(cfg)
    if httpd then
        httpd:stop()
    end
    httpd = require('http.server').new(cfg.host, cfg.port)
    local response_headers = { ['content-type'] = 'application/json' }
  
    httpd:route({path='/',method='GET'},function(req)        
        return Resp(req,{status='ok'})
    end)
  
    httpd:start()
end

local function stop()
    httpd:stop()
end
return {
    validate = validate,
    apply = apply,
    stop = stop,
}
