#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"
; ====================== MESAJ FONKSİYONU ======================
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

MsgShow(Msg) {
    ToolTip Msg, 860, 260
    SetTimer () => ToolTip(), -2000
}

SolClick() {
    Click "Right"
    MsgShow( GetRndMsg(3) ) 
    Sleep Random(80, 100)
}


; ============================================================
$XButton1::{
    static ScriptOnOff :=0
    ScriptOnOff := !ScriptOnOff
    
    if ScriptOnOff {
        MsgShow( GetRndMsg(1) )    ; Başlangıç mesajı
        SetTimer SolClick, 7200
        SolClick() 
    }
    else {
        MsgShow( GetRndMsg(2) )    ; Durdurma mesajı
        SetTimer SolClick, 0
    }
}

