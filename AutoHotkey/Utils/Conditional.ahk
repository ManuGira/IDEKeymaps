#Requires AutoHotkey v2.0

class Conditional {    

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
            if condition(k1)
                Action(k1) ; trigger callback only if condition() function returns true
            else
                SendInput("{Blind}" k1)
        }
        return Hotkey(KeyName, (k0) => conditionalCallback(k0))
    }
    
    /**
     * High level function to map a key to another under a condition. 
     * @param {(String)} srcKey 
     * @param {(String)} dstKey 
     * @param {(Func[String] -> bool)} condition 
     * @param {(String)} [modifier]
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