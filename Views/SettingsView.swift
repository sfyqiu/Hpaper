import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @State private var selectedTab: String = "general"

    var body: some View {
        TabView(selection: $selectedTab) {
            generalTab
                .tabItem { Label("通用", systemImage: "gearshape") }
                .tag("general")
        }
        .frame(width: 500, height: 400)
    }

    private var generalTab: some View {
        Form {
            Section("下载") {
                Toggle("保存到下载目录", isOn: $viewModel.saveToDownloads)
                Toggle("显示所有 Workshop 内容", isOn: $viewModel.showAllWorkshopContent)
            }
            Section("Steam") {
                TextField("Steam Profile ID", text: $viewModel.steamProfileID)
            }
            Section("代理") {
                Toggle("启用代理", isOn: $viewModel.proxyEnabled)
                if viewModel.proxyEnabled {
                    TextField("代理地址", text: $viewModel.proxyHost)
                    TextField("代理端口", text: $viewModel.proxyPort)
                }
            }
        }
        .padding()
    }
}
