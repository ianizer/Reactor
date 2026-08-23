;started: 9/20/2022 11:07 PM
#Include <IanizedFunctions>
#SingleInstance Off
SetBatchLines, -1
SetControlDelay, -1
;store high scores/reaction times in txt file and display them on the top left or something
ReactionTimes := [] ;MaxIndex is also number of PopUps clicked
PopUpSizeMultiplier := 1

Gui, +HwndGuiHwnd +Resize +MaximizeBox

Gui, Show, w500 h500, Reactor
WinMaximize, ahk_id %GuiHwnd%

Gui, Add, Button, % "x" GuiWidth / 2 - 50 " y" GuiHeight / 2 - 50 " w100 h100 gStart vStartButton", Click To Start
Gui, Add, Button, % "x0 y0 Hidden w" (PopUpWidth := GuiWidth // 19.2) " h" (PopUpHeight := GuiHeight // 11.16) " gClick_PopUp vPopUp", Click Me
Gui, Add, Edit, % "x" GuiWidth / 2  - 50 " y" GuiHeight / 2 + 75 " w100 Number gConfigure vNumberOfPopUpsToMake", 10
Gui, Add, Text, x+-145 y+-18 vText1, PopUps:
Gui, Add, Edit, % "x" GuiWidth / 2 - 50 " y" GuiHeight / 2 + 100 " w100 Number gConfigure vMinTimeBetweenPopUps", 500
Gui, Add, Text, x+-263 y+-18 vText2, Min time between PopUps (in ms):
Gui, Add, Edit, % "x" GuiWidth / 2  - 50 " y" GuiHeight / 2 + 125 " w100 Number gConfigure vMaxTimeBetweenPopUps", 1000
Gui, Add, Text, x+-265 y+-18 vText3, Max time between PopUps (in ms):
Gui, Add, Edit, % "x" GuiWidth / 2  - 50 " y" GuiHeight / 2 + 150 " w100 Number gConfigure vPopUpSizeMultiplier", 100
Gui, Add, Text, x+-168 y+-18 vText4, PopUp size`%:

gosub, Configure
return

GuiSize:
	GuiWidth := A_GuiWidth
	GuiHeight := A_GuiHeight
return

Start:
	GuiControl, Hide, StartButton
	GuiControl, Hide, NumberOfPopUpsToMake
	GuiControl, Hide, Text1
	GuiControl, Hide, MinTimeBetweenPopUps
	GuiControl, Hide, Text2
	GuiControl, Hide, MaxTimeBetweenPopUps
	GuiControl, Hide, Text3
	GuiControl, Hide, PopUpSizeMultiplier
	GuiControl, Hide, Text4
	goto, Show_PopUp
return

Restart:
	GuiControl, Show, StartButton
	GuiControl, Show, NumberOfPopUpsToMake
	GuiControl, Show, Text1
	GuiControl, Show, MinTimeBetweenPopUps
	GuiControl, Show, Text2
	GuiControl, Show, MaxTimeBetweenPopUps
	GuiControl, Show, Text3
	GuiControl, Show, PopUpSizeMultiplier
	GuiControl, Show, Text4
return

Configure:
	Gui, Submit, NoHide
	NumberOfPopUpsToMake := (NumberOfPopUpsToMake) ? (NumberOfPopUpsToMake) : (50)
	MinTimeBetweenPopUps := (MinTimeBetweenPopUps) ? (MinTimeBetweenPopUps) : (0)
	MaxTimeBetweenPopUps := (MaxTimeBetweenPopUps) ? (MaxTimeBetweenPopUps) : (0)
	PopUpSizeMultiplier := (PopUpSizeMultiplier) ? (PopUpSizeMultiplier / 100) : (1)
	GuiControl, MoveDraw, PopUp, % "w" (PopUpWidth := PopUpSizeMultiplier * GuiWidth // 19.2) " h" (PopUpHeight := PopUpSizeMultiplier * GuiHeight // 11.16)
return

Show_PopUp:
	if (ReactionTimes.MaxIndex() = NumberOfPopUpsToMake)
	{
		Loop, % ReactionTimes.MaxIndex()
			AverageReactionTime += ReactionTimes[A_Index]
		
		AverageReactionTime /= ReactionTimes.MaxIndex()
		MsgBox % "Average reaction time over " NumberOfPopUpsToMake " PopUps clicked in ms:  " Round(AverageReactionTime, 1)
		AverageReactionTime := 0
		
		ReactionTimes := []
		
		goto, Restart
	}
	SuperAccuSleepBreakable(Random(MinTimeBetweenPopUps, MaxTimeBetweenPopUps), PopUpClicked)
	TimePopUpPoppedUp := A_SuperTickCount()
	GuiControl, Move, PopUp, % "x" Random(0, GuiWidth - PopUpWidth) " y" Random(0, GuiHeight - PopUpHeight)
	GuiControl, Show, PopUp
return

Click_PopUp:
	ReactionTimes.Push(A_SuperTickCount() - TimePopUpPoppedUp)
	GuiControl, Hide, PopUp
	goto, Show_PopUp
return

GuiClose:
*Escape::ExitApp