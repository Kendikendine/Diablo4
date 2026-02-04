#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
Persistent
CoordMode "Mouse", "Client"

; global Değişkenler
; ────────────────────────────────────────────────────────────────
TikSayisi := 33
fareX := 1040
fareY := 570
AutoPilotOnOff := 0
LButtonStartTick := 0
OnOffSwitch1 := 0

; GUI Oluşturma
; ────────────────────────────────────────────────────────────────
myGui := Gui("+ToolWindow +AlwaysOnTop")

myGui.Add("Checkbox", "x5 y10 w75 h30 vClickHelper", "Click Helper")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x80 y10 w75 h30 vOnOffBtn1", "Off")
    .OnEvent("Click", OnOffBtn1Toggle)

myGui.Add("Button", "x5 y40 w75 h30", TikSayisi " sol")
    .OnEvent("Click", SolTik)

myGui.Add("Button", "x80 y40 w75 h30", TikSayisi " sağ")
    .OnEvent("Click", SagTik)

myGui.Add("Button", "x5 y70 w150 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.OnEvent("Close", (*) => myGui.Hide())

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
      MsgShow("Tıklama Yardımcıları Kapalı")
    }
}

SolTik(*) {
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)
    
     Loop TikSayisi {
        Click "Left"
        Sleep Random(300, 500)
    }
    MsgShow(TikSayisi " sol tık tamamlandı")
}

SagTik(*) {
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)

     Loop TikSayisi {
        Click "Right"
        Sleep Random(300, 500)
    }
   
    MsgShow(TikSayisi " sağ tık tamamlandı")
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
   global OnOffSwitch1 := !OnOffSwitch1
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)
    
    if OnOffSwitch1 {
        myGui["OnOffBtn1"].Text := "On"
        MsgShow("Otomatik Yardımcı Açık")
        Korun()
        SetTimer Korun, 11000
    } 
    else {
        myGui["OnOffBtn1"].Text := "Off"
        MsgShow("Otomatik Yardımcı Kapalı")
        SetTimer Korun, 0
    }
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

AutoPilotToggle() {
    global AutoPilotOnOff := !AutoPilotOnOff
    global OnOffSwitch1 := 0
    myGui["OnOffBtn1"].Text := "Off"
    SetTimer Korun, 0
    
    if (AutoPilotOnOff = 0) {
        SetTimer AutoPilot, 0
        MsgShow("AutoPilotKapalı")
        return
    }
    
    MsgShow("AutoPilotAçık")
    SetTimer AutoPilot, 11000
    AutoPilot()
}

AutoPilot() {
    Hapset()
    Korun()   
    DortYonVur()   
}

Hapset() {
    Sleep Random(50, 80)
    Send "2"   ; Kemik Hapisane
}

Korun() {
    Sleep Random(50, 80)
    Send "3"   ; Ceset Patlaması
    Sleep Random(50, 80)
    Send "1"   ; Kemik Fırtınası
}

DortYonVur() {
    static kuzey_x := 1040, kuzey_y := 430
    static dogu_x  := 1040, dogu_y  := 570
    static guney_x :=  860, guney_y := 570
    static bati_x  :=  860, bati_y  := 430
    Sleep Random(50, 80)
    MouseMove kuzey_x, kuzey_y, 35
    Click "Right Down"
      Sleep Random(1500, 2200)
      MouseMove dogu_x, dogu_y, 15
      Sleep Random(1500, 2200)
      MouseMove guney_x, guney_y, 15
      Sleep Random(1500, 2200)
      MouseMove bati_x, bati_y, 15
      Sleep Random(1500, 2200)
      MouseMove kuzey_x, kuzey_y, 15
      Sleep Random(1500, 2200)
    Click "Right Up"
}

; Hotkey'ler
; ────────────────────────────────────────────────────────────────
$XButton1::{
    MouseGetPos &X, &Y
    myGui.Show "x" X " y" Y
    global fareX := X
    global fareY := Y
}

$ü::{
    AutoPilotToggle()
    return
}

~$RButton::{
    if ! myGui["ClickHelper"].Value
        return     ; checkbox kapalı → makro hiç çalışmasın, normal sağ tık geçsin

    ; buradan sonrası sadece checkbox açıkken çalışır
    SetTimer Hapset, 0
    Loop 30
    {
        if !GetKeyState("RButton", "P")
            return
        Sleep 100
    }
    Hapset()
    SetTimer Hapset, 7000
    return
}

~$RButton up::{
    if !myGui["ClickHelper"].Value
        return

    SetTimer Hapset, 0
    return
}

~$LButton::{
    if ! myGui["ClickHelper"].Value
        return

   global LButtonStartTick := A_TickCount
    return
}

~$LButton up::{
    if ! myGui["ClickHelper"].Value
        return

    held_ms := A_TickCount - LButtonStartTick

    if (held_ms >= 1000)
    {
        Click "Left"
        Sleep Random(50, 80)
        Click "Right Down"
        Sleep 1500
        Click "Right Up"
    }
   global LButtonStartTick := 0

    return
}
