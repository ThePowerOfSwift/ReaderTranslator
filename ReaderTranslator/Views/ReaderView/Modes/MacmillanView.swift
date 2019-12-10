//
//  GTranslatorView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/5/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct MacmillanView: View {
    @ObservedObject private var store = Store.shared

    var body: some View {
        WebViewContainer {
            MacmillanRepresenter(selectedText: self.$store.translateAction)
        }.frame(width: AvailableView.macmillan.width.wrappedValue.cgFloatValue)
    }
}

struct MacmillanView_Previews: PreviewProvider {
    static var previews: some View {
        MacmillanView()
    }
}
