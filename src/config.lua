
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = true

-- for module display FIXED_HEIGHT FIXED_WIDTH
CC_DESIGN_RESOLUTION = {
    width = 720,
    height = 1280,
    autoscale = "FIXED_WIDTH",
    callback = function(framesize)
        local ratio = framesize.height / framesize.width
        if ratio <= 1.78 then
            return {autoscale = "FIXED_HEIGHT"}
        end
    end
}
