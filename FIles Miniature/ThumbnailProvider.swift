//
//  ThumbnailProvider.swift
//  FIles Miniature
//
//  Created by Рустам Хахук on 12.05.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit
import QuickLookThumbnailing

class ThumbnailProvider: QLThumbnailProvider {
    
    override func provideThumbnail(for request: QLFileThumbnailRequest, _ handler: @escaping (QLThumbnailReply?, Error?) -> Void) {
        // There are three ways to provide a thumbnail through a QLThumbnailReply. Only one of them should be used.
        print("need some miniatures \(request.maximumSize)  \(request.scale)")
        
         //First way: Draw the thumbnail into the current context, set up with UIKit's coordinate system.

        if request.fileURL.lastPathComponent.dropFirst(request.fileURL.lastPathComponent.count - 5) == "pnart" {
            
            //let img = UIImage(contentsOfFile: request.fileURL.appendingPathComponent("preview-icon.png").path)!
            
            //let k = img.size.width / img.size.height
                
            handler(QLThumbnailReply(imageFileURL: request.fileURL.appendingPathComponent("preview-icon.png")), nil)
//            handler(QLThumbnailReply(contextSize: CGSize(width: request.maximumSize.width, height: request.maximumSize.height * k), currentContextDrawing:  { () -> Bool in
//
//                UIGraphicsGetCurrentContext()!.setAllowsAntialiasing(false)
//                img.draw(in: CGRect(origin: .zero, size: CGSize(width: request.maximumSize.width, height: request.maximumSize.height * k)))
//                return true
//            }), nil)
            
        } else if request.fileURL.lastPathComponent.dropFirst(request.fileURL.lastPathComponent.count - 9) == "pnpalette" {
            let pallete = PalleteWorker(fileUrl: request.fileURL)
            let img = makeImage(pallete: pallete, size : CGSize(width: request.maximumSize.width * request.scale, height: request.maximumSize.height * request.scale))
            
            handler(QLThumbnailReply(contextSize: CGSize(width: request.maximumSize.width, height: request.maximumSize.height), currentContextDrawing: { () -> Bool in
                
                UIGraphicsGetCurrentContext()!.setAllowsAntialiasing(false)
                img.draw(in: CGRect(origin: .zero, size: CGSize(width: request.maximumSize.width, height: request.maximumSize.height)))
                return true
            }), nil)
            
        }
//        let reply = QLThumbnailReply(contextSize: CGSize(width: 60, height: 60), drawing: { (context) -> Bool in
//             //Draw the thumbnail here.
//            context.clear(CGRect(origin: .zero, size: CGSize(width: 180, height: 180)))
//            context.draw(img.cgImage!, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 180)))
//            print("draw")
//             //Return true if the thumbnail was successfully drawn inside this block.
//            return true
//        })
//        handler(reply , nil)

//
//
//        // Second way: Draw the thumbnail into a context passed to your block, set up with Core Graphics's coordinate system.
        // handler(QLThumbnailReply()
        // Third way: Set an image file URL.
        //handler(QLThumbnailReply(imageFileURL: Bundle.main.url(forResource: "fileThumbnail", withExtension: "jpg")!), nil)
    }
    
    func makeImage(pallete : PalleteWorker,size : CGSize) -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 16, height: 16))
        
        let img = renderer.image{context in
            for i in 0..<pallete.colors.count {
                UIColor(hex: pallete.colors[i])!.setFill()
                context.fill(CGRect(x: i % 16, y: i / 16, width: 1, height: 1))
            }
        }
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        context.setAllowsAntialiasing(false)
        context.interpolationQuality = .none

        
        
        img.draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
}
