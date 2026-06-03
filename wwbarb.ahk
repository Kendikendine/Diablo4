#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetKeyDelay -1, -1
SetMouseDelay -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
global ScriptOnOff := 0
MsgShow(Msg) {
    CoordMode "ToolTip", "Client"
    ToolTip Msg, 860, 260
    SetTimer () => ToolTip(), -3000
}
CanPotKontrol() {
    static x := 573, y := 1058
    color := PixelGetColor(x, y, "RGB")
    if (SubStr(color, 1, 3) = "0x0" || SubStr(color, 1, 3) = "0x1" || SubStr(color, 1, 3) = "0x2") {
        Send "q"
        MsgShow("Can potu basıldı")
 }
}

Boo() {
    Send "2"
    MsgShow("2 ye bastım")
}

GazapKontrol() {
    static x := 1011, y := 1103
    static f1 := 0x3C2718, f2 := 0x030303
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return
    Send "4"
    MsgShow("Sana bastım")
}

MeydanOkuKontrol() {
    static x := 802, y := 1109
    static f1 := 0x3F2B1E, f2 := 0x100F10
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return
    Send "1"
    MsgShow("Birine bastım")
}

SavasNaraKontrol() {
    static x := 943, y := 1103
    static f1 := 0x3C2717, f2 := 0x010101
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return
    Send "3"
    MsgShow("3 e bastım")
}

DemirKontrol() {
    static x := 1085, y := 1116
    static f1 := 0x3C2819, f2 := 0x060606
    color := PixelGetColor(x, y, "RGB")
    if (color = f1 || color = f2)
        return
    Send "{Shift down}"
    Click "Left"
    Sleep Random(50, 80)
    Send "{Shift up}"
    MsgShow("Kime bastım")
}

BaslangicRotasyonu() {
    for f in [SavasNaraKontrol, Boo, MeydanOkuKontrol, GazapKontrol, DemirKontrol]
        f(), Sleep(Random(200, 300))
}
$XButton1::{
    global ScriptOnOff := !ScriptOnOff
    if ScriptOnOff {
        MsgShow("SCRIPT AÇIK"), BaslangicRotasyonu()
        for t in [[CanPotKontrol,500],[Boo,6000],[SavasNaraKontrol,1100],[MeydanOkuKontrol,1200],[GazapKontrol,1300],[DemirKontrol,1000]]
            SetTimer t[1], t[2]
    } else {
        MsgShow("SCRIPT KAPALI")
        for t in [[CanPotKontrol],[Boo],[SavasNaraKontrol],[MeydanOkuKontrol],[GazapKontrol],[DemirKontrol]]
            SetTimer t[1], 0
    }
}
ç::{
    static state := 1
    Send( (state := !state) ? "1" : "ğ" )
}