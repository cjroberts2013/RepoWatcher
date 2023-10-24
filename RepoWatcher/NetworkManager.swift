//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Charles Roberts on 10/23/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }
    
    func getUser(urlString: String) async throws -> GitUser {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do  {
            return try decoder.decode(GitUser.self, from: data)
        } catch {
            throw NetworkError.invalidUserData
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidUserData
}

enum UserURL {
    static let myUser = "https://api.github.com/users/cjroberts2013"
    
}
