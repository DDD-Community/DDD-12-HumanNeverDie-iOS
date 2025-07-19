import SwiftUI
import DesignSystem

struct AMDLottieViewDemoView: View {
    @State private var isPlaying = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                headerSection
                
                honeyEffectSection
                
                splashSection
                
                loadingSpinnerSection
                
                controlsSection
            }
            .padding()
        }
        .navigationTitle("Lottie Animations")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("AMDLottieView Demo")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Showcase of Lottie animations integrated into DesignSystem")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var honeyEffectSection: some View {
        VStack(spacing: 16) {
            Text("Honey Effect")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
              AMDLottieView(asset: .honeyEffect)
                    .frame(width: 120, height: 120)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Text("Looping honey effect animation")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var splashSection: some View {
        VStack(spacing: 16) {
            Text("Splash Animation")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
              AMDLottieView(asset: .splash)
                    .frame(width: 200, height: 200)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Text("Play once splash animation")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var loadingSpinnerSection: some View {
        VStack(spacing: 16) {
            Text("Loading Spinner")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 24) {
                VStack(spacing: 8) {
                  AMDLottieView(asset: .loadingSpinner)
                        .frame(width: 40, height: 40)
                    
                    Text("Small")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                  AMDLottieView(asset: .loadingSpinner)
                        .frame(width: 60, height: 60)
                    
                    Text("Medium")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                  AMDLottieView(asset: .loadingSpinner)
                        .frame(width: 80, height: 80)
                    
                    Text("Large")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var controlsSection: some View {
        VStack(spacing: 16) {
            Text("Usage Examples")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 12) {
                codeExample(
                    title: "Honey Effect",
                    code: """
                    AMDLottieView.honeyEffect()
                        .frame(width: 100, height: 100)
                    """
                )
                
                codeExample(
                    title: "Splash Animation",
                    code: """
                    AMDLottieView.splash()
                        .frame(width: 200, height: 200)
                    """
                )
                
                codeExample(
                    title: "Loading Spinner",
                    code: """
                    AMDLottieView.loadingSpinner()
                        .frame(width: 50, height: 50)
                    """
                )
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
    }
    
    private func codeExample(title: String, code: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Text(code)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
        }
    }
}

#Preview {
    NavigationView {
        AMDLottieViewDemoView()
    }
}
