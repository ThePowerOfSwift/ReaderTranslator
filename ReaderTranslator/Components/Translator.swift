//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import Combine
import SwiftUI
import WebKit

struct Translator : ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultUrl = "https://translate.google.com?sl=auto&tl=ru"
    static var hasSentTranslateAction = false
        
    static var pageView: WKPage?

    class Coordinator: WKCoordinator {
        override init(_ parent: WKScriptsSetup) {
            super.init(parent)

            $selectedText
                .debounce(for: 0.5, scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { text in
                    print("Translator_$selectedText", text)
                    if text != "" {
                        parent.sentTranslateAction()
                        self.store.translateAction = .reversoContext(text)
                    }
                }
                .store(in: &cancellableSet)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeView(context: Context) -> WKPage  {
        print("Translator_makeView")
        if let view = Self.pageView { return view }
        
        let view = WKPage(defaultUrl: defaultUrl)
        Self.pageView = view
        
        setupScripts(
            userContentController: view.configuration.userContentController,
            coordinator: context.coordinator)

        return view
    }
      
    func updateView(_ view: WKPage, context: Context) {
        print("Translator_updateView")
        let lastUrl = view.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? defaultUrl
        
        guard var urlComponent = URLComponents(string: url) else { return }
        guard let queryItems = urlComponent.queryItems else { return }

        let oldText = queryItems.first(where: { $0.name == "text" })?.value ?? ""
        
        guard case let .translator(text) = selectedText, text != "", text != oldText else { return }

        if Self.hasSentTranslateAction {
            Self.hasSentTranslateAction = false
            return
        }


        let sl = queryItems.first(where: { $0.name == "sl" })?.value
        let tl = queryItems.first(where: { $0.name == "tl" })?.value

        urlComponent.queryItems = [
            .init(name: "sl", value: sl),
            .init(name: "tl", value: tl),
            .init(name: "text", value: text)
        ]
        
        if let url = urlComponent.url {
            print("Translator_updateView_reload")
            view.load(URLRequest(url: url))
        }
    }
}




