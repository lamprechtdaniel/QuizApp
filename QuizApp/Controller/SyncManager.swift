//
//  SyncManager.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

class SyncManager {
    enum Error: Swift.Error {
            case fileNotFound
            case invalidDirectory
            case writtingFailed
            case readingFailed
            case syncFailed
    }
    
    enum Result<Value> {
        case success(Value)
        case failure(Error?, Value?)
    }
    
    static var shared = SyncManager()
    
    func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let text = try container.decode(String.self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            return dateFormatter.date(from: text) ?? Date()
        })
        return decoder
    }

    
    internal func syncQuizzes(completion: @escaping (Result<[Quiz]>) -> Void) {
        if var url = AppDelegate.backendHost  {
            url.appendPathComponent("/quizes")
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(.failure(.syncFailed, self.localQuizData))
                }
                guard let data = data else {
                    completion(.failure(.syncFailed, self.localQuizData))
                    return
                }
                do {
                    try self.saveToFile(data: data)
                    completion(.success(try self.decoder().decode([Quiz].self, from: data)))
                } catch {
                    print(error)
                    completion(.failure(nil, self.localQuizData))
                }
            }
            dataTask.resume()
        } else {
            completion(.failure(.syncFailed, localQuizData))
        }
    }
    
    
    internal func updateLearning(of quizId: String, with lernstoff: String, changedAt lastChange: Date, completion: @escaping (_ success: Bool) -> Void) {
        if var requestUrl = AppDelegate.backendHost {
            requestUrl.appendPathComponent("/quizes/update/\(quizId)")
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "PUT"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            
            let uploadData = try! JSONSerialization.data(withJSONObject: [
                "lernstoff": lernstoff,
                "last_change": dateFormatter.string(from: lastChange)
            ], options: .prettyPrinted)
            
            request.httpBody = uploadData
            request.setValue("\(uploadData.count)", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let urlUploadTask = URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                if let error = error {
                    print(error)
                    completion(false)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200:
                        completion(true)
                        break
                    default:
                        completion(false)
                        break
                    }
                }
            }
            urlUploadTask.resume()
        }
        
    }
    
    internal var localQuizData:[Quiz]? {
        do {
            let data = try self.readFromFile()
            return try decoder().decode([Quiz].self, from: data)
        } catch {
            print(error)
        }
        return nil
    }

    internal let fileManager = FileManager()
    
    internal func saveToFile(data:Data) throws {
        guard let url = url() else {
            throw Error.invalidDirectory
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
        
        guard fileManager.fileExists(atPath: url.path) else {
            throw Error.fileNotFound
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
        return url.appendingPathComponent("Quizzes.json")
    }
    
}
