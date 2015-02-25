TeleUnicorn = {
    version = 0.02,
    throttled = {},
}

function TeleUnicorn.throttle(key, frequency)
    current_ms = GetFrameTimeMilliseconds() / 1000.0
    last_render_ms = TeleUnicorn.throttled[key] or 0

    if current_ms > (last_render_ms + frequency) then
        TeleUnicorn.throttled[key] = current_ms
        return false
    end

    return true
end
