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
        
        return SimpleEntry(date: Date(),image: #imageLiteral(resourceName: "theme_icon_light") ,type: .rect, configuration: ConfigurationIntent(), colors: [], positions: [0,0,0,0])
    }

    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let project = getProjects().randomElement()!

        let image = UIImage(data: try! Data(contentsOf: project.appendingPathComponent("preview.png")))!
        
        var type: FormStyle = .rect
        
        if image.size.width / image.size.height >= 1.5 {
            type = .width
        } else if image.size.height / image.size.width >= 1.5 {
            type = .height
        }
        
        //print()
        let data = try! Data(contentsOf: project.appendingPathComponent("colors.json"))
        
        let colors: [String] = try! JSONDecoder().decode([String].self, from: data)
        
        let entry = SimpleEntry(date: Date(),image: image, type: type, configuration: configuration, colors: colors, positions: getPositions(colors: colors))
        
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
                
        let currentDate = Date()
        for hourOffset in 0 ..< getProjects().count {
            let project = getProjects()[hourOffset]
            
            print("EEEEE \(project.path)")

            let image = UIImage(data: try! Data(contentsOf: project.appendingPathComponent("preview.png")))!
            
            var type: FormStyle = .rect
            
            if image.size.width / image.size.height >= 1.5 {
                type = .width
            } else if image.size.height / image.size.width >= 1.5 {
                type = .height
            }
            
            //print()
            let data = try! Data(contentsOf: project.appendingPathComponent("colors.json"))
            
            let colors: [String] = try! JSONDecoder().decode([String].self, from: data)
            
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset * 10, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,image: image, type: type, configuration: configuration, colors: colors,positions: getPositions(colors: colors))
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func getProjects() -> [URL] {
        print("EEE")
        
        let files = try! FileManager.default.contentsOfDirectory(at: getDocumentsDirectory().appendingPathComponent("projects"), includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        var projects: [URL] = []
        
        
        files.forEach({
            projects.append($0)
        })
        print(projects)
        
        return projects
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.projects")!
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
    var type: FormStyle
    let configuration: ConfigurationIntent
    var colors: [String]
    var positions: [Int]
}

enum FormStyle: Int {
    case rect = 0
    case width = 1
    case height = 2
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader{metric in
            ZStack(alignment:  Alignment(horizontal: .leading, vertical: .top), content: {
                
                Image(uiImage: #imageLiteral(resourceName: "background"))
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: ContentMode.fill)
                            
                switch entry.type {
                case .rect:
                    Image(uiImage: entry.image)
                        .resizable()
                        .interpolation(.none)
                        .aspectRatio(contentMode: .fill)
                
                case .width:
                    Image(uiImage: entry.image)
                        .resizable()
                        .interpolation(.none)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: metric.size.width, height: metric.size.height * 0.75, alignment: .center)
                    
                    VStack{
                        Spacer()
                        ColorsView(colors: entry.colors,positions: entry.positions, type: entry.type)
                            .frame(width: metric.size.width, height: metric.size.height * 0.25, alignment: .center)
                    }
                case .height:
                    Image(uiImage: entry.image)
                        .resizable()
                        .interpolation(.none)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: metric.size.width * 0.75, height: metric.size.height, alignment: .center)
                    
                    HStack{
                        Spacer()
                        ColorsView(colors: entry.colors,positions: entry.positions, type: entry.type)
                            .frame(width: metric.size.width * 0.25, height: metric.size.height, alignment: .center)
                    }
                }
            })
        }
    }
}

struct ColorsView: View {
    var colors: [String]
    var positions: [Int]
    var type: FormStyle
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor(hex: colors[0])!))
                .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 0)

            if type == .height {
                VStack(spacing: 0) {
                    ForEach(0..<4){ group in
                        switch positions[group] {
                        case 4:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1],colors[pos(group) + 2],colors[pos(group) + 3]])
                        case 3:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1],colors[pos(group) + 2]])
                        case 2:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1]])
                        case 1:
                            ColorGroup(colors: [colors[pos(group)]])
                        default:
                            ColorGroup(colors: [])
                        }
                    }
                }
            } else {
                HStack(spacing: 0) {
                    ForEach(0..<4){group in
                        switch positions[group] {
                        case 4:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1],colors[pos(group) + 2],colors[pos(group) + 3]])
                        case 3:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1],colors[pos(group) + 2]])
                        case 2:
                            ColorGroup(colors: [colors[pos(group)],colors[pos(group) + 1]])
                        case 1:
                            ColorGroup(colors: [colors[pos(group)]])
                        default:
                            ColorGroup(colors: [])
                        }
                    }
                }
            }
        }
    }
    
    func pos(_ index: Int) -> Int {
        var sum = 0
        
        for i in 0..<index {
            sum += positions[i]
        }
        
        return sum
    }
}

struct ColorGroup: View {
    var colors: [String]
    
    var body: some View {
        switch colors.count {
        case 1:
            Rectangle()
                .foregroundColor(Color(UIColor(hex: colors[0])!))
            
        case 2:
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color(UIColor(hex: colors[0])!))
                Rectangle()
                    .foregroundColor(Color(UIColor(hex: colors[1])!))
            }
        case 3:
            VStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(Color(UIColor(hex: colors[0])!))
                
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[1])!))
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[2])!))
                }
            }
        case 4:
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[0])!))
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[1])!))
                }
                
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[2])!))
                    Rectangle()
                        .foregroundColor(Color(UIColor(hex: colors[3])!))
                }
            }
        default:
            Rectangle()
                .foregroundColor(.clear)
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "preview"

    var body: some WidgetConfiguration {
        
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Project's preview")
        .description("Admire your projects right on your home screen")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), image: #imageLiteral(resourceName: "theme_icon_light"),type: .width, configuration: ConfigurationIntent(),colors: [],positions: [0,0,0,0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


func getPositions(colors: [String]) -> [Int] {
    switch colors.count {
    case 16...:
        return [4,4,4,4]
    case 15:
        return [3,4,4,4]
    case 14:
        return [2,4,4,4]
    case 13:
        return [1,4,4,4]
    case 12:
        return [1,3,4,4]
    case 11:
        return [1,2,4,4]
    case 10:
        return [1,1,4,4]
    case 9:
        return [1,1,3,4]
    case 8:
        return [1,1,2,4]
    case 7:
        return [1,1,1,4]
    case 6:
        return [1,1,1,3]
    case 5:
        return [1,1,1,2]
    case 4:
        return [1,1,1,1]
    case 3:
        return [0,1,1,1]
    case 2:
        return [0,0,1,1]
    case 1:
        return [0,0,0,1]
    default:
        return [0,0,0,0]
    }
}

