#Requires AutoHotkey v2.0

#Include OnKeyPress.ahk

global isMappingActive := false

countMax := 4
global countDown := countMax  ; Pour enregistrer le dernier temps d'activité

#HotIf isMappingActive
#Include EasySpecialCharacters.ahk
#HotIf  ; Fin de la condition

; Fonction pour désactiver temporairement le mapping
DisableMapping() {
    global
    isMappingActive := false
    ToolTip("Disable Mapping ", , , 1)
    SetTimer () => ToolTip(), -2000
}

EnableMappingTemp(key) {
    global
    if isMappingActive {
        countDown := countMax  ; Réinitialise le temps d'action
    }
    ToolTip("Enable Mapping: " key, , , 1)
    SetTimer () => ToolTip(), -2000
}

; Function to handle keypresses
; MyCallback(key) {
;     ToolTip("Key pressed MyCallback: " key, , , 1) ; Show the key pressed
;     Sleep(500) ; Keep the tooltip visible for a short time
;     ToolTip("") ; Clear the tooltip
; }

; Hotkey pour activer/désactiver temporairement le mapping (Alt+Space)
!Space:: {
    global
    if isMappingActive {
        isMappingActive := false
    } else {
        isMappingActive := true
        countDown := countMax  ; Réinitialise le temps d'action    
    }
    Return
}

OnKeyPressSubscribe(EnableMappingTemp)

; Fonction pour réactiver le mapping après 2 secondes d'inactivité
CheckActivity() {
    global
    if isMappingActive {
        if (countDown > 0) {  ; Si 2 secondes se sont écoulées
            countDown := countDown - 1
        } else {
            isMappingActive := false
        }
    }
}

; Timer qui vérifie l'inactivité toutes les 500ms (demi-seconde)
SetTimer(CheckActivity, 500)
