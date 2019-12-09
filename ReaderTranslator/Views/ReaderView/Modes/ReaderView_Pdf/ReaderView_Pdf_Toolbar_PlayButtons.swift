//
//  ReaderView_Pdf_Toolbar_PlayButtons.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 9/12/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

private var timer: Timer?

struct ReaderView_Pdf_Toolbar_PlayButtons: View {
    @Binding var player: AudioPlayer
    @Binding var isPlaying: Bool
    @Binding var currentStatus: String

    @ObservedObject var store = Store.shared

    var body: some View {
        HStack(spacing: 2) {
            Button(action: { self.player.player?.currentTime = 0 }, label: { Text("|<") })
            rewindButton(label: "-50", step: -50)
            rewindButton(label: "-5", step: -5)
            rewindButton(label: "-1", step: -1)

            playButtonView

            rewindButton(label: "+1", step: 1)
            rewindButton(label: "+5", step: 5)
            rewindButton(label: "+50", step: 50)
        }
        .onAppear {
            if let url = self.store.pdfAudio { self.player.openAudio(url: url) }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var playButtonView: some View {
        Button(action: {
            guard let player = self.player.player else { return }
            if self.isPlaying {
                player.pause()
                timer?.invalidate()
            } else {
                self.startTimer()
                //hack: currentTime jump forward for some time after an audio is continue to play
                let currentTime = player.currentTime
                player.play()
                player.currentTime = currentTime
            }
            self.isPlaying = player.isPlaying
        }, label: { Text(isPlaying ? "Pause" : "Play").frame(width: 40) })
    }

    private func rewindButton(label: String, step: Double) -> some View {
        Button(action: { self.player.player?.currentTime += step }, label: { Text(label) })
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            guard let player = self.player.player else { return }
            self.currentStatus = String(format: "%.1f/%.1f", player.currentTime, player.duration)
            player.volume = self.store.voiceVolume
        }
    }

}
