import Foundation
import Testing
@testable import NoNapCore

@MainActor
private final class FakeSleepActivityManager: SleepActivityManaging {
    let token = NSObject()
    private(set) var beginCount = 0
    private(set) var endCount = 0
    private(set) var endedToken: NSObjectProtocol?

    func beginActivity() -> NSObjectProtocol {
        beginCount += 1
        return token
    }

    func endActivity(_ activity: NSObjectProtocol) {
        endCount += 1
        endedToken = activity
    }
}

@Suite("Sleep controller")
struct SleepControllerTests {
    @Test @MainActor func testStartsDisabledWithoutBeginningActivity() {
        let manager = FakeSleepActivityManager()
        let controller = SleepController(activityManager: manager)

        #expect(!controller.isEnabled)
        #expect(manager.beginCount == 0)
        #expect(manager.endCount == 0)
    }

    @Test @MainActor func testEnableAndDisableEndsTheSameActivity() {
        let manager = FakeSleepActivityManager()
        let controller = SleepController(activityManager: manager)

        controller.setEnabled(true)
        #expect(controller.isEnabled)
        #expect(manager.beginCount == 1)

        controller.setEnabled(false)
        #expect(!controller.isEnabled)
        #expect(manager.endCount == 1)
        #expect(manager.endedToken.map { ObjectIdentifier($0 as AnyObject) } == ObjectIdentifier(manager.token))
    }

    @Test @MainActor func testRepeatedRequestsAreIdempotent() {
        let manager = FakeSleepActivityManager()
        let controller = SleepController(activityManager: manager)

        controller.setEnabled(true)
        controller.setEnabled(true)
        controller.setEnabled(false)
        controller.setEnabled(false)

        #expect(manager.beginCount == 1)
        #expect(manager.endCount == 1)
        #expect(!controller.isEnabled)
    }

    @Test @MainActor func testDisablingWhileDisabledDoesNotEndAnActivity() {
        let manager = FakeSleepActivityManager()
        let controller = SleepController(activityManager: manager)

        controller.setEnabled(false)

        #expect(manager.beginCount == 0)
        #expect(manager.endCount == 0)
    }
}
