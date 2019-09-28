//
//  ReaderView_Web.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/28/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct ReaderView_Web: View {
    @ObservedObject var store = Store.shared

    var body: some View {
        Group {
            if store.viewMode == .web {
                VStack {
                    HStack {
                        Image(systemName: "arrowshape.turn.up.left\(store.canGoBack ? ".fill" : "")")
                            .onTapGesture {
                                _ = WebView.pageView.goBack()
                            }
                        TextField("Enter website name", text: self.$store.lastWebPage)
                        Button(action: {
                            self.store.lastWebPage = ""
                        }) {
                            Image(systemName: "xmark.circle")
                        }
                    }.padding(5)
                    webView(0)
                    webView(1)
                    webView(2)
                }
            }
        }
    }
    
    private func webView(_ currentTab: Int) -> some View {
        if self.store.currentTab == currentTab {
            let view = WebView(lastWebPage: $store.lastWebPage)
            return AnyView(view)
        }else{
            return AnyView(EmptyView())
        }
    }
}

struct ReaderView_Web_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView_Web()
    }
}