//
//  ViewController.swift
//  RkAppIconsGenerator
//
//  Created by Rathakrishnan on 01/03/21.
//

import Cocoa

class ViewController: NSViewController {
    
    var tabFlag = 0
    var sImage = NSImage()
    
    // main image view
    @IBOutlet weak var mainImage: NSImageView!
    @IBOutlet weak var dragView: RKDragDropView!
    
    // right view icons
    @IBOutlet weak var iconsTabView: NSTabView!
    
    // left views buttons
    @IBOutlet weak var saveBtn: NSButton!
    @IBOutlet weak var selectImgBtn: NSButton!
    @IBOutlet weak var isMacFlag: NSButton!
    @IBOutlet weak var isAndroidFlag: NSButton!
    @IBOutlet weak var isiOSFlag: NSButton!
    // Mac imageview's
    @IBOutlet weak var macImage16_1x:  NSImageView!
    @IBOutlet weak var macImage16_2x:  NSImageView!
    @IBOutlet weak var macImage32_1x:  NSImageView!
    @IBOutlet weak var macImage32_2x:  NSImageView!
    @IBOutlet weak var macImage128_1x: NSImageView!
    @IBOutlet weak var macImage128_2x: NSImageView!
    @IBOutlet weak var macImage256_1x: NSImageView!
    @IBOutlet weak var macImage256_2x: NSImageView!
    @IBOutlet weak var macImage512_1x: NSImageView!
    @IBOutlet weak var macImage512_2x: NSImageView!
    
    //iOS images
    @IBOutlet weak var iosImage20_2x: NSImageView!
    @IBOutlet weak var iosImage20_3x: NSImageView!
    @IBOutlet weak var iosImage29_2x: NSImageView!
    @IBOutlet weak var iosImage29_3x: NSImageView!
    @IBOutlet weak var iosImage40_2x: NSImageView!
    @IBOutlet weak var iosImage40_3x: NSImageView!
    @IBOutlet weak var iosImage60_2x: NSImageView!
    @IBOutlet weak var iosImage60_3x: NSImageView!
    @IBOutlet weak var iosImage1024: NSImageView!
    
    @IBOutlet weak var ipadImage20_2x: NSImageView!
    @IBOutlet weak var ipadImage20_3x: NSImageView!
    @IBOutlet weak var ipadImage29_2x: NSImageView!
    @IBOutlet weak var ipadImage29_3x: NSImageView!
    @IBOutlet weak var ipadImage40_2x: NSImageView!
    @IBOutlet weak var ipadImage40_3x: NSImageView!
    @IBOutlet weak var ipadImage76_2x: NSImageView!
    @IBOutlet weak var ipadImage76_3x: NSImageView!
    @IBOutlet weak var ipadImage83_2x: NSImageView!
    
    //android images
    @IBOutlet weak var androidImg36: NSImageView!
    @IBOutlet weak var androidImg48: NSImageView!
    @IBOutlet weak var androidImg72: NSImageView!
    @IBOutlet weak var androidImg96: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragView.delegate = self
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
            
        }
    }
    
    /// change tab on select
    /// - Parameter sender: <#sender description#>
    @IBAction func onSelectTab(_ sender: Any) {
        tabFlag = (sender as! NSSegmentedControl).selectedSegment
        iconsTabView.selectTabViewItem(at: tabFlag)
    }
    
    /// select file
    /// - Parameter sender: <#sender description#>
    @IBAction func onSelectImage(_ sender: Any) {
        let fileDialog = NSOpenPanel()
        fileDialog.canChooseFiles = true
        fileDialog.canChooseDirectories = false
        fileDialog.allowsMultipleSelection = false
        fileDialog.canCreateDirectories = false
        fileDialog.allowedFileTypes = allowedFileTypes
        
        let choice = fileDialog.runModal()
        
        if choice == NSApplication.ModalResponse.OK {
            if let url = fileDialog.url {
                setMainImage(url)
                setAllIcons()
            }
        }
    }
    
    func setMainImage(_ url: URL) {
        self.sImage = NSImage(byReferencingFile: url.path)!
        DispatchQueue.main.async {
            self.mainImage.image = self.sImage
        }
    }

    @IBAction func saveIconsAction(_ sender: Any) {
        
        if self.isMacFlag.state == .off && self.isiOSFlag.state == .off && self.isAndroidFlag.state == .off {
            showDialog(title: "Warning", msg: "Please choose at least one imageset")
            return
        }
        

        let dialog = NSOpenPanel()
        dialog.canChooseFiles = false
        dialog.canChooseDirectories = true
         
        let choice = dialog.runModal()
        
        if choice == NSApplication.ModalResponse.OK {
            if let folders = dialog.url {
                let folder = createDirectory(folders, "AppIcons")
                if self.isMacFlag.state == .on {
                    saveMacIcons(folder)
                }
                if self.isiOSFlag.state == .on {
                    saveIphoneIcons(folder)
                }
                if self.isAndroidFlag.state == .on {
                    saveAndroidIcons(folder)
                }
            }
        }
        
    }
    
    /// set images for all the imageviews
    func setAllIcons() {
        
        DispatchQueue.main.async {
            
            // set mac images
            self.macImage16_1x.image = self.sImage.resizeIcons(16, 16)
            self.macImage16_2x.image = self.sImage.resizeIcons(32, 32)
            self.macImage32_1x.image = self.sImage.resizeIcons(32, 32)
            self.macImage32_2x.image = self.sImage.resizeIcons(64, 64)
            self.macImage128_1x.image = self.sImage.resizeIcons(128, 128)
            self.macImage128_2x.image = self.sImage.resizeIcons(256, 256)
            self.macImage256_1x.image = self.sImage.resizeIcons(256, 256)
            self.macImage256_2x.image = self.sImage.resizeIcons(512, 512)
            self.macImage512_1x.image = self.sImage.resizeIcons(512, 512)
            self.macImage512_2x.image = self.sImage.resizeIcons(1024, 1024)
            
            // ios iPhone Images
            self.iosImage20_2x.image = self.sImage.resizeIcons(40, 40)
            self.iosImage20_3x.image = self.sImage.resizeIcons(60, 60)
            self.iosImage29_2x.image = self.sImage.resizeIcons(58, 58)
            self.iosImage29_3x.image = self.sImage.resizeIcons(87, 87)
            self.iosImage40_2x.image = self.sImage.resizeIcons(80, 80)
            self.iosImage40_3x.image = self.sImage.resizeIcons(120, 120)
            self.iosImage60_2x.image = self.sImage.resizeIcons(120, 120)
            self.iosImage60_3x.image = self.sImage.resizeIcons(180, 180)
            self.iosImage1024.image = self.sImage.resizeIcons(1024, 1024)
            // ios iPad Images
            self.ipadImage20_2x.image = self.sImage.resizeIcons(20, 20)
            self.ipadImage20_3x.image = self.sImage.resizeIcons(40, 40)
            self.ipadImage29_2x.image = self.sImage.resizeIcons(29, 29)
            self.ipadImage29_3x.image = self.sImage.resizeIcons(58, 58)
            self.ipadImage40_2x.image = self.sImage.resizeIcons(40, 40)
            self.ipadImage40_3x.image = self.sImage.resizeIcons(80, 80)
            self.ipadImage76_2x.image = self.sImage.resizeIcons(76, 76)
            self.ipadImage76_3x.image = self.sImage.resizeIcons(152, 152)
            self.ipadImage83_2x.image = self.sImage.resizeIcons(167, 167)
            
            // set android images
            self.androidImg36.image = self.sImage.resizeIcons(36, 36)
            self.androidImg48.image = self.sImage.resizeIcons(48, 48)
            self.androidImg72.image = self.sImage.resizeIcons(72, 72)
            self.androidImg96.image = self.sImage.resizeIcons(96, 96)
        }
        
        saveBtn.isHidden = false
    }
    
       
    func saveIphoneIcons(_ url: URL)  {
        // set specific folder names
        var folder = createDirectory(url, "iOS")
        folder = createDirectory(folder, "AppIcon.appiconset")
        let path = folder.absoluteString
        let json = folder.appendingPathComponent("Contents.json")
        
        DispatchQueue.main.async {
            if let source = Bundle.main.url(forResource: "Contents_ios", withExtension: "json") {
                try? FileManager.default.removeItem(at: json)
                try? FileManager.default.copyItem(at: source, to: json)
            }
          
            self.iosImage20_2x.image?.saveIcons(path + "iphoneNotification_20pt@2x.png")
            self.iosImage20_3x.image?.saveIcons(path + "iphoneNotification_20pt@3x.png")
            self.iosImage29_2x.image?.saveIcons(path + "iPhoneSpootlight5_29pt@2x.png")
            self.iosImage29_3x.image?.saveIcons(path + "iPhoneSpootlight5_29pt@3x.png")
            self.iosImage40_2x.image?.saveIcons(path + "iPhoneSpootlight7_40pt@2x.png")
            self.iosImage40_3x.image?.saveIcons(path + "iPhoneSpootlight7_40pt@3x.png")
            self.iosImage60_2x.image?.saveIcons(path + "iPhoneApp_60pt@2x.png")
            self.iosImage60_3x.image?.saveIcons(path + "iPhoneApp_60pt@3x.png")
            self.iosImage1024.image?.saveIcons(path + "appiconstore_1024pt.png")
            //ipad icons
            self.ipadImage20_2x.image?.saveIcons(path + "ipad20pt@1x.png")
            self.ipadImage20_3x.image?.saveIcons(path + "ipad20pt@2x.png")
            self.ipadImage29_2x.image?.saveIcons(path + "ipad29pt@1x.png")
            self.ipadImage29_3x.image?.saveIcons(path + "ipad29pt@2x.png")
            self.ipadImage40_2x.image?.saveIcons(path + "ipad40pt@1x.png")
            self.ipadImage40_3x.image?.saveIcons(path + "ipad40pt@2x.png")
            self.ipadImage76_2x.image?.saveIcons(path + "ipad76pt@1x.png")
            self.ipadImage76_3x.image?.saveIcons(path + "ipad76pt@2x.png")
            self.ipadImage83_2x.image?.saveIcons(path + "ipad83pt@2x.png")
        }
    }
    
    func saveAndroidIcons(_ url: URL) {
        let folder = createDirectory(url, "Android")
        let path = folder.absoluteString
            
        DispatchQueue.main.async {
            self.androidImg36.image?.saveIcons(path + "ldpi_36.png")
            self.androidImg48.image?.saveIcons(path + "mdpi_48.png")
            self.androidImg72.image?.saveIcons(path + "hdpi_72.png")
            self.androidImg96.image?.saveIcons(path + "xhdpi_96.png")
        }
    }
    
    /// save mac Icons
    /// - Parameter url: <#url description#>
    func saveMacIcons(_ url: URL) {
        var folder = createDirectory(url, "macOS")
        folder = createDirectory(folder, "AppIcon.appiconset")
        let path = folder.absoluteString
        let json = folder.appendingPathComponent("Contents.json")
        
        DispatchQueue.main.async {
            if let source = Bundle.main.url(forResource: "Contents_mac", withExtension: "json") {
                try? FileManager.default.removeItem(at: json)
                try? FileManager.default.copyItem(at: source, to: json)
            }
            self.macImage16_1x.image?.saveIcons(path + "mac16pt@1x.png")
            self.macImage16_2x.image?.saveIcons(path + "mac16pt@2x.png")
            self.macImage32_1x.image?.saveIcons(path + "mac32pt@1x.png")
            self.macImage32_2x.image?.saveIcons(path + "mac32pt@2x.png")
            self.macImage128_1x.image?.saveIcons(path + "mac128pt@1x.png")
            self.macImage128_2x.image?.saveIcons(path + "mac128pt@2x.png")
            self.macImage256_1x.image?.saveIcons(path + "mac256pt@1x.png")
            self.macImage256_2x.image?.saveIcons(path + "mac256pt@2x.png")
            self.macImage512_1x.image?.saveIcons(path + "mac512pt@1x.png")
            self.macImage512_2x.image?.saveIcons(path + "mac512pt@2x.png")
        }
    }
    
    
    /// show alert when non of the os is selected
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - msg: <#msg description#>
    /// - Returns: <#description#>
    func showDialog(title: String, msg: String) {
        
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = msg
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
    
    /// create directory for given name and path
    /// - Parameters:
    ///   - url: <#url description#>
    ///   - name: <#name description#>
    /// - Returns: <#description#>
    func createDirectory(_ url: URL, _ name: String) -> URL {
        
        var folder = url
        folder.appendPathComponent(name, isDirectory: true)
        var isFolder: ObjCBool = true
        if !FileManager.default.fileExists(atPath: folder.path, isDirectory: &isFolder) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
        }
        return folder
    }
}

//drag and drop view delegate
extension ViewController: RKDragDropViewDelegate {
    func dragViewDigHover() {
        
    }
    
    func dragViewMouseExited() {
        
    }
    
    func dragView(didDragFileWith url: URL) {
        setMainImage(url)
        setAllIcons()
    }
    
    
}

