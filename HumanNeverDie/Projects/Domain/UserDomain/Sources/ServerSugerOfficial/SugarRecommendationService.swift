//
//  SugarRecommendationService.swift
//  SettingFeature
//
//  Created by Seulki Lee on 8/15/25.
//

import Foundation

enum ActivityRange {
  case loose   // 1.4–1.5
  case normal  // 1.6–1.7
  case tight   // 1.8–1.9
}

struct MemberHealthMetric {
  let age: Int?
  let weightKg: Double?
  let gender: Gender
  let activityRange: ActivityRange?
}

class Member {
  let healthMetric: MemberHealthMetric?
  
  init(healthMetric: MemberHealthMetric?) {
    self.healthMetric = healthMetric
  }
}

struct RecommendedSugar {
  let sugarMaxG: Double
  let sugarIdealG: Double
}

class SugarRecommendationService {
  
  func calculate(for member: Member) -> RecommendedSugar {
    // 필수 정보가 하나라도 없으면 0 반환
    guard
      let metric = member.healthMetric,
      let age = metric.age,
      let weight = metric.weightKg,
      let activity = metric.activityRange,
      metric.gender != .none
    else {
      return RecommendedSugar(sugarMaxG: 0, sugarIdealG: 0)
    }
    
    let gender = metric.gender
    let bmr = calculateBMR(age: age, weight: weight, gender: gender)
    let tee = calculateTEE(bmr: bmr, activityRange: activity)
    
    // 전체 에너지 섭취 중 당 에너지 비율: 최대 10%, 권장 5%
    let dailySugarKcalMax = tee * 0.10
    let dailySugarKcalIdeal = tee * 0.05
    
    // 1g 당 4kcal
    let sugarMaxG = dailySugarKcalMax / 4.0
    let sugarIdealG = dailySugarKcalIdeal / 4.0
    
    return RecommendedSugar(sugarMaxG: sugarMaxG, sugarIdealG: sugarIdealG)
  }
  
  private func calculateBMR(age: Int, weight: Double, gender: Gender) -> Double {
    switch age {
    case 18...30:
      return gender == .male
      ? (15.3 * weight + 679)
      : (14.7 * weight + 496)
      
    case 31...60:
      return gender == .male
      ? (11.6 * weight + 879)
      : (8.7 * weight + 829)
      
    case let x where x > 60:
      return gender == .male
      ? (13.5 * weight + 487)
      : (10.5 * weight + 596)
      
    default:
      return 0
    }
  }
  
  private func calculateTEE(bmr: Double, activityRange: ActivityRange) -> Double {
    let pal: Double
    switch activityRange {
    case .loose:
      pal = 1.45
    case .normal:
      pal = 1.65
    case .tight:
      pal = 1.85
    }
    return bmr * pal
  }
}

