import Foundation

extension String {
  public  var isValidNicknameFormat: Bool {
    let regex = "^[가-힣a-zA-Z0-9]{1,10}$"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: self)
  }

  public static func toDate(from string: String) -> Date? {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.date(from: string)
  }
  
  public var toYMDFormat: String {
    return String(self.prefix(10))
  }
}

extension Date {
  public static func toDateKeyString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
  
  public static func toStringConvertDate(from dateString: String) -> Date {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.date(from: dateString) ?? Date()
  }
  
  public static func toDateTitleString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
  }

  public static func toRequestDateKeyString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter.string(from: date)
  }
}
