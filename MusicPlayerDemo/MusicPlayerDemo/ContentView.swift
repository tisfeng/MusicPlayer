//
//  ContentView.swift
//  MusicPlayerDemo
//
//  Created by tisfeng on 2024/11/20.
//

import MusicPlayer
import SwiftUI

struct ContentView: View {
    private let selectedPlayer = MusicPlayers.SystemMedia()

    @State private var musicTrack: MusicTrack?
    @State private var artwork = Image(systemName: "music.note")

    @State private var time = 0.0
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                artwork
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .clipped()
                    .blur(radius: 5)
                    .opacity(0.6)
                    .overlay(Color.black.opacity(0.5))
            }

            VStack(spacing: 20) {
                Text(musicTrack?.title ?? "")
                    .font(.title)
                Text((musicTrack?.artist ?? "") + " - " + (musicTrack?.album ?? ""))

                Text("duration: \(String(format: "%.1f", musicTrack?.duration ?? 0))")
                Text("start time: \(time, specifier: "%.1f")")

                HStack(spacing: 30) {
                    Button(action: {
                        selectedPlayer?.skipToPreviousItem()
                    }) {
                        Image(systemName: "backward.end")
                            .font(.system(size: 25))
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        selectedPlayer?.playPause()
                    }) {
                        Image(systemName: isPlaying ? "play.circle" : "pause.circle")
                            .font(.system(size: 30))
                    }
                    .buttonStyle(.plain)

                    Button(action: {
                        selectedPlayer?.skipToNextItem()
                    }) {
                        Image(systemName: "forward.end")
                            .font(.system(size: 25))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(minWidth: 300, minHeight: 300)
        .padding()
        .environment(\.colorScheme, .dark)
        .onReceive(selectedPlayer!.$currentTrack) {
            if let track = $0 {
                musicTrack = track

                if let coverImage = $0?.artwork {
                    artwork = Image(nsImage: coverImage)
                } else {
                    artwork = Image(systemName: "music.note")
                }
            }
        }
        .onReceive(selectedPlayer!.$playbackState) {
            time = $0.time
            isPlaying = $0.isPlaying
        }
    }
}

#Preview {
    ContentView()
}
