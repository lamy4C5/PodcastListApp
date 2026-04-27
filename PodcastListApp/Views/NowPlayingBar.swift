//
//  NowPlayingBar.swift
//  PodcastListApp
//
//  Small bottom bar shown when an episode is marked as playing.
//  Pure presentational view; parent decides when to show it.
//

import SwiftUI

struct NowPlayingBar: View {

    let episode: PodcastEpisode

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.accentColor)

            VStack(alignment: .leading, spacing: 2) {
                Text("正在播放")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(episode.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Image(systemName: "waveform")
                .foregroundStyle(Color.accentColor)
                .accessibilityHidden(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("正在播放 \(episode.title)")
    }
}

#Preview("NowPlayingBar - Light") {
    VStack {
        Spacer()
        NowPlayingBar(episode: .previewSampleBar)
    }
}

#Preview("NowPlayingBar - Dark") {
    VStack {
        Spacer()
        NowPlayingBar(episode: .previewSampleBar)
    }
    .preferredColorScheme(.dark)
}

private extension PodcastEpisode {
    static let previewSampleBar = PodcastEpisode(
        id: "preview-bar",
        title: "SwiftUI 在大型项目中的取舍",
        host: "陈婧",
        duration: "35 min",
        coverImageName: "podcast_placeholder",
        description: "预览用简介。"
    )
}
