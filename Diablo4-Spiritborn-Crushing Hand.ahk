;Spiritborn, Crushing Hand
#Requires AutoHotkey v2.0
A_ScriptWarningTimeout := -1
;#Warn
#SingleInstance Force
#MaxThreadsPerHotkey 2
KeyHistory 0
ListLines 0
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"

; global Değişkenler
; ────────────────────────────────────────────────────────────────
fareX := 1040
fareY := 570
OnOffAutoKill := 0

; GUI Oluşturma
; ────────────────────────────────────────────────────────────────
myGui := Gui("+ToolWindow +AlwaysOnTop")
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Checkbox", "x5 y10 w90 h30 vClickHelper", "Click Helper")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x95 y10 w90 h30 vOnOffBtn1", "Gizle")
    .OnEvent("Click", OnOffBtn1Toggle)

myGui.Add("Button", "x5 y40 w90 h30", "İksir İç")
    .OnEvent("Click", iksiric)

myGui.Add("Button", "x95 y40 w90 h30","İtem Al")
    .OnEvent("Click", itemal)

myGui.Add("Button", "x5 y70 w180 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.OnEvent("Close", (*) => ExitApp())

; myGui fonksiyonları
; ────────────────────────────────────────────────────────────────
CheckChanged(*) {
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)

    if myGui["ClickHelper"].Value {
       MsgShow("Tıklama Yardımcıları Açık")
    } 
    else { 
      SetTimer AutoKill, 0
      SetTimer AutoClickWhileHeld, 0
      MsgShow("Tıklama Yardımcıları Kapalı")
    }
}

iksiric(*) {
    myGui.Hide()
    Sleep Random(50, 80)
    Send "{ı}"
    Sleep Random(200, 300)
    Send "{Click 1790 770}"

Loop 4 {
            satır := 1
            sütun := A_Index
            pos := GetInvPos(satır, sütun)
            MouseMove pos.x, pos.y, 15
            Sleep Random(50, 80)
            Click "Right"
            Sleep Random(500, 600)
        }
            Send "{Click 1899 80}"
            MsgShow("İksirler içildi.")
}
    
itemal(*) {
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)

     Loop 33 {
        Click "Right"
        Sleep Random(300, 500)
    }
   
    MsgShow("İtemler alındı.")
    MouseMove 1170, 770, 15
    Sleep Random(50, 80)
    Click "Left"
}

HepsiniSat(*) {
    myGui.Hide()
    Sleep Random(50, 80)

    Loop 3 {
        satır := A_Index
        Loop 11 {
            sütun := A_Index
            pos := GetInvPos(satır, sütun)
            MouseMove pos.x, pos.y, 15
            Sleep Random(50, 80)
            Click "Right"
            Sleep Random(300, 500)
        }
    }

    MouseMove fareX, fareY, 15
    MsgShow("Hepsi Satıldı")
}

OnOffBtn1Toggle(*) {
       myGui.Hide()
    }
; Fonksiyonlar
; ────────────────────────────────────────────────────────────────

MsgShow(Msg) {
    CoordMode "ToolTip", "Client"
    ToolTip Msg, fareX, fareY
    SetTimer () => ToolTip(), -6000
}

GetInvPos(satir, sutun) {
    static baseX   := 1220
    static baseY   := 840
    static colStep := 60
    static rowStep := 100

    x := baseX + (sutun - 1) * colStep
    y := baseY + (satir - 1) * rowStep

    return {x: x, y: y}
}

Korun() {
    Send "{1}"
    Sleep 200
    Send "{2}"
}

GorilZehir() {
    Send "{4}"
    Sleep 200
    Click "Right"
}

AutoKill() { 
    Korun()
    Sleep 100 
    GorilZehir()
    Sleep 100
    
    Send "{LShift down}"
    Click "down"
    Sleep 6000
    Click "up"
    Send "{LShift up}"
}

AutoClickWhileHeld(){
        Click "Left"
        Send "{LButton down}"
}

Clickikapa(){
        SetTimer AutoClickWhileHeld, 0
        SetTimer Clickikapa, 0
}

; Hotkey'ler
; ────────────────────────────────────────────────────────────────
$XButton1::{
    MouseGetPos &X, &Y
    myGui.Show "x" X " y" Y
    global fareX := X
    global fareY := Y
}

~$+LButton::{
    if ! myGui["ClickHelper"].Value
        return

    if ! KeyWait("LButton", "T2")
    {
     Korun()
    }

if ! KeyWait("LButton", "T2")
    { 
    GorilZehir()
    }
}

~$LButton::{
    if ! myGui["ClickHelper"].Value
        return
    SetTimer AutoClickWhileHeld, Random(450, 550)
    SetTimer Clickikapa, 7000
}

~$LButton up::{
    if ! myGui["ClickHelper"].Value
        return
    SetTimer AutoClickWhileHeld, 0 
    SetTimer Clickikapa, 0
}

RButton::{
    if ! myGui["ClickHelper"].Value
    {
        Send "{RButton down}"
        KeyWait "RButton"
        Send "{RButton up}"
        return
    }
    Korun()
    Sleep 200
    GorilZehir()
    KeyWait "RButton"
}

~$3::{
    if ! myGui["ClickHelper"].Value
        return    
        MsgShow("AutoKill açık") 
        SetTimer AutoKill, 9000
	Sleep 100
        AutoKill()
    }

~$4::{
    if ! myGui["ClickHelper"].Value
        return    
        MsgShow("AutoKill kapalı") 
        SetTimer AutoKill, 0
    }

~$WheelUp::{
    if ! myGui["ClickHelper"].Value
        return
        Korun()
}
~$WheelDown::{
    if ! myGui["ClickHelper"].Value
        return
        Korun()
}
