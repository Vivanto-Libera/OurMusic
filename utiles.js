function trans(duration) {
    duration = parseInt(duration / 1000)
    let duratoinString
    let seconds
    let minutes
    minutes = parseInt(duration / 60)
    seconds = duration - minutes * 60
    let minStr = minutes.toString().padStart(2, "0")
    let secStr = seconds.toString().padStart(2, "0")
    duratoinString = minStr + ":" + secStr
    return duratoinString
}
