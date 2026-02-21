#Requires AutoHotkey v2.0

class Conditional {    
    static HotKeyMap := Map()
    ; static HotKeyMapAction := Map()
    ; static HotKeyMapConditions := Map()

    static SurroundWithCurlyBracketsIfNeeded(key) {
        ; Construire le pattern en une seule regex avec alternation
        pattern := "\b(Numpad1|Numpad2|Numpad3|Numpad4|Numpad5|Numpad6|Numpad7|Numpad8|Numpad9|Numpad0|NumpadDot|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub)\b"

        ; Remplacer chaque match par [match]
        return RegExReplace(key, pattern, "{$1}")
    }


    /**
     * @description Wraps the builtin `Hotkey()` function. 
     * The Action callback is called only if the ConditionFunction returns true.
     * The parameters KeyName and Action will be passed as is to the builtin function
     * More info in the official documentation of the builtin {@link https://www.autohotkey.com/docs/v2/lib/Hotkey.htm `Hotkey()`} function 
     * @param {(String)} keyName  
     * @param {(Func)} callback 
     * Function to be called if condition is true. Must take 1 parameter
     * Unlike the builtin function, keywords 'On', 'Off', 'Toggle' etc... are not supported
     * @param {(Func)} condition
     * Must take 1 parameter, returns a bool. 
     * @returns {(String)}  
     * An empty string is always returned.  
     */
    static Hotkey(KeyName, Action, condition) {
        conditionalCallback(k1) {
            at_least_one_condition_met := false
            ; iterate over all the tuples in the HotKeyMap[KeyName]
            for ac_tuple_i in Conditional.HotKeyMap[KeyName] { ; Conditional.HotKeyMap[KeyName] {
                Action_i := ac_tuple_i[1]
                condition_i := ac_tuple_i[2]
                if condition_i(k1) {
                    Action_i(k1) ; trigger callback only if condition() function returns true
                    at_least_one_condition_met := true
                }
            }
            if at_least_one_condition_met
                return
            
            ; No condition is met, send the key (if its not a up key)

            if (not RegExMatch(k1, " Up$")) {
                ; if the key is NOT a release key (ends with " Up"),
                ; remove the leading $ if present
                k1 := RegExReplace(k1, "i)^\$")
                
                k1 := Conditional.SurroundWithCurlyBracketsIfNeeded(k1)

                SendInput("{Blind}" k1)
            }
        }
        if not Conditional.HotKeyMap.Has(KeyName)
            Conditional.HotKeyMap[KeyName] := []
        ; add tuple (Action, condition) to the HotKeyMap
        Conditional.HotKeyMap[KeyName].Push([Action, condition])

        ; remove leading $ if present
        return Hotkey(KeyName, (k0) => conditionalCallback(k0))
    }
    
    /**
     * High level function to map a key to another under a condition. 
     * @param {(String)} srcKey 
     * @param {(String)} dstKey 
     * @param {(Func[String] -> bool)} condition 
     * @param {(String)} [modifier]
     * @param {(bool)} [allowRecursion] 
     * @param {(Func[String])} [callback]
     */
    static Remap(srcKey, dstKey, condition, modifier := "*", callback := unset) {
        sendKey(key){
            if condition(key) {
                SendInput("{Blind}" dstKey) ; Send the remapped key when condition() function returns true
            } else {
                SendInput("{Blind}" srcKey) ; Send the original key when condition() function returns false
            }
            
            ; optional user callback
            if IsSet(callback)
                callback(key)
            
        }
        Hotkey("$" modifier srcKey, (k) => sendKey(k))
    }
}