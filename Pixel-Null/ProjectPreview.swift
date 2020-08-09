//
//  ProjectPreview.swift
//  Pixel-Null
//
//  Created by Рустам Хахук on 05.08.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import SwiftUI
import UIKit

struct ProjectPreview: View {
    var body: some View {
        Image(uiImage: loadRandomProject())
            .resizable()
    }
}

func getFrame(name: String) -> UIImage{
    let img = UIImage(data: try! Data(contentsOf: URL(string: "file:///Users/zed/Library/Developer/CoreSimulator/Devices/BB669B41-22A3-40E8-8E7F-E93ED035F94F/data/Containers/Data/Application/0D004D9E-3BFD-4327-B933-F56D12145581/Documents/Projects/")!.appendingPathComponent(name).appendingPathComponent("preview.png").absoluteURL))
    
    return img!
}

func loadRandomProject() -> UIImage {

    
    print(FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0])
    
//    guard let projs = try? FileManager.default.urls(for: .userDirectory, in: .userDomainMask) else {
//        print("can't load")
//        return #imageLiteral(resourceName: "theme_icon_light")
//    }

    var projects: [String] = []
    
//    for i in 0..<projs.count  {
//        let name = projs[i].lastPathComponent
//        if name.hasSuffix(".pnart") {
//            projects.append(name)
//        }
//    }
    if projects.count > 0 {
        return getFrame(name: projects[Int.random(in: 0..<projects.count)])
    } else {
        return #imageLiteral(resourceName: "theme_icon_light")
    }
}

struct ProjectPreview_Previews: PreviewProvider {
    static var previews: some View {
        ProjectPreview()
    }
}
