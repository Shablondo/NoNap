import Combine
import Foundation

@MainActor
public final class SleepController: ObservableObject {
    @Published private var activity: NSObjectProtocol?
    private let activityManager: any SleepActivityManaging

    public var isEnabled: Bool { activity != nil }

    public init(activityManager: any SleepActivityManaging = ProcessInfoSleepActivityManager()) {
        self.activityManager = activityManager
    }

    public func setEnabled(_ enabled: Bool) {
        guard enabled != isEnabled else { return }

        if enabled {
            activity = activityManager.beginActivity()
        } else if let activity {
            activityManager.endActivity(activity)
            self.activity = nil
        }
    }
}
