//
//  AMDWebURL.swift
//  CommonFeature
//
//  Created by 김규철 on 8/28/25.
//

import Foundation

public enum AMDWebURL: String, CaseIterable {
  case addBeverageForm = "https://forms.gle/9sVcZGZRATALoCRZ6"
  case addTermsOfUse = "https://telling-abrosaurus-7ba.notion.site/24d0d89bf00580b08fcad69f40cf98ae"
  case addPrivacyPolicy = "https://telling-abrosaurus-7ba.notion.site/24d0d89bf00580dc8277f6fa24888796?pvs=74"
  case addReviewLink = "https://apps.apple.com/app/id6748367287?action=write-review"
  
  public var url: URL? {
    return URL(string: self.rawValue)
  }
}
