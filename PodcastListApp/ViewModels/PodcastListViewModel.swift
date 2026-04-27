//
//  PodcastListViewModel.swift
//  PodcastListApp
//
//  View model for the podcast list screen.
//  Owns the episodes array and tracks which episode is currently playing.
//

import Foundation
import Combine

final class PodcastListViewModel: ObservableObject {

    @Published private(set) var episodes: [PodcastEpisode] = []
    @Published private(set) var currentPlayingEpisodeID: String?

    init() {
        loadEpisodes()
    }

    /// Loads episodes from the bundled JSON via `PodcastDataLoader`.
    /// On failure, leaves `episodes` empty and logs the error.
    private func loadEpisodes() {
        do {
            episodes = try PodcastDataLoader.loadPodcasts()
        } catch {
            print("PodcastListViewModel: failed to load podcasts -", error)
            episodes = []
        }
    }

    /// Marks the given episode as currently playing.
    /// If it is already the current one, state stays unchanged.
    /// - Parameter episode: The episode the user tapped.
    func togglePlayback(for episode: PodcastEpisode) {
        guard currentPlayingEpisodeID != episode.id else { return }
        currentPlayingEpisodeID = episode.id
    }

    /// Returns whether the given episode is the one currently playing.
    /// - Parameter episode: The episode to check.
    /// - Returns: `true` if it matches `currentPlayingEpisodeID`, otherwise `false`.
    func isPlaying(_ episode: PodcastEpisode) -> Bool {
        currentPlayingEpisodeID == episode.id
    }

    /// Simulates a pull-to-refresh by sleeping briefly and reloading the bundled JSON.
    /// Preserves the currently playing episode if it still exists after reload.
    /// On failure, keeps the previous episode list but clears the playing state.
    @MainActor
    func refresh() async {
        try? await Task.sleep(for: .seconds(1))

        do {
            let newEpisodes = try PodcastDataLoader.loadPodcasts()
            episodes = newEpisodes

            if let id = currentPlayingEpisodeID,
               !newEpisodes.contains(where: { $0.id == id }) {
                currentPlayingEpisodeID = nil
            }
        } catch {
            print("PodcastListViewModel: refresh failed -", error)
            currentPlayingEpisodeID = nil
        }
    }
}
