' ********************************************************************************************************
' ********************************************************************************************************
' **  Roku Prince of Persia Channel - http://github.com/lvcabral/Prince-of-Persia-Roku
' **
' **  Created: April 2016
' **  Updated: May 2016
' **
' **  Ported to Brighscript by Marcelo Lv Cabral from the Git projects:
' **  https://github.com/ultrabolido/PrinceJS - HTML5 version by Ultrabolido
' **  https://github.com/jmechner/Prince-of-Persia-Apple-II - Original Apple II version by Jordan Mechner
' **
' ********************************************************************************************************
' ********************************************************************************************************

Sub PlayIntro(screen as object)
	if m.settings.spriteMode = m.const.SPRITES_DOS
		width = 320
		height = 200
		suffix = "-dos"
	else
		width = 640
		height = 400
		suffix = "-mac"
	end if
	scale = Int(GetScale(screen, width, height))
    centerX = Cint((screen.GetWidth()-(width*scale))/2)
    centerY = Cint((screen.GetHeight()-(height*scale))/2)
	intro = ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/intro-screen"+suffix+".png"), scale)
    CrossFade(screen, centerX, centerY, GetPaintedBitmap(m.colors.black,width*scale, height*scale,true), intro, 3)
    PlaySong("main-theme")
    msg = wait(2600, m.port)
    for s = 1 to 5
        if msg <> invalid
            m.audioPlayer.stop()
            exit for
        end if
        if s = 1
            screen.DrawObject(centerX, centerY, intro)
            screen.DrawObject(centerX + 96*2, centerY + 106*2, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/message-presents"+suffix+".png"),scale))
            delay = 2500
        else if s = 2
            screen.DrawObject(centerX, centerY, intro)
            delay = 2000
        else if s = 3
            screen.DrawObject(centerX, centerY, intro)
            screen.DrawObject(centerX + 96*2, centerY + 122*2, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/message-author"+suffix+".png"),scale))
            delay = 4000
        else if s = 4
            screen.DrawObject(centerX, centerY, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/intro-screen"+suffix+".png"),scale))
            delay = 4300
        else if s = 5
            screen.DrawObject(centerX, centerY, intro)
            screen.DrawObject(centerX + 24*2, centerY + 107*2, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/message-game-name"+suffix+".png"),scale))
            screen.DrawObject(centerX + 35*2, centerY + 180*2, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/message-port"+suffix+".png"),scale))
            delay = 8700
        end if
        screen.SwapBuffers()
        msg = wait(delay, m.port)
    next
End Sub

Sub PlayEnding()
	scale = Int(GetScale(m.mainScreen, 320, 200))
	if m.settings.spriteMode = m.const.SPRITES_DOS
		suffix = "-dos"
		introScale = scale
	else
		suffix = "-mac"
		introScale = scale / 2
	end if
	PlaySong("victory")
	skip = TextScreen(m.mainScreen, "text-the-tyrant" + suffix, m.colors.darkred, 19000, 7)
	if skip then return
	centerX = Cint((m.mainScreen.GetWidth()-(320*scale))/2)
	centerY = Cint((m.mainScreen.GetHeight()-(200*scale))/2)
	intro = ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/intro-screen"+suffix+".png"), introScale)
	CrossFade(m.mainScreen, centerX, centerY, GetPaintedBitmap(0,320*scale, 200*scale,true), intro, 4)
	wait(95000, m.port)
	m.audioPlayer.stop()
End Sub

Function TextScreen(screen as object, pngFile as string, color as integer, waitTime = 0 as integer, fadeIn = 4 as integer) as boolean
    screen.Clear(0)
    scale = Int(GetScale(screen, 320, 200))
    centerX = Cint((screen.GetWidth()-(320*scale))/2)
    centerY = Cint((screen.GetHeight()-(200*scale))/2)
	canvas = GetPaintedBitmap(color, 320*scale, 200*scale, true)
	if m.settings.spriteMode = m.const.SPRITES_DOS
        canvas.DrawObject(0, 0, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/text-screen-dos.png"),scale))
    else
		canvas.DrawObject(0, 0, ScaleBitmap(CreateObject("roBitmap", "pkg:/assets/scenes/images/text-screen-mac.png"),scale/2))
    end if
	bmp = CreateObject("roBitmap", "pkg:/assets/scenes/images/" + pngFile + ".png")
	if bmp.GetWidth() <= 320 then
		bmp = ScaleBitmap(bmp,scale)
	else
		bmp = ScaleBitmap(bmp,scale/2)
	end if
	canvas.DrawObject(30 * scale, 25 * scale, bmp)
	if fadeIn > 0
		CrossFade(screen, centerX, centerY, GetPaintedBitmap(0,320*scale, 200*scale,true), canvas, fadeIn)
	else
		screen.DrawObject(centerX, centerY, canvas)
	end if
    msg = wait(10, m.port)
    screen.SwapBuffers()
    msg = wait(waitTime, m.port)
	return (msg <> invalid)
End Function
