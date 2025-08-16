//
//  UserModel.swift
//  UserDomain
//
//  Created by Seulki Lee on 7/20/25.
//

import Foundation

public enum Gender: String, CaseIterable, Sendable {
    case none = ""
    case MALE = "MALE"
    case FEMALE = "FEMALE"
    
    public var description: String {
        switch self {
        case .none: return ""
        case .MALE: return "남성"
        case .FEMALE: return "여성"
        }
    }
}

public enum ActivityLevel: String, CaseIterable, Sendable {
  case none = ""
  case loose = "LOOSE"
  case normal = "NORMAL"
  case tight = "TIGHT"
  
  public var description: String {
      switch self {
      case .none: return ""
      case .loose: return "낮은 편"
      case .normal: return "보통"
      case .tight: return "높은 편"
      }
  }
}

public enum SugarGoal: String, CaseIterable, Sendable {
  case none = ""
  case easy = "EASY"
  case normal = "NORMAL"
  case hard = "HARD"
  
  public var descriptionTitle: String {
    switch self {
    case .none: return ""
    case .easy: return "쉬움"
    case .normal: return "보통"
    case .hard: return "어려움"
    }
  }
  
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
}
