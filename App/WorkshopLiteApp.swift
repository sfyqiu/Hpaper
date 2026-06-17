import SwiftUI
import WebKit

@main
struct WorkshopLiteApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1000, minHeight: 700)
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var urlString = "https://steamcommunity.com/app/431960/workshop/"
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 0) {
            topBar
            Divider()
            switch selectedTab {
            case 0: workshopView
            case 1: DownloadsView()
            default: workshopView
            }
        }
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            Text("Workshop Lite")
                .font(.system(size: 15, weight: .bold))

            Button("浏览") { selectedTab = 0 }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: selectedTab == 0 ? .bold : .regular))

            Button("下载进度") { selectedTab = 1 }
                .buttonStyle(.plain)
                .font(.system(size: 13, weight: selectedTab == 1 ? .bold : .regular))

            Spacer()

            if isLoading {
                ProgressView().controlSize(.small)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var workshopView: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("输入 Steam Workshop URL...", text: $urlString)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12))
                    .padding(8)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(6)

                Button("前往") {
                    if let url = URL(string: urlString) {
                        NSWorkspace.shared.open(url)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(8)

            Divider()

            GeometryReader { geo in
                WebView(url: URL(string: urlString))
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct WebView: NSViewRepresentable {
    let url: URL?

    func makeNSView(context: Context) -> WKWebView {
        let web = WKWebView()
        web.allowsBackForwardNavigationGestures = true
        if let url { web.load(URLRequest(url: url)) }
        return web
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url, nsView.url?.absoluteString != url.absoluteString else { return }
        nsView.load(URLRequest(url: url))
    }
}
