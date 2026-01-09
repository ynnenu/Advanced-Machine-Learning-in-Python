import SwiftUI

struct TileView: View {
    let value: Int

    private var backgroundColor: Color {
        switch value {
        case 0: return Color(.systemGray5)
        case 2: return Color(.systemOrange).opacity(0.4)
        case 4: return Color(.systemOrange).opacity(0.6)
        case 8: return Color(.systemOrange)
        case 16: return Color(.systemRed).opacity(0.8)
        case 32: return Color(.systemRed)
        case 64: return Color(.systemPink)
        case 128: return Color(.systemPurple).opacity(0.8)
        case 256: return Color(.systemPurple)
        case 512: return Color(.systemBlue).opacity(0.8)
        case 1024: return Color(.systemBlue)
        default: return Color(.systemGreen)
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .aspectRatio(1, contentMode: .fit)
            if value != 0 {
                Text("\(value)")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    TileView(value: 128)
        .padding()
}
