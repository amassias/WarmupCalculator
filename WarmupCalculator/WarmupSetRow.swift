import SwiftUI

struct WarmupSetRow: View {
    let set: WarmupSet
    let unit: WeightUnit

    var body: some View {
        HStack(spacing: 14) {
            setIndexBadge

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(set.weight, specifier: "%.1f") \(unit.displayName)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)

                    Spacer()

                    Text("\(set.percentage)%")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule(style: .continuous)
                                .fill(AppTheme.accent.opacity(0.14))
                        )
                }

                Text(Localization.localizedString("%d répétitions • %d%%", arguments: set.reps, set.percentage))
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)

                if let note = set.note {
                    Text(LocalizedStringKey(note))
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(AppTheme.accentAlt)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.76))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.82), lineWidth: 1)
                )
        )
    }

    private var setIndexBadge: some View {
        ZStack {
            Circle()
                .fill(AppTheme.coolGradient)
                .frame(width: 38, height: 38)

            Text("\(set.setNumber)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
        }
    }
}

struct WarmupSetRow_Previews: PreviewProvider {
    static var previews: some View {
        WarmupSetRow(
            set: WarmupSet(setNumber: 1, weight: 60, reps: 8, percentage: 50),
            unit: .kg
        )
        .padding()
        .background(AppBackgroundView())
        .previewLayout(.sizeThatFits)
    }
}
