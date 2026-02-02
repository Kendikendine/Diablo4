#Requires AutoHotkey v2.0
#Warn
#SingleInstance Force
Persistent

CoordMode "Mouse", "Client"   ; Koordinatların pencereye göre olduğunu belirtir

; Global Değişkenler
; ────────────────────────────────────────────────────────────────
Global TikSayisi := 33
Global fareX := 1040
Global fareY := 570
Global DaireVurOnOff := 0
Global LButtonStartTick := 0

; GUI Oluşturma
; ────────────────────────────────────────────────────────────────
myGui := Gui("+AlwaysOnTop")

myGui.Add("Checkbox", "x5 y10 w75 h30 vAutoHelperCheck", "Yardımcı")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x80 y10 w75 h30", "Rezerve")
    ;.OnEvent("Click", Fonksiyonismi)

myGui.Add("Button", "x5 y40 w75 h30", TikSayisi " sol")
    .OnEvent("Click", SolTik)

myGui.Add("Button", "x80 y40 w75 h30", TikSayisi " sağ")
    .OnEvent("Click", SagTik)

myGui.Add("Button", "x5 y70 w150 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.OnEvent("Close", (*) => myGui.Hide())

; myGui fonksiyonları
; ────────────────────────────────────────────────────────────────

SolTik(*) {
    myGui.Hide()
    Sleep Random(50, 80)
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
    Sleep Random(50, 80)
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

CheckChanged(*) {
    myGui.Hide()

    if myGui["AutoHelperCheck"].Value {
        MouseMove fareX, fareY, 15
        Sleep Random(50, 80)

        MsgShow("Otomatik Yardımcı Açık")
        AutoHelper()
        SetTimer AutoHelper, 10000
    } else {
        MsgShow("Otomatik Yardımcı Kapalı")
        SetTimer AutoHelper, 0
    }
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

AutoHelper() {
    Sleep Random(500, 800)
    Send "3"   ; Ceset Patlaması
    Sleep Random(1000, 1200)
    Send "1"   ; Kemik Fırtınası
}

DaireVur() {
    local kuzey_x := 1040, kuzey_y := 430
    local dogu_x  := 1040, dogu_y  := 570
    local guney_x :=  860, guney_y := 570
    local bati_x  :=  860, bati_y  := 430
   
    MouseMove kuzey_x, kuzey_y, 35
    Sleep Random(500, 800)
    Send "2"   ; Kemik Hapisane
    Sleep Random(300, 500)
    Click "Right Down"
    
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

DaireVurToggle() {
    Global DaireVurOnOff := !DaireVurOnOff
    myGui["AutoHelperCheck"].Value := 0
    SetTimer AutoHelper, 0
    
    if (DaireVurOnOff = 0) {
        SetTimer DaireVur, 0
        MsgShow("DaireVurKapalı")
        return
    }
    
    MsgShow("DaireVurAçık")
    DaireVur()
    SetTimer DaireVur, 11000
}

Hapset() {
    Sleep Random(50, 80)     ; ufak insanileştirme
    Send "{2 down}"
    Sleep Random(50, 80)
    Send "{2 up}"
}

; Hotkey'ler
; ────────────────────────────────────────────────────────────────
$XButton1::{
    MouseGetPos &X, &Y
    myGui.Show "x" X " y" Y
    Global fareX := X
    Global fareY := Y
}

$ü::{
    DaireVurToggle()
    return
}

~$RButton::{
    if ! myGui["AutoHelperCheck"].Value
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
    if !myGui["AutoHelperCheck"].Value
        return

    SetTimer Hapset, 0
    return
}

~$LButton::{
    if ! myGui["AutoHelperCheck"].Value
        return
global LButtonStartTick
    LButtonStartTick := A_TickCount
    return
}

~$LButton up::{
    if ! myGui["AutoHelperCheck"].Value
        return
global LButtonStartTick
    held_ms := A_TickCount - LButtonStartTick

    if (held_ms >= 1000)
    {
        Click "Left"
        Sleep Random(50, 80)
        Click "Right Down"
        Sleep 1500
        Click "Right Up"
    }
    LButtonStartTick := 0

    return
}
