//
//  RKDragDropView.swift
//  RkAppIconsGenerator
//
//  Created by Rathakrishnan on 04/03/21.
//  Copyright © 2021 Rathakrishnan. All rights reserved.
//

import Cocoa

// protocol
protocol RKDragDropViewDelegate {
    func dragViewDigHover()
    func dragViewMouseExited()
    func dragView(didDragFileWith url: URL)
}

class RKDragDropView: NSView {
    
    var delegate: RKDragDropViewDelegate?
    
    // check file type
    private var isFileTypeOk = false
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")])
    }

    /// check if the file type is allowed
    /// - Parameter sender: <#sender description#>
    /// - Returns: <#description#>
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isFileTypeOk = checkExtension(drag: sender)
        if isFileTypeOk {
            delegate?.dragViewDigHover()
        }
        return []
    }
    
    /// get the details of the selected image
    /// - Parameter sender: <#sender description#>
    /// - Returns: <#description#>
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        isFileTypeOk ?.copy : []
    }
    
    /// Pass url on mouse release
    /// - Parameter sender: <#sender description#>
    /// - Returns: <#description#>
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let selectedImgUrl = sender.draggedFileURL else { return false }
        
        // call the delegate method
        if isFileTypeOk {
            delegate?.dragView(didDragFileWith: selectedImgUrl)
        }
        return true
    }
    
    // Check drag object, grab the url of the file coming in, and check if it matches a 'allowedViewTypes' UTI String.
    fileprivate func checkExtension(drag: NSDraggingInfo) -> Bool {
        guard let urlResource = try? drag.draggedFileURL?.resourceValues(forKeys: [.typeIdentifierKey]) else {
            return false
        }
        guard let typeIdentifier = urlResource.typeIdentifier else {
            return false
        }
        return allowedFileTypes.contains(typeIdentifier)
    }
    
    /// notify dragviewcontroller if drag leaves without drop
    /// - Parameter sender: <#sender description#>
    override func draggingExited(_ sender: NSDraggingInfo?) {
        delegate?.dragViewMouseExited()
    }
}

extension NSDraggingInfo {
    var draggedFileURL: URL? {
        let pboadType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
        let filenames = draggingPasteboard.propertyList(forType: pboadType) as? [String]
        guard let path = filenames?.first else { return nil }
        return URL(fileURLWithPath: path)
    }
}
