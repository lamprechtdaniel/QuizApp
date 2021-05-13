//
//  Fetchable.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//
import Foundation

class Fetchable {
    enum Error: Swift.Error {
            case fileAlreadyExists
            case invalidDirectory
            case writtingFailed
            case readingFailed
    }
    
    var id: Int?
    var apiUrl: URL?
    
    var type: String {
        return String(describing: self)
    }
    let fileManager = FileManager()
    
    
    func saveToFile(data:Data) throws {
        guard let url = url() else {
            throw Error.invalidDirectory
        }
        if fileManager.fileExists(atPath: url.absoluteString) {
            throw Error.fileAlreadyExists
        }
        do {
            try data.write(to: url)
        } catch {
            print(error)
            throw Error.writtingFailed
        }
    }
    
    func readFromFile() throws -> Data {
        guard let url = url() else {
            throw Error.invalidDirectory
        }
        
        guard fileManager.fileExists(atPath: url.absoluteString) else {
            throw Error.fileAlreadyExists
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print(error)
            throw Error.readingFailed
        }
    }
    
    
    
    internal func url() -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first, let id = id else {
            return nil
        }
        return url.appendingPathComponent("\(type).\(id)")
    }
}
