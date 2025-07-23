import SwiftUI

import DesignSystem

@main
struct DesignSystemDemoApp: App {
  
  init() {
    DesignSystemFontFamily.registerAllCustomFonts()
  }
  
  var body: some Scene {
    WindowGroup {
      DesignSystemListView()
    }
  }
}

private struct DesignSystemListView: View {
  @State private var items: [DesignSystemType] = DesignSystemType.allCases
  
  var body: some View {
    NavigationStack {
      List(items, id: \.self) { type in
        NavigationLink(destination: DesignSystemDetailView(type: type)) {
          Text(type.title)
        }
      }
      .navigationTitle("아맞당 디자인시스템.")
    }
  }
}

private struct DesignSystemDetailView: View {
  private let type: DesignSystemType
  
  init(type: DesignSystemType) {
    self.type = type
  }
  
  var body: some View {
    ZStack {
      switch type {
      case .color:
        ColorDemoView()
      case .font:
        FontDemoView()
      case .amdGlucoseValueLabel:
        AMDGlucoseValueLabelDemoView()
      case .amdCard:
        AMDCardDemoView()
      case .amdProgress:
        AMDProgressDemoView()
      case .amdChip:
        AMDChipDemoView()
      case .AMDBeverageList:
        AMDBeverageListDemoView()
      case .amdDatePicker:
        AMDDatePickerDemoView()
      case .amdTextField:
        AMDTextFieldDemoView()
      case .amdButton:
        AMDButtonDemoView()
      case .amdFloatingButton:
        AMDFloatingButtonDemoView()
      case .amdOptionButton:
        AMDOptionButtonView()
      case .amdLottieView:
        AMDLottieViewDemoView()
      }
    }
  }
}

#Preview {
  DesignSystemListView()
}
