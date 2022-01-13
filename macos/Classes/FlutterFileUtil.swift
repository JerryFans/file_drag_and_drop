//
//  FlutterFileUtil.swift
//  file_drag_and_drop
//
//  Created by 逸风 on 2022/1/12.
//

import Foundation

class FlutterFileUtil {
    static func isDirectory(_ path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory = ObjCBool(false)
        let fileExists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
        return fileExists && isDirectory.boolValue
    }
    
    static func fileExtension(_ path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let fileExtension = url.pathExtension.lowercased()
        return fileExtension
    }
}
