import Foundation

extension String {
  public var isValidNicknameFormat: Bool {
    let regex = "^[가-힣a-zA-Z0-9]{1,10}$"
    let test = NSPredicate(format: "SELF MATCHES %@", regex)
    return test.evaluate(with: self)
  }
}
