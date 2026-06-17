import SwiftUI
import AppKit

@MainActor
class MainContentNavigationState: ObservableObject {
    @Published var selectedMedia: MediaItem?
    @Published var librarySelectedMedia: MediaItem?
    @Published var libraryMediaContext: [MediaItem] = []
}

struct ContentView: View {
    @StateObject private var mediaViewModel = MediaExploreViewModel()
    @StateObject private var navigationState = MainContentNavigationState()
    @StateObject private var localization = LocalizationService.shared
    @ObservedObject private var arcSettings = ArcBackgroundSettings.shared
    @State private var showSettings = false

    var body: some View {
        ZStack {
            // 背景
            ArcBackgroundPanel(theme: arcSettings.themeMode)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 顶部导航栏
                topBar

                // 主内容 - 直接显示壁纸引擎浏览
                MediaExploreContentView(
                    viewModel: mediaViewModel,
                    selectedMedia: navigationState.binding(for: \.selectedMedia),
                    showSettings: $showSettings
                )
            }
        }
        .preferredColorScheme(arcSettings.isLightMode ? .light : .dark)
        .sheet(isPresented: $showSettings) {
            SettingsView(viewModel: SettingsViewModel())
                .environmentObject(WorkshopSourceManager.shared)
        }
        .onAppear {
            StatusBarController.shared.configure(
                showWindow: {},
                releaseMemory: {},
                quit: { NSApp.terminate(nil) }
            )
        }
    }

    private var topBar: some View {
        HStack {
            Text("Swallpaper Workshop Lite")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(arcSettings.primaryText)

            Spacer()

            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 14))
                    .foregroundStyle(arcSettings.secondaryText)
            }
            .buttonStyle(.plain)
            .help("设置")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

extension MainContentNavigationState {
    func binding<Value>(for keyPath: ReferenceWritableKeyPath<MainContentNavigationState, Value>) -> Binding<Value> {
        Binding(
            get: { self[keyPath: keyPath] },
            set: { self[keyPath: keyPath] = $0 }
        )
    }
}
