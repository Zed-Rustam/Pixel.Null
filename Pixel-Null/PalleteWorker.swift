//
//  PalleteWorker.swift
//  new Testing
//
//  Created by Рустам Хахук on 16.03.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class PalleteWorker {
    private var pallete : Pallete
    private var name : String
    
    var palleteName : String {
        get{
            return name
        }
        set {
            name = newValue
        }
    }
    
    var colors : [String] {
        get {
            return pallete.colors
        }
        set{
            pallete.colors = newValue
        }
    }
    
    var colorPallete : Pallete {
        get{
            return pallete
        }
    }
    
    func save(){
        do {
            try FileManager.default.createDirectory(atPath: PalleteWorker.getDocumentsDirectory().path, withIntermediateDirectories: true, attributes: nil)
            
            let data = try JSONEncoder().encode(pallete)
            try String(data: data, encoding: .utf8)!.write(to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pallete"), atomically: true, encoding: .utf8)
        } catch {
        }
    }
    
    func deleteColor(index : Int){
        pallete.colors.remove(at: index)
    }
    
    func cloneColor(index : Int){
        pallete.colors.insert(pallete.colors[index], at: index)
    }
    
    func updateColor(index : Int,color : String){
        pallete.colors[index] = color
    }
    
    func addColor(newColor : String){
        pallete.colors.append(newColor)
    }
    
    func moveColor(from : Int, to : Int){
        let color = pallete.colors.remove(at: from)
        pallete.colors.insert(color , at: to)
    }
    func delete(){
        try? FileManager.default.removeItem(atPath: PalleteWorker.getDocumentsDirectory().appendingPathComponent("\(palleteName).pallete").path)
    }
    
    func rename(newName : String){
        if newName != palleteName {
            try! FileManager.default.moveItem(at: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pallete"), to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(newName).pallete"))
            palleteName = newName
        }
    }
    
    func getURL() -> URL {
        return URL(fileURLWithPath: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pallete").path)
    }
    
    init(name : String, colors : [String]){
        pallete = Pallete(colors: colors)
        self.name = name
        save()
    }
    
    init(fileName : String){
        pallete = try! JSONDecoder().decode(Pallete.self, from: try! Data(contentsOf: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(fileName).pallete")))
        name = fileName
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])!
        return paths.appendingPathComponent("Palletes")
    }
    
    static func getDocumentsDirectoryWithFile() -> URL {
        let paths = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return paths.appendingPathComponent("Palletes")
    }
}

struct Pallete : Codable {
    var colors : [String]
    
    static func getKoef(count : Int) -> CGFloat {
        var width = Int(sqrt(Double(count)))
                       
        if count > 1 && count < 4  {
            width = 2
        } else if count > Int(powf(Float(width + 1), 2)) - width - 1 {
            width += 1
        }
       
        var height = width
        
        if count > Int(powf(Float(width),2)) && count <= Int(powf(Float(width + 1),2)) - width - 1 {
            height += 1
        }
    
        return CGFloat(height) / CGFloat(width)
    }
}
