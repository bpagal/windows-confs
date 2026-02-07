#Requires AutoHotkey v2.0

; Win + Shift + 1 → PC screen only
#+1::
{
    Send "#p"
    Sleep 300
    Send "{Home}{Enter}"
}

; Win + Shift + 2 → Second screen only
#+2::
{
    Send "#p"
    Sleep 300
    Send "{End}{Enter}"
}

; Win + Shift + 3 → Extend
#+3::
{
    Send "#p"
    Sleep 300
    Send "{Home}{Down 2}{Enter}"
}

; Windows + 1 to switch to Brave (or open if not running)
#1::
{
    if WinExist("ahk_exe brave.exe") {
        WinActivate("ahk_exe brave.exe")
    } else {
        Run("brave.exe")
    }
}

; Windows + 2 to switch to Discord (or open if not running)
#2::
{
    if WinExist("ahk_exe Discord.exe") {
        WinActivate("ahk_exe Discord.exe")
    }
}

; Windows + 3 to open File Explorer new window or new tab
#3::
{
    if WinExist("ahk_class CabinetWClass") {
        WinActivate
    } else {
        Run("explorer.exe")
    }
}

; Windows + 4 to switch to Steam (or open if not running)
#4::
{
    if WinExist("ahk_exe steam.exe") {
        WinActivate("ahk_exe steam.exe")
    } else {
        Run("steam://open/main")
    }
}

; Windows + Shift + Q to move cursor to other monitor's center
#+q::
{
    if (MonitorGetCount() < 2)
        return
    
    CoordMode("Mouse", "Screen")
    
    MonitorGet(1, &L1, &T1, &R1, &B1)
    MonitorGet(2, &L2, &T2, &R2, &B2)
    
    MouseGetPos(&mx, &my)
    
    center1X := (L1 + R1) // 2
    center1Y := (T1 + B1) // 2
    center2X := (L2 + R2) // 2
    center2Y := (T2 + B2) // 2
    
    ; Dynamic check: if mouse X is less than where monitor 2 starts
    if (mx < L2) {
        ; On monitor 1, move to monitor 2
        DllCall("SetCursorPos", "int", center2X, "int", center2Y)
    } else {
        ; On monitor 2, move to monitor 1
        DllCall("SetCursorPos", "int", center1X, "int", center1Y)
    }
}

; Windows + Q to switch to game windows (hierarchy)
#q::
{
    games := [
        "ahk_exe Client-Win64-Shipping.exe",  ; Wuthering Waves
        "ahk_exe StarRail.exe",                ; Honkai Star Rail
        "ahk_exe TS4_x64.exe"                  ; The Sims 4
    ]
    
    for game in games {
        if WinExist(game) {
            WinActivate(game)
            return
        }
    }
}

; Windows + Z = Ctrl + Shift + Tab (previous tab) - only in browsers
#HotIf WinActive("ahk_exe firefox.exe") or WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe brave.exe")
#z::Send("^+{Tab}")
#x::Send("^{Tab}")
#HotIf

; Windows + Shift + Z = Move tab left, Windows + Shift + X = Move tab right
#HotIf WinActive("ahk_exe firefox.exe") or WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe") or WinActive("ahk_exe brave.exe")
#+z::Send("^+{PgUp}")
#+x::Send("^+{PgDn}")
#HotIf

; Windows + Shift + Tab = Windows + Shift + Right
#+Tab::Send("#+{Right}")

; Windows + Shift + C to close current window
#+c::WinClose("A")