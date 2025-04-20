#Requires AutoHotkey v2.0

class EditTextSelection {
    static Apply(UserFunction) {
        ; Backup clipboard
        ClipBoardBackup := ClipboardAll()
        A_Clipboard := ""   ; Restore the original clipboard.
        ; Simule un Ctrl+C pour copier la sélection
        Send("^c")
        if ClipWait(0.5) {
            txt := A_Clipboard
            newTxt := UserFunction(txt)
            
            ; Remplace la sélection par le chemin converti
            A_Clipboard := newTxt
            Send("^v")
            
            ; restore the original clipboard.
            Sleep(50) ; Attendre un peu pour s'assurer que le collage est terminé

            ; Sélectionne le texte collé
            Send("{Left " . StrLen(newTxt) . "}") 
            Send("+{Right " . StrLen(newTxt) . "}")

            A_Clipboard := ClipBoardBackup 
        } else {
            MsgBox("Erreur : Impossible de copier le texte sélectionné.")
        }
        return
    }

    static SwapClipboardWithSelection(){
        IsClipboardText() {
            return ClipWait(0.1) && !!StrLen(A_Clipboard)
        }
        if !IsClipboardText()
            return

        ; Backup text clipboard
        txtA := A_Clipboard
        A_Clipboard := ""   ; Restore the original clipboard.
        Send("^c")
        if ClipWait(0.5) {
            txtB := A_Clipboard
            
            A_Clipboard := txtA
            Send("^v")

            Sleep(50) ; Attendre un peu pour s'assurer que le collage est terminé
            A_Clipboard := txtB

            ; Sélectionne le texte collé
            Send("{Left " . StrLen(txtA) . "}") 
            Send("+{Right " . StrLen(txtA) . "}")

            Sleep(50)
        }
    }
}
