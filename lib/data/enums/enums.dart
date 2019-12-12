enum TypeQuery { ARTISTS, ALBUMS, TRACKS, SCROBBLES }

class TypeQueryHelper {
  static String getValue(TypeQuery typeQuery) {
    switch (typeQuery) {
      case TypeQuery.ARTISTS:
        return "/artists";
      case TypeQuery.ALBUMS:
        return "/albums";
      case TypeQuery.TRACKS:
        return "/tracks";
      case TypeQuery.SCROBBLES:
        return "";
    }
  }
}

enum Period { overall, day7, month1, month3, month6, month12 }

class PeriodHelper {
  static String getPeriodQueryValue(Period period) {
    switch (period) {
      case Period.overall:
        return "ALL";
      case Period.day7:
        return "LAST_7_DAYS";
      case Period.month1:
        return "LAST_30_DAYS";
      case Period.month3:
        return "LAST_90_DAYS";
      case Period.month6:
        return "LAST_180_DAYS";
      case Period.month12:
        return "LAST_365_DAYS";
    }
  }

  static String getValue(Period period) {
    switch (period) {
      case Period.overall:
        return "Overall";
      case Period.day7:
        return "7day";
      case Period.month1:
        return "1month";
      case Period.month3:
        return "3month";
      case Period.month6:
        return "6month";
      case Period.month12:
        return "12month";
    }
  }

  static Period getPeriod(String value) {
    switch (value) {
      case "Overall":
        return Period.overall;
      case "7day":
        return Period.day7;
      case "1month":
        return Period.month1;
      case "3month":
        return Period.month3;
      case "6month":
        return Period.month6;
      case "12month":
        return Period.month12;
      default:
        return Period.overall;
    }
  }
}
