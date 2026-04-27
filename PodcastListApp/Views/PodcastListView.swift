//
//  PodcastListView.swift
//  PodcastListApp
//
//  Root screen of the app: shows the podcast list and wires taps
//  to the view model. Rendering of each row is delegated to PodcastRowView.
//

import SwiftUI

struct PodcastListView: View {

    @StateObject private var viewModel = PodcastListViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.episodes) { episode in
                Button {
                    viewModel.togglePlayback(for: episode)
                } label: {
                    PodcastRowView(
                        episode: episode,
                        isPlaying: viewModel.isPlaying(episode)
                    )
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .navigationTitle("播客节目")
            .refreshable {
                await viewModel.refresh()
            }
            .safeAreaInset(edge: .bottom) {
                if let current = currentEpisode {
                    NowPlayingBar(episode: current)
                }
            }
        }
    }

    /// Resolves the episode matching `currentPlayingEpisodeID`, if any.
    private var currentEpisode: PodcastEpisode? {
        guard let id = viewModel.currentPlayingEpisodeID else { return nil }
        return viewModel.episodes.first { $0.id == id }
    }
}

#Preview("List - Light") {
    PodcastListView()
}

#Preview("List - Dark") {
    PodcastListView()
        .preferredColorScheme(.dark)
}
