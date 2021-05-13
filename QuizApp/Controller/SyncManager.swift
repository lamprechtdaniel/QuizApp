//
//  SyncManager.swift
//  QuizApp
//
//  Created by Mathias Gsell on 13.05.21.
//

import Foundation

//class SyncManager {
//
//    static var shared = SyncManager()
//
//    internal func syncAll() {
//
//    }
//
//    internal func snyc<T:Fetchable>(type: T) {
//        if let url = type.apiUrl {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    print(error)
//                }
//
//                guard let data = data else { return }
//                do {
//                    let data = try JSONDecoder().decode(T.self, from: data)
//                    //type.saveToFile(data: data)
//                } catch {
//                    print(error)
//                }
//
//            }
//
//        }
//    }
//
//}
