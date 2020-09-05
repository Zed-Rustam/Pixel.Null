//
//  Widgets.swift
//  Widgets
//
//  Created by Рустам Хахук on 26.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        getProjects()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 10 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 5, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getProjects() -> [String] {
        print("EEE")
        print(try! FileManager.default.contentsOfDirectory(atPath: getDocumentsDirectory().path))
        
        return []
    }
    
    func getDocumentsDirectory() -> URL {
        //let paths = FileManager.default.urls(for: .userDirectory, in: .userDomainMask)
        
        print(try! FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask))
        
        return try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    //let projectName: String
    let configuration: ConfigurationIntent
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            Image(uiImage: #imageLiteral(resourceName: "background"))
                .resizable()
                .antialiased(false)
                .interpolation(.none)
                .aspectRatio(contentMode: .fill)
            
            Image(uiImage: #imageLiteral(resourceName: "theme_icon_light"))
                .resizable()
                //.antialiased(false)
                .interpolation(.none)
                .aspectRatio(contentMode: .fit)
            
//            Rectangle()
//                .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0),Color.black.opacity(0.05),Color.black.opacity(0.15), Color.black.opacity(0.3)]), startPoint: UnitPoint(x: 0.5, y: 0.5), endPoint: UnitPoint(x: 0.5, y: 1)))
            
//            VStack{
//                Spacer()
//                HStack{
//                    Text("Project name")
//                        .font(Font.system(size: 12, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                        .offset(x: 16, y: -16)
//                    Spacer()
//                }
//            }
        })
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("nanoArt Widget")
        .description("widget for preview your projects")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct Widgets_Previews_2: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


struct Widgets_Previews_3: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
