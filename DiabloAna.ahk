; =============================================
; DIABLO 4 ANA HELPER (TEMEL)
; =============================================
#Requires AutoHotkey v2.0
A_ScriptWarningTimeout := -1
#Warn
#SingleInstance Force
#MaxThreadsPerHotkey 3
KeyHistory 0
ListLines 0
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"


; =============================================
; GLOBAL DEĞİŞKENLER
; =============================================
fareX := 913
fareY := 413
OnOffKlavye := 1
CanOnOff := 0
BalikOnOff := 0
TmpOnOff := 0          ; Rezerve Tmp butonu için
BalikSüreMin := 3000
BalikSüreMax := 5000
KontrolSuresi := 777


; =============================================
; GUI OLUŞTURMA
; =============================================
myGui := Gui("+ToolWindow +AlwaysOnTop", "Diablo4 Yardımcısı")
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Button", "x95 y10 w90 h30", "Gizle").OnEvent("Click", (*) => myGui.Hide())

myGui.Add("Button", "x5 y40 w90 h30 vbalikbtn ", "BalikOff")
    .OnEvent("Click", Balik)

myGui.Add("Button", "x95 y40 w90 h30","İtem Al")
    .OnEvent("Click", itemal)

myGui.Add("Button", "x5 y70 w180 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.Add("Button", "x5   y100 w45 h30", "^r").OnEvent("Click", mbtn1)
myGui.Add("Button", "x50  y100 w45 h30 vOnOffBtn1", "On").OnEvent("Click", mbtn2)
myGui.Add("Button", "x95  y100 w45 h30 vTmpBtn", "Tmp")
    .OnEvent("Click", TmpBtnClick)
myGui.Add("Button", "x140 y100 w45 h30 vCanBtn", "Can").OnEvent("Click", CanBtnClick)

myGui.OnEvent("Close", (*) => ExitApp())

; Kısayollar GUI
myGuiKisayollar := Gui("+ToolWindow +AlwaysOnTop", "Kısayollar")
myGuiKisayollar.SetFont("s10", "Segoe UI")
myGuiKisayollar.Add("Text",,
    "XButton1 (tek tıklama) → GUI göster/gizle`n" .
    "XButton1 (çift tıklama) → (boş - ileride doldurulabilir)`n" .
    "Ctrl + XButton1 → Fare konumunu güncelle`n" .
    "ç → item tavla`n" .
    "t → Klavye yardımcılarını kapat (Can pot dahil)`n" .
    "Tab → (ileride eklenebilir)"
)
myGuiKisayollar.OnEvent("Close", (*) => myGuiKisayollar.Hide())


; =============================================
; MENÜ OLUŞTURMA
; =============================================
mymenuBar := MenuBar()
infoMenu := Menu()
infoMenu.Add("Kısayollar", (*) => (myGui.Hide(), myGuiKisayollar.Show("x" fareX " y" fareY)))
mymenuBar.Add("Bilgi", infoMenu)

balikMenu := Menu()
balikMenu.Add("Ayarlar", AyarlarMenu)
balikMenu.Add("Renk Takip", RenkTakipMenu)
balikMenu.Add("Konum Takip", KonumTakipMenu)
mymenuBar.Add("Araçlar", balikMenu)

myGui.MenuBar := mymenuBar


; =============================================
; GUI BUTON VE EVENT FONKSİYONLARI
; =============================================
itemal(*) {
    myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)

     Loop 33 {
        Click "Right"
        Sleep Random(100, 120)
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
            Sleep Random(100, 120)
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
    global OnOffKlavye := !OnOffKlavye
    Sleep Random(50, 80)
    if OnOffKlavye {
        myGui["OnOffBtn1"].Text := "On"
        MsgShow("Klavye yardımcıları Açık")
    } 
    else {
        myGui["OnOffBtn1"].Text := "Off"
        MsgShow("Klavye yardımcıları Kapalı")
    }
}


; =============================================
; TMP REZERVE BUTONU
; =============================================
TmpBtnClick(*) {
    global TmpOnOff
    
    TmpOnOff := !TmpOnOff
    
    if TmpOnOff {
        myGui["TmpBtn"].Text := "On"
        ; Buraya ileride Tmp fonksiyonu eklenebilir
    } 
    else {
        myGui["TmpBtn"].Text := "Tmp"
        ; Buraya ileride kod eklenebilir
    }
}


; =============================================
; CAN POT SİSTEMİ
; =============================================
CanBtnClick(*) {
    global CanOnOff, KontrolSuresi
    CanOnOff := !CanOnOff
    
    if CanOnOff {
        myGui["CanBtn"].Text := "On"
        SetTimer CanPotKontrol, KontrolSuresi
        MsgShow("Can pot sistemi aktif")
    } 
    else {
        myGui["CanBtn"].Text := "Can"
        SetTimer CanPotKontrol, 0
        MsgShow("Can pot sistemi pasif")
    }
}

CanPotKontrol() {
    color := PixelGetColor(fareX, fareY, "RGB")
    if (SubStr(color, 1, 3) = "0x0" || SubStr(color, 1, 3) = "0x1" || SubStr(color, 1, 3) = "0x2") {
        Send "q"
        MsgShow("cana bastım")
    }
}


; =============================================
; BALIK AV SİSTEMİ
; =============================================
Balik(*) {
    global BalikOnOff := !BalikOnOff
     myGui.Hide()
    MouseMove fareX, fareY, 15
    Sleep Random(50, 80)
    if BalikOnOff {
        myGui["balikbtn"].Text := "BalikOn"
        BalikAv()
        SetTimer BalikAv, BalikSüreMax + 1000
    } else {
        myGui["balikbtn"].Text := "BalikOff"
        SetTimer BalikAv, 0
    }
}

BalikAv() {
    Send "Ğ"
    Sleep Random(BalikSüreMin, BalikSüreMax)
    Send "1"
}


; =============================================
; AYARLAR - RENK TAKİP - KONUM TAKİP
; =============================================
AyarlarMenu(*) {
    global BalikOnOff, BalikSüreMin, BalikSüreMax, KontrolSuresi
    
    ; Balığı kapat
    SetTimer BalikAv, 0
    BalikOnOff := 0
    myGui["balikbtn"].Text := "BalikOff"
    
    ayarGui := Gui("+ToolWindow +AlwaysOnTop", "Ayarlar")
    ayarGui.SetFont("s10", "Segoe UI")
    
    ayarGui.Add("Text", "x10 y15 w160", "Balık Minimum Süre:")
    minEdit := ayarGui.Add("Edit", "x180 y12 w80", BalikSüreMin)
    
    ayarGui.Add("Text", "x10 y45 w160", "Balık Maksimum Süre:")
    maxEdit := ayarGui.Add("Edit", "x180 y42 w80", BalikSüreMax)
    
    ayarGui.Add("Text", "x10 y75 w160", "Can & Renk Kontrol Süresi:")
    kontrolEdit := ayarGui.Add("Edit", "x180 y72 w80", KontrolSuresi)
    
    ayarGui.Add("Button", "x80 y140 w100 h30 Default", "Tamam").OnEvent("Click", (*) => KaydetAyar())
    
    ayarGui.Show("x" fareX+50 " y" fareY)
    
    KaydetAyar(*) {
        global BalikSüreMin, BalikSüreMax, KontrolSuresi
        BalikSüreMin := Integer(minEdit.Value)
        BalikSüreMax := Integer(maxEdit.Value)
        KontrolSuresi := Integer(kontrolEdit.Value)
        ayarGui.Destroy()
        MsgShow("Ayarlar güncellendi")
    }
}

RenkTakipMenu(*) {
    global fareX, fareY, KontrolSuresi
    
    myGui.Hide()
    
    global RenkTakipGui := Gui("+ToolWindow +AlwaysOnTop", "Renk Takip")
    RenkTakipGui.SetFont("s10", "Segoe UI")
    
    global RT_XText := RenkTakipGui.Add("Text", "x10 y10 w200", "X: " fareX " | Y: " fareY)
    global RT_RenkText := RenkTakipGui.Add("Text", "x10 y35 w200", "Renk: ------")
    
    RenkTakipGui.Add("Button", "x10 y65 w100 h30", "Kopyala").OnEvent("Click", RenkKopyala)
    
    RenkTakipGui.Show("x" fareX " y" fareY-50)
    WinSetTransparent(150, "ahk_id " RenkTakipGui.Hwnd)
    RenkTakipGui.OnEvent("Close", RenkTakipGui_Close)
    SetTimer RenkGuncelle, KontrolSuresi
}

RenkGuncelle() {
    global RT_XText, RT_RenkText, fareX, fareY
    
    color := PixelGetColor(fareX, fareY, "RGB")
    RT_XText.Text := "X: " fareX " | Y: " fareY
    RT_RenkText.Text := "Renk: " color
}

RenkKopyala(*) {
    global fareX, fareY
    color := PixelGetColor(fareX, fareY, "RGB")
    A_Clipboard := fareX "," fareY "," color
    MsgShow("Kopyalandı: " fareX "," fareY "," color)
}

RenkTakipGui_Close(*) {
    SetTimer RenkGuncelle, 0
    RenkTakipGui.Destroy()
}

KonumTakipMenu(*) {
    global fareX, fareY, KontrolSuresi
    
    if IsSet(KonumTakipGui) && WinExist("ahk_id " KonumTakipGui.Hwnd) {
        SetTimer KonumGuncelle, 0
        KonumTakipGui.hide()
        return
    }
    
    myGui.Hide()
    
    global KonumTakipGui := Gui("+ToolWindow -Caption +AlwaysOnTop", "Konum Takip")
    KonumTakipGui.SetFont("s10", "Segoe UI")
    
    global KT_XYText := KonumTakipGui.Add("Text", "x10 y8 w180", "X: " fareX " | Y: " fareY)
    
    MouseGetPos &mx, &my
    KonumTakipGui.Show("x" mx " y" my " NoActivate")
    WinSetTransparent(150, "ahk_id " KonumTakipGui.Hwnd)
    KonumTakipGui.OnEvent("Close", KonumTakipGui_Close)
    
    SetTimer KonumGuncelle, KontrolSuresi
}

KonumGuncelle() {
    global KT_XYText, KonumTakipGui
    
    MouseGetPos &mx, &my
    KT_XYText.Text := "X: " mx " | Y: " my
    KonumTakipGui.Move(mx, my)
}

KonumTakipGui_Close(*) {
    SetTimer KonumGuncelle, 0
    KonumTakipGui.Destroy()
}


; =============================================
; YARDIMCI FONKSİYONLAR
; =============================================
MsgShow(Msg) {
    CoordMode "ToolTip", "Client"
    ToolTip Msg, 860, 260
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

itemtavla() {
    MouseMove 480, 362, 15
    Sleep Random(100, 150)
    Click
    Sleep Random(100, 150)
    MouseMove 436, 994, 15
    Sleep Random(100, 150)
    Click
    Sleep Random(100, 150)
    MouseMove 340, 905, 15
    Sleep Random(100, 150)
    Click
    Sleep 500
    Click
    MouseMove 385, 347, 15
}


; =============================================
; HOTKEYLER
; =============================================
$XButton1::{
    if (A_PriorHotkey == "$XButton1" && A_TimeSincePriorHotkey < 300)
    {
        ; Çift tıklama - şu an boş (ileride doldurabilirsin)
        myGui.Hide()
    }
    else
    {
        if (WinExist("ahk_id " myGui.Hwnd)) {
            myGui.Hide()
        } 
        else {
            myGui.Show("x" fareX " y" fareY)
        }
    }
}

^$XButton1::{
    MouseGetPos &X, &Y
    global fareX := X
    global fareY := Y
    MsgShow("Fare konumu güncellendi:`n" X "," Y)
}

~ç::{
    if !OnOffKlavye
        return
    itemtavla()
}

~t::{
    if !OnOffKlavye
        return
    myGui["CanBtn"].Text := "Can"
    SetTimer CanPotKontrol, 0
    global CanOnOff := 0   
    MsgShow("Can pot kapatıldı")
}

~Tab::{
    if !OnOffKlavye
        return
    ; İleride kullanılabilir
}
