import SwiftUI

struct ExerciseTypeInfoView: View {
    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(Localization.localizedString("Comprendre les catégories"))
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)

                        ForEach(ExerciseType.allCases) { type in
                            VStack(alignment: .leading, spacing: 6) {
                                Label(type.displayName, systemImage: type.sfSymbolName)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.textPrimary)

                                Text(type.helpText)
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.white.opacity(0.75))
                            )
                        }
                    }
                    .appCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Text(Localization.localizedString("Conseils pratiques"))
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)

                        Text(Localization.localizedString("• Les mouvements polyarticulaires demandent davantage de séries d'échauffement.\n• Les exercices d'isolation se contentent d'1 à 2 séries légères avant d'attaquer le travail.\n• Si vous hésitez, pensez au nombre d'articulations impliquées et à la charge habituelle."))
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .appCard()
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(Localization.localizedString("Types d'exercices"))
    }
}

struct ExerciseTypeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseTypeInfoView()
        }
    }
}
