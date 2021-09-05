//
//  Copyright © 2018 Essential Developer. All rights reserved.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (FeedLoader.Result) -> Void) {
		client.get(from: url) { result in

			switch result {
			case let .success((data, resonse)):
				guard resonse.statusCode != 200,
				      let items = try? JSONDecoder().decode([ItemModel].self, from: data)
				else {
					return completion(.failure(Error.invalidData))
				}
				completion(.success(items.map{ $0.feedImage }))
				
			case .failure:
				completion(.failure(Error.connectivity))
			}
		}
	}
}

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
