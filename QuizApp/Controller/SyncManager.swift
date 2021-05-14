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
        } else {
            var dummyQuizzes = [Quiz]()
            var dummyQuestions = [Question]()
            
            var dummyAnswers = [Answer]()
            dummyAnswers.append(Answer(id: 1, text: "fix des", isCorrect: true))
            dummyAnswers.append(Answer(id: 2, text: "fix net", isCorrect: false))
            dummyAnswers.append(Answer(id: 3, text: "fix nö", isCorrect: false))
            dummyAnswers.append(Answer(id: 4, text: "fix nana", isCorrect: false))

            dummyQuestions.append(Question(id: 1, question: "hehe 1. Frage", answers: dummyAnswers))
            
            dummyQuizzes.append(Quiz(id: 1, title: "myQuiz", lernstoff: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet", questions: dummyQuestions))
            
            
            completion(.failure(.syncFailed, dummyQuizzes))
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
