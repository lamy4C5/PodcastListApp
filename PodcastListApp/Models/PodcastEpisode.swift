//
//  PodcastEpisode.swift
//  PodcastListApp
//
//  Data model for a single podcast episode.
//  Decoded from the bundled podcasts.json resource.
//

import Foundation

struct PodcastEpisode: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let host: String
    let duration: String
    let coverImageName: String
    let description: String
}
