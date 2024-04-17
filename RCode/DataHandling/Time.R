calcSeasonName <- function(date) {
  month <- lubridate::month(lubridate::ymd(date))
  if (month %in% 3:5) {
    return ("Spring")
  } else if (month %in% 6:8) {
    return ("Summer")
  } else if (month %in% 9:11) {
    return ("Autumn")
  } else {
    return ("Winter")
  }
}