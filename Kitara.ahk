#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"
global ScriptOnOff := 0
MsgShow(Msg) {
    ToolTip Msg, 860, 260
    SetTimer () => ToolTip(), -3000
}
Boo() {
    static messages := [
        "Boo ya bastım 🔥",
        "Pardon sana bastım 😅",
        "Haydi sende bas ⚡",
        "Kime bastım 😂",
        "Ona bastım! 👹"
    ]
    randomMsg := messages[Random(1, messages.Length)]
    Send "{Numpad8}"
    MsgShow(randomMsg)
    SetTimer Boo, 0
    SetTimer Boo, Random(4200, 5000)
}
$XButton1::{
   
     global ScriptOnOff := !ScriptOnOff
     if ScriptOnOff {
        SetTimer Boo, Random(4200, 5000)
        static messagesStart := [
        "Beni mi çağırdın 🔥",
        "Yemedi mi? 😅",
        "Basmaya geldim ⚡",
        "Geldim kime basayım. 😂",
        "Tam vaktinde çağırdın amk 👹"
    ]
    randommsgstart := messagesStart[Random(1, messagesStart.Length)]
    MsgShow(randommsgStart)
} 
    else {
        SetTimer Boo, 0
       static messagesStop := [
        "Ben kaçtım 🔥",
        "Çok ararsın beni 😅",
        "Demek kovdun beni. 😂",
        "Çağırdın neden yolluyorsun amk 👹"
    ]
    randomMsgStop := messagesStop[Random(1, messagesStop.Length)]
    MsgShow(randomMsgStop)   
    }
  }
Numpad0::{
    static state := 0
    static list := ["1", "ğ"]
    Send list[state + 1]
    state := Mod(state + 1, list.Length)
}

