local log = require('log')
local fiber = require('fiber')

local function loop(cfg)
    while true do
        log.info(fiber.time())
        fiber.sleep(cfg.timeout)
    end
end

local function validate(cfg)
    if cfg.timeout then
        assert(type(cfg.timeout) == "number", "'timeout' should be a number")
        assert(cfg.timeout >= 5 * 60 and cfg.timeout <= 60 * 60 * 24, " valid between 1-65535")
    end
end

local function apply(cfg)
    fiber.create(loop,cfg)
end

return {
     validate = validate,
     apply = apply,
     stop = function() end,
}
