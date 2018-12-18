; ZotCopy - A handy shortcut for inserting cite keys from Zotero.
; Desi Quintans
; github.com/DesiQuintans/ZotCopy


; Requirements:

; Zotero Standalone needs to be installed and running.
; In Zotero Standalone, Edit → Preferences → Advanced → Shortcuts, the action
; 'Copy Selected Items to Clipboard' should be mapped as Ctrl + Shift + C.
; This is its default setting.


; Keys

; Win + z  (Outside Zotero) Invoke ZotCopy and enter a search query.
; Win + z  (Inside Zotero)  Paste citations into the invoking app.
; Esc      (Inside Zotero)  Escape to the invoking app without doing anything.


; Description

; ZotCopy automates the process of copying citations from Zotero Standalone and
; pasting them into any other program. While ZotCopy and Zotero Standalone are
; running, press Win + z in any other program to invoke a ZotCopy search
; prompt. Type in a search query and hit Enter, and it will be entered as a
; search in Zotero. Select the sources that you want to cite, then press
; Win + z again. The quick citations for those sources will be pasted in.

; You can change the quick citation style by going to Edit → Preferences →
; Export → Quick Copy Default Format. I recommend installing Better BibTeX and
; setting this to Better BibTeX Citation Key Quick Copy, which lets you use
; Pandoc to build the bibliography automatically.


; Acknowledgements

; Thanks to BlackVariant for the icon.
; http://www.iconarchive.com/show/button-ui-requests-5-icons-by-blackvariant/Zotero-icon.html

; Thanks to berban for InputBox() code.
; https://autohotkey.com/board/topic/70407-inputbox-easy-powerful-inputbox-implementation/


; # Code follows below ---------------------------------------




#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory
SetTitleMatchMode, 2 ; Can contain the string anywhere
#SingleInstance force ; Only allow one instance of this script

; # Global variables -----------------------------------------

invoking_win_id :=



; # Program flow ---------------------------------------------

#z::
    if !WinExist("ahk_exe zotero.exe") {
        MsgBox, 16, ZotCopy, Zotero Standalone needs to be running. Please start Zotero.
        return
    }

    ; If the active window is Zotero, the user wants to paste citations for selected sources into a document.
    ; If the active window is NOT Zotero, the user wants to choose sources.
    if WinActive("Zotero") AND WinActive("ahk_class MozillaWindowClass") AND WinActive("ahk_exe zotero.exe") {
        ; User is trying to invoke a fresh instance of ZotCopy from inside Zotero.
        if (invoking_win_id == "") {
            MsgBox, 16, ZotCopy, ZotCopy has no target window. Please go to the app where you want to insert citation keys and call ZotCopy from there with Win + Z.
            return
        }

        return_and_insert(invoking_win_id)
    } else {
        ; Save the details of the invoking application
        WinGet, invoking_win_id, ID, A

        do_search()
    }
return


#IfWinActive ahk_exe zotero.exe

    Esc::
        WinActivate, ahk_id %invoking_window%
    return



; # Private functions ----------------------------------------

; Prompt the user to enter a search string for Zotero.
do_search() {
    ; InputBox, needle, ZotCopy - Enter a search query, , , 400, 100

    ; Using this InputBox code because it puts the InputBox on top of everything else.
    InputBox(needle, "ZotCopy - Enter a search query")

    ; If the user hits Cancel or ESC.
    if (ErrorLevel != 0) {
        ; Do nothing.
        return
    } else {
        WinActivate ahk_exe zotero.exe ; Go to Zotero window
        Send ^{f}                      ; Focus the search bar
        SendRaw % needle               ; Search is incremental, so no need for {Enter}
        Sleep 500                      ; If the Collections pane doesn't have focus after the search is completed, increase this.
        Send {Tab 2}                   ; Go to Collections pane (there is no direct shortcut)
        Send {PgUp 10}                 ; In case we are not at the first entry yet
        Send {-}                       ; Fold all attachments to show only titles
    }
}



; Copy short citations into the calling application
return_and_insert(dest_id) {
    Send ^+{c}                         ; Quick Copy the selected items
    ; Sleep 125                          ; If citations are not pasted properly, uncomment and increase this.
    WinActivate ahk_id %dest_id%       ; Go to the application where ZotCopy was first invoked
    ; Sleep 125                          ; If citations are not pasted properly, uncomment and increase this.

    if WinActive("ahk_exe emacs.exe") {
        Send !{x}yank{Enter}           ; M-x yank, just in case the user has rebinded it from C-y.
    } else {
        Send ^{v}                      ; CUA shortcut works everywhere else.
    }

}



InputBox(ByRef OutputVar="", Title="", Text="", Default="`n", Keystrokes="")
{
	Static KeysToSend, PID, HWND, PreviousEntries
	If (A_ThisLabel <> "InputBox") {
		If HWND
			SetTimer, InputBox, Off
		If !PID {
			Process, Exist
			PID := ErrorLevel
		}
		If Keystrokes
			KeysToSend := Keystrokes
		WinGet, List, List, ahk_class #32770 ahk_pid %PID%
		HWND = `n0x0`n
		Loop %List%
			HWND .= List%A_Index% "`n"
		If InStr(Default, "`n") and (UsePrev := True)
			StringReplace, Default, Default, `n, , All
		If (Title = "")
			Title := SubStr(A_ScriptName, 1, InStr(A_ScriptName, ".") - 1) ": Input"
		SetTimer, InputBox, 20
		StringReplace, Text, Text, `n, `n, UseErrorLevel
		InputBox, CapturedOutput, %Title%, %Text%, , , Text = "" ? 100 : 116 + ErrorLevel * 18 , , , , , % UsePrev and (t := InStr(PreviousEntries, "`r" (w := (u := InStr(Title, " - ")) ? SubStr(Title, 1, u - 1) : Title) "`n")) ? v := SubStr(PreviousEntries, t += (u ? u - 1 : StrLen(Title)) + 2, InStr(PreviousEntries "`r", "`r", 0, t) - t) : Default
		If !(Result := ErrorLevel) {
			OutputVar := CapturedOutput
			If t
				StringReplace, PreviousEntries, PreviousEntries, `r%w%`n%v%, `r%w%`n%OutputVar%
			Else
				PreviousEntries .= "`r" w "`n" OutputVar
		}
		Return Result
	} Else If InStr(HWND, "`n") {
		If !InStr(HWND, "`n" (TempHWND := WinExist("ahk_class #32770 ahk_pid " PID)) "`n") {
			WinDelay := A_WinDelay
			SetWinDelay, -1
			WinSet, AlwaysOnTop, On, % "ahk_id " (HWND := TempHWND)
			WinActivate, ahk_id %HWND%
			If KeysToSend {
				WinWaitActive, ahk_id %HWND%, , 1
				If !ErrorLevel
					SendInput, %KeysToSend%
				KeysToSend =
			}
			SetTimer, InputBox, -400
			SetWinDelay, %WinDelay%
		}
	} Else If WinExist("ahk_id " HWND) {
		WinSet, AlwaysOnTop, On, ahk_id %HWND%
		SetTimer, InputBox, -400
	} Else
		HWND =
	Return
	InputBox:
	Return InputBox()
}

; End of ZotCopy
