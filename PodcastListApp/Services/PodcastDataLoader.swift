//
//  PodcastDataLoader.swift
//  PodcastListApp
//
//  Loads and decodes the bundled podcasts.json into [PodcastEpisode].
//  No networking, no third-party libraries.
//

import Foundation

enum PodcastDataLoaderError: Error {
    case fileNotFound(name: String)
    case decodingFailed(underlying: Error)
}

enum PodcastDataLoader {

    /// Loads podcast episodes from the bundled JSON resource.
    /// - Parameter fileName: JSON file name without extension. Defaults to "podcasts".
    /// - Returns: Decoded array of `PodcastEpisode`.
    /// - Throws: `PodcastDataLoaderError` if the file is missing or cannot be decoded.
    static func loadPodcasts(fileName: String = "podcasts") throws -> [PodcastEpisode] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            throw PodcastDataLoaderError.fileNotFound(name: "\(fileName).json")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([PodcastEpisode].self, from: data)
        } catch {
            throw PodcastDataLoaderError.decodingFailed(underlying: error)
        }
    }
}
