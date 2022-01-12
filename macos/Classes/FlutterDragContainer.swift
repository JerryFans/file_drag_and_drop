//
//  FlutterDragContainer.swift
//  file_drag_and_drop
//
//  Created by 逸风 on 2022/1/12.
//

import Cocoa

protocol FlutterDragContainerDelegate {
    func draggingEntered();
    func draggingExit();
    func draggingFileAccept(_ files:Array<FlutterFileInfo>);
}

extension NSPasteboard.PasteboardType {
    static let backwardsCompatibleFileURL: NSPasteboard.PasteboardType = {
        if #available(OSX 10.13, *) {
            return NSPasteboard.PasteboardType.fileURL
        } else {
            return NSPasteboard.PasteboardType(kUTTypeFileURL as String)
        }
    } ()
}

class FlutterFileInfo {
    var filePath: URL
    var relativePath: String
    
    init(_ filePath: URL, relativePath: String) {
        self.filePath = filePath
        self.relativePath = relativePath
    }
}

class FlutterDragContainer: NSView {
    
    var delegate : FlutterDragContainerDelegate?
    
    let acceptTypes = ["png", "jpg", "jpeg"]
    let NSFilenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
    
    let normalAlpha: CGFloat = 0
    let highlightAlpha: CGFloat = 0.2
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([
            NSPasteboard.PasteboardType.backwardsCompatibleFileURL,
            NSPasteboard.PasteboardType(rawValue: kUTTypeItem as String)
            ]);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: highlightAlpha).cgColor;
        if let delegate = self.delegate {
            delegate.draggingEntered();
        }
        return NSDragOperation.generic
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: normalAlpha).cgColor;
        if let delegate = self.delegate {
            delegate.draggingExit();
        }
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.layer?.backgroundColor = NSColor(white: 1, alpha: normalAlpha).cgColor;
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        var files = Array<FlutterFileInfo>()
        if let board = sender.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray {
            for path in board {
                files.append(contentsOf: collectFiles(path as! String))
            }
        }
        
        if self.delegate != nil {
            self.delegate?.draggingFileAccept(files);
        }
        
        return true
    }
    
    func collectFiles(_ filePath: String) -> Array<FlutterFileInfo> {
        var files = Array<FlutterFileInfo>()
        let isDirectory = FlutterFileUtil.isDirectory(filePath)
        if isDirectory {
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: filePath)
            while let relativePath = enumerator?.nextObject() as? String {
                let fullFilePath = filePath.appending("/\(relativePath)")
                if (fileIsAcceptable(fullFilePath)) {
                    let parent = URL(fileURLWithPath: filePath).lastPathComponent
                    files.append(FlutterFileInfo(URL(fileURLWithPath: fullFilePath), relativePath:"\(parent)/\(relativePath)"))
                }
            }
        } else if (fileIsAcceptable(filePath)) {
            let url = URL(fileURLWithPath: filePath)
            files.append(FlutterFileInfo(url, relativePath:url.lastPathComponent))
        }
        return files
    }
    
    func fileIsAcceptable(_ path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        let fileExtension = url.pathExtension.lowercased()
        return acceptTypes.contains(fileExtension)
    }
    
}
