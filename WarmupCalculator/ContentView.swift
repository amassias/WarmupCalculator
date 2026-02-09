import SwiftUI

struct ContentView: View {
    @StateObject private var exerciseLibrary = ExerciseLibrary()
    @AppStorage(StorageKeys.selectedLanguage) private var storedLanguage = AppLanguage.french.rawValue

    private var appLanguage: AppLanguage {
        AppLanguage(rawValue: storedLanguage) ?? .french
    }

    var body: some View {
        TabView {
            MainCalculatorView()
                .tabItem {
                    Label(Localization.localizedString("Calcul"), systemImage: "flame.fill")
                }

            ProfileView()
                .tabItem {
                    Label(Localization.localizedString("Profil"), systemImage: "person.crop.circle")
                }
        }
        .tint(AppTheme.accent)
        .environmentObject(exerciseLibrary)
        .environment(\.locale, Locale(identifier: appLanguage.localeIdentifier))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
