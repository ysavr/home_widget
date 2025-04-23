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
        let count = userDefault?.integer(forKey: "count_key") ?? 0
        return SimpleEntry(date: Date(), count: count)
    }
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 0)
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

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let count: Int
}

struct MyHomeWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
      
      var body: some View {
        if family == .accessoryCircular {
          ZStack {
            Circle()
              .fill(Color.blue.opacity(0.2))
            Text(entry.count.description)
              .font(.system(size: 24, weight: .bold))
          }
        } else {
          VStack {
            Text("You have pushed the button this many times:")
              .font(.caption2)
              .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Text(entry.count.description)
              .font(.title)
              .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            HStack {
              // This button is for clearing
              Button(intent: BackgroundIntent(method: "clear")) {
                Image(systemName: "xmark")
                  .font(.system(size: 16))
                  .foregroundColor(.red)
                  .frame(width: 24, height: 24)
              }
              .buttonStyle(.plain)
              .frame(alignment: .leading)
              
              Spacer()
              
              // This button is for incrementing
              Button(intent: BackgroundIntent(method: "increment")) {
                Image(systemName: "plus")
                  .font(.system(size: 16))
                  .foregroundColor(.white)
              }
              .frame(width: 24, height: 24)
              .background(.blue)
              .cornerRadius(12)
              .frame(alignment: .trailing)
            }
          }
        }
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
    SimpleEntry(date: .now, count: 0)
    SimpleEntry(date: .now, count: 0)
}
