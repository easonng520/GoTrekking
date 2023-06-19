//
//  AppDelegate.swift
//  GoTrekking
//
//  Created by eazz on 9/6/2023.
//


import Foundation
struct Event: Decodable {
  let id: Int
  let name: String
  let date: String

  
  enum CodingKeys: String, CodingKey {
      case id,name,date
  }
}

extension URLSession {
  func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) {
    self.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
      }

      if let data = data {
        do {
          let object = try JSONDecoder().decode(T.self, from: data)
          completion(.success(object))
        } catch let decoderError {
          completion(.failure(decoderError))
        }
      }
    }.resume()
  }
}

