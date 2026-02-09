import SwiftUI

struct WarmupModelInfoView: View {
    var body: some View {
        ZStack {
            AppBackgroundView()

            ScrollView {
                VStack(spacing: 16) {
                    modelCard(
                        title: Localization.localizedString("Modèle Progressif"),
                        icon: WarmupModel.progressive.icon,
                        iconGradient: AppTheme.accentGradient,
                        description: Localization.localizedString("Idéal pour les charges maximales et la force. On augmente progressivement le pourcentage du poids de travail pour préparer le système nerveux et affiner la technique."),
                        protocolLines: [
                            Localization.localizedString("50-60% × 8 répétitions"),
                            Localization.localizedString("70% × 5 répétitions"),
                            Localization.localizedString("80% × 3 répétitions"),
                            Localization.localizedString("90-95% × 1 répétition")
                        ],
                        detail: Localization.localizedString("Les athlètes avancés peuvent ajouter une montée intermédiaire supplémentaire ou un single léger à 92%."),
                        whenToUse: Localization.localizedString("• Séances de force lourde (squat, développé couché, soulevé de terre).\n• Objectif : maximiser la performance sur une charge principale.\n• Parfait pour les pratiquants intermédiaires et avancés qui veulent limiter les surprises sur la série de travail.")
                    )

                    modelCard(
                        title: Localization.localizedString("Modèle Potentiation 80%"),
                        icon: WarmupModel.potentiation80.icon,
                        iconGradient: AppTheme.coolGradient,
                        description: Localization.localizedString("Échauffement court et intense pour passer rapidement aux séries effectives. Utilise une montée directe vers 80-85% pour activer sans générer trop de fatigue."),
                        protocolLines: [
                            Localization.localizedString("≈50% × 6-8 répétitions"),
                            Localization.localizedString("≈80% × 3-5 répétitions")
                        ],
                        detail: Localization.localizedString("Les pratiquants avancés peuvent ajouter un single à 90-92% pour maximiser la potentiation."),
                        whenToUse: Localization.localizedString("• Séances explosives ou de vitesse.\n• Athlètes confirmés disposant de peu de temps.\n• À privilégier sur les mouvements polyarticulaires. Pour les isolations, limitez-vous à 1-2 séries légères.")
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle(Localization.localizedString("Modèles d'échauffement"))
    }

    private func modelCard(
        title: String,
        icon: String,
        iconGradient: LinearGradient,
        description: String,
        protocolLines: [String],
        detail: String,
        whenToUse: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(iconGradient)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Image(systemName: icon)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                    }

                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                Spacer()
            }

            Text(description)
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)

            VStack(alignment: .leading, spacing: 8) {
                Text(Localization.localizedString("Protocole recommandé"))
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                ForEach(Array(protocolLines.enumerated()), id: \.offset) { index, line in
                    HStack(spacing: 8) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(Circle().fill(AppTheme.accentAlt))

                        Text(line)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                }

                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
            }
            .padding(.top, 4)

            VStack(alignment: .leading, spacing: 6) {
                Text(Localization.localizedString("Quand l'utiliser ?"))
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Text(whenToUse)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .appCard()
    }
}

struct WarmupModelInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WarmupModelInfoView()
        }
    }
}
