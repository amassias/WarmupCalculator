import SwiftUI
import AudioToolbox

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var timeRemaining = 60
    @State private var isActive = false
    @State private var selectedTime = 60
    @State private var timer: Timer?

    private let timeOptions = [30, 45, 60, 90, 120, 180]

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()

                VStack(spacing: 22) {
                    header
                    timerRing
                    timeOptionsGrid
                    controlButtons
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 18)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .navigationTitle(Localization.localizedString("Rest Timer"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Localization.localizedString("Fermer")) { dismiss() }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
            .onChange(of: selectedTime) { _, newValue in
                guard !isActive else { return }
                timeRemaining = newValue
            }
        }
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text(Localization.localizedString("Rest Timer"))
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.textPrimary)

            Text(Localization.localizedString("Sélectionnez le repos"))
                .font(.subheadline)
                .foregroundStyle(AppTheme.textSecondary)
        }
        .padding(.top, 6)
    }

    private var timerRing: some View {
        let elapsed = min(max(Double(selectedTime - timeRemaining) / Double(max(selectedTime, 1)), 0), 1)

        return ZStack {
            Circle()
                .stroke(Color.white.opacity(0.45), style: StrokeStyle(lineWidth: 18, lineCap: .round))

            Circle()
                .trim(from: 0, to: elapsed)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.90, green: 0.21, blue: 0.20),
                            Color(red: 0.99, green: 0.54, blue: 0.25),
                            Color(red: 0.17, green: 0.67, blue: 0.55)
                        ]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.9), value: timeRemaining)

            VStack(spacing: 6) {
                Text(timeString(time: timeRemaining))
                    .font(.system(size: 52, weight: .bold, design: .rounded))
                    .foregroundStyle(AppTheme.textPrimary)

                Text(Localization.localizedString(isActive ? "RUNNING" : "READY"))
                    .font(.caption.weight(.semibold))
                    .kerning(1.3)
                    .foregroundStyle(isActive ? AppTheme.accent : AppTheme.textSecondary)
            }
        }
        .frame(width: 250, height: 250)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 34, style: .continuous)
                        .stroke(Color.white.opacity(0.65), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 14, x: 0, y: 8)
        )
    }

    private var timeOptionsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
            ForEach(timeOptions, id: \.self) { option in
                Button {
                    selectedTime = option
                    if !isActive {
                        timeRemaining = option
                    }
                } label: {
                    Text(timeString(time: option))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(selectedTime == option ? Color.white : AppTheme.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(selectedTime == option ? AppTheme.coolGradient : LinearGradient(colors: [Color.white.opacity(0.85), Color.white.opacity(0.65)], startPoint: .top, endPoint: .bottom))
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.7), lineWidth: 1)
                )
        )
    }

    private var controlButtons: some View {
        HStack(spacing: 16) {
            Button(action: resetTimer) {
                Label(Localization.localizedString("Reset"), systemImage: "arrow.counterclockwise")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.8))
                    )
            }

            Button(action: toggleTimer) {
                Label(Localization.localizedString(isActive ? "Pause" : "Start"), systemImage: isActive ? "pause.fill" : "play.fill")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isActive ? AppTheme.coolGradient : AppTheme.accentGradient)
                            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                    )
            }
        }
    }

    private func toggleTimer() {
        isActive.toggle()

        if isActive {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    AudioServicesPlaySystemSound(1005)
                    resetTimer()
                }
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }

    private func resetTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
        timeRemaining = selectedTime
    }

    private func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
