//
//  BSDataManager.swift
//  RunnerSplits
//
//  Created by 88713791 on 9/16/16.
//  Copyright © 2016 Brady Stoffel. All rights reserved.
//

import Foundation
import UIKit

class BSFileManager {
    
    /**
     Get the contents of a file in a string format
     */
    class func getFileContents(_ fileName: String) -> String? {
        let filePath = getFilePath(fileName)
        
        if !FileManager.default.fileExists(atPath: filePath) {
            saveFileContents(fileName, contents: "")
        }
        
        do {
            let fileStr = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            return fileStr
        } catch {
            print("Couldnt find file")
            print(error)
            
        }
        return nil
    }
    
    /**
     Contents of file from URL
     */
    class func getFileContents(_ fileUrl : URL) -> String? {
        do {
            let fileStr = try String(contentsOfFile: fileUrl.path, encoding: String.Encoding.utf8)
            return fileStr
        } catch {
            print("Couldnt find file")
            print(error)
            
        }
        return nil
    }
    
    
    /**
     Saves string to the filename provided
     */
    class func saveFileContents(_ fileName: String, contents: String) {
        
        print("saving file contents")
        print(fileName)
        let filePath = getFilePath(fileName)
        print(filePath)
        do{
            try contents.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8 )
        } catch{
            print("error trying to find")
            print (error)
        }
        
        
    }
    
    /**
     Adds .csv to end of name
     */
    class fileprivate func getFilePath(_ fileName: String) -> String {
        var newFileName = fileName
        if fileName.components(separatedBy: ".").count == 1 {
            newFileName += ".csv"
        }
        
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/\(newFileName)"
        return filePath
    }
    
    /**
     Folder URL from string
     */
    class func getFolderPath(_ fileName: String) -> URL {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/\(fileName)"
        return URL(fileURLWithPath: filePath)
    }
    
    /**
     Deletes file from URL
     */
    class func deleteFile(_ raceURL : URL) {
        let fileManager = FileManager()
        
        do {
            try fileManager.removeItem(at: raceURL)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    /**
     Deletes directory from String
     */
    class func deleteDir(_ path: String) {
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/\(path)"
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            
            
        } catch {
            print("Can't delete Dir or not there")
            print(error)
        }
        
    }
    
    /**
     Creates a directory
     */
    class func makeDir(_ path : String) {
        //Found the correct way to access Documents directory online. StackOverflow
        let filePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String) + "/\(path)"
        let fileURL = URL(fileURLWithPath: filePath)
        var isDir : ObjCBool = false
        do {
            if !FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir) {
                try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("Can't create Dir")
            print(error)
        }
    }
    
    /**
     Returns if a file at URL is present
     */
    class func ifFileExists(_ fileUrl : URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileUrl.path)
    }
    
   
}
