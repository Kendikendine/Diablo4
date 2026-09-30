#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"
global startTime := A_TickCount
global fareX := 913, fareY := 413
global fareLastX := 713, fareLastY := 213

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
myGuiinfo1.Add("Text",, "Kafalık: LolrdZir`n"
               . "Silah Feorgia`n"
               . "Yüzük Hearbringer`n") 

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
infoMenu.Add("Sıfırla", ResetStartTime)
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
MsgShow("Cata Druid")
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
    Sleep Random(100, 150)
    Click 480, 362, "Left"
    Sleep Random(250, 350)
    Click 436, 994, "Left"
    Sleep Random(250, 350)
    Click 340, 905, "Left"
    Sleep Random(250, 350)
    Click "Left"
    Sleep 500
    Click 385, 347, 0
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

GetElapsedTime() {
    elapsed := (A_TickCount - startTime) // 1000  ; saniye cinsinden fark
    hours   := Floor(elapsed / 3600)
    minutes := Floor(Mod(elapsed, 3600) / 60)
    seconds := Mod(elapsed, 60)
    return Format("{:02}:{:02}:{:02}", hours, minutes, seconds)
}
 
ResetStartTime(*) {
    global startTime
    startTime := A_TickCount
    myGui.Hide()
}

; ===== Hotkeyler =====

$XButton1:: {
    ; İlk KeyWait: tuş bırakılana kadar bekle, 0.15 saniye sınır
    if !KeyWait("XButton1", "T0.250") {
        ; Tuş bırakılmadı → basılı tutma
        MsgShow (GetElapsedTime())
        myGui.Show("x750 y350") 
        return
    }

    ; İkinci KeyWait: tekrar basılmasını bekle, 0.15 saniye sınır
    if KeyWait("XButton1", "D T0.250") {
        ; Çift tıklama algılandı
         MsgShow("çift tıklama")
        return
    }

    ; Eğer ikinci basış gelmezse → tek tıklama
      TimerlerOpenClose()
     
}

/*
~$LButton::{
    if !myGui["ClickHelper"].Value
        return

    if !KeyWait("LButton", "T2")
    {
;buraya basıldıktan 2 saniye sonra çalışacak şeyler yaz

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
}
*/
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
        Sleep(Random(1000, 1200))
      TimerlerClose()
    }
}



TimerlerOpen() {
   MsgShow("Timerler olsa açacam aq")
}

TimerlerClose() {
MsgShow("Timerler olsa kapayacam aq")
}