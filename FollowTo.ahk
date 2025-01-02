#Persistent
#NoEnv
#SingleInstance Force

iniFilePath := "config.ini"

IniRead, url1, %iniFilePath%, webhooks, url1
IniRead, url2, %iniFilePath%, webhooks, url2
IniRead, url3, %iniFilePath%, webhooks, url3
IniRead, url4, %iniFilePath%, webhooks, url4
IniRead, url5, %iniFilePath%, webhooks, url5
IniRead, sticky, %iniFilePath%, settings, sticky
IniRead, ready, %iniFilePath%, settings, ready

sticky := (sticky = 1) ? "Checked" : ""
ready := (ready = 1) ? "Checked" : ""

GuiShowFirst:
    Gui, Destroy
    If (sticky = "Checked")
        Gui, +AlwaysOnTop
    Gui, Add, Text,, URL 1:
    Gui, Add, Edit, vURL1 w300, %url1%
    Gui, Add, Text,, URL 2:
    Gui, Add, Edit, vURL2 w300, %url2%
    Gui, Add, Text,, URL 3:
    Gui, Add, Edit, vURL3 w300, %url3%
    Gui, Add, Text,, URL 4:
    Gui, Add, Edit, vURL4 w300, %url4%
    Gui, Add, Text,, URL 5:
    Gui, Add, Edit, vURL5 w300, %url5%
    Gui, Add, CheckBox, vSticky %sticky%, Always On Top
    Gui, Add, Button, gSaveSettings, Save Settings
    Gui, Add, Button, gOpenMapGUI, Go to Map
    IniRead, ready, %iniFilePath%, settings, ready
    ready := (ready = 1) ? "Checked" : ""
    If (ready = "Checked") {
        GoSub, OpenMapGUI
    } Else {
        Gui, Show, w400, Configuration
    }
return

SaveSettings:
    Gui, Submit, NoHide
    IniWrite, %URL1%, %iniFilePath%, webhooks, url1
    IniWrite, %URL2%, %iniFilePath%, webhooks, url2
    IniWrite, %URL3%, %iniFilePath%, webhooks, url3
    IniWrite, %URL4%, %iniFilePath%, webhooks, url4
    IniWrite, %URL5%, %iniFilePath%, webhooks, url5
    IniWrite, % (Sticky = 1 ? 1 : 0), %iniFilePath%, settings, sticky
    MsgBox, Settings saved successfully!
return

OpenMapGUI:
    IniWrite, 1, %iniFilePath%, settings, ready
    Gui, Destroy
    If (sticky = "Checked")
        Gui, +AlwaysOnTop
    Gui, Add, Picture, w800 h600, map1.jpg

    Gui, Add, Text, x10 y610, Select a Webhook, then tap a field and it'll send the command:
    Gui, Add, Text, x675 y610, Made by riotlsd (@pawselfie)
    Gui, Add, Text, x675 y625, Inspiration by e_lol (@e_wol)
    Gui, Add, Radio, x10 y640 w160 h80 vSelectedWebhook Group Checked, Webhook 1
    Gui, Add, Radio, x170 y640 w160 h80, Webhook 2
    Gui, Add, Radio, x330 y640 w160 h80, Webhook 3
    Gui, Add, Radio, x490 y640 w160 h80, Webhook 4
    Gui, Add, Radio, x650 y640 w160 h80, Webhook 5
    Gui, Add, Button, x10 y720 w60 h40 gOpenFirstGUI, Settings

    Gui, Add, Button, x67 y506 w60 h20 gMapButtonClick, Stump
    Gui, Add, Button, x192 y522 w60 h20 gMapButtonClick, Pineapple
    Gui, Add, Button, x278 y525 w80 h20 gMapButtonClick, MountainTop
    Gui, Add, Button, x520 y505 w60 h20 gMapButtonClick, Pumpkin
    Gui, Add, Button, x520 y462 w60 h20 gMapButtonClick, Cactus
    Gui, Add, Button, x620 y510 w60 h20 gMapButtonClick, PineTree
    Gui, Add, Button, x512 y390 w80 h20 gMapButtonClick, Strawberry
    Gui, Add, Button, x430 y396 w60 h20 gMapButtonClick, Spider
    Gui, Add, Button, x312 y404 w60 h20 gMapButtonClick, Bamboo
    Gui, Add, Button, x628 y316 w60 h20 gMapButtonClick, Rose
    Gui, Add, Button, x554 y112 w80 h20 gMapButtonClick, Coconut
    Gui, Add, Button, x739 y64 w60 h20 gMapButtonClick, Pepper
    Gui, Add, Button, x290 y275 w60 h20 gMapButtonClick, Clover
    Gui, Add, Button, x299 y331 w80 h20 gMapButtonClick, BlueFlower
    Gui, Add, Button, x458 y320 w80 h20 gMapButtonClick, Mushroom
    Gui, Add, Button, x421 y260 w80 h20 gMapButtonClick, Dandelion
    Gui, Add, Button, x541 y290 w80 h20 gMapButtonClick, Sunflower

    Gui, Show, w822 h770, Map GUI
return

MapButtonClick:
    GuiControlGet, ButtonName, Focus
    Gui, Submit, NoHide
    ButtonName := "FollowTo "A_GuiControl
    SelectedURL := ""
        
    Loop, 5 {
        If (SelectedWebhook = A_Index) {
            IniRead, SelectedURL, %iniFilePath%, webhooks, url%A_Index%
            break
        }
    }

    If (!SelectedURL) {
        MsgBox, Make sure the url you selected is properly set.
        return
    }

    HTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HTTP.Open("POST", SelectedURL, False)
    HTTP.SetRequestHeader("Content-Type", "application/json")
    HTTP.Send("{""content"": """ ButtonName """}")
return

OpenFirstGUI:
    Gui, Destroy
    IniWrite, 0, %iniFilePath%, settings, ready
    Goto, GuiShowFirst
return

ExitApp:
    ExitApp
return