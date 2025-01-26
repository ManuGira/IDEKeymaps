#Requires AutoHotkey v2.0

#Include Assert.ahk
#Include ../Utils/TimeStamp.ahk

TestTimeStamp() {
    ts0 := TimeStamp.Now()
    ts0.millis := 900
    ts200 := TimeStamp(0, 200)
    ts1 := TimeStamp.Add(ts0, ts200)
    interval := TimeStamp.Sub(ts1, ts0)
    
    Assert.Equal(interval.sec, 0, "TimeStamp arithmetic")
    Assert.Equal(interval.millis, 200, "TimeStamp arithmetic")
    Assert.Equal(Floor(interval.ValueMs()), 200, "TimeStamp arithmetic")
}
TestTimeStamp()

TestTimeStamp2() {
    ts1000 := TimeStamp(1, 0)
    ts1200 := TimeStamp(1, 200)

    interval := ts1200.Sub(ts1000)
    
    Assert.Equal(interval.sec, 0, "TimeStamp arithmetic")
    Assert.Equal(interval.millis, 200, "TimeStamp arithmetic")
    Assert.Equal(Floor(interval.ValueMs()), 200, "TimeStamp arithmetic")
}
TestTimeStamp2()