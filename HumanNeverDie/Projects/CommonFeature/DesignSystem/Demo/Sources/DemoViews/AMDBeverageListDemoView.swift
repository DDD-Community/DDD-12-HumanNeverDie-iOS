//
//  AMDBeverageListDemoView.swift
//  DesignSystem
//
//  Created by 김규철 on 6/25/25.
//

import SwiftUI

import DesignSystem

struct AMDBeverageListDemoView: View {
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 20) {
        VStack(alignment: .leading, spacing: 0) {
          Text("Large Type")
            .amdFont(.largeBold)
            .foregroundStyle(.gray80)
            .padding(.horizontal, 20)
          
          ForEach(0..<3, id: \.self) { index in
            AMDBeverageListView.large(
              thumbnailURL: "https://picsum.photos/200/300?random=\(index)",
              brandTitle: "Brand \(index + 1)",
              beverageTitle: "Premium Beverage \(index + 1)",
              glucose: Double(50 + index * 25),
              kcal: Double(100 + index * 50),
              sugarFreeVariant: index % 2 == 0 ? .zero : .low,
              favoriteState: .init(
                isFavorite: false,
                action: {
                  print("Favorite toggled for large item \(index)")
                }
              ),
              infoAction: {
                print("Info tapped for large item \(index)")
              }
            )
            .padding(.horizontal, 20)
          }
        }
        
        VStack(alignment: .leading, spacing: 0) {
          Text("Medium Type")
            .amdFont(.largeBold)
            .foregroundStyle(.gray80)
            .padding(.horizontal, 20)
          
          ForEach(3..<6, id: \.self) { index in
            AMDBeverageListView.medium(
              thumbnailURL: "https://picsum.photos/200/300?random=\(index)",
              brandTitle: "Brand \(index + 1)",
              beverageSize: "Tall",
              beverageTitle: "Medium Beverage \(index + 1)",
              glucose: Double(30 + index * 15),
              kcal: Double(80 + index * 30),
              sugarFreeVariant: index % 3 == 0 ? nil : (index % 3 == 1 ? .zero : .low),
              menuAction: {
                print("Menu tapped for medium item \(index)")
              }
            )
            .padding(.horizontal, 20)
          }
        }
        
        VStack(alignment: .leading, spacing: 0) {
          Text("Small Type")
            .amdFont(.largeBold)
            .foregroundStyle(.gray80)
            .padding(.horizontal, 20)
          
          ForEach(6..<10, id: \.self) { index in
            AMDBeverageListView.small(
              thumbnailURL: "https://picsum.photos/200/300?random=\(index)",
              brandTitle: "Brand \(index + 1)",
              beverageSize: "Short",
              beverageTitle: "Small Beverage \(index + 1)",
              glucose: Double(20 + index * 10),
              kcal: Double(60 + index * 20),
              sugarFreeVariant: index % 2 == 0 ? .zero : nil
            )
            .padding(.horizontal, 20)
          }
        }
      }
      .padding(.vertical, 20)
    }
  }
}
