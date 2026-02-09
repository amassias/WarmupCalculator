import SwiftUI

struct ProfileView: View {
    @AppStorage(StorageKeys.userLevel) private var storedLevel = UserLevel.intermediate.rawValue
    @AppStorage(StorageKeys.preferredUnit) private var storedUnit = WeightUnit.kg.rawValue
    @AppStorage(StorageKeys.selectedLanguage) private var storedLanguage = AppLanguage.french.rawValue

    private var userLevel: UserLevel {
        UserLevel(rawValue: storedLevel) ?? .intermediate
    }

    private var preferredUnit: WeightUnit {
        WeightUnit(rawValue: storedUnit) ?? .kg
    }

    private var appLanguage: AppLanguage {
        AppLanguage(rawValue: storedLanguage) ?? .french
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView {
                    VStack(spacing: 16) {
                        header
                        trainingLevelCard
                        unitCard
                        languageCard
                        resourcesCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(Localization.localizedString("Profil & réglages"))
            .tint(AppTheme.accent)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 34))
                .foregroundStyle(AppTheme.accent)

            VStack(alignment: .leading, spacing: 4) {
                Text(Localization.localizedString("Profil"))
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Text(Localization.localizedString("Niveau : %@", arguments: userLevel.displayName))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()
        }
        .appCard()
    }

    private var trainingLevelCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.localizedString("Niveau d'entraînement"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Picker(Localization.localizedString("Niveau"), selection: $storedLevel) {
                ForEach(UserLevel.allCases) { level in
                    Text(level.displayName).tag(level.rawValue)
                }
            }
            .pickerStyle(.segmented)

            Text(userLevel.description)
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .appCard()
    }

    private var unitCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.localizedString("Unités de poids"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Picker(Localization.localizedString("Unité"), selection: $storedUnit) {
                ForEach(WeightUnit.allCases) { unit in
                    Text(unit.displayName).tag(unit.rawValue)
                }
            }
            .pickerStyle(.segmented)

            Text(Localization.localizedString("Le choix est mémorisé et utilisé pour tous les calculs."))
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)

            Text("• \(preferredUnit.displayName)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.accentAlt)
        }
        .appCard()
    }

    private var languageCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.localizedString("Langue de l'application"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Picker(Localization.localizedString("Langue"), selection: $storedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language.rawValue)
                }
            }
            .pickerStyle(.segmented)

            Text(Localization.localizedString("Langue actuelle : %@", arguments: appLanguage.displayName))
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)

            Text(Localization.localizedString("Le changement de langue s'applique immédiatement."))
                .font(.caption)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .appCard()
    }

    private var resourcesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(Localization.localizedString("Ressources"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            NavigationLink(destination: WarmupModelInfoView()) {
                resourceRow(
                    title: Localization.localizedString("Comprendre les protocoles"),
                    icon: "flame.fill"
                )
            }

            NavigationLink(destination: ExerciseTypeInfoView()) {
                resourceRow(
                    title: Localization.localizedString("Différence polyarticulaire / isolation"),
                    icon: "questionmark.circle"
                )
            }
        }
        .appCard()
    }

    private func resourceRow(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(AppTheme.accentAlt)
            Text(title)
                .foregroundStyle(AppTheme.textPrimary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.75))
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
