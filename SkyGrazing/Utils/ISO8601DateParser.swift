//
//  ISO8601DateParser.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/19.
//

import Foundation

struct ISO8601DateParser {
    /// ISO8601文字列をDateに変換する（小数秒あり/なし両対応）
    static func date(from dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        // 小数秒ありでまず試行
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: dateString) {
            return date
        }
        // 小数秒なしで再試行
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: dateString)
    }
}
