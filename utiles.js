function trans(duration) {
    if (isNaN(duration) || duration < 0 || !isFinite(duration)) {
        return "00:00"
    }
    let totalSeconds = Math.floor(duration / 1000)
    let minutes = Math.floor(totalSeconds / 60)
    let seconds = totalSeconds - minutes * 60
    let minStr = minutes < 10 ? "0" + minutes : "" + minutes
    let secStr = seconds < 10 ? "0" + seconds : "" + seconds
    return minStr + ":" + secStr
}
