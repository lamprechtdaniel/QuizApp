//
//  SyncManager.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

class SyncManager {
    enum Error: Swift.Error {
            case fileAlreadyExists
            case invalidDirectory
            case writtingFailed
            case readingFailed
            case syncFailed
    }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error, Value?)
    }
    
    static var shared = SyncManager()
    
    internal func syncQuizzes(completion: @escaping (Result<[Quiz]>) -> Void) {
        if let url = URL(string: "") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                }
                //read from file
                var quizzesFromStorage = [Quiz]()
                do {
                    let data = try self.readFromFile()
                    quizzesFromStorage = try JSONDecoder().decode([Quiz].self, from: data)
                } catch {
                    print(error)
                    completion(.failure(error as! SyncManager.Error, nil))
                }
                
                guard let data = data else {
                    completion(.failure(.syncFailed, quizzesFromStorage))
                    return
                }
                do {
                    try self.saveToFile(data: data)
                    completion(.success(try JSONDecoder().decode([Quiz].self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(error as! SyncManager.Error, quizzesFromStorage))
                }
            }
        }
    }

    internal let fileManager = FileManager()
    
    internal func saveToFile(data:Data) throws {
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
    
    internal func readFromFile() throws -> Data {
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
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent("Quiz.json")
    }
    
}
