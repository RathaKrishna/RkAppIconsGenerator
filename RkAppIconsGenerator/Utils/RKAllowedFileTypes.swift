//
//  RKAllowedFileTypes.swift
//  RkAppIconsGenerator
//
//  Created by Rathakrishnan on 04/03/21.
//  Copyright © 2021 Rathakrishnan. All rights reserved.
//

import AppKit

var allowedFileTypes: [String] {
    var allowed = NSImage.imageTypes
    allowed.append(contentsOf: ["com.adobe.illustrator.ai-image"])
    return allowed
}

