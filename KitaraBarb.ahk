#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"


MsgGui := Gui("+AlwaysOnTop -Caption +ToolWindow  +E0x20")
MsgGui.BackColor := "010101"
MsgGui.SetFont("s18 cYellow bold", "Segoe UI")
;WinSetTransparent(50, MsgGui)
WinSetTransColor("010101", MsgGui)

MsgText := MsgGui.AddText("x10 y10 w400 Center BackgroundTrans", "")

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
         MsgShow("Çift Tıkladın")
        return
    }

    ; Eğer ikinci basış gelmezse → tek tıklama
    TimerlerOpenClose()
}

$Numpad2::{
   ShiftSolClick()
}


+$XButton1::HepsiniSat()     ; Shift + XButton1
^$XButton1::itemal()         ; Ctrl + XButton1
!$XButton1::itemtavla()      ; Alt + XButton1
; =========Fonksiyonlar================
TimerlerOpenClose() {
  
    static TimersOnOff :=0
    TimersOnOff := !TimersOnOff
    
    if TimersOnOff {
        MsgShow( GetRndMsg(1) )    ; Başlangıç mesajı
        Sleep(Random(1000, 1200))
        YürekNara()
       
}
    else {
        MsgShow( GetRndMsg(2) )    ; Durdurma mesajı
       SetTimer(YürekNara, 0)
    }
}

ShiftSolClick() {
Send("+{Click}")
}

YürekNara(){
    Send "{Numpad8}"
    MsgShow( GetRndMsg(3) )
    SetTimer(YürekNara, Random(7200, 8000))
}

TmSkiller(){
   MsgShow("Tüm Tuşlara bastık ")
    ShiftSolClick()
    Sleep (Random(300, 400))
    Send "{Numpad4}"
    Sleep (Random(300, 400))
    Send "{Numpad8}"
    Sleep (Random(300, 400))
    Send "{Numpad1}" 
}