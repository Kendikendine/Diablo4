#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
Persistent
SetKeyDelay -1, -1
CoordMode "Mouse", "Client"
CoordMode "Pixel", "Client"
CoordMode "ToolTip", "Client"

global fareX := 913, fareY := 413, KontrolSuresi := 777, RenkTakipGui := ""

RenkTakipMenu(*) {
    global fareX, fareY, KontrolSuresi, RenkTakipGui, RT_XText, RT_RenkText
    RenkTakipGui := Gui("+ToolWindow +AlwaysOnTop", "Renk Takip")
    RenkTakipGui.SetFont("s10", "Segoe UI")
    RT_XText := RenkTakipGui.Add("Text", "x10 y10 w200", "X: " fareX " | Y: " fareY)
    RT_RenkText := RenkTakipGui.Add("Text", "x10 y35 w200", "Renk: ------")
    RenkTakipGui.Add("Button", "x10 y65 w100 h30", "Kopyala").OnEvent("Click", RenkKopyala)
    RenkTakipGui.Show("x" fareX " y" fareY-50)
    WinSetTransparent(150, RenkTakipGui)
    RenkTakipGui.OnEvent("Close", (*) => (SetTimer(RenkGuncelle, 0), RenkTakipGui.Hide()))
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

KoordinatGUI(*) {
    global fareX, fareY
    MouseGetPos &X, &Y
    g := Gui("+ToolWindow +AlwaysOnTop", "Koordinat Ayarla")
    g.SetFont("s10", "Segoe UI")
    g.Add("Text", "x10 y12 w20", "X:")
    ex := g.Add("Edit", "x35 y10 w80 Number", X)
    g.Add("Text", "x130 y12 w20", "Y:")
    ey := g.Add("Edit", "x155 y10 w80 Number", Y)
    g.Add("Button", "x80 y48 w90 h32 Default", "OK").OnEvent("Click", (*) => Kaydet(g, ex, ey))
    g.OnEvent("Close", (*) => g.Hide())
    g.Show("x" X " y" Y)
}

Kaydet(g, ex, ey) {
    global fareX, fareY, RenkTakipGui
    fareX := Integer(ex.Value)
    fareY := Integer(ey.Value)
    g.Hide()
    MsgShow("Koordinatlar güncellendi:`n" fareX ", " fareY)
    if (IsObject(RenkTakipGui) && WinExist("ahk_id " RenkTakipGui.Hwnd))
        RenkGuncelle()
}

^$XButton1::KoordinatGUI()
$XButton1::RenkTakipMenu()

MsgShow(m) {
    ToolTip m, 860, 260
    SetTimer () => ToolTip(), -4000
}

MsgShow("Renk Takip hazır.`nXButton1 menü`nCtrl+XButton1 koordinat")