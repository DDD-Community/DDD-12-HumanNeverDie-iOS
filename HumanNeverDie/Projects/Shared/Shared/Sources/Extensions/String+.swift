//
//  String+.swift
//  Shared
//
//  Created by 김규철 on 8/16/25.
//

import Foundation

extension String {
  public var isValidNicknameFormat: Bool {
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
