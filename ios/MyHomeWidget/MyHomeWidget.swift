//
//  MyHomeWidget.swift
//  MyHomeWidget
//
//  Created by mobiledev on 23/04/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private func getDatafromFlutter() -> SimpleEntry {
        let userDefault = UserDefaults(suiteName: "group.com.ex.homewidgetdemo")
        let textFromFlutter = userDefault?.string(forKey: "text_from_flutter_app") ?? "-"
        return SimpleEntry(date: Date(), text: textFromFlutter)
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "-")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = getDatafromFlutter()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = getDatafromFlutter()
        let timeline = Timeline(entries: [entries], policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
}

struct MyHomeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.text)
    }
}

struct MyHomeWidget: Widget {
    let kind: String = "MyHomeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MyHomeWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyHomeWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    MyHomeWidget()
} timeline: {
    SimpleEntry(date: .now, text: "halo")
    SimpleEntry(date: .now, text: "halo")
}
