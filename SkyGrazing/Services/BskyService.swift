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
    var isLoading = false
    private let client = BskyClient()
    
    /// 認証済みでなければログインし、GETリクエストを実行する
    func fetch<R: BskyRequestable>(_ request: R) async throws -> R.Response
        where R.Response: BskyResponseCheckable {
        try await ensureLoggedIn()
        let response = try await client.fetch(request: request)
        try checkResponse(response)
        return response
    }
    
    /// 認証済みでなければログインし、POSTリクエストを実行する
    func post<R: BskyPostable>(_ request: R) async throws -> R.Response
        where R.Response: BskyResponseCheckable {
        try await ensureLoggedIn()
        let response = try await client.post(request: request)
        try checkResponse(response)
        return response
    }
    
    private func ensureLoggedIn() async throws {
        if client.accessToken == nil {
            let _ = try await client.login()
        }
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
