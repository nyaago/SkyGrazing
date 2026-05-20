//
//  BskyService.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/05/03.
//

import Foundation
import Observation

enum BskyApiError: Error {
    case apiError(error: String, message: String)
}

@Observable
class BskyService {
    var isLoggedIn = false
    var isLoggingIn = false
    private let client = BskyClient()
    
    /// GETリクエストを実行する
    func fetch<R: BskyRequestable>(_ request: R) async throws -> R.Response
        where R.Response: BskyResponseCheckable {
        let response = try await client.fetch(request: request)
        try checkResponse(response)
        return response
    }
    
    /// POSTリクエストを実行する
    func post<R: BskyPostable>(_ request: R) async throws -> R.Response
        where R.Response: BskyResponseCheckable {
        let response = try await client.post(request: request)
        try checkResponse(response)
        return response
    }
    
    /// UI から identifier/password でログインする
    func login(identifier: String, password: String) async throws {
        let _ = try await client.login(identifier: identifier, password: password)
        isLoggedIn = true
    }
    
    private func checkResponse(_ response: BskyResponseCheckable) throws {
        if response.isError {
            let error = response.error ?? "Unknown Error"
            let message = response.message ?? "Unknown Message"
            print("API error: \(error) - \(message)")
            throw BskyApiError.apiError(error: error, message: message)
        }
    }
}
