#Requires AutoHotkey v2.0

#Include ../Nodes/include.ahk
#Include ../Utils/Utils.ahk
#Include ../Utils/Range.ahk

/*
    Manages 16 reactive state nodes, one for each combination of the four modifier
    keys (Ctrl, Alt, Shift, Win). Each node is active (true) when exactly its
    associated modifier combination is held — i.e. the expected modifiers are all
    pressed and none of the unexpected ones are.

    State nodes are indexed 1–16 using a 4-bit encoding:
        bit 3 (8) = Ctrl, bit 2 (4) = Alt, bit 1 (2) = Shift, bit 0 (1) = Win

    Usage:
        - Pass one key-state node per modifier to __New().
        - Subscribe to stateNodes[index] for a specific modifier combination.
        - Call ComputeIndex() to resolve a boolModifiers object to its index.
        - Call Reset() to force the "no modifiers" state and clear all others.
*/
class ModifierNodes {
    KeyNames := {CTRL:"Control", ALT:"Alt", SHIFT:"Shift", WIN:"LWin"}

    /*
        Creates the 16 modifier-combination state nodes.

        Parameters:
            ctrlNode  - INode tracking the physical Ctrl key state.
            altNode   - INode tracking the physical Alt key state.
            shiftNode - INode tracking the physical Shift key state.
            winNode   - INode tracking the physical Win key state.
    */
    __New(ctrlNode, altNode, shiftNode, winNode) {
        this.keyNodes := Map()
        this.keyNodes[this.KeyNames.CTRL] := ctrlNode
        this.keyNodes[this.KeyNames.ALT] := altNode
        this.keyNodes[this.KeyNames.SHIFT] := shiftNode
        this.keyNodes[this.KeyNames.WIN] := winNode

        this.stateNodes := []
        for index in Range(1, 17) {
            boolModifiers := this.CreateBoolModifiers(index)
            modNode := this._CreateModNode(boolModifiers)
            this.stateNodes.Push(modNode)
        }
    }

    /*
        Builds an AndNode that is true only when exactly the modifiers described
        by boolModifiers are active. Required modifiers feed into the And directly;
        forbidden modifiers are collected into an OrNode which is then negated,
        ensuring no unwanted modifier is held.

        Parameters:
            boolModifiers - Object with boolean fields: ctrl, alt, shift, win.

        Returns: AndNode
    */
    _CreateModNode(boolModifiers){
        truthies := []
        falsies := []
        (boolModifiers.ctrl ? truthies : falsies).Push(this.keyNodes[this.KeyNames.CTRL])
        (boolModifiers.alt ? truthies : falsies).Push(this.keyNodes[this.KeyNames.ALT])
        (boolModifiers.shift ? truthies : falsies).Push(this.keyNodes[this.KeyNames.SHIFT])
        (boolModifiers.win ? truthies : falsies).Push(this.keyNodes[this.KeyNames.WIN])

        truthies.Push(NotNode(OrNode(falsies)))
        modNode := AndNode(truthies)
        return modNode
    }

    /*
        Converts a boolModifiers object to its stateNodes index (0–15).
        Encoding: Ctrl=bit3, Alt=bit2, Shift=bit1, Win=bit0.

        Parameters:
            boolModifiers - Object with boolean fields: ctrl, alt, shift, win.

        Returns: Integer index in [1, 16].
    */
    ComputeIndex(boolModifiers) {
        return 1 + (boolModifiers.ctrl ? 8 : 0) + (boolModifiers.alt ? 4 : 0) + (boolModifiers.shift ? 2 : 0) + (boolModifiers.win ? 1 : 0)
    }

    /*
        Decodes a stateNodes index into a boolModifiers object.
        Each bit of the index maps to one modifier key:
            bit 3 (8) = ctrl, bit 2 (4) = alt, bit 1 (2) = shift, bit 0 (1) = win.

        Parameters:
            index - Integer in [1, 16].

        Returns: Object with boolean fields: ctrl, alt, shift, win.
    */
    CreateBoolModifiers(index) {
        return {
            ctrl: ((index-1) & 8) != 0,
            alt: ((index-1) & 4) != 0,
            shift: ((index-1) & 2) != 0,
            win: ((index-1) & 1) != 0,
        }
    }

    GetNode(boolModifiers){
        index := this.ComputeIndex(boolModifiers)
        return this.stateNodes[index]
    }

    GetState(boolModifiers){
        return this.GetNode(boolModifiers).GetState()
    }

    /*
        Forces all state nodes to false, then activates the "no modifiers" node
        (index 1). Use this to bring ModifierNodes to a known clean state,
        e.g. on script initialisation or after a focus change.
    */
    Reset() {
        for modNode in this.stateNodes {
            modNode.Update(false)
        }

        ind1 := this.ComputeIndex({ctrl:false, alt:false, shift:false, win:false})
        this.stateNodes[ind1].Update(true)
    }
}
