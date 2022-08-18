
local pd <const> = playdate
local gfx <const> = pd.graphics

function IS_DAYTIME()
    return CUR_TIME.hour >= 7 and CUR_TIME.hour <= 18
    -- return true
end