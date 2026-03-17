#Requires AutoHotkey v2.0

/*
    Python-style range iterator for AutoHotkey v2.
    Produces a sequence of values from start to end (exclusive) with the given step.
    
    Usage:
        for x in Range(1, 10, 2) {
            MsgBox(x)  ; outputs 1, 3, 5, 7, 9
        }

    Parameters:
        start - First value in the sequence (inclusive)
        end   - Last value to reach (exclusive)
        step  - Increment between values (positive or negative)
*/
class Range {
    /*
        Supports multiple constructor signatures:
        - Range(end) → start=0, step=1
        - Range(start, end) → step=1
        - Range(start, end, step)
    */
    __New(param1 := unset, param2 := unset, param3 := unset) {
        if not IsSet(param3) {
            if not IsSet(param2) {
                ; Only one parameter: Range(end)
                this.start := 0
                this.end := param1
                this.step := 1
            } else {
                ; Two parameters: Range(start, end)
                this.start := param1
                this.end := param2
                this.step := 1
            }
        } else {
            ; Three parameters: Range(start, end, step)
            this.start := param1
            this.end := param2
            this.step := param3
        }
    }

    /*
        Makes Range compatible with for-in loops.
        Returns an enumerator function that yields successive values.
    */
    __Enum(NumberOfVars) {
        state := {current: this.start, step: this.step, end: this.end}
        return (&value) => this._NextValue(state, &value)
    }

    /*
        Helper method for the enumerator. Advances to the next value in the sequence.
    */
    _NextValue(state, &value) {
        if (state.step > 0 && state.current >= state.end) || (state.step < 0 && state.current <= state.end) {
            return false
        }
        value := state.current
        state.current += state.step
        return true
    }
}