//
//  BskyService.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/05.
//

import Foundation

protocol BskyRequestable: Encodable {
    associatedtype Response: Decodable
    func endPoint() -> String
    func buildQueryItems() -> [URLQueryItem]
}

protocol BskyPostable: Encodable {
    associatedtype Response: Decodable
    func endPoint() -> String
}

class BskyClient {
    private let baseURL = "https://bsky.social/xrpc/"
    
    func fetch<R: BskyRequestable>(request: R, accessJwt: String? = nil) async throws -> R.Response {
        var components = URLComponents(string: baseURL + request.endPoint())
        let queryItems = request.buildQueryItems()
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        if let token = accessJwt {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        printJSON(from: data)
        do {
            return try JSONDecoder().decode(R.Response.self, from: data)
        } catch {
            printError(from: error)
            throw error
        }
    }
    
    func post<R: BskyPostable>(request: R, accessJwt: String? = nil) async throws -> R.Response {
        guard let url = URL(string: baseURL + request.endPoint()) else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessJwt {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        printJSON(from: data)
        do {
            return try JSONDecoder().decode(R.Response.self, from: data)
        } catch {
            printError(from: error)
            throw error
        }
    }
    
    private func printJSON(from data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("--- API Response JSON ---")
            print(jsonString)
            print("-------------------------")
        }
    }
    
    private func printError(from error: Error) {
        print("--- API Error ---")
        print(error.localizedDescription)
        if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("❌ キーが見つかりません: \(key.stringValue) - パス: \(context.codingPath)")
                case .typeMismatch(let type, let context):
                    print("❌ 型が違います: \(type) - パス: \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("❌ 値が空(null)です: \(type) - パス: \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("❌ データが壊れています - パス: \(context.codingPath)")
                @unknown default:
                    print("❌ 未知のデコードエラー: \(error)")
                }
            }
        print("-----------------")
    }   
}
