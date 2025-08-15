//
//  SugarRecommendationService.swift
//  SettingFeature
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation

struct MemberHealthMetric {
  let age: Int?
  let weightKg: Double?
  let gender: Gender
}

class Member {
  let healthMetric: MemberHealthMetric?
  
  init(healthMetric: MemberHealthMetric?) {
    self.healthMetric = healthMetric
  }
}

public struct RecommendedSugar {
  public let looseSugarMaxG: Double    // 쉬움일 때 MAX
  public let normalSugarMaxG: Double   // 보통일 때 MAX
  public let tightSugarMaxG: Double    // 어려움일 때 MAX
}

public class SugarRecommendationService {
  public init() {}
  
  public func calculate(for userInfo: UserInfo) -> RecommendedSugar {
    let age = calculateAge(from: userInfo.birthDate)
    
    guard
      let age = age,
      userInfo.selectedGender != .none,
      userInfo.weight > 0
    else {
      return RecommendedSugar(
        looseSugarMaxG: 0,
        normalSugarMaxG: 0,
        tightSugarMaxG: 0
      )
    }
    
    let gender = userInfo.selectedGender
    let weight = Double(userInfo.weight)
    let bmr = calculateBMR(age: age, weight: weight, gender: gender)
    
    // 3가지 활동량에 대해 각각 계산
    let looseTEE = calculateTEE(bmr: bmr, activityLevel: .loose)
    let normalTEE = calculateTEE(bmr: bmr, activityLevel: .normal)
    let tightTEE = calculateTEE(bmr: bmr, activityLevel: .tight)
    
    // 각각의 MAX 값 계산 (5% 기준)
    let looseSugarMaxG = (looseTEE * 0.05) / 4.0
    let normalSugarMaxG = (normalTEE * 0.05) / 4.0
    let tightSugarMaxG = (tightTEE * 0.05) / 4.0
    
    return RecommendedSugar(
      looseSugarMaxG: looseSugarMaxG,
      normalSugarMaxG: normalSugarMaxG,
      tightSugarMaxG: tightSugarMaxG
    )
  }
  
  private func calculateAge(from birthDateString: String) -> Int? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    guard let birthDate = formatter.date(from: birthDateString) else {
      return nil
    }
    
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
    return ageComponents.year
  }
  
  private func calculateBMR(age: Int, weight: Double, gender: Gender) -> Double {
    switch age {
    case 18...30:
      return gender == .MALE
      ? (15.3 * weight + 679)
      : (14.7 * weight + 496)
      
    case 31...60:
      return gender == .MALE
      ? (11.6 * weight + 879)
      : (8.7 * weight + 829)
      
    case let x where x > 60:
      return gender == .MALE
      ? (13.5 * weight + 487)
      : (10.5 * weight + 596)
      
    default:
      return 0
    }
  }
  
  private func calculateTEE(bmr: Double, activityLevel: ActivityLevel) -> Double {
    let pal: Double
    switch activityLevel {
    case .loose:
      pal = 1.45
    case .normal:
      pal = 1.65
    case .tight:
      pal = 1.85
    case .none:
      pal = 0
    }
    return bmr * pal
  }
}
