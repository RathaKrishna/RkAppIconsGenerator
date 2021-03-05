//
//  NSImageExtensions.swift
//  RkAppIconsGenerator
//
//  Created by Rathakrishnan on 01/03/21.
//  Copyright © 2021 Rathakrishnan. All rights reserved.
//

import Cocoa

extension NSImage {
    
    /// The height of the image.
    var height: CGFloat {
        return size.height
    }
    
    /// The width of the image.
    var width: CGFloat {
        return size.width
    }
    
    
    /// <#Description#>
    var pngData: Data? {
        guard
            let tiff = tiffRepresentation,
            let bmapImage = NSBitmapImageRep(data: tiff)
        else { return nil }
        return bmapImage.representation(using: .png, properties: [:])
    }
    
    
    /// resize icon images
    /// - Parameters:
    ///   - width: <#width description#>
    ///   - height: <#height description#>
    /// - Returns: <#description#>
    func resizeIcons(_ width: CGFloat, _ height: CGFloat) -> NSImage {
        
        let img = NSImage(size: CGSize(width: width, height: height))
        img.lockFocus()
        let context = NSGraphicsContext.current
        context?.imageInterpolation = .high
        let oldRect = NSMakeRect(0, 0, self.width,self.height)
        let newRect = NSMakeRect(0, 0, width, height)
        self.draw(in: newRect, from: oldRect, operation: .copy, fraction: 1)
        img.unlockFocus()
        return img
    }
    
    @discardableResult
    func saveIcons(_ path: String) -> Bool {
        guard let url = URL(string: path) else { return false }
        
        do {
            try pngData?.write(to: url, options: .atomic)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
