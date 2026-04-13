//
//  BskyService.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/05.
//

import Foundation
import Combine

protocol BskyRequestable: Encodable {
    associatedtype Response: Decodable
    func endPoint() -> String
    func buildQueryItems() -> [URLQueryItem]
//    func classType() -> Decodable.Type
}

protocol BskyPostable: Encodable {
    associatedtype Response: Decodable
    func endPoint() -> String
}

enum BskyError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
    case unknown
}

enum BskyValidationError: Error {
    
}

class BskyClient {
    private let baseURL = "https://bsky.social/xrpc/"
    
    func fetch<R: BskyRequestable>(request: R, accessJwt: String?) -> AnyPublisher<R.Response, Error> {
        var components = URLComponents(string: baseURL + request.endPoint())
        let queryItems = request.buildQueryItems()
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)
        if let token = accessJwt {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .handleEvents(receiveOutput: { output in
                self.printJSON(from: output.data)
                })
            .map(\.data)
            .decode(type: R.Response.self, decoder: JSONDecoder()) // 強制キャスト不要
            .mapError({ error in
                self.printError(from: error)
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func post<R: BskyPostable>(request: R) -> AnyPublisher<R.Response, Error> {
        post(request: request, accessJwt: nil)
    }
    
    func post<R: BskyPostable>(request: R, accessJwt: String?) -> AnyPublisher<R.Response, Error> {
        guard let url = URL(string: baseURL + request.endPoint()) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessJwt {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .handleEvents(receiveOutput: { output in
                self.printJSON(from: output.data)
            })
            .map(\.data)
            .decode(type: R.Response.self, decoder: JSONDecoder())
            .mapError { error in
                self.printError(from: error)
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
