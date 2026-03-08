#Requires AutoHotkey v2.0

#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk

class ModifierNodes {
    __New(ctrlNode, altNode, shiftNode, winNode) {
        this.std := AndNode([NotNode(OrNode([shiftNode, altNode, ctrlNode, winNode]))])
        this.shift := AndNode([shiftNode, NotNode(OrNode([altNode, ctrlNode, winNode]))])
        this.ctrl := AndNode([ctrlNode, NotNode(OrNode([shiftNode, altNode, winNode]))])
        this.win := AndNode([winNode, NotNode(OrNode([shiftNode, altNode, ctrlNode]))])
        this.alt := AndNode([altNode, NotNode(OrNode([shiftNode, ctrlNode, winNode]))])

        this.ctrl_alt := AndNode([ctrlNode, altNode, NotNode(OrNode([shiftNode, winNode]))])
        this.alt_shift := AndNode([altNode, shiftNode, NotNode(OrNode([ctrlNode, winNode]))])
        this.ctrl_shift := AndNode([ctrlNode, shiftNode, NotNode(OrNode([altNode, winNode]))])

        this.ctrl_alt_shift := AndNode([ctrlNode, altNode, shiftNode, NotNode(winNode)])

        this.nodesList := [
            this.std, 
            this.shift, 
            this.ctrl, 
            this.win, 
            this.alt,
            this.ctrl_alt,
            this.alt_shift,
            this.ctrl_shift,
            this.ctrl_alt_shift
        ]        
    }

    EnableShowStateOnChange() {
        ShowState(){
            stateStr := "Modifiers: " . "`n"
            stateStr .= "  std:  " . this.std.GetState() . "`n"
            stateStr .= "  shift:  " . this.shift.GetState() . "`n"
            stateStr .= "  ctrl:  " . this.ctrl.GetState() . "`n"
            stateStr .= "  win:  " . this.win.GetState() . "`n"
            stateStr .= "  alt:  " . this.alt.GetState() . "`n"
            stateStr .= "  ctrl_alt:  " . this.ctrl_alt.GetState() . "`n"
            stateStr .= "  alt_shift:  " . this.alt_shift.GetState() . "`n"
            stateStr .= "  ctrl_shift:  " . this.ctrl_shift.GetState() . "`n"
            stateStr .= "  ctrl_alt_shift:  " . this.ctrl_alt_shift.GetState() . "`n"
            TempToolTip(stateStr, 2000)
        }

        for modNode in this.nodesList {
            modNode.Subscribe((s) => ShowState())
        }
    }

    Reset() {
        for modNode in this.nodesList {
            modNode.Update(false)
        }

        this.std.Update(true)
    }
}
