import SwiftUI

struct ExerciseSelectionView: View {
    @EnvironmentObject private var exerciseLibrary: ExerciseLibrary
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedExercise: Exercise?

    @State private var showAddExercise = false
    @State private var searchText = ""

    var body: some View {
        ZStack {
            AppBackgroundView()

            List {
                ForEach(ExerciseType.allCases) { type in
                    let exercises = filteredExercises(for: type)
                    if !exercises.isEmpty {
                        Section(header: Label(type.displayName, systemImage: type.sfSymbolName)) {
                            ForEach(exercises) { exercise in
                                Button {
                                    selectedExercise = exercise
                                    dismiss()
                                } label: {
                                    row(for: exercise)
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(Color.clear)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        showAddExercise = true
                    } label: {
                        HStack {
                            Label(Localization.localizedString("Ajouter un exercice"), systemImage: "plus.circle")
                                .foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.white.opacity(0.72))
                        )
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                } footer: {
                    Text(Localization.localizedString("Impossible de trouver votre mouvement ? Ajoutez-le et indiquez sa catégorie."))
                }

                Section {
                    NavigationLink(destination: ExerciseTypeInfoView()) {
                        Label(Localization.localizedString("Polyarticulaire vs Isolation"), systemImage: "questionmark.circle")
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(Localization.localizedString("Choisir un exercice"))
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(Localization.localizedString("Fermer")) { dismiss() }
            }
        }
        .searchable(text: $searchText, prompt: Localization.localizedString("Choisir un exercice"))
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView { name, type, equipment in
                try exerciseLibrary.addCustomExercise(name: name, type: type, equipment: equipment)
            }
        }
    }

    private func filteredExercises(for type: ExerciseType) -> [Exercise] {
        let exercises = exerciseLibrary.exercises(by: type)
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return exercises
        }

        return exercises.filter { exercise in
            exercise.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func row(for exercise: Exercise) -> some View {
        HStack(spacing: 12) {
            Image(systemName: exercise.iconName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.accentAlt)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(AppTheme.accentAlt.opacity(0.16))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(exercise.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(exercise.type.displayName)
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            if exercise.id == selectedExercise?.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.accent)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.76))
        )
    }
}

struct ExerciseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ExerciseSelectionView(selectedExercise: .constant(nil))
                .environmentObject(ExerciseLibrary())
        }
    }
}
