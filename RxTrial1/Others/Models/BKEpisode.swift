//
//  BKEpisode.swift
//  RxTrial1
//
//  Created by Ben KIM on 2022/07/02.
//

import Foundation
import CoreData

struct BKEpisode: Codable {
    let id: String
    let serverId: String?
    let title: String
    let image: String?
    let timestamp: Date?

    internal init(id: String, serverId: String? = nil, title: String, image: String?, timestamp: Date? = Date()) {
        self.id = id
        self.serverId = serverId
        self.title = title
        self.image = image
        self.timestamp = timestamp
    }
    
}

extension BKEpisode {
    static var sample: BKEpisode {
        BKEpisode(id: "id", serverId: "serverId", title: "title", image: "image", timestamp: Date())
    }
}
