#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Utils/CaseConverter.ahk

TestGuessCaseType() {
    lower := "lower"
    upper := "UPPER"
    mixed := "Mixed"

    Assert.Equal(CaseConverter.GuessCaseType("test"), lower)
    Assert.Equal(CaseConverter.GuessCaseType("TEST"), upper)
    Assert.Equal(CaseConverter.GuessCaseType("tEst"), mixed) 
   
    Assert.Equal(CaseConverter.GuessCaseType(".,_:;+*%&/\()=?!<>[]{}() `"¦@#°§¬|¢´``~¢çtest1234567890"), lower)
    Assert.Equal(CaseConverter.GuessCaseType(".,_:;+*%&/\()=?!<>[]{}() `"¦@#°§¬|¢´``~¢ÇTEST1234567890"), upper)
    Assert.Equal(CaseConverter.GuessCaseType(".,_:;+*%&/\()=?!<>[]{}() `"¦@#°§¬|¢´``~¢çÇtEst1234567890"), mixed) 
}
TestGuessCaseType()


TestSwapEachCase() {
    Assert.Equal(CaseConverter.SwapEachCase("çtest"), "ÇTEST")
    Assert.Equal(CaseConverter.SwapEachCase("ÇTEST"), "çtest")
    Assert.Equal(CaseConverter.SwapEachCase("çtEst"), "ÇTeST")

    specChars := ".,_:;+*%&/\()=?!<>[]{}() `"¦@#°§¬|¢´``~¢1234567890"
    Assert.Equal(CaseConverter.SwapEachCase(specChars "çtest"), specChars "ÇTEST")
    Assert.Equal(CaseConverter.SwapEachCase(specChars "ÇTEST"), specChars "çtest")
    Assert.Equal(CaseConverter.SwapEachCase(specChars "çtEst"), specChars "ÇTeST")
}
TestSwapEachCase()
