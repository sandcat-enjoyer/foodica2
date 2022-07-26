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

private func makeData() -> PieChartData {
    let data = PieDataSet(
    dataPoints: [
        PieChartDataPoint(value: 7, description: "Fat", colour: .red),
                        PieChartDataPoint(value: 2, description: "Sugar",   colour: .blue),
                        PieChartDataPoint(value: 9, description: "Salt", colour: .green),
                        PieChartDataPoint(value: 6, description: "Saturated Fat",  colour: .green)
    ], legendTitle: "Foodica"
    )
    
    return PieChartData(dataSets: data, metadata: ChartMetadata(title: "Calories consumed", subtitle: ""), chartStyle: PieChartStyle(infoBoxPlacement: .header))
}

struct CalorieWidgetEntryView : View {
    var entry: Provider.Entry
    var data: PieChartData = makeData()
    private var FlutterDataView: some View {
        VStack {
            PieChart(chartData: data)
                .touchOverlay(chartData: data)
                .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])
                .frame(minWidth: 150, maxWidth: 300, minHeight: 150, idealHeight: 200, maxHeight: 300, alignment: .center)
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

