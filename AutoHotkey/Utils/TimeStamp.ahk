#Requires AutoHotkey v2.0

class TimeStamp {
    static Now(){
        return TimeStamp(A_Now, A_MSec)
    }

    static Add(ts0, ts1){
        return TimeStamp(ts0.sec + ts1.sec, ts0.millis + ts1.millis)
    }

    static Sub(ts0, ts1){
        sec := ts0.sec - ts1.sec
        millis := ts0.millis - ts1.millis
        return TimeStamp(ts0.sec - ts1.sec, ts0.millis - ts1.millis)
    }

    Sub(ts1){
        return TimeStamp.Sub(this, ts1)
    }

    Add(ts1){
        return TimeStamp.Add(this, ts1)
    }
    
    __New(sec, millis) {
        this.sec := sec
        this.millis := millis
    }

    Value() {
        return this.sec + this.millis/1000
    }

    ValueMs() {
        return this.sec*1000 + this.millis
    }
}
