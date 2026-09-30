//
//  BskyPostRecord+AttributedText.swift
//  SkyGrazing
//
//  Created by nyaago on 2026/09/28.
//

import Foundation

extension BskyPostRecord {
    /// facets の link を反映した表示用の `AttributedString`。
    /// link facet が指すバイト範囲に対応するテキスト部分へ URL リンクを付与する。
    /// facets がない・link がない場合はプレーンなテキストをそのまま返す。
    var attributedText: AttributedString {
        let raw = text ?? ""
        var result = AttributedString(raw)

        guard let facets else { return result }
        let byteCount = raw.utf8.count

        for facet in facets {
            // link feature の URL を取り出す（mention / tag はここでは対象外）。
            guard let uri = facet.features.first(where: {
                $0.type == "app.bsky.richtext.facet#link"
            })?.uri, let url = URL(string: uri) else { continue }

            let start = facet.index.byteStart
            let end = facet.index.byteEnd
            guard start >= 0, start < end, end <= byteCount else { continue }

            // UTF-8 バイトオフセットを String.Index へ変換する。
            guard let range = stringRange(byteStart: start, byteEnd: end, in: raw),
                  let lower = AttributedString.Index(range.lowerBound, within: result),
                  let upper = AttributedString.Index(range.upperBound, within: result) else {
                continue
            }

            result[lower..<upper].link = url
        }

        return result
    }

    /// UTF-8 バイト範囲を `String` の文字境界に沿った `Range<String.Index>` へ変換する。
    /// 範囲が文字境界に一致しない場合は nil を返す。
    private func stringRange(byteStart: Int, byteEnd: Int, in string: String) -> Range<String.Index>? {
        let utf8 = string.utf8
        guard let startUTF8 = utf8.index(utf8.startIndex, offsetBy: byteStart, limitedBy: utf8.endIndex),
              let endUTF8 = utf8.index(utf8.startIndex, offsetBy: byteEnd, limitedBy: utf8.endIndex),
              let start = startUTF8.samePosition(in: string),
              let end = endUTF8.samePosition(in: string) else {
            return nil
        }
        return start..<end
    }
}
