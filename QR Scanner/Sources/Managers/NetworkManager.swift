//
//  NetworkManager.swift
//  QR Scanner
//
//  Created by Артем Галай on 10.03.23.
//

import UIKit

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func fetchData(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else {
                if let error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }.resume()
    }
}

enum NetworkError: Error {
    case badURL
}
