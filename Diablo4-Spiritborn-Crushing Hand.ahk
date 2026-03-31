;Spiritborn, Crushing Hand
#Requires AutoHotkey v2.0
A_ScriptWarningTimeout := -1
#Warn
#MaxThreadsPerHotkey 3
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
myGui := Gui("+ToolWindow +AlwaysOnTop", "Diablo4 Yardımcısı")
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Checkbox", "x5 y10 w90 h30 vClickHelper", "Click Helper")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x95 y10 w90 h30", "Gizle").OnEvent("Click", (*) => myGui.Hide())

myGui.Add("Button", "x5 y40 w90 h30", "İksir İç")
    .OnEvent("Click", iksiric)

myGui.Add("Button", "x95 y40 w90 h30","İtem Al")
    .OnEvent("Click", itemal)

myGui.Add("Button", "x5 y70 w180 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.Add("Button", "x5   y100 w45 h30", "^r").OnEvent("Click", mbtn1)
myGui.Add("Button", "x50  y100 w45 h30", "2").OnEvent("Click", mbtn2)
myGui.Add("Button", "x95  y100 w45 h30", "3").OnEvent("Click", mbtn3)
myGui.Add("Button", "x140 y100 w45 h30", "4").OnEvent("Click", mbtn4)

myGui.OnEvent("Close", (*) => ExitApp())

myGuiinfo1 := Gui("+ToolWindow +AlwaysOnTop", "İtemlerin Düştüğü Yerler")
myGuiinfo1.SetFont("s10", "Segoe UI")
myGuiinfo1.Add("Text",, "Yargı Tarlaları in patronu mührü: (Urivar) Yüzük ve kolluk`n"
               . "Tövbekar Salonu in patronu mührü: (Grigorie) : Yüzük ve kolluk`n"
               . "Buzul çatlak in patronu mührü: (Buzdaki canavar): Kafalık`n"
               . "Kadimimn mevkisi in patronu mührü (Lort Zir): Pantolon ve ayakkabı`n"
               . "Açık buz yarığı in patronu mührü: (Duriel): Silah`n"
               . "Asılı adamın salonu in patronu mührü(Andariel): Pantolon (Tibault's Will)`n"
               . "Müjdecinin ini in patronu mührü (nefret müjdecisi) :silah")

myGuiinfo2 := Gui("+ToolWindow +AlwaysOnTop", "Amulet Skiller")
myGuiinfo2.SetFont("s10", "Segoe UI")
myGuiinfo2.Add("Text",, "1. Maximum Kaynak`n"
               . "2. Apex (Zirve)`n"
               . "3. Dominant (Hakim)`n"
               . "4. Briliance (ihtişam)`n"
               . "5. Potent (Tesirli)`n"
               . "6. Furnace (Ocak)")
              

; ────────────────────────────────────────────────────────────────
; Menü Oluşturma
; ────────────────────────────────────────────────────────────────
mymenuBar := MenuBar()
infoMenu := Menu()
infoMenu.Add("İtemler", (*) => (myGui.Hide(), myGuiinfo1.Show("x" fareX " y" fareY) ))
infoMenu.Add("Amulet", (*) => (myGui.Hide(), myGuiinfo2.Show("x" fareX " y" fareY) ))
infoMenu.Add("Crushing Hand", (*) => (myGui.Hide(), Run("https://maxroll.gg/d4/build-guides/crushing-hand-spiritborn-guide")))
mymenuBar.Add("Bilgi", infoMenu)
myGui.MenuBar := mymenuBar

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

mbtn1(*) {
  myGui.Hide()
    Sleep Random(50, 80)
        Send "^r"
        Sleep Random(50, 80)
        Send "^r"
}

mbtn2(*) {
    myGui.Hide()
}

mbtn3(*) {
    myGui.Hide()
}

mbtn4(*) {
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
    Send "{3}"
    Sleep 100
    Send "{LShift down}"
    Click "down"
    Sleep 6000
    Click "up"
    Send "{LShift up}"
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
    Sleep 200
    Send "{3}"
    }
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
    Sleep 200
    Send "{3}"
    KeyWait "RButton"
}

~$WheelUp::{
    if ! myGui["ClickHelper"].Value
        {
       Sleep 50
        return
        }
         Sleep 100
         Send "{2}"
}

~$WheelDown::{
    if ! myGui["ClickHelper"].Value
        {
       Sleep 50
        return
        }
         Sleep 100
         Send "{1}"
}

ü::{  
        MsgShow("AutoKill açık") 
        SetTimer AutoKill, 9000
	Sleep 100
        AutoKill()
}

ğ::{  
        MsgShow("AutoKill kapalı") 
        SetTimer AutoKill, 0
}

~t::myGui["ClickHelper"].Value := 0
~Tab::myGui["ClickHelper"].Value := 1
~m::myGui["ClickHelper"].Value := 1
