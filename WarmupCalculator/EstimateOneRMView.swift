import SwiftUI

struct EstimateOneRMView: View {
    let unit: WeightUnit
    let onUseEstimate: (Double) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var weightInput: String = ""
    @State private var reps: Int = 5

    private let calculator = WarmupCalculator()

    private var estimate: Double? {
        let normalized = weightInput.replacingOccurrences(of: ",", with: ".")
        guard let weight = Double(normalized), weight > 0 else { return nil }
        return calculator.estimateOneRepMax(weight: weight, reps: reps)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView {
                    VStack(spacing: 16) {
                        inputCard
                        estimationCard

                        if let estimate {
                            Button {
                                onUseEstimate(estimate)
                                dismiss()
                            } label: {
                                Label(Localization.localizedString("Utiliser comme charge de travail"), systemImage: "arrow.down.circle")
                            }
                            .buttonStyle(GradientActionButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(Localization.localizedString("Estimer mon 1RM"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localization.localizedString("Fermer")) { dismiss() }
                }
            }
        }
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(Localization.localizedString("Performance récente"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            TextField(Localization.localizedString("Poids soulevé"), text: $weightInput)
                .keyboardType(.decimalPad)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.78))
                )

            Stepper(value: $reps, in: 1...20) {
                Text(Localization.localizedString("Répétitions: %d", arguments: reps))
                    .foregroundStyle(AppTheme.textPrimary)
            }
        }
        .appCard()
    }

    private var estimationCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.localizedString("Estimation"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            if let estimate {
                Text(Localization.localizedString("1RM estimé : %.1f %@", arguments: estimate, unit.displayName))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(AppTheme.accent)

                Text(Localization.localizedString("Formule de Brzycki – résultat indicatif, votre 1RM réel peut varier."))
                    .font(.footnote)
                    .foregroundStyle(AppTheme.textSecondary)
            } else {
                Text(Localization.localizedString("Entrez un poids et des répétitions valides pour obtenir une estimation."))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .appCard()
    }
}

struct EstimateOneRMView_Previews: PreviewProvider {
    static var previews: some View {
        EstimateOneRMView(unit: .kg) { _ in }
    }
}
