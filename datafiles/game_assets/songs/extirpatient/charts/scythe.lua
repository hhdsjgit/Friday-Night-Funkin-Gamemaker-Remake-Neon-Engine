local draining = false
local active = false
local pushed = false
local active2 = false
local increase = 0
local isDownScroll = false
function onCreatePost()
    if not modcharts then
        close()
        return
    end
    isDownScroll = getPropertyFromGroup('strumLineNotes', 0, 'downScroll')
    makeLuaSprite('scythe', 'nightflaid/scythe', 0,((isDownScroll and -550) or 200))
    setObjectCamera('scythe', 'hud')
    addLuaSprite('scythe', true)
    setProperty('scythe.origin.y', getProperty('scythe.height'))
    scaleObject('scythe', 0.4,0.4, false)
    setProperty('scythe.flipX', not isDownScroll)
    setProperty('scythe.angle', ((isDownScroll and -105) or -90))
    setProperty('scythe.alpha', 0)
    startTween('woahColor', 'scythe.colorTransform', {redOffset = 255, greenOffset = -200, blueOffset = -200}, 1, {ease = 'quadOut'})

    makeLuaSprite('scythe2', 'nightflaid/scythe', 1600,(isDownScroll and 75) or -450)
    setObjectCamera('scythe2', 'hud')
    addLuaSprite('scythe2', true)
    setProperty('scythe2.origin.y', getProperty('scythe.height'))
    scaleObject('scythe2', 0.9,1.1, false)
    setProperty('scythe2.flipX', not isDownScroll)
    setProperty('scythe2.angle', -90)
end

function onUpdatePost(elasped)
    setProperty('scythe.x',getProperty('iconP1.x') -80)
    if draining then
        if getHealth() > 0.7 then addHealth(-elasped/5) end
        setProperty('scythe.colorTransform.redOffset', 70 + 50*math.sin(getSongPosition()/100))
        setProperty('scythe.offset.y', getRandomFloat(-1,1))
        setProperty('scythe.offset.x', getRandomFloat(-2,2))
    end
    if active2 then
        setProperty('scythe2.offset.x', 75*math.cos(getSongPosition()/500))
    end
    if toting then
        increase = increase + elasped * 7.5
        setProperty('scythe2.angle', increase*math.sin(getSongPosition()/1000 - increase*2))
        setProperty('scythe2.offset.y', - increase*math.sin(getSongPosition()/500 - increase*2))
    end
end
function clash()
    startTween('woah', 'scythe', {y = ((isDownScroll and -450) or 100), angle = ((isDownScroll and -105) or -75)}, 0.25, {ease = 'backInOut', onComplete = 'startDrain'})
end
function toggleSpin()
    toting = true
end
function startDrain()
    draining = true
end

function onBeatHit()
    if curBeat == 580 then
        active = true
    end
    if curBeat == 586 then
        active = false
        startTween('woosh', 'scythe2', {x = 1600}, 0.5, {ease = 'backOut'})
        startTween('woahColorer', 'scythe2.colorTransform', {redOffset = 200, greenOffset = -255, blueOffset = -255}, 0.5, {ease = 'quadOut'})
    end
    if active then
        pushed = not pushed
        if pushed then
            startTween('woosh', 'scythe2', {x = 1100}, 0.5, {ease = 'backOut'})
        else
            startTween('woosh', 'scythe2', {x = 1300}, 0.5, {ease = 'backOut'})  
        end
    end
    if curBeat == 594 then
        active2 = true
        setProperty('scythe2.angle', 0)
        setProperty('scythe2.x', 700)
        setProperty('scythe2.y', ((isDownScroll and -350) or 600))
        if isDownScroll then
            setProperty('scythe2.origin.y', 0)
            setProperty('scythe2.flipY', true)
        end
        scaleObject('scythe2', 0.8, 0.8, false)
        startTween('woosh', 'scythe2', {y = ((isDownScroll and -100) or 300)}, 1, {ease = 'backOut', onComplete = 'toggleSpin'})
        startTween('woahColorer', 'scythe2.colorTransform', {redOffset = 0, greenOffset = 0, blueOffset = 0}, 0.5, {ease = 'quadOut'})
    end
    if curBeat == 588 then
        startTween('woah', 'scythe', {y = ((isDownScroll and -475) or 75), angle = ((isDownScroll and -205) or 25), alpha = 1}, 1, {ease = 'quadOut', onComplete = 'clash'})
        startTween('woahColor', 'scythe.colorTransform', {redOffset = 0, greenOffset = 0, blueOffset = 0}, 1.5, {ease = 'quadOut'})
    end
    if curBeat == 606 then
        active2 = false
        toting = false
        startTween('woaher', 'scythe2', {y = ((isDownScroll and -150) or 400), alpha = -0.1}, 0.75, {ease = 'sineOut'})
        startTween('woahColorer', 'scythe2.colorTransform', {redOffset = 200, greenOffset = -255, blueOffset = -255}, 0.5, {ease = 'quadOut'})
        startTween('woah', 'scythe', {y = ((isDownScroll and -400) or 150), alpha = -0.1, angle = ((isDownScroll and -95) or -85), ['offset.x'] = -25}, 0.75, {ease = 'sineOut'})
        startTween('woahColor', 'scythe.colorTransform', {redOffset = 200, greenOffset = -255, blueOffset = -255}, 0.5, {ease = 'quadOut'})
        draining = false
    end
end

