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
            try String(data: data, encoding: .utf8)!.write(to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pnpalette"), atomically: true, encoding: .utf8)
        } catch {
            print(error)
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
        try? FileManager.default.removeItem(atPath: PalleteWorker.getDocumentsDirectory().appendingPathComponent("\(palleteName).pnpalette").path)
    }
    
    func rename(newName : String){
        if newName != palleteName {
            try! FileManager.default.moveItem(at: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pnpalette"), to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(newName).pnpalette"))
            palleteName = newName
        }
    }
    
    func getURL() -> URL {
        return URL(fileURLWithPath: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(palleteName).pnpalette").path)
    }
    
    init(name : String, colors : [String], isSave : Bool = true){
        pallete = Pallete(colors: colors)
        self.name = name
        
        if isSave {
            save()
        }
    }
    
    init(fileName : String){
        pallete = try! JSONDecoder().decode(Pallete.self, from: try! Data(contentsOf: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent("\(fileName).pnpalette")))
        name = fileName
    }
    
    init(fileUrl : URL){
        pallete = try! JSONDecoder().decode(Pallete.self, from: try! Data(contentsOf: fileUrl))
        name = fileUrl.lastPathComponent
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = URL(string: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])!
        return paths.appendingPathComponent("Palletes")
    }
    
    static func getDocumentsDirectoryWithFile() -> URL {
        let paths = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return paths.appendingPathComponent("Palletes")
    }
    
    static func clone(original : String, clone : String){
        do{
            try FileManager.default.copyItem(at: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent(original), to: PalleteWorker.getDocumentsDirectoryWithFile().appendingPathComponent(clone))
            //try FileManager.default.copyItem(at: URL(fileURLWithPath: original, isDirectory: false), to: URL(fileURLWithPath: clone, isDirectory: false))
        } catch{
            print(error.localizedDescription)
        }
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
