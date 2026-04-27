//
//  PodcastRowView.swift
//  PodcastListApp
//
//  Presentational row for a single podcast episode.
//  Does not own state; parent passes in `isPlaying`.
//

import SwiftUI

struct PodcastRowView: View {

    let episode: PodcastEpisode
    let isPlaying: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            coverImage
            textContent
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(rowBackground)
        .contentShape(Rectangle())
    }

    // MARK: - Subviews

    private var coverImage: some View {
        ZStack {
            Color(.secondarySystemBackground)

            if UIImage(named: episode.coverImageName) != nil {
                Image(episode.coverImageName)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "waveform")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 64, height: 64)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(episode.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer(minLength: 4)

                Text(episode.duration)
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .layoutPriority(1)
            }

            Text(episode.host)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Text(episode.description)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            if isPlaying {
                nowPlayingBadge
                    .padding(.top, 2)
            }
        }
    }

    private var nowPlayingBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "play.circle.fill")
            Text("正在播放")
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(Color.accentColor)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(isPlaying ? Color.accentColor.opacity(0.14) : Color.clear)
    }
}

// MARK: - Previews

#Preview("Row - Light") {
    VStack(spacing: 8) {
        PodcastRowView(episode: .previewSample, isPlaying: false)
        PodcastRowView(episode: .previewSample, isPlaying: true)
    }
    .padding()
}

#Preview("Row - Dark") {
    VStack(spacing: 8) {
        PodcastRowView(episode: .previewSample, isPlaying: false)
        PodcastRowView(episode: .previewSample, isPlaying: true)
    }
    .padding()
    .preferredColorScheme(.dark)
}

private extension PodcastEpisode {
    static let previewSample = PodcastEpisode(
        id: "preview",
        title: "SwiftUI 在大型项目中的取舍",
        host: "陈婧",
        duration: "35 min",
        coverImageName: "podcast_placeholder",
        description: "状态管理、性能、与 UIKit 的协作经验分享。"
    )
}
