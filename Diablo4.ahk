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

; GUI Oluşturma
; ────────────────────────────────────────────────────────────────
myGui := Gui("+AlwaysOnTop")

myGui.Add("Checkbox", "x5 y10 w150 h30 vAutoHelperCheck", "Otomatik Yardımcı")
    .OnEvent("Click", CheckChanged)

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
}

CheckChanged(*) {
    myGui.Hide()

    if myGui["AutoHelperCheck"].Value {
        MouseMove fareX, fareY, 15
        Sleep Random(80, 150)

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

    ; Sabit başlangıç noktaları
    baseX := 1220
    baseY := 840
    colStep := 60     ; sütunlar arası
    rowStep := 100    ; satırlar arası

    Loop 3 {  ; satırlar (0, 1, 2)
        row := A_Index - 1
        currentY := baseY + row * rowStep

        Loop 11 {  ; sütunlar (0..10)
            col := A_Index - 1
            currentX := baseX + col * colStep

            MouseMove currentX, currentY, 15
            Sleep Random(50, 80)
            Click "Right"
            Sleep Random(300, 500)
        }
    }
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)
    MsgShow("Hepsi Satıldı")
}

; Fonksiyonlar
; ────────────────────────────────────────────────────────────────

MsgShow(Msg) {
    CoordMode "ToolTip", "Client"
    ToolTip Msg, fareX, fareY
    SetTimer () => ToolTip(), -6000
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
    
    if (DaireVurOnOff = 0) {
        SetTimer DaireVur, 0
        MsgShow("DaireVurKapalı")
        return
    }
    
    MsgShow("DaireVurAçık")
    DaireVur()
    SetTimer DaireVur, 11000
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

/*
~RButton::{
    Send "{3 down}"
    KeyWait "RButton"
    Send "{3 up}"
}
*/