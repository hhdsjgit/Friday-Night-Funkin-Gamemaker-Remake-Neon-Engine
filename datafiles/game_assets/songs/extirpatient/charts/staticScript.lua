local text = {'RESULTS PENDING', 'TESTS INCONCLUSIVE', 'REQUIRES MORE\n DATA', "SHE'S SAFE", "WAR'S ALWAYS THE SAME", "STAY A LITTLE LONGER,\n WON'T YOU?", "CHEATING DEATH OR\n CHEATING LIFE?", "CONTACTING MIGHTFLAID", "INTRIGUING SPECIMEN"}
local rareText = {}
function onCreate()
    if not modcharts then
        close()
        return
    end
    makeLuaText('spookie', 'MADNESS', 0,0)
    setTextColor('spookie', '000000')
    setTextSize('spookie', 75)
    setTextBorder('spookie', 3, 'FF0028')
    setTextFont('spookie', 'pause.ttf')
    setTextAlignment('spookie', 'center')
    setProperty('spookie.antialiasing', false)
    setObjectCamera('spookie', 'camOther')
    addLuaText('spookie', true)
    setProperty('spookie.alpha', 0.3)
    screenCenter('spookie')
    addProperty('spookie.x', 0)

    makeAnimatedLuaSprite('lmao', 'nightflaid/TrickyStatic', 0,0)
    setObjectCamera('lmao', 'camHUD')
    addAnimationByPrefix('lmao', 'static', 'static', 24, true)
    objectPlayAnimation('lmao', 'static')
    setProperty('lmao.antialiasing', false)
    setGraphicSize('lmao', screenWidth, screenHeight)
    screenCenter('lmao')
    addLuaSprite('lmao', false)
    setProperty('lmao.alpha', 0.3)

  
    setProperty('lmao.visible', false)
    setProperty('spookie.visible', false)
end

function onEvent(n,a, v)
    if n == 'tiky' then
        setProperty('lmao.visible', true)
        setProperty('spookie.visible', true)
        cameraShake('camHUD', 0.015, v)
        cameraShake('camGame', 0.02, v)
        if getRandomBool(5) then
            updateText(text[getRandomInt(1, #rareText)])
        else
            updateText(text[getRandomInt(1, #text)])
        end
        runTimer('removeStatic', v)
        customFlash('camGame', 'FF0000', v*1.25, {ease ='quadIn', first = false, blend = 'multiply',  alpha = 0.75})
    end
end

function onTimerCompleted(tag)
    if tag == 'removeStatic' then
        setProperty('lmao.visible', false)
        setProperty('spookie.visible', false) 
    end
end

function onUpdate(elapsed)
    setProperty('spookie.angle', 3*math.sin(getSongPosition()*20))
end

function updateText(text)
    setTextString('spookie', text)
    screenCenter('spookie','y')
    setProperty('spookie.y', getProperty('spookie.y')-15)
end
