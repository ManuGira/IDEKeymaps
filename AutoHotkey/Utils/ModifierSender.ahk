#Requires AutoHotkey v2.0

class ModifierSender {

    __New(){
        this.enableNodesList := []
        this.modifierNodesList := []
    }

    Add(enableNode, modifierNodes) {
        enableNode.Subscribe((state) => state ? Apply)
    }

    SendModInput(state, key) {
        if state {
            SendInput("{Blind}{" key " Down}")
        } else {
            SendInput("{Blind}{" key " Up}")
        }
    }

    SendShift(state) {
        this.SendModInput(state, "Shift")
    }

    SendAlt(state) {
        this.SendModInput(state, "Alt")
    }

    SendCtrl(state) {
        this.SendModInput(state, "Control")
    }

    SendWin(state) {
        this.SendModInput(state, "LWin")
    }
        
    __New() {
    }
}