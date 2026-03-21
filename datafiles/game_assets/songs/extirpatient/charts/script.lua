local f = false
local q = false
local qe = false
local qt = false
local qtt = false
local aq = false
local ae = false

local b = false
local p = false
local g = false
local c = false
local d = false

local savedValOverlay = 167.5
local savedValBars = 210.5

function onCreatePost()
    if not modcharts then
        close()
        return
    end
end

local zoomEvent = {
    ['normal'] = function()
        setProperty('defaultCamZoom', 0.65)
        setProperty('opponentCameraOffset', {100,280})
        setProperty('cameraSpeed', 1.5)
        cameraSetTarget('dad')
        setProperty('isCameraOnForcedPos', true)
    end,
    ['sonic'] = function()
        setProperty('defaultCamZoom', 0.65)
        setProperty('opponentCameraOffset', {0,600})
        setProperty('cameraSpeed', 1.5)
        cameraSetTarget('dad')
        setProperty('isCameraOnForcedPos', true)
    end,
    ['reset'] = function()
        setProperty('defaultCamZoom', 0.34)
        setProperty('opponentCameraOffset', {300,480})
        setProperty('cameraSpeed', 1)
        setProperty('isCameraOnForcedPos', false)
    end
}

function onStepHit() 
    if curStep >= 5 and not qe then
        setProperty('subtitle.x', -1520)
        setProperty('subtitle.y', -25)
        qe = true
        if not isSideStory then
            setSubtitle("Hahahaha...","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 26 and not qt then
        qt = true
        if not isSideStory then
            setSubtitle("Well well, look at you.","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 48 and not qtt then
        qtt = true
        if not isSideStory then
            setSubtitle("Very interesting.","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 64 and not b then
        b = true
        if not isSideStory then
            setSubtitle(" ","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 3481 and not aq then
        aq = true
        if not isSideStory then
            setSubtitle("Results conclusive.","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 3494 and not ae then
        ae = true
        if not isSideStory then
            setSubtitle("Ta-ta!","pause.ttf", "0xFF010101", 120, 6, "0xFF001F")
        end
    end
    if curStep >= 2304 and not q then
        q = true
    
        startTween('adaqwewq', 'instance', {globalIconXController = 0}, 0.2, {ease = 'quadOut'})
		doTweenX('rightBarAlddddphaTwn', 'bar.overlay', savedValOverlay, 0.2, 'quadOut')
		doTweenX('rightBarAlddphaTwn', 'bar.rightBar', savedValBars, 0.2, 'quadOut')
		doTweenX('rightBarAlddadphaTwn', 'bar.leftBar', savedValBars, 0.2, 'quadOut')
    end
    if curStep >= 2420 and not p then
        p = true
        handleZoom('normal')
    end
    if curStep >= 2432 and not g then
        g = true
        handleZoom('reset')
    end
    
    if curStep >= 2612 and not c then
        c = true
        handleZoom('sonic')
    end
    if curStep >= 2624 and not d then
        d = true
        handleZoom('reset')
        cameraSetTarget('bf')
    end
    if curStep >= 3200 and not f then
        doTweenColor('DT', 'iconP2', '0xFFFFFFFF', 0, "circOut")
        doTweenColor('DDT', 'bar.leftBar', '0xFFFFFFFF', 0, "circOut")
        setProperty('health', 1)
        
        f = true
    end
end

function handleZoom(kind)
    zoomEvent[kind]()
    runHaxeCode('game.moveCameraSection(0);')
end