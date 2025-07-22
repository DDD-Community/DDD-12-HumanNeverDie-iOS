//
//  ADMSectionDivider.swift
//  DesignSystem
//
//  Created by Seulki Lee on 7/23/25.
//

import SwiftUI

public func sectionDivider() -> some View {
  Divider()
    .listRowSeparator(.hidden)
    .listRowInsets(EdgeInsets())
    .listRowBackground(Color.clear)
}
