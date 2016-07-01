' ********************************************************************************************************
' ********************************************************************************************************
' **  Roku Prince of Persia Channel - http://github.com/lvcabral/Prince-of-Persia-Roku
' **
' **  Created: April 2016
' **  Updated: June 2016
' **
' **  Ported to Brighscript by Marcelo Lv Cabral from the Git projects:
' **  https://github.com/ultrabolido/PrinceJS - HTML5 version by Ultrabolido
' **  https://github.com/jmechner/Prince-of-Persia-Apple-II - Original Apple II version by Jordan Mechner
' **
' ********************************************************************************************************
' ********************************************************************************************************

Function StartMenu(screen as object) as integer
    screen.Clear(0)
    scale = Int(GetScale(screen, 640, 426))
    centerX = Cint((screen.GetWidth()-(640*scale))/2)
    centerY = Cint((screen.GetHeight()-(426*scale))/2)
    CrossFade(screen, centerX, centerY, GetPaintedBitmap(m.colors.black,640*scale, 426*scale,true),ScaleBitmap(CreateObject("roBitmap", "pkg:/images/start_menu.jpg"),scale),4)
    menuFont = m.fonts.getFont("Prince of Persia Game Font", 30, false, false)
    button = -1
    selected = 0
    while true
        if button <> selected
            screen.Clear(0)
            screen.DrawObject(centerX, centerY, ScaleBitmap(CreateObject("roBitmap", "pkg:/images/start_menu.jpg"),scale))
            faceColors = [ m.colors.white, m.colors.white, m.colors.white, m.colors.white ]
            faceColors[selected] = &hFF0000FF
            screen.DrawText("Play Classic Mode", centerX + 210, centerY + 170, faceColors[0], menuFont)
            screen.DrawText("Play 4 Rooms Mode", centerX + 200, centerY + 230, faceColors[1], menuFont)
            screen.DrawText("Play 9 Rooms Mode", centerX + 200, centerY + 290, faceColors[2], menuFont)
            screen.DrawText("Game Settings", centerX + 225, centerY + 347, faceColors[3], menuFont)
            screen.SwapBuffers()
            button = selected
        end if
        key = wait(0, m.port)
        if key <> invalid
            if key = m.code.BUTTON_UP_PRESSED or key = m.code.BUTTON_RIGHT_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button > 0
                    selected = button - 1
                else
                    selected = 3
                end if
            else if key = m.code.BUTTON_DOWN_PRESSED or key = m.code.BUTTON_LEFT_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button < 3
                    selected = button + 1
                else
                    selected = 0
                end if
            else if key = m.code.BUTTON_SELECT_PRESSED
                m.sounds.select.Trigger(50)
                if button < 3
                    return button + 1
                else
                    SettingsMenu(screen)
                    button = -1
                end if
            end if
        end if
    end while
End Function

Sub SettingsMenu(screen as object)
    scale = Int(GetScale(screen, 640, 426))
    centerX = Cint((screen.GetWidth()-(640*scale))/2)
    centerY = Cint((screen.GetHeight()-(426*scale))/2)
    menuFont = m.fonts.getFont("Prince of Persia Game Font", 30, false, false)
    colorWhite = &hFFFFFFFF
    colorRed = &hFF0000FF
    button = -1
    selected = m.settings.controlMode
    while true
        if button <> selected
            screen.Clear(0)
            screen.DrawObject(centerX, centerY, ScaleBitmap(CreateObject("roBitmap", "pkg:/images/settings_menu.jpg"),scale))
            faceColors = [ m.colors.white, m.colors.white, m.colors.white ]
            faceColors[selected] = &hFF0000FF
            screen.DrawText("Control Mode", centerX + 85, centerY + 156, faceColors[0], menuFont)
            screen.DrawText("Graphics Mode", centerX + 85, centerY + 212, faceColors[1], menuFont)
            screen.DrawText("Game Credits", centerX + 85, centerY + 270, faceColors[2], menuFont)
            screen.SwapBuffers()
            button = selected
        end if
        key = wait(0, m.port)
        if key <> invalid
            if key = m.code.BUTTON_UP_PRESSED or key = m.code.BUTTON_RIGHT_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button > 0
                    selected = button - 1
                else
                    selected = 2
                end if
            else if key = m.code.BUTTON_DOWN_PRESSED or key = m.code.BUTTON_LEFT_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button < 2
                    selected = button + 1
                else
                    selected = 0
                end if
            else if key = m.code.BUTTON_BACK_PRESSED
                m.sounds.navSingle.Trigger(50)
                exit while
            else if key = m.code.BUTTON_SELECT_PRESSED
                m.sounds.select.Trigger(50)
                if selected = 0
                    option = OptionsMenu(screen, [{text: "Vertical Control", image:"control_vertical"},{text:"Horizontal Control", image:"control_horizontal"}], m.settings.controlMode)
                    if option >= 0 and option <> m.settings.controlMode
                        m.settings.controlMode = option
                        SaveSettings(m.settings)
                    end if
                else if selected = 1
                    option = OptionsMenu(screen, [{text: "IBM-PC MS-DOS", image:"graphics_dos"},{text:"Macintosh Classic", image:"graphics_mac"}], m.settings.spriteMode)
                    if option >= 0 and option <> m.settings.spriteMode
                        m.settings.spriteMode = option
                        SaveSettings(m.settings)
                    end if
                else if selected = 2
                    TextScreen(screen, "text-credits", m.colors.black)
                end if
                button = -1
            end if
        end if
    end while
End Sub

Function OptionsMenu(screen as object, options as object, default as integer) as integer
    scale = Int(GetScale(screen, 640, 426))
    centerX = Cint((screen.GetWidth()-(640*scale))/2)
    centerY = Cint((screen.GetHeight()-(426*scale))/2)
    menuFont = m.fonts.getFont("Prince of Persia Game Font", 30, false, false)
    colorWhite = &hFFFFFFFF
    colorRed = &hFF0000FF
    button = -1
    selected = default
    while true
        if button <> selected
            screen.Clear(0)
            screen.DrawObject(centerX, centerY, ScaleBitmap(CreateObject("roBitmap", "pkg:/images/options_menu.jpg"),scale))
            if selected = 0
                screen.DrawText(options[0].text, centerX + 80, centerY + 47, colorRed, menuFont)
                screen.DrawText(options[1].text, centerX + 73, centerY + 105, colorWhite, menuFont)
            else
                screen.DrawText(options[0].text, centerX + 80, centerY + 47, colorWhite, menuFont)
                screen.DrawText(options[1].text, centerX + 73, centerY + 105, colorRed, menuFont)
            end if
            screen.DrawObject(centerX, centerY, ScaleBitmap(CreateObject("roBitmap", "pkg:/images/" + options[selected].image + ".png"),scale))
            screen.SwapBuffers()
            button = selected
        end if
        key = wait(0, m.port)
        if key <> invalid
            if key = m.code.BUTTON_DOWN_PRESSED or key = m.code.BUTTON_LEFT_PRESSED or key = m.code.BUTTON_UP_PRESSED or key = m.code.BUTTON_RIGHT_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button = 1
                    selected = 0
                else
                    selected = 1
                end if
            else if key = m.code.BUTTON_BACK_PRESSED
                m.sounds.navSingle.Trigger(50)
                selected = -1
                exit while
            else if key = m.code.BUTTON_SELECT_PRESSED
                m.sounds.select.Trigger(50)
                exit while
            end if
        end if
    end while
    return selected
End Function

Function MessageBox(screen as object, width as integer, height as integer, text as string) as integer
    leftX = Cint((screen.GetWidth()-width)/2)
    topY = Cint((screen.GetHeight()-height)/2)
    xt = leftX + int(width / 2) - ((Len(text) + 1) * 14) / 2
    xb = leftX + int(width / 2) - (13 * 14) / 2
    yt = topY + height / 2 - 25
    button = -1
    selected = m.const.BUTTON_YES
    m.mainScreen.SwapBuffers()
    while true
        if button <> selected
            screen.DrawRect(leftX, topY, width, height, m.colors.black)
            m.bitmapFont[2].write(screen, text, xt, yt)
            DrawBorder(screen, width, height, m.colors.white, 0)
            boff = [0,60,100]
            line = [42,28,84]
            m.bitmapFont[2].write(screen, "Yes", xb + boff[0], yt + 30)
            m.bitmapFont[2].write(screen, "No", xb + boff[1], yt + 30)
            m.bitmapFont[2].write(screen, "Cancel", xb + boff[2], yt + 30)
            screen.DrawLine(xb + boff[selected], yt + 50, xb + boff[selected] + line[selected], yt + 50, m.colors.white)
            m.mainScreen.SwapBuffers()
            button = selected
        end if
        key = wait(0, m.port)
        if (key<> invalid)
            if key = m.code.BUTTON_LEFT_PRESSED or key = m.code.BUTTON_UP_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button > m.const.BUTTON_YES
                    selected = button - 1
                else
                    selected = m.const.BUTTON_CANCEL
                end if
            else if key = m.code.BUTTON_RIGHT_PRESSED or key = m.code.BUTTON_DOWN_PRESSED
                m.sounds.navSingle.Trigger(50)
                if button < m.const.BUTTON_CANCEL
                    selected = button + 1
                else
                    selected = m.const.BUTTON_YES
                end if
            else if key = m.code.BUTTON_BACK_PRESSED
                m.sounds.navSingle.Trigger(50)
                return m.const.BUTTON_CANCEL
            else if key = m.code.BUTTON_SELECT_PRESSED
                m.sounds.select.Trigger(50)
                return selected
            end if
        end if
    end while
End Function
