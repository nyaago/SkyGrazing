//
//  RelativeCreatedAtText.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/08/06.
//

import SwiftUI

struct RelativeCreatedAtText: View {
    let createdAt: String?

    var body: some View {
        Text(formatCreatedAt() ?? "").modifier(CaptionModifier())
    }
    
    private func formatCreatedAt() -> String? {
        if let createdAt {
            return formatDate(dateString: createdAt)
        }
        return nil
    }

    private func formatDate(dateString: String) -> String? {
        guard let date = dateFrom(dateString: dateString)
        else { return nil }
        return format(date: date)
    }

    private func format(date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.dateTimeStyle = .numeric
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    private func dateFrom(dateString: String) -> Date? {
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

/*
 #Preview {
 RelativeCreatedAtText()
 }
 */
