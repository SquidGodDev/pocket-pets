
local pd <const> = playdate
local gfx <const> = pd.graphics

function IS_DAYTIME()
    return pd.getTime().hour >= 7 and pd.getTime().hour <= 18
    -- return true
end