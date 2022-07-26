//
//  CalorieWidget.swift
//  CalorieWidget
//
//  Created by Jules Debbaut on 19/07/2022.
//

import WidgetKit
import SwiftUI
import Intents
import SwiftUICharts

struct Provider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), flutterData: FlutterData(text: "Calories Consumed"))
    }
    //this is where the data for the preview in the widget gallery gets generated. this can just be dummy data
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), flutterData: FlutterData(text: "Calories Consumed"))
        completion(entry)
    }
    
    //this is where we grab our timeline, the place where we grab our widgetData from the app itself
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
        VStack {
            let salt = Legend(color: .green, label: "Salt", order: 1)
            let sugar = Legend(color: .blue, label: "Sugar", order: 2)
            let saturatedFat = Legend(color: .orange, label: "Saturated Fat", order: 3)
            let fat = Legend(color: .red, label: "Fat", order: 4)

            let points: [DataPoint] = [
                .init(value: 70, label: "", legend: salt),
                .init(value: 50, label: "", legend: sugar),
                .init(value: 30, label: "", legend: saturatedFat),
                .init(value: 90, label: "", legend: fat)
            ]
            
            BarChartView(dataPoints: points)
        }
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
