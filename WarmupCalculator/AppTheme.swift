import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.91, green: 0.30, blue: 0.20)
    static let accentAlt = Color(red: 0.13, green: 0.57, blue: 0.76)
    static let textPrimary = Color(red: 0.10, green: 0.12, blue: 0.18)
    static let textSecondary = Color(red: 0.32, green: 0.38, blue: 0.47)

    static let pageGradient = LinearGradient(
        colors: [
            Color(red: 0.96, green: 0.97, blue: 1.00),
            Color(red: 0.93, green: 0.95, blue: 0.99),
            Color(red: 0.98, green: 0.95, blue: 0.90)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.40, blue: 0.26),
            Color(red: 0.88, green: 0.22, blue: 0.17)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let coolGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.54, blue: 0.74),
            Color(red: 0.17, green: 0.68, blue: 0.55)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardStroke = Color.white.opacity(0.65)
}

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            AppTheme.pageGradient

            Circle()
                .fill(AppTheme.accent.opacity(0.10))
                .frame(width: 320)
                .offset(x: 130, y: -260)
                .blur(radius: 8)

            Circle()
                .fill(AppTheme.accentAlt.opacity(0.10))
                .frame(width: 300)
                .offset(x: -140, y: 320)
                .blur(radius: 10)
        }
        .ignoresSafeArea()
    }
}

struct AppCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(AppTheme.cardStroke, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 8)
            )
    }
}

extension View {
    func appCard() -> some View {
        modifier(AppCardModifier())
    }
}

struct GradientActionButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isEnabled ? AppTheme.accentGradient : LinearGradient(colors: [Color.gray.opacity(0.45), Color.gray.opacity(0.35)], startPoint: .top, endPoint: .bottom))
                    .shadow(color: Color.black.opacity(isEnabled ? 0.22 : 0.05), radius: isEnabled ? 12 : 2, x: 0, y: isEnabled ? 6 : 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.22, dampingFraction: 0.8), value: configuration.isPressed)
    }
}
