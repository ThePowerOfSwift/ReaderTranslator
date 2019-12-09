//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit

struct WikipediaRepresenter: ViewRepresentable, WKScriptsSetup {
    @Binding var selectedText: TranslateAction
    private let defaultURL = "https://en.wikipedia.org/wiki/Special:Search"

    static var pageView: WKPageView?
    static var coorinator: Coordinator?

    class Coordinator: WKCoordinator {
        var selectedText = ""
    }

    func makeCoordinator() -> Coordinator {
        makeCoordinator(coordinator: Coordinator(self))
    }

    func makeView(context: Context) -> WKPageView {
        if let view = Self.pageView { return view }

        let view = WKPageView()
        view.load(urlString: defaultURL)
        Self.pageView = view

        setupScriptCoordinator(view: view, coordinator: context.coordinator)

        return view
    }

    func updateView(_ view: WKPageView, context: Context) {
        guard case var .wikipedia(text) = selectedText else { return }
        text = text.replacingOccurrences(of: "\n", with: " ")
        Store.shared.translateAction.next()

        print("\(theClassName)_updateView_update", text)

        guard var urlComponent = URLComponents(string: defaultURL) else { return }
        urlComponent.queryItems = [.init(name: "search", value: text)]

        if let url = urlComponent.url {
            print("\(theClassName)_updateView_reload", url.absoluteString)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                view.load(URLRequest(url: url))
            }
        }
    }
}

extension WikipediaRepresenter.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let event = getEvent(data: message.body) else { return }
        var text: String { event.extra?.selectedText ?? "" }

        switch event.name {
        case "selectionchange":
            guard let text = event.extra?.selectedText else { return }
            self.selectedText = text
            store.translateAction.addAll(text: text, except: .wikipedia)
        case "keydown":
            if event.extra?.keyCode == 18 { //Alt
                SpeechSynthesizer.speak(text: text, stopSpeaking: true, isVoiceEnabled: true)
            }
        default:
            print("webkit.messageHandlers.\(event.name).postMessage() isn't found")
        }
    }
}