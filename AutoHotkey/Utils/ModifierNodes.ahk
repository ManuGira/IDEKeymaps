#Requires AutoHotkey v2.0

#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk

class ModifierNodesBase {
    
    __New(nodes){
        this.std := nodes.std
        this.shift := nodes.shift
        this.ctrl := nodes.ctrl
        this.win := nodes.win
        this.alt := nodes.alt
        this.ctrl_alt := nodes.ctrl_alt
        this.alt_shift := nodes.alt_shift
        this.ctrl_shift := nodes.ctrl_shift
        this.ctrl_alt_shift := nodes.ctrl_alt_shift
    }

    GetNodeList() {
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

        for modNode in this.GetNodeList() {
            modNode.Subscribe((s) => ShowState())
        }
    }

    Reset() {
        for modNode in this.GetNodeList() {
            modNode.Update(false)
        }

        this.std.Update(true)
    }
}

class ModifierNodes extends ModifierNodesBase {
    __New(ctrlNode, altNode, shiftNode, winNode) {
        nodes := {
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
        super.__New(nodes)
    }
}

class GatedModifierNodes extends ModifierNodesBase {
    __New(controlerNode, modifierNodes) {
        nodes := {
            std : GateNode(controlerNode, modifierNodes.std),
            shift : GateNode(controlerNode, modifierNodes.shift),
            ctrl : GateNode(controlerNode, modifierNodes.ctrl),
            win : GateNode(controlerNode, modifierNodes.win),
            alt : GateNode(controlerNode, modifierNodes.alt),

            ctrl_alt : GateNode(controlerNode, modifierNodes.ctrl_alt),
            alt_shift : GateNode(controlerNode, modifierNodes.alt_shift),
            ctrl_shift : GateNode(controlerNode, modifierNodes.ctrl_shift),

            ctrl_alt_shift : GateNode(controlerNode, modifierNodes.ctrl_alt_shift),
        }
        super.__New(nodes)
    }
}
