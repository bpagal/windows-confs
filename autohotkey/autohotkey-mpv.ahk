#Requires AutoHotkey v2.0
#SingleInstance Force

mpvWinTitle := "ahk_exe mpv.exe"

^Left::  ControlSend("{Left}", , mpvWinTitle)
^Right:: ControlSend("{Right}", , mpvWinTitle)
^Up::    ControlSend("{Space}", , mpvWinTitle)
 