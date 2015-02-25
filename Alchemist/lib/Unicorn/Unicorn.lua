Unicorn = {
    version = 0.01,
    throttled = {},
}

function Unicorn.throttle(key, frequency)
    current_ms = GetFrameTimeMilliseconds() / 1000.0
    last_render_ms = Unicorn.throttled[key] or 0

    if current_ms > (last_render_ms + frequency) then
        Unicorn.throttled[key] = current_ms
        return false
    end

    return true
end
