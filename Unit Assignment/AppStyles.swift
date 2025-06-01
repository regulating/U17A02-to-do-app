import SwiftUI

struct AppColors {
    static let primaryBackground = Color(UIColor.systemGroupedBackground) // A light gray, adapts to light/dark mode
    static let secondaryBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let accent = Color.green // Similar to the green in your mockups
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let destructive = Color.red
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(AppColors.accent)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .foregroundColor(AppColors.destructive)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColors.destructive, lineWidth: 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(AppColors.secondaryBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
