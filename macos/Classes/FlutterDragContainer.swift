//
//  FlutterDragContainer.swift
//  file_drag_and_drop
//
//  Created by 逸风 on 2022/1/12.
//

import Cocoa

typealias FileResult = (path: String, isDirectory: Bool, fileExtension: String)

protocol FlutterDragContainerDelegate {
    func draggingFileEntered()
    func draggingFileExit()
    func prepareForDragFileOperation()
    func performDragFileOperation(_ results : [FileResult])
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

class FlutterDragContainer: NSView {
    
    var delegate : FlutterDragContainerDelegate?
    let acceptTypes = ["png", "jpg", "jpeg"]
    let NSFilenamesPboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
    
    
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
        if let delegate = self.delegate {
            delegate.draggingFileEntered();
        }
        return NSDragOperation.generic
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        if let delegate = self.delegate {
            delegate.draggingFileExit();
        }
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if self.delegate != nil {
            self.delegate?.prepareForDragFileOperation()
        }
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        var files = Array<FileResult>()
        if let board = sender.draggingPasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray {
            for path in board {
                print(path)
                if let p = path as? String {
                    let isDirectory = FlutterFileUtil.isDirectory(p)
                    let fileExtension = FlutterFileUtil.fileExtension(p)
                    files.append((path: p,isDirectory: isDirectory, fileExtension: fileExtension))
                }
            }
        }
        if self.delegate != nil {
            self.delegate?.performDragFileOperation(files)
        }
        return true
    }
    
    func fileIsAcceptable(_ path: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        let fileExtension = url.pathExtension.lowercased()
        return acceptTypes.contains(fileExtension)
    }
    
}
