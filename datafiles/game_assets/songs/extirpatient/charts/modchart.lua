local toggledShove = false
local isDownScroll = false
local trulyBeats = 0
local flashyBits = {79, 143, 171, 199, 279, 311, 339, 367}
local testValue = -0.25
local toggledToll = false
local shakeTime = 0
local negativity = 1
function onCreatePost()
    setProperty('camZoomingMult', 0)
    setProperty('camZoomingDecay', 1.5)
    setProperty('gameZoomingDecay', 1.5)
    isDownScroll = getPropertyFromGroup('strumLineNotes', 0, 'downScroll')
    negativity = (isDownScroll and -1 or 1)
    if getSongPosition() < 0 then
        setHudVisible(false)
        setProperty('camZooming', false)
        setProperty('camGame.zoom', 0.65)
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'y', getPropertyFromGroup('strumLineNotes', i, 'y') + 200 * ((isDownScroll and 1) or -1))
        end
    end
    runHaxeCode([[
        function charactersCamera(visible: Bool)
            {
                camCharacters.visible = visible;
                }
            ]])

    if not modcharts then return end
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        local strumTime = getPropertyFromGroup('unspawnNotes', i, 'strumTime')
        if (strumTime >= 300967 and strumTime < 301693) or (strumTime >= 303991 and strumTime < 305866) then
            if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
                setPropertyFromGroup('unspawnNotes', i, 'flipY', not isDownScroll)
                setPropertyFromGroup('unspawnNotes', i, 'correctionOffset', (isDownScroll and 0) or 53)
                setPropertyFromGroup('unspawnNotes', i, 'isReversingScroll', true)
            end
        end
        if (strumTime >= 317300 and strumTime < 340500) then
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'colorTransform.redOffset', -50)
                setPropertyFromGroup('unspawnNotes', i, 'colorTransform.greenOffset', -100)
                setPropertyFromGroup('unspawnNotes', i, 'colorTransform.blueOffset', -100)
            end
        end
        if (strumTime > 340500 and strumTime < 350500) then
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'visible', false)
            end
        end
    end
end

function onSongStart()
    if getSongPosition() <  100 then
        setProperty('isCameraOnForcedPos', true)
        setProperty('camFollow.x', getMidpointX('dad')+300)
        setProperty('camFollow.y', getMidpointY('dad')+300)
        setProperty('camFollowPos.x', getMidpointX('dad')+300)
        setProperty('camFollowPos.y', getMidpointY('dad')+300)
    end
end

local songEnded = false
function onEndSong()
	songEnded = true
end

local redObjects = {
    'bar.leftBar', 'bar.rightBar', 'bar.overlay', 'iconP1', 'iconP2', 'botplayTxt', 'scoreTxt', 'songTimeLeft', 'missAccTxt'
}
function onBeatHit()
    trulyBeats = trulyBeats + 1
    if curBeat == 144 or curBeat == 172 or curBeat == 312 or curBeat == 340 or curBeat == 368 then
        trulyBeats = curBeat
    end
    if curBeat >= 16 and curBeat < 864 then
        if curBeat >= 16 and curBeat < 864 then
            commitABeat(trulyBeats)
        elseif curBeat >= 144 and curBeat < 172 or curBeat >= 312 and curBeat < 368 then
            commitABeat(curBeats)
        end
    end
    for _, v in ipairs(flashyBits) do
        if curBeat == v then
            setProperty('camHUD.zoom', 1)
            setProperty('camGame.zoom', 0.34)
            doTweenZoom('tem', 'camHUD', 1.08, crochet/1000, 'expoIn')
            doTweenZoom('camGame', 'camGame', 0.36, crochet/1000, 'expoIn')
            luaTrace('FUCKKKKKKKKKKKKKK')
        end
        if curBeat == v + 1 then
            luaTrace('DRAAAAAGOOOOOOOON')
            cancelTween('tem')
            cancelTween('camGame')
            triggerEvent('Add Camera Zoom', "0.025", "0.025")
            if flashingLights then
                customFlash('camGame', 'FF0000', 1, {ease = 'quadOut', alpha = 0.3})
            end
            setProperty('camShakeStrength', 5)
        end
    end
    if curBeat == 1 then
        setProperty('camGame.visible', true)
        runHaxeCode("camCharacters.visible = true;")
        doTweenZoom('camGame', 'camGame', 0.55, 1, 'expoOut') 
    end
    if curBeat == 6 then
        setProperty('cameraSpeed', 0.75)
        setProperty('camFollow.x', getMidpointX('dad')+650)
        setProperty('camFollow.y', getMidpointY('dad')+450)
        doTweenZoom('camGame', 'camGame', 0.5, crochet/250, 'sineOut')
    end
    if curBeat == 12 then
		runHaxeCode('game.moveCameraSection(0);')
        setProperty('cameraSpeed', 0.25)
        setProperty('isCameraOnForcedPos', false)
        doTweenZoom('camGame', 'camGame', 0.34, crochet/250, 'quartIn')
        for i = 0, 3 do
            runTimer('fuckYou'..i, 0.4*i)
        end
    end
    if curBeat == 15 then
        doTweenZoom('tem', 'camHUD', 1.1, crochet/1000, 'expoIn')
    end
    if curBeat == 16 then
        cancelTween('camGame')
        cancelTween('tem')
        setProperty('camZooming', true)
        triggerEvent('Add Camera Zoom', "0.05", "0.05")
        if flashingLights then
            customFlash('camGame', 'FF0000', 1, {ease = 'quadOut', alpha = 0.5})
        end
        setHudVisible(true)
        setProperty('cameraSpeed', 1)
        setProperty('camShakeStrength', 7)
    end
    if curBeat == 448 then
        setProperty('camShakeSpeed', 0)
        setProperty('camShakeStrength', 2.5)
    end
    if curBeat == 607 and modcharts then --flip for shaggy
        moveHUD(not isDownScroll)
        for i = 0, 3 do
            noteTweenY('daddy'..i, i, defaultOpponentStrumY0 + 525 * ((isDownScroll and -1) or 1), crochet/500, 'expoInOut')
            noteTweenY('bf'..i, i+4, defaultPlayerStrumY0 + 525 * ((isDownScroll and -1) or 1), crochet/500, 'expoInOut')
        end
        triggerEvent('Change Scroll Speed', '0.05', tostring(crochet/1000 * 0.99))
        for _,obj in ipairs(redObjects) do
            startTween('redding'..obj, obj..'.colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 100, alphaOffset = -200}, crochet/1000, 'quadIn')
        end
    end
    if curBeat == 608 and modcharts then --flip for shaggy
        if enabledUnderlay then
            setProperty('playerUnderlayGradient.flipY', not getProperty('playerUnderlayGradient.flipY'))
        end
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'downScroll', not isDownScroll)
        end
        triggerEvent('Change Scroll Speed', '1', tostring(crochet/1000 * 0.99))
        for _,obj in ipairs(redObjects) do
            startTween('redding'..obj, obj..'.colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0, alphaOffset = 0}, crochet/1000, 'quadOut')
        end
    end
    if curBeat == 639 and modcharts then --unflip for shaggy
        moveHUD(isDownScroll)
        for i = 0, 3 do
            noteTweenY('daddy'..i, i, defaultOpponentStrumY0 + (90 + 80 * 0.708) * negativity, crochet/500, 'expoInOut')
            noteTweenY('bf'..i, i+4, defaultPlayerStrumY0 + (90 - 80 * 0.708) * negativity, crochet/500, 'expoInOut')
        end
        triggerEvent('Change Scroll Speed', '0.05', tostring(crochet/1000 * 0.99))
        for _,obj in ipairs(redObjects) do
            startTween('redding'..obj, obj..'.colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 100, alphaOffset = -225}, crochet/1000, 'cubeIn')
        end
    end
    if curBeat == 640 and modcharts then --unflip for shaggy
        if enabledUnderlay then
            setProperty('playerUnderlayGradient.flipY', not getProperty('playerUnderlayGradient.flipY'))
        end
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'downScroll', isDownScroll)
        end
        triggerEvent('Change Scroll Speed', '1', tostring(crochet/1000 * 0.99))
        for _,obj in ipairs(redObjects) do
            startTween('redding'..obj, obj..'.colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0, alphaOffset = 0}, crochet/1000, 'expoOut')
        end
    end
    if curBeat == 512 and modcharts then
        for i = 0, 3 do
            startTween('moveNote'..i, 'strumLineNotes.members['..i..']', {x = _G['defaultOpponentStrumX'..i], y = _G['defaultOpponentStrumY'..i], angle = 0}, crochet/1000, {ease = 'cubeOut'})
            startTween('moveNoteBF'..i, 'strumLineNotes.members['..(i+4)..']', {x = _G['defaultPlayerStrumX'..i], y = _G['defaultPlayerStrumY'..i], angle = 0}, crochet/1000, {ease = 'cubeOut'})
        end
    end
    if curBeat == 543 and modcharts then
        toggledShove = true
        local offset = 85
        for we = 0, 3 do
            noteTweenX('move'..we, we+4, getPropertyFromGroup('playerStrums', we, 'x') - offset, crochet/1000, 'backIn')
            noteTweenX('grove'..we, we, getPropertyFromGroup('opponentStrums', we, 'x') + offset, crochet/1000, 'backIn')
        end
    end
    handleSwap()
end
function onStepHit()
    if curStep == 50 or curStep == 53 or curStep == 56 or 
        curStep == 306 or curStep == 309 or curStep == 312 or 
        curStep == 562 or curStep == 565 or curStep == 568 or 
        curStep == 980 or curStep == 984 or
        curStep == 1652 or curStep == 1656 or
        curStep == 3442 or curStep == 3445 or curStep == 3448 then
        redPulse()
    end
end

function handleSwap()
    if not modcharts then return end
    if curBeat == 643 or curBeat == 651 then
        for i = 0, 3 do
            noteTweenX('moveDad'..i, i, _G['defaultOpponentStrumX'..i]+312*2, crochet/450, 'quadInOut')
            noteTweenX('moveBF'..i, i+4, _G['defaultPlayerStrumX'..i]-312*2, crochet/450, 'quadInOut')
        end
    end
    if curBeat == 647 then
        for i = 0, 3 do
            noteTweenX('moveDad'..i, i, _G['defaultOpponentStrumX'..i], crochet/450, 'quadInOut')
            noteTweenX('moveBF'..i, i+4, _G['defaultPlayerStrumX'..i], crochet/450, 'quadInOut')
        end
    end
end
function smallShift()
    if not modcharts then return end
    for i = 0, 3 do
        startTween('dad'..i, 'strumLineNotes.members['..i..']', {x = (getPropertyFromGroup('opponentStrums', i, 'x') - ((notesSkins and 320 or 300))/4), y = getPropertyFromGroup('opponentStrums', i, 'y') + 80/4 * negativity, alpha = getPropertyFromGroup('opponentStrums', i, 'alpha')-0.165}, 0.1, {ease = 'backOut'})
        startTween('bf'..i, 'strumLineNotes.members['..(i+4)..']', {x = (getPropertyFromGroup('playerStrums', i, 'x') + (412/4)), y = getPropertyFromGroup('playerStrums', i, 'y') - 80/4 * negativity}, 0.1, {ease = 'backOut'})
    end
end
function bfHeys(Val)
    if not modcharts then return end
    if Val == "0" then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') + 50 * negativity)
            noteTweenY('boyfriendSkippable'..i, i + 4,  getPropertyFromGroup('playerStrums', i, 'y') - 50 * negativity, crochet/2005, 'quadOut')
            noteTweenY('dadSkippable'..i, i,  getPropertyFromGroup('opponentStrums', i, 'y') + 250 * negativity, crochet/1500, 'backOut')
            setPropertyFromGroup('opponentStrums', i, 'alpha', 0.4)
        end
    end
    if Val == "1" then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('playerStrums', i, 'x') + 32)
            noteTweenX('boyfriendSkippable'..i, i + 4,  getPropertyFromGroup('playerStrums', i, 'x') - 32, crochet/2005, 'quadOut')
        end
    end
    if Val == "2" then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') - 16)
            noteTweenY('boyfriendSkippable'..i, i + 4,  getPropertyFromGroup('playerStrums', i, 'y') + 16, crochet/2005, 'cubeOut')
            noteTweenY('dadSkippable'..i, i,  getPropertyFromGroup('opponentStrums', i, 'y') - 250 * negativity, crochet/1000, 'expoIn')
        end
    end
    if Val == "3" then
        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'y', getPropertyFromGroup('playerStrums', i, 'y') - 16)
            noteTweenY('boyfriendSkippable'..i, i + 4,  getPropertyFromGroup('playerStrums', i, 'y') + 16, crochet/2005, 'cubeOut')
        end
    end
end
function opponentNoteHit()
    if curBeat >= 544 and curBeat < 576 and getPropertyFromGroup('strumLineNotes', 3, 'x') < 850 then
        shoveNotes(17.5)
    end
    if curBeat >= 480 and curBeat < 512 then
        addShake(2.75)
    end
    if curBeat >= 479 and curBeat < 496 and modcharts then
        for i = 0, 3 do
            startTween('moveNote'..i, 'strumLineNotes.members['..(i)..']', {x = _G['defaultOpponentStrumX'..i] + getRandomInt(-8, 8), y = _G['defaultOpponentStrumY'..i] + getRandomInt(-8, 8), angle = getRandomInt(-5, 5)}, 0.1, {ease = 'elasticOut'})
            startTween('moveNoteBF'..i, 'strumLineNotes.members['..(i+4)..']', {x = _G['defaultPlayerStrumX'..i] + getRandomFloat(-15, 15), y = _G['defaultPlayerStrumY'..i] + getRandomFloat(-15, 15), angle = getRandomInt(-12, 12)}, 0.1, {ease = 'elasticOut'})
        end
    end
end
function goodNoteHit()
    if curBeat >= 544 and curBeat < 576 and getPropertyFromGroup('strumLineNotes', 0, 'x') > 50 then
        shoveNotes(-12.5)
    end
end
function shakeNotes()
    if not modcharts then return end
    local x = getRandomFloat(-5,5)
    local y = getRandomFloat(-5,5)
    for i = 0, 3 do
        setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i] + x)
        setPropertyFromGroup('strumLineNotes', i, 'y', _G['defaultOpponentStrumY'..i] + y)
        setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + x*-0.5)
        setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + y*-0.5)
    end
end
function shoveNotes(amount)
    if not modcharts then return end
    if not toggledShove then return end
    for we = 0, 3 do
        local progress = math.min(1 - ((getPropertyFromGroup('strumLineNotes', 4, 'x') - 850) / (1400 - 850)), 1)
        local preg = math.min(1 - ((getPropertyFromGroup('strumLineNotes', we+4, 'x') - 850) / (1400 - 850)), 1)
        startTween('moveNote'..we, 'strumLineNotes.members['..(we)..']', {x = getPropertyFromGroup('strumLineNotes', we, 'x') + amount * progress}, 0.2, {ease = 'backOut'})
        startTween('moveNoteW'..we, 'strumLineNotes.members['..(we+4)..']', {x = getPropertyFromGroup('strumLineNotes', we+4, 'x') + amount * preg}, 0.2, {ease = 'backOut'})
    end
end
function onUpdatePost(elapsed)
    local stren = getProperty('camShakeStrength')
    if stren > 1 then
        runHaxeCode("camCharacters.shake("..stren.." * 0.0015, 0.05);")
    end
    if curBeat >= 704 and curBeat < 736 then
        runHaxeCode("camVideo.zoom = 1 + (game.camHUD.zoom - 1) * 2;")
    end
    if not modcharts then return end
    if songEnded then return end
    if curBeat >= 641 and curBeat < 654 or curBeat  >= 656 and getSongPosition() < 324188 then         
        local beat = (getSongPosition() / crochet)
        offset = math.cos(beat * math.pi / 4)
        local beat2 = ((getSongPosition() + crochet * 2) / crochet)
        local offset2 = math.sin(beat2 * math.pi / 3.5)

        for i = 0, 3 do
            setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + (90 - 80 * offset) * negativity)
            setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] + (90 + 80 * offset) * negativity)
            if curBeat  >= 656 and curBeat < 670 then
                setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 320 + 100 * offset)
                setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + (306) + 100 * offset2)
            end
        end
    end

    if curBeat >= 448 and curBeat < 480 then
        shakeTime = shakeTime + elapsed
        if shakeTime > elapsed * 6 then
            shakeNotes()
            shakeTime = 0
        end
    end
    if toggledToll and curBeat < 700 then
        local addition = elapsed / (mustHitSection and -1.5 or 1.5)
        testValue = math.max(testValue + addition, -0.25)
    else
        testValue = math.max(testValue - elapsed * 1.5, -0.25)
    end
    if toggledToll then
        for i = 0, 3 do
            local val, val2
            val = _G['defaultOpponentStrumX'..i] + 300 + 2.5*i
            val2 = val + 60
            setPropertyFromGroup('strumLineNotes', i, 'x', (val) + math.min(testValue*10 + 3, 13) * math.sin(getSongPosition()/100))
            setPropertyFromGroup('strumLineNotes', i+4, 'x', (val2)  - math.min(testValue*8 + 2, 10) * math.sin(getSongPosition()/(79)))
            setPropertyFromGroup('strumLineNotes', i+4, 'alpha', (1 - math.min(testValue/2, 0.3)) + 0.1 *math.cos(getSongPosition()/69))
            setPropertyFromGroup('strumLineNotes', i, 'alpha', math.min(testValue/2 + 0.15, 0.7) - 0.1 * math.sin(getSongPosition()/42))
        end
    end
    runHaxeFunction('charactersCamera', {getProperty('camGame.visible')})
end

function dadBatNote(val)
    if not modcharts then return end
    if val == '0' then
        for i = 0 , 3 do
            startTween('bfHide'..i, 'strumLineNotes.members['..(i+4)..']', {y = _G['defaultPlayerStrumY'..i] + 100, alpha = 0}, crochet/1000, {ease = 'backIn'})
            startTween('bfColor'..i, 'strumLineNotes.members['..(i+4)..'].colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 100}, crochet/1000, {ease = 'cubeIn'})
        end
    elseif val == '1' then
        for i = 0 , 3 do
            startTween('bfHide'..i, 'strumLineNotes.members['..(i+4)..']', {y = _G['defaultPlayerStrumY'..i], alpha = 1}, crochet/1000, {ease = 'cubeOut'})
            startTween('bfColor'..i, 'strumLineNotes.members['..(i+4)..'].colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0}, crochet/1000, {ease = 'cubeOut'})
        end
    elseif val == '2' then
        for i = 0 , 3 do
            startTween('dadHide'..i, 'strumLineNotes.members['..(i)..']', {y = _G['defaultOpponentStrumY'..i] + 100, alpha = 0}, crochet/1000, {ease = 'backIn'})
            startTween('dadColor'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 100}, crochet/1000, {ease = 'cubeIn'})
        end
    elseif val == '3' then
        for i = 0 , 3 do
            startTween('dadHide'..i, 'strumLineNotes.members['..(i)..']', {y = _G['defaultOpponentStrumY'..i], alpha = 1}, crochet/1000, {ease = 'cubeOut'})
            startTween('dadColor'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0}, crochet/1000, {ease = 'cubeOut'})
        end
    end
end
function onTimerCompleted(tag)
    if string.sub(tag, 1, 4) == 'fuck' then
        local va = tag:gsub('fuckYou', '')
        noteTweenY('bar'..va, va, defaultOpponentStrumY0, crochet/600, 'quadOut')
        noteTweenY('bwe'..va, 7-va, defaultPlayerStrumY0, crochet/600, 'quadOut')
    end
end

function setOppAnimation(anim)
	local switchCase = {
        ["RUV"] = function()
            setProperty('camShakeSpeed', 8)
        end,
		["GARCELLO"] = function()
            setProperty('camShakeSpeed', 5.5)
            if not modcharts then return end
            for i = 0, 7 do
                startTween('fade'..i, 'strumLineNotes.members['..(i)..']', {alpha = 0.6}, crochet/1000, {ease = 'quadOut'})
            end
        end,
		["TABI"] = function()
            if not modcharts then return end
            for i = 0, 7 do
                startTween('fade'..i, 'strumLineNotes.members['..(i)..']', {alpha = 1}, crochet/2000, {ease = 'quadOut'})
            end
		end,
		["TRICKY"] = function()
            if not modcharts then return end
            for i = 0, 3 do
                noteTweenX('moveNote'..i, i+4, _G['defaultPlayerStrumX'..i], crochet/1000, 'cubeOut')
                noteTweenX('moveNoteW'..i, i, _G['defaultOpponentStrumX'..i], crochet/1000, 'cubeOut')
            end
		end,
        ["POKEMON"] = function()
            toggledToll = true
            if not modcharts then return end
            for i = 0, 3 do
                cancelTween('boyfriendSkippable'..i) cancelTween('dadSkippable'..i)
                noteTweenY('moveBF'..i, i + 4, _G['defaultPlayerStrumY'..i], crochet/1000, 'backOut')
                noteTweenY('moveDad'..i, i, _G['defaultOpponentStrumY'..i], crochet/1000, 'backOut')
            end
		end
	}
    if switchCase[anim] ~= nil then
		switchCase[anim]()
	end
end

function doDarkScreen()
    if not modcharts then return end
    for i = 0, 3 do
        noteTweenY('moveUp'..i, i,_G['defaultOpponentStrumY'..i] + ((isDownScroll and 159) or -100), crochet/500, 'backIn')
    end
end
function nintendoShift(index)
    toggledToll = false
    if not modcharts then return end
    for i = 0, 3 do
        startTween('fade'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 200}, crochet/1000, {ease = 'quadIn'})
        noteTweenAlpha('alpha'..i, i, 0, crochet/1000, {ease = 'quartIn'})
    end
    if enabledUnderlay then
        startTween('fadeGradient', 'playerUnderlayGradient.colorTransform', {alphaOffset = -255}, crochet/1000, {ease = 'quadIn'})
    end
    noteTweenX('backOffX0', 4, _G['defaultPlayerStrumX0']- 430, crochet/500, 'circInOut')
    noteTweenX('backOffX1', 5, _G['defaultPlayerStrumX1']- 400, crochet/500, 'circInOut')
    noteTweenX('backOffX2', 6, _G['defaultPlayerStrumX2']- 230, crochet/500, 'circInOut')
    noteTweenX('backOffX3', 7, _G['defaultPlayerStrumX3']- 200, crochet/500, 'circInOut')
end
function preMidsongCutscene()
    setProperty('camZoomingMult', 0)
    if not modcharts then return end
    startTween('hudAlphaShaderTween', 'hudAlphaShader', { camAlpha = 0.75 }, crochet/1000, { ease = 'cubeIn' })
    noteTweenX('backOffX0', 4, _G['defaultPlayerStrumX0']- 555, crochet/500, 'cubeInOut')
    noteTweenX('backOffX1', 5, _G['defaultPlayerStrumX1']- 505, crochet/500, 'cubeInOut')
    noteTweenX('backOffX2', 6, _G['defaultPlayerStrumX2']- 110, crochet/500, 'cubeInOut')
    noteTweenX('backOffX3', 7, _G['defaultPlayerStrumX3']- 60, crochet/500, 'cubeInOut')
    for i = 4, 7 do
        startTween('fade'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = -50}, crochet/1000, {ease = 'cubeIn'})
    end
    for _,obj in ipairs(redObjects) do
        if obj ~= 'botplayTxt' then 
        startTween('redding'..obj, obj..'.colorTransform', {greenOffset = -200, blueOffset = -200, redOffset = 100, alphaOffset = -500}, crochet/1000, 'cubeIn')
        end
    end
end

function returner()
    if not modcharts then return end
    startTween('hudAlphaShaderTween', 'hudAlphaShader', { camAlpha = 1 }, crochet/500, { ease = 'cubeOut' })
    if enabledUnderlay then
        startTween('fadeGradient', 'playerUnderlayGradient.colorTransform', {alphaOffset = 0}, crochet/500, {ease = 'quadInOut'})
    end
    for i = 0, 3 do
        setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultOpponentStrumX'..i])
        noteTweenX('backOffX'..i, i+4, _G['defaultPlayerStrumX'..i], crochet/500, 'quadInOut')
        noteTweenY('moveUp'..i, i,_G['defaultOpponentStrumY'..i], crochet/500, 'cubeInOut')
        startTween('fade'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0}, crochet/1000, {ease = 'cubeIn'})
        noteTweenAlpha('alpha'..i, i, 1, crochet/500, {ease = 'cubeIn'})
    end
    for _,obj in ipairs(redObjects) do
        if obj ~= 'botplayTxt' then 
        startTween('redding'..obj, obj..'.colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0, alphaOffset = 0}, crochet/1000, 'quadOut')
        end
    end
    for we = 0, 7 do
        startTween('fade'..we, 'strumLineNotes.members['..(we)..'].colorTransform', {greenOffset = 0, blueOffset = 0, redOffset = 0}, crochet/500, {ease = 'quadOut'})
    end
end

function redPulse()
    if not modcharts then return end
    for i = 0 , 7 do
        cancelTween('redNess'..i)
        setPropertyFromGroup('strumLineNotes', i, 'colorTransform.redOffset', 50)
        setPropertyFromGroup('strumLineNotes', i, 'colorTransform.blueOffset', -100)
        setPropertyFromGroup('strumLineNotes', i, 'colorTransform.greenOffset', -100)
        startTween('redNess'..i, 'strumLineNotes.members['..(i)..'].colorTransform', {redOffset = 0, blueOffset = 0, greenOffset = 0}, crochet/1250, {ease = 'quadIn'})
    end
    setProperty('camShakeStrength', 4)
end
local zoomBeats = {415, 447, 479, 511, 543, 575, 607, 639, 671}

function commitABeat(beats) --Change all instances of trulyBeats to curBeat incase this shit desynced on lag
    if curBeat >= 200 and curBeat < 248 then return end
    if curBeat >= 368 and curBeat < 416 then return end
    if curBeat >= 736 and curBeat < 800 then return end
    if curBeat == 151 or curBeat == 158 or curBeat == 165 or curBeat == 319 or curBeat == 326 or curBeat == 333 or curBeat == 347 or curBeat == 354 or curBeat ==361 then
        trulyBeats = trulyBeats + 1
        triggerEvent('Add Camera Zoom', "0.01", "0.015")
    end
    for _,v in ipairs(zoomBeats) do
        if curBeat == v then
            luaTrace('shouldIgnore')
            table.remove(zoomBeats, _)
            return
        end
    end
    
    if beats % 2 == 0 then
        triggerEvent('Add Camera Zoom', "0.0075", "0.0125")
    else
        triggerEvent('Add Camera Zoom', "0.02", "0.025")
    end
end

function moveHUD(Test)
    local hbPos = Test and 0 or 610
    local time = crochet/500
    doTweenY('score', 'scoreTxt', Test and 600 or 65, time, 'expoInOut')
    doTweenY('bot', 'botplayTxt', Test and 610 or 80, time,'expoInOut')
    doTweenY('missACC', 'missAccTxt', Test and 20 or 645, time,'expoInOut')
    doTweenY('timeLeft', 'songTimeLeft', Test and 20 or 645, time,'expoInOut')
    doTweenY('healthBar', 'bar.leftBar', hbPos, time, 'expoInOut')
    doTweenY('healthBar2', 'bar.rightBar', hbPos, time, 'expoInOut')
    doTweenY('healthBar3', 'bar.overlay', hbPos, time, 'expoInOut')
    doTweenY('iconP1', 'iconP1', hbPos - 16, time, 'expoInOut')
    doTweenY('iconP2', 'iconP2', hbPos - 16, time, 'expoInOut')
end