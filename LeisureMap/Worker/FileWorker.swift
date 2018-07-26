//
//  FileWorker.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/26.
//  Copyright © 2018年 tripim. All rights reserved.
//

import Foundation

protocol FileWorkerDelegate {
    func fileWorkWriteComplete(_ sender:FileWorker,fileName:String,tag:Int)
    func fileWorkReadComplete(_ sender:FileWorker,fileName:String,tag:Int)
}

class FileWorker{
    var fileWorkerDelegate:FileWorkerDelegate?
    
    func writeToFile(content:String,fileName:String,tag:Int) {
        
        if let dir=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let fileURL=dir.appendingPathComponent(fileName)
            do{
                try content.write(to: fileURL, atomically: false, encoding: .utf8)
                self.fileWorkerDelegate?.fileWorkWriteComplete(self, fileName: fileURL.absoluteString, tag: tag)
            }
            catch{
                print(error)
            }
        }
    }
    
    func readFromFile(content:String,fileName:String,tag:Int)->String {
        var result:String=""
        
        return result
        
    }
}
