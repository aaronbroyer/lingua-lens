import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: Store
    @Environment(\.dismiss) private var dismiss
    var onDismiss: (() -> Void)?

    private var uniqueWordCount: Int {
        let words = store.lessons.flatMap { $0.words.map(\.lemma) }
        return Set(words).count
    }

    private var recentWords: [WordItem] {
        Array(store.lessons.flatMap { $0.words }.suffix(6))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    statCard(title: "Words learned", value: "\(uniqueWordCount)")
                    statCard(title: "Lessons completed", value: "\(store.lessons.count)")

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent words")
                            .font(.headline)
                        if recentWords.isEmpty {
                            Text("Start a lesson to see your vocabulary here.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        } else {
                            let columns = [GridItem(.flexible()), GridItem(.flexible())]
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(recentWords) { word in
                                    Text(word.lemma.capitalized)
                                        .font(.subheadline).bold()
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.15))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back to Camera") {
                        handleDismiss()
                    }
                }
            }
        }
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.system(size: 42, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private func handleDismiss() {
        if let onDismiss {
            onDismiss()
        } else {
            dismiss()
        }
    }
}
