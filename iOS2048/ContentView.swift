import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameModel()

    var body: some View {
        VStack(spacing: 16) {
            header
            boardView
            controls
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    handleSwipe(value)
                }
        )
        .alert("Game Over", isPresented: $game.isGameOver) {
            Button("Try Again") { game.reset() }
        } message: {
            Text("Final score: \(game.score)")
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("2048")
                    .font(.largeTitle.bold())
                Text("Score: \(game.score)")
                    .font(.headline)
            }
            Spacer()
            Button("New Game") {
                game.reset()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var boardView: some View {
        VStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { col in
                        TileView(value: game.board[row][col])
                    }
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray4))
        .cornerRadius(12)
    }

    private var controls: some View {
        VStack(spacing: 8) {
            Text("Swipe to move tiles")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 12) {
                Button("Up") { game.move(.up) }
                Button("Left") { game.move(.left) }
                Button("Down") { game.move(.down) }
                Button("Right") { game.move(.right) }
            }
            .buttonStyle(.bordered)
        }
    }

    private func handleSwipe(_ value: DragGesture.Value) {
        let horizontal = value.translation.width
        let vertical = value.translation.height

        if abs(horizontal) > abs(vertical) {
            game.move(horizontal > 0 ? .right : .left)
        } else {
            game.move(vertical > 0 ? .down : .up)
        }
    }
}

#Preview {
    ContentView()
}
