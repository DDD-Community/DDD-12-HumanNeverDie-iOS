//
//  BeverageRecordViewFactory.swift
//  BeverageRecordListFeature
//
//  Created by 김규철 on 7/30/25.
//

import SwiftUI

@MainActor
public struct BeverageRecordViewFactory {
  public static func create(productID: String, isLiked: Bool, recordDate: Date) -> some View {
    let viewModel = BeverageRecordViewModel(productID: productID, isLiked: isLiked, beverageRecordDate: recordDate)
    return BeverageRecordView(viewModel: viewModel)
  }
}
