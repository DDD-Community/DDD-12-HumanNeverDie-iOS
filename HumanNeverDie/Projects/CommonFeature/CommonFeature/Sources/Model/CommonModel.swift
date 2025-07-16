//
//  CommonModel.swift
//  CommonFeature
//
//  Created by Seulki Lee on 7/16/25.
//

import Foundation

public enum Gender: String, CaseIterable {
  case none = ""
  case male = "남성"
  case female = "여성"
  
  public var isSelected: Bool {
    return self != .none
  }
}

public enum ActivityLevel: String, CaseIterable {
  case none = ""
  case low = "낮은 편"
  case medium = "보통"
  case high = "높은 편"
  
  public var isSelected: Bool {
    return self != .none
  }
}

public enum SugarGoal: String, CaseIterable {
  case none = ""
  case easy = "쉬움"
  case normal = "보통"
  case hard = "어려움"
  
  public var description: String {
    switch self {
    case .none: return ""
    case .easy: return "권장량의 100% 이내 섭취"
    case .normal: return "권장량의 50% 이내 섭취"
    case .hard: return "권장량의 20% 이내 섭취"
    }
  }
  
  public var targetAmount: String {
    switch self {
    case .none: return ""
    case .easy: return "하루 200g"
    case .normal: return "하루 100g"
    case .hard: return "하루 40g"
    }
  }
  
  public var isSelected: Bool {
    return self != .none
  }
}
