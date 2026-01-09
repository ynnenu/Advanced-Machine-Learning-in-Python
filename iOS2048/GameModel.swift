import SwiftUI

final class GameModel: ObservableObject {
    @Published var board: [[Int]]
    @Published var score: Int
    @Published var isGameOver: Bool

    private let size = 4

    init() {
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        score = 0
        isGameOver = false
        reset()
    }

    func reset() {
        board = Array(repeating: Array(repeating: 0, count: size), count: size)
        score = 0
        isGameOver = false
        addRandomTile()
        addRandomTile()
    }

    func move(_ direction: Direction) {
        guard !isGameOver else { return }
        let original = board
        switch direction {
        case .left:
            for row in 0..<size {
                board[row] = mergedLine(from: board[row])
            }
        case .right:
            for row in 0..<size {
                let reversed = mergedLine(from: board[row].reversed())
                board[row] = Array(reversed.reversed())
            }
        case .up:
            for col in 0..<size {
                let line = (0..<size).map { board[$0][col] }
                let merged = mergedLine(from: line)
                for row in 0..<size {
                    board[row][col] = merged[row]
                }
            }
        case .down:
            for col in 0..<size {
                let line = (0..<size).map { board[$0][col] }
                let merged = mergedLine(from: line.reversed())
                let restored = Array(merged.reversed())
                for row in 0..<size {
                    board[row][col] = restored[row]
                }
            }
        }

        if board != original {
            addRandomTile()
            if !movesAvailable() {
                isGameOver = true
            }
        }
    }

    private func mergedLine<S: Sequence>(from line: S) -> [Int] where S.Element == Int {
        var filtered = line.filter { $0 != 0 }
        var merged: [Int] = []
        var skip = false
        for index in 0..<filtered.count {
            if skip {
                skip = false
                continue
            }
            if index + 1 < filtered.count, filtered[index] == filtered[index + 1] {
                let value = filtered[index] * 2
                score += value
                merged.append(value)
                skip = true
            } else {
                merged.append(filtered[index])
            }
        }
        while merged.count < size {
            merged.append(0)
        }
        return merged
    }

    private func addRandomTile() {
        let emptyPositions = board.indices.flatMap { row in
            board[row].indices.compactMap { col in
                board[row][col] == 0 ? (row, col) : nil
            }
        }
        guard let position = emptyPositions.randomElement() else { return }
        board[position.0][position.1] = Bool.random() ? 2 : 4
    }

    private func movesAvailable() -> Bool {
        if board.contains(where: { $0.contains(0) }) {
            return true
        }
        for row in 0..<size {
            for col in 0..<size {
                let value = board[row][col]
                if row + 1 < size, board[row + 1][col] == value {
                    return true
                }
                if col + 1 < size, board[row][col + 1] == value {
                    return true
                }
            }
        }
        return false
    }
}

enum Direction {
    case up
    case down
    case left
    case right
}
