//
//  FlutterFileUtil.swift
//  file_drag_and_drop
//
//  Created by 逸风 on 2022/1/12.
//

import Foundation

class FlutterFileUtil {
    static let sOutPutFolderName = "tinypng_output"
    
    static var sOutputPath = ""
    
    static func getOutputPath() -> URL {
        let fileManager = FileManager.default
        var path: URL!
        if sOutputPath == "" {
            let directoryURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask)[0]
            path = directoryURL.appendingPathComponent(sOutPutFolderName, isDirectory: true)
        } else {
            path = URL(fileURLWithPath: sOutputPath)
        }
        if !fileManager.fileExists(atPath: path!.path) {
            try! fileManager.createDirectory(at: path!, withIntermediateDirectories: true, attributes: nil)
        }
        return path!
    }
    
    static func getDefaultOutputPath() -> URL {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .desktopDirectory, in: .userDomainMask)[0]
        let path = directoryURL.appendingPathComponent(sOutPutFolderName, isDirectory: true)
        return path
    }
    
    static func deleteOnExists(_ file: URL) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: file.path) {
            try! fileManager.removeItem(at: file)
        }
    }
    
    static func isDirectory(_ path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory = ObjCBool(false)
        let fileExists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue
    }
}
