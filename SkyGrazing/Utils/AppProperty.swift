//
//  AppProperty.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/04/30.
//

import Foundation

class AppProperty {
    var property: Dictionary<String, Any> = [:]
    init() {
        // App.plistのパス取得
        let path = Bundle.main.path(forResource: "App", ofType: "plist")
        // App.plistをDictionary形式で読み込み
        let configurations = NSDictionary(contentsOfFile: path!)
        if let datasourceDictionary: [String : Any]  = configurations as? [String : Any] {
            property = datasourceDictionary
        }
    }

    /// 指定されたキーの値を取得する
    /// - Parameter key: plistのキー
    func getString(_ key: String) -> String? {
        guard let value: String = property[key] as? String else {
            return nil
        }
        return value
    }
}
