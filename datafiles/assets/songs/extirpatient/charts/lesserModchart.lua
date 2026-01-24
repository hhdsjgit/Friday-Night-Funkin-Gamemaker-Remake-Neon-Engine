local arrowVars = {index = 0, x = 0, y = 0, flip = false}
local negativity
function onCreate()
    setVar('easingValueX', 1)
	getVar('easingValueX')
	setVar('easingValueY', 1)
	getVar('easingValueY')
end
function onCreatePost()
    isDownScroll = getPropertyFromGroup('strumLineNotes', 0, 'downScroll')
    negativity = (isDownScroll and -1 or 1)
end

function createFunnyWarning(x, y, flipped)
    if not modcharts then return end
    arrowVars.x, arrowVars.y, arrowVars.flip = x, y, flipped
    if flipped then
        arrowVars.index = 2
    end
    createArrow(x,y,flipped)
    arrowVars.index = arrowVars.index + (arrowVars.flip and -1 or 1)
    runTimer('arrowSpawn', 0.125, 2)
end
function createArrow(x, y ,flipped)
    local var = 'warrow'..arrowVars.index
    makeLuaSprite(var, 'nightflaid/arrow', x + 135 * -arrowVars.index + (flipped and -40 or 40), y)
    setProperty(var..'.alpha', 0)
    scaleObject(var, 0.5,0.5)
    setProperty(var..'.flipX', flipped)
    setObjectCamera(var, 'hud')
    addLuaSprite(var)
    startTween('var'..arrowVars.index, var, {alpha = 1}, 0.225, {ease = 'quadOut', onComplete = 'handleArrow'})
    doTweenX('wa'..arrowVars.index, var, x + 135 * -arrowVars.index + (flipped and 60 or -60), 0.6, 'cubeOut')
end
function onTimerCompleted(tag)
    if tag == 'arrowSpawn' then
        createArrow(arrowVars.x,arrowVars.y,arrowVars.flip)
        arrowVars.index = arrowVars.index + (arrowVars.flip and -1 or 1)
    end
end

function handleArrow(tag, we)
    luaTrace(tag)
    startTween(tag, we, {alpha = 0,}, 0.175, { ease = 'quadIn', onComplete = 'delete'})
end
function delete(a, we)
    removeLuaSprite(we, true)
    arrowVars.index = 0
end

function onUpdate(elapsed)
    if songEnded or not modcharts then return end
    if curBeat >= 200 and curBeat < 250 or curBeat >= 368 and curBeat < 416 then
        local add = 20 * math.sin(getSongPosition()/500) * (1 - getVar('easingValueX'))
        for i = 0, 3 do
            setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i] + add)
            setPropertyFromGroup('strumLineNotes', i+4, 'x', _G['defaultPlayerStrumX'..i] + add)
        end
    end
    if curBeat >= 224 and curBeat < 250 or curBeat >= 392 and curBeat < 416 then
        local val = getVar('easingValueY') 
        for i = 0, 3 do
            setPropertyFromGroup('strumLineNotes', i, 'y', _G['defaultOpponentStrumY'..i] + 20 * math.cos(getSongPosition()/1000 + i) * (1 - val))
            setPropertyFromGroup('strumLineNotes', i+4, 'y', _G['defaultPlayerStrumY'..i] + 20 * math.cos(getSongPosition()/1000 + i+4) * (1 - val))
        end
    end
end
function onStepHit()
    if curStep % 2 == 0  and (curBeat >= 200 and curBeat < 224 or curBeat >= 368 and curBeat < 392) then
        doPulsePiano()
    end
end
function onBeatHit()
    if curBeat == 642 or curBeat == 650 then
        createFunnyWarning(getPropertyFromGroup('playerStrums', 3, 'x') , getPropertyFromGroup('playerStrums', 0, 'y') - 50 * negativity, false)
    elseif curBeat == 646 then
        createFunnyWarning(getPropertyFromGroup('playerStrums', 3, 'x') - 50, getPropertyFromGroup('playerStrums', 0, 'y') + 75 * negativity, true)
    end
    if curBeat == 200  or curBeat == 368 then
        easeValuer('easingValueX', 0, 1)
    end
    if curBeat == 224 or curBeat == 392 then
        easeValuer('easingValueY', 0, 0.75)
        setProperty('isCameraOnForcedPos', true)
        setProperty('camZoomingMult', 0)
        setProperty('camFollow.x', getMidpointX('boyfriend')-200)
        setProperty('camFollow.y', getMidpointY('boyfriend')-400)
    end
    if curBeat == 224 or curBeat == 227 or curBeat == 230 or curBeat == 233 or curBeat == 395 or curBeat == 398 or curBeat == 401  then
        setProperty('camFollow.x', getProperty('camFollow.x')+15)
        setProperty('camFollow.y', getProperty('camFollow.y')+15)
        local woah = getProperty('defaultCamZoom') + 0.02
        setProperty('defaultCamZoom', woah)
        doTweenZoom('camGame', 'camGame', woah, 0.5, 'cubeOut') 
    end
    if curBeat == 236 or curBeat == 404 then
        setProperty('camFollow.x', getProperty('camFollow.x')+15)
        setProperty('camFollow.y', getProperty('camFollow.y')+15)
        setProperty('cameraSpeed', 0.8)
        local woah = getProperty('defaultCamZoom') + 0.06
        setProperty('defaultCamZoom', woah)
        doTweenZoom('camGame', 'camGame', woah, crochet/1000 * 6, 'quadOut') 
    end
    if curBeat == 242 or curBeat == 410 then
        setProperty('camFollow.x', getProperty('camFollow.x')-50)
        setProperty('camFollow.y', getProperty('camFollow.y')-50)
        setProperty('cameraSpeed', 1)
        local woah = getProperty('defaultCamZoom') - 0.05
        setProperty('defaultCamZoom', woah)
        doTweenZoom('camGame', 'camGame', woah, crochet/1000 * 3, 'quadOut') 
    end
    if curBeat == 245 then
        easeValuer('easingValueX', 1, 2)
        easeValuer('easingValueY', 1, 2)
        setProperty('isCameraOnForcedPos', false)
        runHaxeCode('game.moveCameraSection(12);')
        setProperty('cameraSpeed', 0.8)
        setProperty('defaultCamZoom', 0.34)
        doTweenZoom('camGame', 'camGame', 0.34, crochet/332, 'quartIn')
    end
    if curBeat == 413 then
        easeValuer('easingValueX', 1, 2)
        easeValuer('easingValueY', 1, 2)
        setProperty('isCameraOnForcedPos', true)
        runHaxeCode('game.moveCameraSection(0);')
        setProperty('cameraSpeed', 1.2)
        setProperty('defaultCamZoom', 0.34)
        doTweenZoom('camGame', 'camGame', 0.34, crochet/332, 'quartIn')
    end
    if curBeat == 247 or curBeat == 415 then
        doTweenZoom('tem', 'camHUD', 1.1, crochet/1000, 'expoIn')
    end
    if curBeat == 248 then
        cancelTween('camGame')
        cancelTween('tem')
        setProperty('isCameraOnForcedPos', false)
        if flashingLights then
            customFlash('camGame', 'FF0000', 1, {ease = 'quadOut', alpha = 0.3})
        end
        triggerEvent('Add Camera Zoom', "0.1", "0.05")
        setProperty('cameraSpeed', 1)
        setProperty('camShakeStrength', 8)
    end
    if curBeat == 416 then
        cancelTween('camGame')
        cancelTween('tem')
        setProperty('isCameraOnForcedPos', false)
        runHaxeCode('game.moveCameraSection(0);')
        setProperty('cameraSpeed', 1)
        triggerEvent('Add Camera Zoom', "0.1", "0.06")
        setProperty('camShakeStrength', 6)
    end
    if curBeat == 798 then
        doTweenAlpha('white', 'whiteScreen', 1, crochet/500, 'quadIn')
    end
    if curBeat == 800 then
        doTweenAlpha('white', 'whiteScreen', 0, crochet/250, 'quadOut')
    end
end
local pulseNumber = 1
local pulseDir = 1

function doPulsePiano()
    if not modcharts then return end
    local bfValue = 9 - pulseNumber
    cancelTween('returner'..pulseNumber)
    setPropertyFromGroup('strumLineNotes', pulseNumber - 1, 'scale.x', 0.8)
    setPropertyFromGroup('strumLineNotes', pulseNumber - 1, 'scale.y', 0.8)
    setPropertyFromGroup('strumLineNotes', pulseNumber - 1, 'y', defaultOpponentStrumY0 -10)
    startTween('returner'..pulseNumber, 'strumLineNotes.members['..(pulseNumber - 1)..']', {['scale.x'] = 0.695, ['scale.y']  = 0.695, y = (defaultOpponentStrumY0)}, crochet/1000, {ease = 'quadOut'})
    cancelTween('returner'..bfValue)
    setPropertyFromGroup('strumLineNotes', bfValue - 1, 'scale.x', 0.8)
    setPropertyFromGroup('strumLineNotes', bfValue - 1, 'scale.y', 0.8)
    setPropertyFromGroup('strumLineNotes', bfValue - 1, 'y', defaultPlayerStrumY0 - 10)
    startTween('returner'..bfValue, 'strumLineNotes.members['..(bfValue - 1)..']', {['scale.x'] = 0.695, ['scale.y']  = 0.695, y = (defaultPlayerStrumY0)}, crochet/1000, {ease = 'quadOut'})

    pulseNumber = pulseNumber + pulseDir
    if pulseNumber == 4 then
        pulseDir = -1
    elseif pulseNumber == 1 then
        pulseDir = 1
    end
end


function easeValuer(name, amount, time)
    runHaxeCode([[
        FlxTween.num(getVar(']]..name..[['),]]..amount..[[,]]..time..[[ ,{ease: FlxEase.quadOut}, function(num) {setVar(']]..name..[[',num); });
    ]])
end