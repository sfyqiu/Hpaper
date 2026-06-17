import SwiftUI

struct DownloadsView: View {
    @State private var downloads: [DownloadEntry] = []
    @State private var urlInput = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("下载管理")
                .font(.system(size: 16, weight: .bold))
                .padding(.horizontal)

            HStack {
                TextField("粘贴 Workshop 下载链接...", text: $urlInput)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(Color(.windowBackgroundColor))
                    .cornerRadius(6)

                Button("添加下载") {
                    guard !urlInput.isEmpty else { return }
                    let entry = DownloadEntry(
                        url: urlInput,
                        name: urlInput.components(separatedBy: "/").last ?? urlInput
                    )
                    downloads.append(entry)
                    urlInput = ""
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }
            .padding(.horizontal)

            Divider()

            if downloads.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "arrow.down.circle")
                        .font(.system(size: 36))
                        .foregroundStyle(.secondary)
                    Text("暂无下载任务")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text("从浏览页面复制链接，粘贴到这里开始下载")
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(downloads) { entry in
                            DownloadRow(entry: entry) {
                                downloads.removeAll { $0.id == entry.id }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct DownloadEntry: Identifiable {
    let id = UUID()
    let url: String
    let name: String
    var progress: Double = 0
    var status: Status = .pending
    var localURL: URL?

    enum Status { case pending, downloading, completed, failed }
}

struct DownloadRow: View {
    let entry: DownloadEntry
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                Text(statusText)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if entry.status == .downloading {
                ProgressView(value: entry.progress)
                    .progressViewStyle(.linear)
                    .frame(width: 80)
                Text("\(Int(entry.progress * 100))%")
                    .font(.system(size: 11))
            }

            if entry.status == .completed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }

            if entry.status == .failed {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(.red)
            }
        }
        .padding(12)
        .background(Color(.windowBackgroundColor))
        .cornerRadius(8)
        .contextMenu {
            Button("移除") { onRemove() }
        }
    }

    private var statusText: String {
        switch entry.status {
        case .pending: return "等待中"
        case .downloading: return "下载中..."
        case .completed: return "已完成"
        case .failed: return "下载失败"
        }
    }
}
