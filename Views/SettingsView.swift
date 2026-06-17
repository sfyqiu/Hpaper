import SwiftUI

enum SettingsTab: String, CaseIterable, Identifiable {
    case general, downloads, workshop, about
    var id: String { rawValue }
    var title: String {
        switch self {
        case .general: return "通用"
        case .downloads: return "下载"
        case .workshop: return "壁纸引擎"
        case .about: return "关于"
        }
    }
    var icon: String {
        switch self {
        case .general: return "gearshape"
        case .downloads: return "arrow.down.circle"
        case .workshop: return "gearshape.2"
        case .about: return "info.circle"
        }
    }
}

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: SettingsTab = .general
    @State private var showSteamLogin = false

    var body: some View {
        HStack(spacing: 0) {
            sidebar
            Divider()
            content
        }
        .frame(width: 720, height: 500)
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("设置").font(.system(size: 15, weight: .bold))
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 12)

            ForEach(SettingsTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: tab.icon).frame(width: 16)
                        Text(tab.title).font(.system(size: 13))
                        Spacer()
                    }
                    .padding(.horizontal, 16).padding(.vertical, 8)
                    .background(selectedTab == tab ? Color.accentColor.opacity(0.15) : Color.clear)
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            Spacer()
        }
        .frame(width: 150)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                switch selectedTab {
                case .general: generalView
                case .downloads: downloadsView
                case .workshop: workshopView
                case .about: aboutView
                }
            }
            .padding(24)
        }
    }

    private var generalView: some View {
        VStack(spacing: 16) {
            GroupBox(label: Text("通用").font(.system(size: 12, weight: .semibold))) {
                VStack(spacing: 10) {
                    Toggle("开机启动", isOn: $viewModel.launchAtLogin)
                }
                .padding(8)
            }
            GroupBox(label: Text("代理").font(.system(size: 12, weight: .semibold))) {
                VStack(spacing: 8) {
                    Toggle("启用 HTTP 代理", isOn: $viewModel.proxyEnabled)
                    if viewModel.proxyEnabled {
                        HStack { Text("地址").frame(width: 50, alignment: .trailing); TextField("127.0.0.1", text: $viewModel.proxyHost).textFieldStyle(.roundedBorder) }
                        HStack { Text("端口").frame(width: 50, alignment: .trailing); TextField("7890", text: $viewModel.proxyPort).textFieldStyle(.roundedBorder) }
                    }
                }
                .padding(8)
            }
        }
    }

    private var downloadsView: some View {
        GroupBox(label: Text("下载").font(.system(size: 12, weight: .semibold))) {
            VStack(spacing: 10) {
                Toggle("保存下载到应用库", isOn: $viewModel.saveToDownloads)
            }
            .padding(8)
        }
    }

    private var workshopView: some View {
        GroupBox(label: Text("壁纸引擎").font(.system(size: 12, weight: .semibold))) {
            VStack(spacing: 12) {
                HStack {
                    Text("Steam 64位 ID").frame(width: 100, alignment: .trailing)
                    TextField("输入 Steam 64位 ID（数字）", text: $viewModel.steamProfileID)
                        .textFieldStyle(.roundedBorder)
                }

                Button("Steam 网页登录") {
                    showSteamLogin = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

                Toggle("显示所有内容（含未分类）", isOn: $viewModel.showAllWorkshopContent)
            }
            .padding(8)
        }
        .sheet(isPresented: $showSteamLogin) {
            SteamLoginSheet(isPresented: $showSteamLogin)
                .environmentObject(WorkshopSourceManager.shared)
        }
    }

    private var aboutView: some View {
        GroupBox(label: Text("关于 Hpaper").font(.system(size: 12, weight: .semibold))) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Hpaper v1.0.0").font(.system(size: 13))
                Text("基于 Swallpaper-Mac-v3 精简").font(.system(size: 11)).foregroundStyle(.secondary)
                Text("仅保留壁纸引擎浏览与下载功能").font(.system(size: 11)).foregroundStyle(.secondary)
            }
            .padding(8)
        }
    }
}
