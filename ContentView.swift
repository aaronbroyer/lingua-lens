import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @State private var showingDashboard = false

    var body: some View {
        NavigationStack {
            ZStack {
                ARViewContainer()
                    .ignoresSafeArea()

                OverlaysView()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        makeLessonButton
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, store.currentLesson == nil ? 32 : 220)
                }

                if let lesson = store.currentLesson {
                    VStack {
                        Spacer()
                        QuizView(lesson: lesson)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.spring(), value: store.currentLesson != nil)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Dashboard") {
                        showingDashboard = true
                    }
                }
            }
            .navigationTitle("LinguaLens")
            .sheet(isPresented: $showingDashboard) {
                DashboardView(onDismiss: { showingDashboard = false })
                    .environmentObject(store)
            }
        }
    }

    private var makeLessonButton: some View {
        Button {
            store.buildLesson()
        } label: {
            Label("Make Lesson", systemImage: "text.book.closed")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.85))
                .clipShape(Capsule())
                .shadow(radius: 6)
        }
        .disabled(store.detections.isEmpty || store.currentLesson != nil)
        .opacity(store.detections.isEmpty || store.currentLesson != nil ? 0.5 : 1)
        .padding(.bottom, 12)
    }
}
