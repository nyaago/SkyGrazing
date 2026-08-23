//
//  RelativeDateFormatter.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/19.
//

import Foundation

struct RelativeDateFormatter {
    /// Dateを相対日時文字列にフォーマットする（例: "5分前"）
    static func string(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.dateTimeStyle = .numeric
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    /// ISO8601文字列を相対日時文字列にフォーマットする
    static func string(from dateString: String) -> String? {
        guard let date = ISO8601DateParser.date(from: dateString) else {
            return nil
        }
        return string(from: date)
    }
}
