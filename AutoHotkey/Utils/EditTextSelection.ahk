#Requires AutoHotkey v2.0

class EditTextSelection {
    static Do(UserFunction) {
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
    
            ; estore the original clipboard.
            Sleep(100) ; Attendre un peu pour s'assurer que le collage est terminé
            A_Clipboard := ClipBoardBackup 
        } else {
            MsgBox("Erreur : Impossible de copier le texte sélectionné.")
        }
        return
    }
}
