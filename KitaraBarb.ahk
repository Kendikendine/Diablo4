#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"

; =============================================
; GUI OLUŞTURMA
; =============================================

;Ana GUI
myGui := Gui("+ToolWindow +AlwaysOnTop", "Ayarlar")
myGui.SetFont("s10", "Segoe UI")

myGui.Add("Checkbox", "x5 y10 w90 h30 vClickHelper", "Click Helper")
    .OnEvent("Click", CheckChanged)

myGui.Add("Button", "x95 y10 w90 h30", "Gizle").OnEvent("Click", (*) => myGui.Hide())

myGui.OnEvent("Close", (*) => ExitApp())

; Bilgi GUI
myGuiinfo1 := Gui("+ToolWindow +AlwaysOnTop", "İtemlerin Düştüğü Yerler")
myGuiinfo1.SetFont("s10", "Segoe UI")
myGuiinfo1.Add("Text",, "Kafalık: Bartuk`n"
               . "Göğüs zırhı: Duriel`n"
               . "Pantolon Butcher`n"
               . "Ramaldini silah Butcher`n") 

; Kısayollar GUI
myGuiKisayollar := Gui("+ToolWindow +AlwaysOnTop", "Kısayollar")
myGuiKisayollar.SetFont("s10", "Segoe UI")
myGuiKisayollar.Add("Text",,
    "XButton1 tek tıklama → Timerler aç/kapat`n" .
    "XButton1 çift tıklama → Ayarlar GUI aç`n" .
    "XButton1 basılı tutma → Tüm skill tuşlarını bas`n" .
    "LButton (2 sn basılı) → Mesaj göster (2 saniye)`n" .
    "LButton (4 sn basılı) → Mesaj göster (4 saniye)`n" .
    "LButton bırakma → ClickHelper açıksa işlem yapar`n" .
    "Shift + XButton1 → Hepsini Sat`n" .
    "Ctrl + XButton1 → İtemleri Al`n" .
    "Alt + XButton1 → Item Tavla"
)

;Mesaj GUI
MsgGui := Gui("+AlwaysOnTop -Caption +ToolWindow  +E0x20")
MsgGui.BackColor := "010101"
MsgGui.SetFont("s18 cYellow bold", "Segoe UI")
;WinSetTransparent(50, MsgGui)
WinSetTransColor("010101", MsgGui)

MsgText := MsgGui.AddText("x10 y10 w400 Center BackgroundTrans", "")

; =============================================
; MENÜ OLUŞTURMA
; =============================================
mymenuBar := MenuBar()
infoMenu := Menu()
infoMenu.Add("İtemler", (*) => (myGui.Hide(), myGuiinfo1.Show("x750 y250") ))
infoMenu.Add("ChargeBarb Build", (*) => (myGui.Hide(), Run("https://d4builds.gg/builds/charge-barbarian-endgame/?var=0")))
infoMenu.Add("Kısayollar", (*) => (myGui.Hide(), myGuiKisayollar.Show("x750 y250")))
mymenuBar.Add("Bilgi", infoMenu)

myGui.MenuBar := mymenuBar

; =========Temel Fonksiyonlar================
MsgShow(Msg) {
    global MsgText, MsgGui
    
    MsgText.Text := Msg
    MsgGui.Show("x750 y250 NoActivate")
    
    ; Eski timer'ları temizle
    SetTimer((*) => MsgGui.Hide(), 0)
    
    ; Yeni timer
    SetTimer((*) => (IsObject(MsgGui) ? MsgGui.Hide() : 0), -2000)
}
MsgShow("Kitara Barbar")
; ===== Mesajlar =====
GetRndMsg(which) {
    static messages := Map(
        1, [  ; Başlangıç mesajları
            "Beni mi çağırdın 🔥",
            "Yemedi mi? 😅",
            "Basmaya geldim ⚡",
            "Geldim kime basayım. 😂",
            "Tam vaktinde çağırdın amk 👹"
        ],
        2, [  ; Durdurma mesajları
            "Ben kaçtım 🔥",
            "Çok ararsın beni 😅",
            "Demek kovdun beni. 😂",
            "Çağırdın neden yolluyorsun amk 👹"
        ],
        3, [  ; Bastım mesajları
            "Sana bastım 🔥",
            "Kime bastım  😂",
            "Ona bastım ⚡",
            "Bize bastım 👹",
            "Size bastım 🔥",
            "Bana bastılar 😅",
            "Sana bastılar 😂",
            "Ona bastılar  👹"
        ]
    )
    
    if messages.Has(which)
        return messages[which][Random(1, messages[which].Length)]
    
    return "Parametreyi kontrol et"
}

CheckChanged(*) {
    Sleep Random(50, 80)

    if myGui["ClickHelper"].Value {
       MsgShow("Tıklama Yardımcıları Açık")
    } 
    else { 
      MsgShow("Tıklama Yardımcıları Kapalı")
    }
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

itemtavla(*) {
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

HepsiniSat(*) {
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

    MsgShow("Hepsi Satıldı")
}

itemal(*) {
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

; ===== Hotkeyler =====

$XButton1:: {
    ; İlk KeyWait: tuş bırakılana kadar bekle, 0.15 saniye sınır
    if !KeyWait("XButton1", "T0.250") {
        ; Tuş bırakılmadı → basılı tutma
            TmSkiller()     
return
    }

    ; İkinci KeyWait: tekrar basılmasını bekle, 0.15 saniye sınır
    if KeyWait("XButton1", "D T0.250") {
        ; Çift tıklama algılandı
         myGui.Show("x750 y350")
        return
    }

    ; Eğer ikinci basış gelmezse → tek tıklama
    TimerlerOpenClose()
}

~$LButton::{
    if !myGui["ClickHelper"].Value
        return

    if !KeyWait("LButton", "T2")
    {
;buraya basıldıktan 2 saniye sonra çalışacak şeyler yaz
      SetTimer  Zipla , 1200

        if !KeyWait("LButton", "T2")
        {
             ;burayada 4 saniye sonra çalışacak şeylerii yaz
        }
    }
}

~LButton Up::{
    if !myGui["ClickHelper"].Value
        return
;buraya elini bırakınca yazılan şeyleri yaz
SetTimer Zipla , 0

}

+$XButton1::HepsiniSat()     ; Shift + XButton1
^$XButton1::itemal()         ; Ctrl + XButton1
!$XButton1::itemtavla()      ; Alt + XButton1

; =========Karakter Fonksiyonları================
TimerlerOpenClose() {
  
    static TimersOnOff :=0
    TimersOnOff := !TimersOnOff
    
    if TimersOnOff {
        MsgShow( GetRndMsg(1) )    ; Başlangıç mesajı
        Sleep(Random(1000, 1200))
        TimerlerOpen()      
}
    else {
        MsgShow( GetRndMsg(2) )    ; Durdurma mesajı
       TimerlerClose()
    }
}

TmSkiller() {
    MsgShow("Tüm Tuşlara bastık")
    
    for key in ["Numpad2", "Numpad1", "Numpad8", "Numpad4"] {
        Send("{" key "}")
        Sleep(Random(350, 450))
    }
}

YürekNara(){
    Send "{Numpad8}"
    MsgShow( GetRndMsg(3) )
    SetTimer(YürekNara, Random(7200, 8000))
}

Zipla(){
   Send "{Numpad7}"
   Sleep(Random(350, 450))
   Send "{Numpad7}"
}

 MeydanokuKontrol() {
    static x := 865, y := 1096
    static f1 := 0x3D291B, f2 := 0x0A0B0A
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return

     Send "{Numpad4}"
    MsgShow( GetRndMsg(3) )
}

SavasNarasiKontrol() {
    static x := 930, y := 1096
    static f1 := 0x3C2719, f2 := 0x050405
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return

    Send "{Numpad1}"
    MsgShow( GetRndMsg(3) )
}

    GazapKontrol() {
    static x := 1072, y := 1095
    static f1 := 0x4A3D33, f2 := 0x2C2D2C
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return

    
    Send "{Numpad2}"
    MsgShow(GetRndMsg(3) )
}

TimerlerOpen() {
    GazapKontrol()
    SetTimer GazapKontrol , 1000
    Sleep(Random(350, 450))
    SavasNarasiKontrol()
    SetTimer SavasNarasiKontrol , 1100
    Sleep(Random(350, 450))
    MeydanokuKontrol()
    SetTimer MeydanokuKontrol , 1200
    Sleep(Random(350, 450))
    YürekNara()
}

TimerlerClose() {
    SetTimer GazapKontrol , 0
    SetTimer SavasNarasiKontrol , 0
    SetTimer MeydanokuKontrol , 0
    SetTimer YürekNara , 0
}
