import SwiftUI

struct MainCalculatorView: View {
    @EnvironmentObject private var exerciseLibrary: ExerciseLibrary
    @StateObject private var viewModel = MainCalculatorViewModel()

    @AppStorage(StorageKeys.preferredUnit) private var storedUnit = WeightUnit.kg.rawValue
    @AppStorage(StorageKeys.userLevel) private var storedLevel = UserLevel.intermediate.rawValue

    @State private var showExerciseSheet = false
    @State private var showModelInfo = false
    @State private var showEstimateSheet = false
    @State private var showTimer = false
    @State private var previousUnit: WeightUnit = .kg

    private var weightUnit: WeightUnit {
        WeightUnit(rawValue: storedUnit) ?? .kg
    }

    private var userLevel: UserLevel {
        UserLevel(rawValue: storedLevel) ?? .intermediate
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                ScrollView {
                    VStack(spacing: 16) {
                        header
                        exerciseCard
                        warmupModelCard
                        calculateButton
                        resultsCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle(Localization.localizedString("Warmup Calculator"))
            .sheet(isPresented: $showExerciseSheet) {
                NavigationStack {
                    ExerciseSelectionView(selectedExercise: $viewModel.selectedExercise)
                        .environmentObject(exerciseLibrary)
                }
            }
            .sheet(isPresented: $showModelInfo) {
                NavigationStack { WarmupModelInfoView() }
            }
            .sheet(isPresented: $showEstimateSheet) {
                EstimateOneRMView(unit: weightUnit) { estimated in
                    viewModel.updateWorkingWeight(with: estimated)
                }
            }
            .sheet(isPresented: $showTimer) {
                TimerView()
            }
            .tint(AppTheme.accent)
            .onAppear {
                previousUnit = weightUnit
            }
            .onChange(of: storedUnit) { _, _ in
                let newUnit = weightUnit
                convertWorkingWeight(from: previousUnit, to: newUnit)
                previousUnit = newUnit
                recalculateIfNeeded()
            }
            .onChange(of: storedLevel) { _, _ in
                recalculateIfNeeded()
            }
            .onChange(of: viewModel.warmupModel) { _, _ in
                recalculateIfNeeded()
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(Localization.localizedString("Science-based warmups"))
                    .font(.title2.weight(.bold))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(Localization.localizedString("Optimisez vos séries d'échauffement selon l'exercice, le protocole et votre niveau."))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppTheme.coolGradient)
                    .frame(width: 54, height: 54)
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
            }
        }
        .appCard()
    }

    private var exerciseCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(Localization.localizedString("Exercice & charge"))
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            Button {
                showExerciseSheet = true
            } label: {
                HStack(spacing: 12) {
                    Group {
                        if let exercise = viewModel.selectedExercise {
                            Image(systemName: exercise.iconName)
                                .font(.headline)
                                .frame(width: 34, height: 34)
                                .background(Circle().fill(AppTheme.accent.opacity(0.18)))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(exercise.name)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text(exercise.type.displayName)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                        } else {
                            Image(systemName: "list.bullet")
                                .font(.headline)
                                .frame(width: 34, height: 34)
                                .background(Circle().fill(AppTheme.accent.opacity(0.18)))

                            Text(Localization.localizedString("Choisir un exercice"))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                )
            }

            VStack(alignment: .leading, spacing: 10) {
                Text(Localization.localizedString("Poids de travail"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                HStack(spacing: 10) {
                    TextField(Localization.localizedString("Poids"), text: $viewModel.workingWeightInput)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 11)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.78))
                        )

                    Picker(Localization.localizedString("Unité"), selection: $storedUnit) {
                        ForEach(WeightUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 126)
                }

                Button {
                    showEstimateSheet = true
                } label: {
                    Label(Localization.localizedString("Estimer mon 1RM"), systemImage: "function")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(AppTheme.accent)
                }

                Label(Localization.localizedString("Niveau : %@", arguments: userLevel.displayName), systemImage: "person.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
        .appCard()
    }

    private var warmupModelCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label(Localization.localizedString("Modèle d'échauffement"), systemImage: viewModel.warmupModel.icon)
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)

                Spacer()

                Button {
                    showModelInfo = true
                } label: {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundStyle(AppTheme.accent)
                }
                .buttonStyle(.plain)
            }

            Picker(Localization.localizedString("Modèle"), selection: $viewModel.warmupModel) {
                ForEach(WarmupModel.allCases) { model in
                    Text(model.title).tag(model)
                }
            }
            .pickerStyle(.segmented)

            Text(viewModel.warmupModel.summary)
                .font(.footnote)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .appCard()
    }

    private var calculateButton: some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.calculate(unit: weightUnit, userLevel: userLevel)
            }
        } label: {
            Label(Localization.localizedString("Calculer l'échauffement"), systemImage: "flame.fill")
        }
        .buttonStyle(GradientActionButtonStyle())
        .disabled(viewModel.selectedExercise == nil || viewModel.workingWeightInput.isEmpty)
        .padding(.horizontal, 2)
    }

    private var resultsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label(Localization.localizedString("Protocoles générés"), systemImage: "bolt.heart.fill")
                    .font(.headline)
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()

                if !viewModel.warmupSets.isEmpty {
                    Button {
                        showTimer = true
                    } label: {
                        Label(Localization.localizedString("Timer"), systemImage: "timer")
                            .font(.subheadline.weight(.medium))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.accentAlt)
                }
            }

            if viewModel.warmupSets.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.headline)
                        .foregroundStyle(AppTheme.accent)
                    Text(Localization.localizedString("Renseignez votre exercice et votre charge puis lancez le calcul pour voir les séries recommandées."))
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.65))
                )
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.warmupSets) { set in
                        WarmupSetRow(set: set, unit: weightUnit)
                    }
                }

                VStack(alignment: .leading, spacing: 7) {
                    Text(Localization.localizedString("Recommandations"))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(Localization.localizedString("• Repos 45-60 sec entre les séries d'échauffement.\n• Repos 2-3 min avant la série de travail.\n• Concentrez-vous sur la technique et la respiration."))
                        .font(.footnote)
                        .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.top, 2)
            }
        }
        .appCard()
    }

    private func convertWorkingWeight(from oldUnit: WeightUnit, to newUnit: WeightUnit) {
        guard oldUnit != newUnit else { return }
        let normalized = viewModel.workingWeightInput.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value > 0 else { return }

        let valueInKg = oldUnit == .kg ? value : value / WeightUnit.lbs.conversionFactor
        let converted = newUnit == .kg ? valueInKg : valueInKg * WeightUnit.lbs.conversionFactor
        viewModel.updateWorkingWeight(with: converted)
    }

    private func recalculateIfNeeded() {
        guard !viewModel.warmupSets.isEmpty else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.88)) {
            viewModel.calculate(unit: weightUnit, userLevel: userLevel)
        }
    }
}

struct MainCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        MainCalculatorView()
            .environmentObject(ExerciseLibrary())
    }
}
