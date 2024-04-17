makeCrypticCorrection <- function(trans_type, amount, correction = 5) {
  if (trans_type == "T") {
    return (amount)
  } else {
    return (correction * amount)
  }
}