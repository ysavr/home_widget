//
//  BackgroundIntent.swift
//  MyHomeWidgetExtension
//
//  Created by mobiledev on 23/04/25.
//

import AppIntents
import Foundation
import home_widget
import WidgetKit

@available(iOS 17, *)
public struct BackgroundIntent: AppIntent {
  static public var title: LocalizedStringResource = "Increment Counter"

  @Parameter(title: "Method")
  var method: String

  public init() {
    method = "increment"
  }

  public init(method: String) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
      let userDefaults = UserDefaults(suiteName: "group.com.ex.homewidgetdemo")
        var count = userDefaults?.integer(forKey: "count_key") ?? 0

        if method == "increment" {
          count += 1
        } else if method == "clear" {
          count = 0
        }

        userDefaults?.set(count, forKey: "count_key")

        // Reload the widget timeline
        WidgetCenter.shared.reloadTimelines(ofKind: "MyHomeWidget")

        return .result()  }
}

/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}

