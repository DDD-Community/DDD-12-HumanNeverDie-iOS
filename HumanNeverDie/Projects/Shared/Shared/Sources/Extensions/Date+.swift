//
//  Date+.swift
//  Shared
//
//  Created by 김규철 on 8/16/25.
//

import Foundation

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
  
  public static func convertUTCToKoreaTime(_ utcDate: Date) -> Date {
    // UTC 시간을 문자열로 변환 (UTC 기준)
    let utcFormatter = DateFormatter()
    utcFormatter.timeZone = TimeZone(identifier: "UTC")
    utcFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = utcFormatter.string(from: utcDate)
    
    // 같은 문자열을 한국 시간대로 해석
    let koreaFormatter = DateFormatter()
    koreaFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    koreaFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    return koreaFormatter.date(from: dateString) ?? utcDate
  }
}
