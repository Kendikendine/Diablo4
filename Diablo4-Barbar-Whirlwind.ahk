; =============================================
; BARBAR WHIRLWIND - D4 HELPER
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
OnOffAutofire := 0
BooOnOff := 0
CanOnOff := 0
BalikOnOff :=0
BooSuresi := 6000
BalikSüreMin := 3000
BalikSüreMax := 5000
KontrolSuresi := 777

; ───── Otomatik Hareket Sistemi ─────
KuzeyX := 954
KuzeyY := 142
DoguX  := 355
DoguY  := 515
GuneyX := 990
GuneyY := 875
BatiX  := 1437
BatiY  := 539
; =============================================
; GUI OLUŞTURMA
; =============================================
myGui := Gui("+ToolWindow +AlwaysOnTop", "Diablo4 Yardımcısı")
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Checkbox", "x5 y10 w90 h30 vClickHelper", "Click Helper")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x95 y10 w90 h30", "Gizle").OnEvent("Click", (*) => myGui.Hide())

myGui.Add("Button", "x5 y40 w90 h30 vbalikbtn ", "BalikOff")
    .OnEvent("Click", Balik)

myGui.Add("Button", "x95 y40 w90 h30","İtem Al")
    .OnEvent("Click", itemal)

myGui.Add("Button", "x5 y70 w180 h30", "Tümünü Sat")
    .OnEvent("Click", HepsiniSat)

myGui.Add("Button", "x5   y100 w45 h30", "^r").OnEvent("Click", mbtn1)
myGui.Add("Button", "x50  y100 w45 h30 vOnOffBtn1", "On").OnEvent("Click", mbtn2)
myGui.Add("Button", "x95  y100 w45 h30 vBooBtn", "Boo")
    .OnEvent("Click", BooBtnClick)
myGui.Add("Button", "x140 y100 w45 h30 vCanBtn", "Can").OnEvent("Click", CanBtnClick)

myGui.OnEvent("Close", (*) => ExitApp())

; Bilgi GUI
myGuiinfo1 := Gui("+ToolWindow +AlwaysOnTop", "İtemlerin Düştüğü Yerler")
myGuiinfo1.SetFont("s10", "Segoe UI")
myGuiinfo1.Add("Text",, "Kafalık: Bartuk`n"
               . "Eldiven: Georgie`n"
               . "Pantolon non bos unuque`n"
               . "Ramaldini silah Butcher`n") 

; Kısayollar GUI
myGuiKisayollar := Gui("+ToolWindow +AlwaysOnTop", "Kısayollar")
myGuiKisayollar.SetFont("s10", "Segoe UI")
myGuiKisayollar.Add("Text",,
    "XButton1 (tek tıklama) → myGui göster/gizle`n" .
    "XButton1 (çift tıklama) → Autofire aç/kapat`n" .
    "Ctrl + XButton1 → Fare konumunu güncelle`n" .
    "RButton (2 sn basılı) → Demir aktif`n" .
    "RButton (4 sn basılı) → Korun + Gazap aktif`n" .
    "RButton Up → Timer'ları kapat`n" .
    "WheelUp → (ClickHelper açıksa)`n" .
    "WheelDown → (ClickHelper açıksa)`n" .
    "t → ClickHelper kapat`n" .
    "Tab → ClickHelper aç`n" .
    "ç → item tavla`n" .
    "ü → Tüm otomatik sistemleri kapat"
)
myGuiKisayollar.OnEvent("Close", (*) => myGuiKisayollar.Hide())


; =============================================
; MENÜ OLUŞTURMA
; =============================================
mymenuBar := MenuBar()
infoMenu := Menu()
infoMenu.Add("İtemler", (*) => (myGui.Hide(), myGuiinfo1.Show("x" fareX " y" fareY) ))
infoMenu.Add("WWBarb Build", (*) => (myGui.Hide(), Run("https://d4builds.gg/builds/whirlwind-barbarian-endgame/?var=6")))
infoMenu.Add("Kısayollar", (*) => (myGui.Hide(), myGuiKisayollar.Show("x" fareX " y" fareY)))
mymenuBar.Add("Bilgi", infoMenu)

balikMenu := Menu()
balikMenu.Add("Ayarlar", AyarlarMenu)
balikMenu.Add("Renk Takip", RenkTakipMenu)
balikMenu.Add("Konum Takip", KonumTakipMenu)
balikMenu.Add("Otomatik", OtomatikHareketBaslat)
mymenuBar.Add("Araclar", balikMenu)

myGui.MenuBar := mymenuBar


; =============================================
; GUI BUTON VE EVENT FONKSİYONLARI
; =============================================
CheckChanged(*) {
    Sleep Random(50, 80)

    if myGui["ClickHelper"].Value {
       MsgShow("Tıklama Yardımcıları Açık")
    } 
    else { 
      MsgShow("Tıklama Yardımcıları Kapalı")
    }
}
    
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
; BOO SİSTEMİ
; =============================================
BooBtnClick(*) {
    global BooOnOff, BooSuresi
    
    BooOnOff := !BooOnOff
    
    if BooOnOff {
        myGui["BooBtn"].Text := "On"
        ;Kodu Yaz Boo açıkken
    } 
    else {
        myGui["BooBtn"].Text := "Boo"
        ;Kodu yaz Boo Kapalıyken
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
    global BalikOnOff, BalikSüreMin, BalikSüreMax, KontrolSuresi, BooSuresi
    
    ; Balığı kapat
    SetTimer BalikAv, 0
    BalikOnOff := 0
    myGui["balikbtn"].Text := "BalikOff"
    
    ayarGui := Gui("+ToolWindow +AlwaysOnTop", "Ayarlar")
    ayarGui.SetFont("s10", "Segoe UI")
    
    ayarGui.Add("Text", "x10 y15 w160", "Balık Minimum Süre (ms):")
    minEdit := ayarGui.Add("Edit", "x180 y12 w80", BalikSüreMin)
    
    ayarGui.Add("Text", "x10 y45 w160", "Balık Maksimum Süre (ms):")
    maxEdit := ayarGui.Add("Edit", "x180 y42 w80", BalikSüreMax)
    
    ayarGui.Add("Text", "x10 y75 w160", "Can & Renk Kontrol Süresi (ms):")
    kontrolEdit := ayarGui.Add("Edit", "x180 y72 w80", KontrolSuresi)
    
    ayarGui.Add("Text", "x10 y105 w160", "Boo Süresi (ms):")
    booEdit := ayarGui.Add("Edit", "x180 y102 w80", BooSuresi)
    
    ayarGui.Add("Button", "x80 y140 w100 h30 Default", "Tamam").OnEvent("Click", (*) => KaydetAyar())
    
    ayarGui.Show("x" fareX+50 " y" fareY)
    
    KaydetAyar(*) {
        global BalikSüreMin, BalikSüreMax, KontrolSuresi, BooSuresi
        BalikSüreMin := Integer(minEdit.Value)
        BalikSüreMax := Integer(maxEdit.Value)
        KontrolSuresi := Integer(kontrolEdit.Value)
        BooSuresi     := Integer(booEdit.Value)
        ayarGui.Destroy()
        MsgShow("Ayarlar güncellendi:`nBalık Min: " BalikSüreMin " ms`nBalık Max: " BalikSüreMax " ms`nKontrol Süresi: " KontrolSuresi " ms`nBoo Süresi: " BooSuresi " ms")
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
; OTOMATİK HAREKET VE AUTOFIRE SİSTEMİ
; =============================================
OtomatikHareketBaslat(*) {
    myGui.Hide()
    Sleep Random(50, 80)
    myGui["OnOffBtn1"].Text := "On"
     global OnOffKlavye := 1
    Sleep Random(50, 80)
    Boo()
    SetTimer Boo, BooSuresi

    SetTimer CanPotKontrol, KontrolSuresi

    autofireon()

    SetTimer AutoMoveCycle, 3000
    
    MsgShow("Otomatik Hareket Sistemi BAŞLADI")
}

AutoMoveCycle() {
    static points := [
        {x: KuzeyX, y: KuzeyY},
        {x: DoguX,  y: DoguY},
        {x: GuneyX, y: GuneyY},
        {x: BatiX,  y: BatiY}
    ]
    static index := 1

    point := points[index]
    MouseMove point.x, point.y, 15
    
    index++
    if (index > 4)
        index := 1
}

Demir() {
    Send "{Shift down}"
    Click "Left"
    Sleep Random(50, 80)
    Send "{Shift up}"
}

GazapKontrol() {
    static x := 1011
    static y := 1103
    static forbiddenColor1 := 0x3C2718
    static forbiddenColor2 := 0x030303
    
    color := PixelGetColor(x, y, "RGB")
    
    ; Eğer renk yasak renklerden biri ise basma
    if (color = forbiddenColor1 || color = forbiddenColor2) {
        return
    }
    
    ; İki yasaklı renkten farklıysa Gazap bas
    Send "4"
    MsgShow("sana bastım")
}

MeydanOkuKontrol() {
    static x := 802
    static y := 1109
    static forbiddenColor1 := 0x3F2B1E
    static forbiddenColor2 := 0x100F10
    
    color := PixelGetColor(x, y, "RGB")
    
    ; Eğer renk yasak renklerden biri ise basma
    if (color = forbiddenColor1 || color = forbiddenColor2) {
        return
    }
    
    ; İki yasaklı renkten farklıysa "1" tuşuna bas (Meydan Oku)
    Send "1"
 MsgShow("1'e bastım")
}
SavasNaraKontrol() {
    static x := 943
    static y := 1103
    static forbiddenColor1 := 0x3C2717
    static forbiddenColor2 := 0x010101
    
    color := PixelGetColor(x, y, "RGB")
    
    ; Eğer renk yasak renklerden biri ise basma
    if (color = forbiddenColor1 || color = forbiddenColor2) {
        return
    }
    
    ; İki yasaklı renkten farklıysa "3" tuşuna bas (Savaş Narası)
    Send "3"
 MsgShow("3'e bastım")
}
DemirKontrol() {
    static x := 1085
    static y := 1116
    static forbiddenColor1 := 0x3C2819
    static forbiddenColor2 := 0x060606
    
    color := PixelGetColor(x, y, "RGB")
    
    ; Eğer renk yasak renklerden biri ise basma
    if (color = forbiddenColor1 || color = forbiddenColor2) {
        return
    }
    
    ; İki yasaklı renkten farklıysa Demir() fonksiyonunu çağır
    Demir()
 MsgShow(" kime bastım")
}

Boo() {
    Send "2"
    MsgShow("2'e bastım")
    ;Sleep Random(200, 300)
    ;Send "{Space}"
}

autofireon() {
   GazapKontrol()
   Sleep Random(200, 300)
   ; DemirKontrol() 
   Sleep Random(200, 300)
   SavasNaraKontrol()
   Sleep Random(200, 300)
   MeydanOkuKontrol()
   Sleep Random(200, 300)
   Boo()
    SetTimer GazapKontrol, 1300
    ; SetTimer DemirKontrol, 1000
    SetTimer SavasNaraKontrol, 1100
    SetTimer MeydanOkuKontrol, 1200
    SetTimer Boo, BooSuresi
    Send "{RButton down}"
}

autofireoff() {
    SetTimer GazapKontrol, 0
    ; SetTimer DemirKontrol, 0
    SetTimer SavasNaraKontrol, 0
    SetTimer MeydanOkuKontrol, 0
    SetTimer Boo, 0
    Send "{RButton up}"
}


; =============================================
; HOTKEYLER
; =============================================
$XButton1::{
    if (A_PriorHotkey == "$XButton1" && A_TimeSincePriorHotkey < 300)
    {
        myGui.Hide()   
        global OnOffAutofire := !OnOffAutofire
        if OnOffAutofire {
            autofireon()
            MsgShow("Autofire açık")
        } 
        else {
            autofireoff()
            MsgShow("Autofire kapalı")
        }
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

~$RButton::{
    if !myGui["ClickHelper"].Value
        return

    if !KeyWait("RButton", "T2")
    {
   SavasNaraKontrol()
   Sleep Random(200, 300)
   Boo()
   Sleep Random(200, 300)
   MeydanOkuKontrol()
    SetTimer Boo, BooSuresi
    SetTimer SavasNaraKontrol, 1100
    SetTimer MeydanOkuKontrol, 1200

        if !KeyWait("RButton", "T2")
        {
              GazapKontrol()
              Sleep Random(200, 300)
              ; DemirKontrol()
              SetTimer GazapKontrol, 1300
             ; SetTimer DemirKontrol, 1000
        }
    }
}

~RButton Up::{
    if !myGui["ClickHelper"].Value
        return
    SetTimer GazapKontrol, 0
    SetTimer Boo, 0
    ; SetTimer DemirKontrol, 0
    SetTimer SavasNaraKontrol, 0
    SetTimer MeydanOkuKontrol, 0
}

~$WheelUp::{
    if !myGui["ClickHelper"].Value
    {
       Sleep 50
        return
    }
}

~$WheelDown::{
    if !myGui["ClickHelper"].Value
    {
       Sleep 50
        return
    }
}

~t::{
    if !OnOffKlavye
        return
    myGui["ClickHelper"].Value := 0
    myGui["CanBtn"].Text := "Can"
    SetTimer CanPotKontrol, 0
    global CanOnOff := 0   
}

~Tab::{
    if !OnOffKlavye
        return
    myGui["ClickHelper"].Value := 1
}

~ç::{
    if !OnOffKlavye
        return
    itemtavla()
}

~ü::{
    if !OnOffKlavye
        return

    SetTimer AutoMoveCycle, 0
    SetTimer Boo, 0
    SetTimer CanPotKontrol, 0
    SetTimer GazapKontrol, 0
    ; SetTimer DemirKontrol, 0
    SetTimer SavasNaraKontrol, 0
    SetTimer MeydanOkuKontrol, 0
    SetTimer BalikAv, 0

    autofireoff()

    global OnOffKlavye   := 1
    global OnOffAutofire := 0
    global BooOnOff      := 0
    global CanOnOff      := 0
    global BalikOnOff    := 0

    myGui["OnOffBtn1"].Text := "On"
    myGui["BooBtn"].Text    := "Boo"
    myGui["CanBtn"].Text    := "Can"
    myGui["balikbtn"].Text  := "BalikOff"

    myGui["ClickHelper"].Value := 0

    MsgShow("ACİL DURDURMA - Tüm sistemler sıfırlandı")
}
