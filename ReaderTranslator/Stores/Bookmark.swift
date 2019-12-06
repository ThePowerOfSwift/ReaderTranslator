//
//  Bookmark.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 6/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Foundation

struct Bookmark: Codable, Hashable {
    var checked: Bool = false
    let text: String
}

typealias Bookmarks = [Bookmark]

extension Array where Element == Bookmark {
    func contains(text: String) -> Bool {
        self.first { $0.text == text } != nil
    }

    func firstIndex(text: String) -> Int? {
        self.firstIndex { $0.text == text }
    }

    mutating func remove(text: String) {
        guard let index = self.firstIndex(text: text) else { return }
        self.remove(at: index)
    }

    mutating func append(_ text: String) {
        self.append(Bookmark(text: text))
    }

    mutating func toggle(_ text: String) {
        guard let index = self.firstIndex(text: text) else { return }
        self[index].checked.toggle()
    }
}
