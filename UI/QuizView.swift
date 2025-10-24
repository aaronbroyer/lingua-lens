import SwiftUI

struct QuizView: View {
    @EnvironmentObject private var store: Store
    let lesson: Lesson

    @State private var selections: [UUID: String] = [:]
    @State private var listeningItems: Set<UUID> = []

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.secondary.opacity(0.4))
                .frame(width: 40, height: 5)

            Text("Quick Quiz")
                .font(.title3).bold()

            ForEach(lesson.quiz) { item in
                quizBlock(for: item)
            }

            Button(action: store.completeCurrentLesson) {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .shadow(radius: 10)
    }

    @ViewBuilder
    private func quizBlock(for item: QuizItem) -> some View {
        switch item.type {
        case "label_match":
            labelMatchBlock(item: item)
        case "speak":
            speakBlock(item: item)
        default:
            Text(item.prompt)
                .font(.body)
        }
    }

    private func labelMatchBlock(item: QuizItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.prompt)
                .font(.headline)

            if let options = item.options {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(options, id: \.self) { option in
                        Button {
                            selections[item.id] = option
                        } label: {
                            HStack(spacing: 6) {
                                Text(option.capitalized)
                                    .font(.subheadline).bold()
                                if option == item.answer, selections[item.id] == option {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(chipColor(for: option, item: item))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func speakBlock(item: QuizItem) -> some View {
        let isListening = listeningItems.contains(item.id)

        return VStack(alignment: .leading, spacing: 12) {
            Text(item.prompt)
                .font(.headline)

            Button {
                toggleListening(for: item.id)
            } label: {
                HStack {
                    Image(systemName: isListening ? "waveform" : "mic.fill")
                    Text(isListening ? "Listening (stub)" : "Start speaking")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange.opacity(0.9))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .padding()
        .background(Color.orange.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        // TODO: Integrate Whisper ASR for real speak tasks.
    }

    private func chipColor(for option: String, item: QuizItem) -> Color {
        if selections[item.id] == option, option == item.answer {
            return Color.green.opacity(0.9)
        } else if selections[item.id] == option {
            return Color.gray.opacity(0.7)
        } else {
            return Color.blue.opacity(0.6)
        }
    }

    private func toggleListening(for id: UUID) {
        if listeningItems.contains(id) {
            listeningItems.remove(id)
        } else {
            listeningItems.insert(id)
        }
    }
}
