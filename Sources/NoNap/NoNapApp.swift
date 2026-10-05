import AppKit
import NoNapCore
import SwiftUI

@MainActor
@main
struct NoNapApp: App {
    @StateObject private var sleepController = SleepController()

    var body: some Scene {
        MenuBarExtra {
            Toggle(
                "Не спать при простое",
                isOn: Binding(
                    get: { sleepController.isEnabled },
                    set: { sleepController.setEnabled($0) }
                )
            )
            Divider()
            Button("Завершить") {
                sleepController.setEnabled(false)
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: sleepController.isEnabled ? "sun.max.fill" : "moon.zzz")
        }
    }
}
