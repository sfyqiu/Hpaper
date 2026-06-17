import SwiftUI
import Combine
import ServiceManagement
import Kingfisher

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var saveToDownloads = true {
        didSet { UserDefaults.standard.set(saveToDownloads, forKey: DownloadPathManager.persistDownloadsToAppLibraryDefaultsKey) }
    }
    @Published var launchAtLogin = false { didSet { UserDefaults.standard.set(launchAtLogin, forKey: "launch_at_login") } }
    @Published var showAllWorkshopContent = true { didSet { UserDefaults.standard.set(showAllWorkshopContent, forKey: "show_all_workshop_content") } }
    @Published var steamProfileID: String = "" {
        didSet { UserDefaults.standard.set(steamProfileID, forKey: "workshop_steam_profile_id") }
    }

    @Published var proxyEnabled = false { didSet { UserDefaults.standard.set(proxyEnabled, forKey: "proxy_enabled"); syncProxySettings() } }
    @Published var proxyHost: String = "" { didSet { UserDefaults.standard.set(proxyHost, forKey: "proxy_host"); syncProxySettings() } }
    @Published var proxyPort: String = "" { didSet { UserDefaults.standard.set(proxyPort, forKey: "proxy_port"); syncProxySettings() } }

    private func syncProxySettings() {
        let config = URLSessionConfiguration.default
        if proxyEnabled, !proxyHost.isEmpty, let port = Int(proxyPort) {
            config.connectionProxyDictionary = [
                kCFNetworkProxiesHTTPEnable: true,
                kCFNetworkProxiesHTTPProxy: proxyHost,
                kCFNetworkProxiesHTTPPort: port,
                kCFNetworkProxiesHTTPSEnable: true,
                kCFNetworkProxiesHTTPSProxy: proxyHost,
                kCFNetworkProxiesHTTPSPort: port
            ]
        } else {
            config.connectionProxyDictionary = nil
        }
    }

    init() {
        let defaults = UserDefaults.standard
        saveToDownloads = defaults.object(forKey: DownloadPathManager.persistDownloadsToAppLibraryDefaultsKey) as? Bool ?? true
        launchAtLogin = defaults.bool(forKey: "launch_at_login")
        showAllWorkshopContent = defaults.bool(forKey: "show_all_workshop_content")
        steamProfileID = defaults.string(forKey: "workshop_steam_profile_id") ?? ""
        proxyEnabled = defaults.bool(forKey: "proxy_enabled")
        proxyHost = defaults.string(forKey: "proxy_host") ?? ""
        proxyPort = defaults.string(forKey: "proxy_port") ?? ""
    }
}
