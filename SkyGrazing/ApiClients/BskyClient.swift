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

/// 認証に関するエラー。
enum BskyAuthError: Error {
    /// accessJwt / refreshJwt ともに失効するなどして、再ログインが必要になった状態。
    case sessionExpired
}

class BskyClient {
    private let baseURL = "https://bsky.social/xrpc/"

    /// accessJwt 期限切れ時の refreshSession を直列化し、同時リクエストでの多重更新を防ぐ。
    private let refreshCoordinator = SessionRefreshCoordinator()

    func fetch<R: BskyRequestable>(request: R) async throws -> R.Response {
        var components = URLComponents(string: baseURL + request.endPoint())
        let queryItems = request.buildQueryItems()
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        let urlRequest = URLRequest(url: url)
        let data = try await performAuthorized(urlRequest)
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
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let data = try await performAuthorized(urlRequest)
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

    /// accessJwt を Authorization に付けてリクエストを実行する。
    /// ExpiredToken を検知したら refreshSession で更新し、新しい accessJwt で 1 度だけリトライする。
    /// 更新自体に失敗した場合は `BskyAuthError.sessionExpired` を投げる。
    private func performAuthorized(_ request: URLRequest) async throws -> Data {
        var authorizedRequest = request
        applyAccessToken(to: &authorizedRequest)

        let (data, response) = try await URLSession.shared.data(for: authorizedRequest)
        guard isExpiredToken(data: data, response: response) else {
            return data
        }

        // accessJwt の期限切れ。refreshJwt でセッションを更新してから一度だけ再試行する。
        do {
            try await refreshCoordinator.refresh { [weak self] in
                _ = try await self?.refreshSession()
            }
        } catch {
            throw BskyAuthError.sessionExpired
        }

        var retriedRequest = request
        applyAccessToken(to: &retriedRequest)
        let (retriedData, _) = try await URLSession.shared.data(for: retriedRequest)
        return retriedData
    }

    /// 現在の accessJwt を Authorization ヘッダに設定する（存在する場合のみ）。
    private func applyAccessToken(to request: inout URLRequest) {
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    /// bsky は accessJwt 期限切れ時に HTTP 400 と `{"error":"ExpiredToken"}` を返す。
    private func isExpiredToken(data: Data, response: URLResponse) -> Bool {
        guard let http = response as? HTTPURLResponse,
              http.statusCode == 400 || http.statusCode == 401 else {
            return false
        }
        guard let errorResponse = try? JSONDecoder().decode(BskyErrorResponse.self, from: data) else {
            return false
        }
        return errorResponse.error == "ExpiredToken"
    }

    /// エラー応答の最小限のエンベロープ。
    private struct BskyErrorResponse: Decodable {
        let error: String?
        let message: String?
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
    private static let appAccessTokenKey = "appAccessJwt"
    private static let appRefreshTokenKey = "appRefreshJwt"

    /// Plist の identifier/password で createSession を呼び、トークンを Keychain に保存する
    func login() async throws -> BskySession {
        let appProperty = AppProperty()
        guard let identifier = appProperty.getString("BskyIdentifier"),
              let password = appProperty.getString("BskyPassword") else {
            throw URLError(.userAuthenticationRequired)
        }
        return try await login(identifier: identifier, password: password)
    }

    /// 指定された identifier/password で createSession を呼び、トークンを Keychain に保存する
    func login(identifier: String, password: String) async throws -> BskySession {
        let request = BskyCreateSessionRequest(identifier: identifier, password: password)
        let session = try await post(request: request)
        KeychainHelper.save(key: Self.accessTokenKey, value: session.accessJwt)
        KeychainHelper.save(key: Self.refreshTokenKey, value: session.refreshJwt)
        UserSettings.handle = session.handle
        return session
    }
    
    /// Keychain の refreshJwt を Bearer に付けて refreshSession を呼び、
    /// 新しい accessJwt / refreshJwt を Keychain に保存する。
    func refreshSession() async throws -> BskySession {
        guard let refreshToken = KeychainHelper.load(key: Self.refreshTokenKey) else {
            throw URLError(.userAuthenticationRequired)
        }
        let request = BskyRefreshSessionRequest()
        guard let url = URL(string: baseURL + request.endPoint()) else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // refreshSession は accessJwt ではなく refreshJwt で認証する
        urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        #if DEBUG
        printJSON(from: data)
        #endif
        do {
            let session = try JSONDecoder().decode(BskySession.self, from: data)
            KeychainHelper.save(key: Self.accessTokenKey, value: session.accessJwt)
            KeychainHelper.save(key: Self.refreshTokenKey, value: session.refreshJwt)
            UserSettings.handle = session.handle
            return session
        } catch {
            #if DEBUG
            printError(from: error)
            #endif
            throw error
        }
    }

    func logout() {
        KeychainHelper.delete(key: Self.accessTokenKey)
        KeychainHelper.delete(key: Self.refreshTokenKey)
    }
   
    var accessToken: String? {
        KeychainHelper.load(key: Self.accessTokenKey)
    }
}

/// refreshSession を直列化するコーディネータ。
/// 複数のAPI 発行により、同時に複数のリクエストが期限切れを検知しても、更新は 1 本にまとめて実行する。
private actor SessionRefreshCoordinator {
    private var inFlight: Task<Void, Error>?

    /// 既に更新中ならその完了を待ち、そうでなければ新たに更新を開始する。
    /// operation = refresh 実際のrefresh処理を行うClosure。Task { } 内で実行するので @escaping
    func refresh(_ operation: @escaping () async throws -> Void) async throws {
        if let inFlight {
            // 既に更新中
            try await inFlight.value
            return
        }
        // 更新開始
        let task = Task { try await operation() }
        inFlight = task
        defer { inFlight = nil }
        try await task.value
    }
}
