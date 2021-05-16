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
            case writingFailed
            case readingFailed
            case syncFailed
    }
    
    enum Result<Value> {
        case success
        case failure(Error?)
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

    
    internal func syncQuizzes(completion: @escaping (Result<Any>) -> Void) {
        if var url = AppDelegate.backendHost  {
            url.appendPathComponent("/quizes")
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                    completion(.failure(.syncFailed))
                }
                guard let data = data else {
                    completion(.failure(.syncFailed))
                    return
                }
                do {
                    try self.saveToFile(data: data)
                    completion(.success)
                } catch {
                    print(error)
                    completion(.failure(.writingFailed))
                }
            }
            dataTask.resume()
        } else {
            completion(.failure(.syncFailed))
        }
    }
    
    internal func syncScores(of quizId: String, completion: @escaping (_ success: Bool, _ scores: [Score]?) -> Void) {
        if var url = AppDelegate.backendHost  {
            url.appendPathComponent("/scores/\(quizId)")
            let dataTask = URLSession.shared.dataTask(with: url) { (responseData, response, error) in
                if let error = error {
                    print(error)
                    completion(false, nil)
                    return
                }
                var scores: [Score]?
                if let responseData = responseData {
                    do {
                        scores = try self.decoder().decode([Score].self, from: responseData)
                        
                        completion(true, scores)
                    } catch {
                        print(error)
                    }
                }

//                if let response = response as? HTTPURLResponse {
//                    switch response.statusCode {
//                    case 200:
//                        completion(true, scores)
//                        break
//                    default:
//                        completion(false, scores)
//                        break
//                    }
//                }
            }
            dataTask.resume()
        } else {
            completion(false, nil)
        }
    }
    
    internal func postScore(quizId: String, username: String, record: Int, completion: @escaping (_ success: Bool) -> Void) {
        if !Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            completion(false)
            return
        }
        if var requestUrl = AppDelegate.backendHost {
            requestUrl.appendPathComponent("/scores")
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            
           
            let uploadData = try! JSONSerialization.data(withJSONObject: [
                "quizId": quizId,
                "username": username,
                "record": record
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
    
    
    internal func updateLearning(of quizId: String, with lernstoff: String, changedAt lastChange: Date, completion: @escaping (_ success: Bool, _ quiz: Quiz?) -> Void) {
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
                    completion(false, nil)
                    return
                }
                var quiz: Quiz?
                if let responseData = responseData {
                    do {
                        quiz = try self.decoder().decode(Quiz.self, from: responseData)
                        
                       
                        if quiz != nil, var quizzes = Quiz.items, let indexOfUpdatingQuiz = quizzes.firstIndex(where: { $0._id == quiz?._id }) {
                            quizzes[indexOfUpdatingQuiz] = quiz!
                            
                            let encoder = JSONEncoder()
                            encoder.dateEncodingStrategy = .custom({(date, encoder) in
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                var container = encoder.singleValueContainer()
                                try container.encode(dateFormatter.string(from: date))
                            })
                            try self.saveToFile(data: encoder.encode(quizzes))
                        }
                    } catch {
                        print(error)
                    }
                }

                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200:
                        completion(true, quiz)
                        break
                    default:
                        completion(false, quiz)
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
            try data.write(to: url, options: [.atomic])
        } catch {
            print(error)
            throw Error.writingFailed
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
