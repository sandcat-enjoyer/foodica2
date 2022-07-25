//
//  CalorieWidget.swift
//  CalorieWidget
//
//  Created by Jules Debbaut on 19/07/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: nil)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.julesdebbaut.foodica")
        var flutterData: FlutterData? = nil
        
        if (sharedDefaults != nil) {
            do {
                let shared = sharedDefaults?.string(forKey: "widgetData")
                if (shared != nil) {
                    let decoder = JSONDecoder()
                    flutterData = try decoder.decode(FlutterData.self, from: shared!.data(using: .utf8)!)
                }
            }
            catch {
                print(error)
            }
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,flutterData: flutterData)
            entries.append(entry)
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct FlutterData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let flutterData: FlutterData?
}

struct CalorieWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var FlutterDataView: some View {
        Text(entry.flutterData!.text)
    }
    
    private var NoDataView: some View {
        Text("No data found.")
    }

    var body: some View {
        if (entry.flutterData == nil) {
            NoDataView
        }
        else {
            FlutterDataView
        }
    }
}

@main
struct CalorieWidget: Widget {
    let kind: String = "CalorieWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            CalorieWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Foodica")
        .description("Keep track of your currently consumed calories.")
    }
}

struct CalorieWidget_Previews: PreviewProvider {
    static var previews: some View {
        CalorieWidgetEntryView(entry: SimpleEntry(date: Date(), flutterData: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
