#Requires AutoHotkey v2.0

#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk

class ModifierNodesBase {
    __New(keyNodes, stateNodes){
        this.shift_key := keyNodes.shift
        this.alt_key := keyNodes.alt
        this.ctrl_key := keyNodes.ctrl
        this.win_key := keyNodes.win

        this.std := stateNodes.std
        this.shift := stateNodes.shift
        this.ctrl := stateNodes.ctrl
        this.win := stateNodes.win
        this.alt := stateNodes.alt
        this.ctrl_alt := stateNodes.ctrl_alt
        this.alt_shift := stateNodes.alt_shift
        this.ctrl_shift := stateNodes.ctrl_shift
        this.ctrl_alt_shift := stateNodes.ctrl_alt_shift
    }

    GetStateNodeList() {
        return [
            this.std,
            this.shift,
            this.ctrl,
            this.win,
            this.alt,
            this.ctrl_alt,
            this.alt_shift,
            this.ctrl_shift,
            this.ctrl_alt_shift,
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
            Utils.TempToolTip(stateStr, 2000)
        }

        for modNode in this.GetStateNodeList() {
            modNode.Subscribe((s) => ShowState())
        }
    }

    Reset() {
        for modNode in this.GetStateNodeList() {
            modNode.Update(false)
        }

        this.std.Update(true)
    }
}

class ModifierNodes extends ModifierNodesBase {
    __New(ctrlNode, altNode, shiftNode, winNode) {
        keyNodes := {
            ctrl : ctrlNode,
            alt : altNode,
            shift : shiftNode,
            win : winNode,
        }

        stateNodes := {
            std : AndNode([NotNode(OrNode([shiftNode, altNode, ctrlNode, winNode]))]),
            shift : AndNode([shiftNode, NotNode(OrNode([altNode, ctrlNode, winNode]))]),
            ctrl : AndNode([ctrlNode, NotNode(OrNode([shiftNode, altNode, winNode]))]),
            win : AndNode([winNode, NotNode(OrNode([shiftNode, altNode, ctrlNode]))]),
            alt : AndNode([altNode, NotNode(OrNode([shiftNode, ctrlNode, winNode]))]),

            ctrl_alt : AndNode([ctrlNode, altNode, NotNode(OrNode([shiftNode, winNode]))]),
            alt_shift : AndNode([altNode, shiftNode, NotNode(OrNode([ctrlNode, winNode]))]),
            ctrl_shift : AndNode([ctrlNode, shiftNode, NotNode(OrNode([altNode, winNode]))]),

            ctrl_alt_shift : AndNode([ctrlNode, altNode, shiftNode, NotNode(winNode)]),
        }
        super.__New(keyNodes, stateNodes)
    }
}
