//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by Mauro Worobiej on 05/09/2021.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

class FeedImageMapper {
	private struct ItemModel: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}

		var feedImage: FeedImage {
			FeedImage(id: id, description: description, location: location, url: url)
		}
	}

	static var OK_200: Int { 200 }

	static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == OK_200,
		      let items = try? JSONDecoder().decode([ItemModel].self, from: data)
		else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}

		return .success(items.map { $0.feedImage })
	}
}
