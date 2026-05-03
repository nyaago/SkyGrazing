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

protocol BskyResponseCheckable {
    var error: String? { get }
    var message: String? { get }
    var isError: Bool { get }
}

class BskyClient {
    private let baseURL = "https://bsky.social/xrpc/"
    
    func fetch<R: BskyRequestable>(request: R) async throws -> R.Response {
        var components = URLComponents(string: baseURL + request.endPoint())
        let queryItems = request.buildQueryItems()
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        if let token = accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        #if DEBUG
        printJSON(from: data)
        #endif
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(R.Response.self, from: data)
        } catch {
            #if DEBUG
            printError(from: error)
            #endif
            throw error
        }
    }
    
    func post<R: BskyPostable>(request: R) async throws -> R.Response {
        guard let url = URL(string: baseURL + request.endPoint()) else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        #if DEBUG
        printJSON(from: data)
        #endif
        do {
            return try JSONDecoder().decode(R.Response.self, from: data)
        } catch {
            #if DEBUG
            printError(from: error)
            #endif
            throw error
        }
    }
    
    #if DEBUG
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
    #endif
    
    private static let accessTokenKey = "accessJwt"
    private static let refreshTokenKey = "refreshJwt"
    
    /// Plist の identifier/password で createSession を呼び、トークンを Keychain に保存する
    func login() async throws -> BskySession {
        let appProperty = AppProperty()
        guard let identifier = appProperty.getString("BskyIdentifier"),
              let password = appProperty.getString("BskyPassword") else {
            throw URLError(.userAuthenticationRequired)
        }
        let request = BskyCreateSessionRequest(identifier: identifier, password: password)
        let session = try await post(request: request)
        KeychainHelper.save(key: Self.accessTokenKey, value: session.accessJwt)
        KeychainHelper.save(key: Self.refreshTokenKey, value: session.refreshJwt)
        return session
    }
    
    var accessToken: String? {
        KeychainHelper.load(key: Self.accessTokenKey)
    }
}
