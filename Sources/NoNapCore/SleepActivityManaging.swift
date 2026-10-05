import Foundation

@MainActor
public protocol SleepActivityManaging: AnyObject {
    func beginActivity() -> NSObjectProtocol
    func endActivity(_ activity: NSObjectProtocol)
}

@MainActor
public final class ProcessInfoSleepActivityManager: SleepActivityManaging {
    nonisolated public init() {}

    public func beginActivity() -> NSObjectProtocol {
        ProcessInfo.processInfo.beginActivity(
            options: [.idleSystemSleepDisabled, .idleDisplaySleepDisabled],
            reason: "NoNap is keeping the Mac and display awake while idle"
        )
    }

    public func endActivity(_ activity: NSObjectProtocol) {
        ProcessInfo.processInfo.endActivity(activity)
    }
}
