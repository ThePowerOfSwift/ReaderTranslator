//
//  RewindView.swift
//  ReaderTranslatorPlayer
//
//  Created by Viktor Kushnerov on 2/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct RewindButtonsView: View {
    let audioStore = AudioStore.shared
    
    var body: some View {
        HStack {
            Button(
                action: { AudioStore.shared.player?.currentTime = 0 },
                label: { Text("|<") }
            )
            .buttonStyle(RoundButtonStyle())
            rewindButton(label: "-50", step: -50)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)
            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+50", step: 50)
        }
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(
            action: {
                self.audioStore.player?.currentTime += step
                self.audioStore.updateTimeline()
            },
            label: { Text(label).frame(width: 35) }
        )
        .buttonStyle(RoundButtonStyle())
    }
}

struct RewindView_Previews: PreviewProvider {
    static var previews: some View {
        RewindButtonsView()
    }
}
