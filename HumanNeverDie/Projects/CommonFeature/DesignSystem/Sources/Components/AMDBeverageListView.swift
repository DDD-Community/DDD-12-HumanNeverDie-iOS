//
//  AMDBeverageListView.swift
//  DesignSystemDemo
//
//  Created by 김규철 on 6/25/25.
//

import SwiftUI

import NukeUI

public struct AMDBeverageListView: View {
  private let type: ListType
  private let thumbnailURL: String
  private let brandTitle: String
  private let beverageTitle: String
  private let beverageSize: String?
  private let glucose: Double
  private let kcal: Double
  private let sugarFreeVariant: AMDSugarFreeVariant?
  
  private let likeState: LikeState?
  private let infoAction: (() -> Void)?
  private let menuAction: (() -> Void)?
  
  public struct LikeState {
    public let isLiked: Bool
    public let action: () -> Void
    
    public init(
      isLiked: Bool,
      action: @escaping () -> Void
    ) {
      self.isLiked = isLiked
      self.action = action
    }
  }
  
  public enum ListType {
    case small
    case medium
    case large
    case completed
    case card
    
    fileprivate var height: CGFloat {
      switch self {
      case .small:
        return 89
      case .medium:
        return 110
      case .large:
        return 124
      case .completed, .card:
        return 106
      }
    }
    
    fileprivate var padding: CGFloat {
      switch self {
      case .small:
        return 10
      case .medium, .completed, .card:
        return 16
      case .large:
        return 12
      }
    }
    
    fileprivate var thumbnailSize: CGSize {
      switch self {
      case .small, .completed, .card:
        return .init(width: 56, height: 56)
      case .medium:
        return .init(width: 74, height: 74)
      case .large:
        return .init(width: 100, height: 100)
      }
    }
    
    fileprivate var backgroundColor: Color {
      switch self {
      case .completed, .medium:
        return .gray10
        
      case .card:
        return .clear
        
      default:
        return .white
      }
    }
    
    fileprivate var brandFont: AMDFont {
      switch self {
      case .small:
        return .xsmallRegular
      case .medium, .large, .completed, .card:
        return .smallRegular
      }
    }
    
    fileprivate var beverageFont: AMDFont {
      switch self {
      case .small:
        return .smallRegular
      case .medium, .large, .completed, .card:
        return .mediumMedium
      }
    }
    
    fileprivate var beverageSizeFont: AMDFont {
      switch self {
      case .small:
        return .smallBold
      case .medium, .large, .completed, .card:
        return .mediumBold
      }
    }
    
    fileprivate var glucoseFont: AMDFont {
      switch self {
      case .small:
        return .smallBold
      case .medium, .large, .completed, .card:
        return .mediumBold
      }
    }
    
    fileprivate var kcalFont: AMDFont {
      switch self {
      case .small:
        return .smallRegular
      case .medium, .large, .completed, .card:
        return .mediumRegular
      }
    }
  }
  
  public init(
    type: ListType,
    thumbnailURL: String,
    brandTitle: String,
    beverageSize: String? = nil,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?,
    likeState: LikeState?,
    infoAction: (() -> Void)? = nil,
    menuAction: (() -> Void)? = nil
  ) {
    self.type = type
    self.thumbnailURL = thumbnailURL
    self.brandTitle = brandTitle
    self.beverageTitle = beverageTitle
    self.beverageSize = beverageSize
    self.glucose = glucose
    self.kcal = kcal
    self.sugarFreeVariant = sugarFreeVariant
    self.likeState = likeState
    self.infoAction = infoAction
    self.menuAction = menuAction
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 12) {
        thumbnail
        
        VStack {
          VStack(spacing: 2) {
            brandView
            beverageView
          }
          
          Spacer()
          beverageInfoView
        }
      }
      .padding(type.padding)
      .frame(minHeight: type.height, maxHeight: type.height)
      .background(type.backgroundColor)
      .if(type == .medium || type == .completed) {
        $0.amdCornerRadius(.medium)
      }
      
      divider
    }
  }
}

private extension AMDBeverageListView {
  private var thumbnail: some View {
    LazyImage(url: URL(string:thumbnailURL)) { state in
      Group {
        if let image = state.image {
          image
            .resizable()
            .scaledToFill()
            .frame(width: type.thumbnailSize.width, height: type.thumbnailSize.height)
            .amdCornerRadius(.small)
            .if(type == .large) {
              $0
                .overlay(alignment: .topLeading) {
                  favoriteButton
                    .padding([.top, .leading], 6)
                }
            }
          
        } else {
          progressView
        }
      }
    }
    .processors([.resize(size: type.thumbnailSize)])
  }
  
  private var progressView: some View {
    Rectangle()
      .frame(width: type.thumbnailSize.width, height: type.thumbnailSize.height)
      .foregroundStyle(.gray10)
      .amdCornerRadius(.small)
      .overlay(alignment: .center) {
        ProgressView()
      }
  }
  
  @ViewBuilder
  private var favoriteButton: some View {
    if let likeState {
      Button(action: likeState.action) {
        Group {
          if likeState.isLiked {
            AMDImage.liked24.swiftUIImage
          } else {
            AMDImage.unliked24.swiftUIImage
          }
        }
        .animation(.bouncy(duration: 0.6, extraBounce: 0.2), value: likeState.isLiked)
      }
    } else {
      EmptyView()
    }
  }
}

private extension AMDBeverageListView {
  @ViewBuilder
  private var brandView: some View {
    switch type {
    case .large:
      HStack(spacing: 0) {
        brandTitleText
        infoButton
      }
      
    case .small, .medium:
      HStack(spacing: 0) {
        brandTitleText
        menuButton
      }
      
    default:
      brandTitleText
    }
  }
  
  private var brandTitleText: some View {
    Text(brandTitle)
      .amdFont(type.brandFont)
      .foregroundStyle(.gray60)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var infoButton: some View {
    Button {
      infoAction?()
    } label: {
      AMDImage.info24.swiftUIImage
    }
  }
  
  private var menuButton: some View {
    Button {
      menuAction?()
    } label: {
      AMDImage.more24.swiftUIImage
    }
  }
}

private extension AMDBeverageListView {
  private var beverageView: some View {
    beverageTitleText
  }
  
  private var beverageTitleText: some View {
    Text(beverageTitle)
      .amdFont(type.beverageFont)
      .foregroundStyle(.gray80)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension AMDBeverageListView {
  @ViewBuilder
  private var beverageInfoView: some View {
    switch type {
    case .large:
      HStack {
        HStack(spacing: 4) {
          glucoseText
          sugarBadge
        }
        
        Spacer()
        kcalText
      }
      
    case .medium, .small, .completed, .card:
      HStack {
        HStack(spacing: 8) {
          beverageSizeText
          sugarBadge
        }
        
        Spacer()
        
        HStack(spacing: 4) {
          glucoseText
          
          Divider()
            .frame(width: 1)
            .foregroundStyle(.gray40)
          
          kcalText
        }
      }
    }
  }
  
  private var beverageSizeText: some View {
    Text(beverageSize ?? "")
      .amdFont(type.beverageSizeFont)
      .foregroundStyle(.gray85)
  }
  
  private var glucoseText: some View {
    Text("\(Int(glucose))g")
      .amdFont(type.glucoseFont)
      .foregroundStyle(.gray85)
  }
  
  @ViewBuilder
  private var sugarBadge: some View {
    if let sugarFreeVariant {
      AMDBadge(
        title: sugarFreeVariant.rawValue,
        type: sugarFreeVariant == .zero ? .primary : .yellow
      )
    } else {
      EmptyView()
    }
  }
  
  private var kcalText: some View {
    Text("\(Int(kcal))kcal")
      .amdFont(type.kcalFont)
      .foregroundStyle(.gray70)
  }
  
  @ViewBuilder
  private var divider: some View {
    switch type {
    case .large, .small, .card:
      AMDDevider()
      
    default:
      EmptyView()
    }
  }
}

// MARK: - Factory methods

public extension AMDBeverageListView {
  static func small(
    thumbnailURL: String,
    brandTitle: String,
    beverageSize: String,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?,
  ) -> AMDBeverageListView {
    return AMDBeverageListView(
      type: .small,
      thumbnailURL: thumbnailURL,
      brandTitle: brandTitle,
      beverageSize: beverageSize,
      beverageTitle: beverageTitle,
      glucose: glucose,
      kcal: kcal,
      sugarFreeVariant: sugarFreeVariant,
      likeState: nil,
      infoAction: nil,
      menuAction: nil
    )
  }
  
  static func medium(
    thumbnailURL: String,
    brandTitle: String,
    beverageSize: String,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?,
    menuAction: @escaping () -> Void
  ) -> AMDBeverageListView {
    return AMDBeverageListView(
      type: .medium,
      thumbnailURL: thumbnailURL,
      brandTitle: brandTitle,
      beverageSize: beverageSize,
      beverageTitle: beverageTitle,
      glucose: glucose,
      kcal: kcal,
      sugarFreeVariant: sugarFreeVariant,
      likeState: nil,
      infoAction: nil,
      menuAction: menuAction
    )
  }
  
  static func large(
    thumbnailURL: String,
    brandTitle: String,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?,
    likeState: LikeState,
    infoAction: @escaping () -> Void
  ) -> AMDBeverageListView {
    return AMDBeverageListView(
      type: .large,
      thumbnailURL: thumbnailURL,
      brandTitle: brandTitle,
      beverageSize: nil,
      beverageTitle: beverageTitle,
      glucose: glucose,
      kcal: kcal,
      sugarFreeVariant: sugarFreeVariant,
      likeState: likeState,
      infoAction: infoAction
    )
  }
  
  static func completed(
    thumbnailURL: String,
    brandTitle: String,
    beverageSize: String,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?
  ) -> AMDBeverageListView {
    return AMDBeverageListView(
      type: .completed,
      thumbnailURL: thumbnailURL,
      brandTitle: brandTitle,
      beverageSize: beverageSize,
      beverageTitle: beverageTitle,
      glucose: glucose,
      kcal: kcal,
      sugarFreeVariant: sugarFreeVariant,
      likeState: nil,
      infoAction: nil,
      menuAction: nil
    )
  }
  
  static func card(
    thumbnailURL: String,
    brandTitle: String,
    beverageSize: String,
    beverageTitle: String,
    glucose: Double,
    kcal: Double,
    sugarFreeVariant: AMDSugarFreeVariant?
  ) -> AMDBeverageListView {
    return AMDBeverageListView(
      type: .card,
      thumbnailURL: thumbnailURL,
      brandTitle: brandTitle,
      beverageSize: beverageSize,
      beverageTitle: beverageTitle,
      glucose: glucose,
      kcal: kcal,
      sugarFreeVariant: sugarFreeVariant,
      likeState: nil,
      infoAction: nil,
      menuAction: nil
    )
  }
}
