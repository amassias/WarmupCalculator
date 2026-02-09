import SwiftUI

struct AddExerciseView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var type: ExerciseType = .compound
    @State private var equipment: EquipmentType = .barbell
    @State private var errorMessage: String?

    let onAdd: (String, ExerciseType, EquipmentType) throws -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                Form {
                    Section {
                        TextField(Localization.localizedString("Nom"), text: $name)
                    } header: {
                        Text(Localization.localizedString("Nom de l'exercice"))
                    }

                    Section(header: Text(Localization.localizedString("Catégorie"))) {
                        Picker(Localization.localizedString("Type"), selection: $type) {
                            ForEach(ExerciseType.allCases) { exerciseType in
                                Text(exerciseType.displayName).tag(exerciseType)
                            }
                        }

                        Picker(Localization.localizedString("Matériel"), selection: $equipment) {
                            ForEach(EquipmentType.allCases) { equipment in
                                Label(equipment.displayName, systemImage: equipment.sfSymbolName)
                                    .tag(equipment)
                            }
                        }
                    }

                    Section(footer: Text(Localization.localizedString("Les exercices ajoutés sont sauvegardés localement sur l'appareil."))) {
                        EmptyView()
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(Localization.localizedString("Nouvel exercice"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localization.localizedString("Fermer")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(Localization.localizedString("Ajouter")) {
                        do {
                            try onAdd(name, type, equipment)
                            dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert(
                Localization.localizedString("Erreur"),
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { shouldShow in
                        if !shouldShow {
                            errorMessage = nil
                        }
                    }
                )
            ) {
                Button(Localization.localizedString("OK"), role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        AddExerciseView { _, _, _ in }
    }
}
