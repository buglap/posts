//
//  PostFetcher.swift
//  PostsApp
//
//  Created by Jenny escobar on 7/11/22.
//

import Foundation
import Combine

protocol PostFetchable {
    func postList() -> AnyPublisher<[PostResponse], APIError>
    func postComments(postID: Int) -> AnyPublisher<[CommentResponse], APIError>
}

class PostFetcher {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension PostFetcher: PostFetchable {
    func postComments(postID: Int) -> AnyPublisher<[CommentResponse], APIError> {
        return getData(with: getPostCommentsComponents(postID: postID))
    }
    
    func postList() -> AnyPublisher<[PostResponse], APIError> {
        return getData(with: getPostListComponents())
    }
    
    private func getData<T>(
      with components: URLComponents
    ) -> AnyPublisher<T, APIError> where T: Decodable {
      guard let url = components.url else {
        let error = APIError.network(description: "Couldn't create URL")
        return Fail(error: error).eraseToAnyPublisher()
      }
      return session.dataTaskPublisher(for: URLRequest(url: url))
        .mapError { error in
          .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
          decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}


// MARK: - PostAPI
private extension PostFetcher {
    struct PostAPI {
        static let scheme = "https"
        static let host = "jsonplaceholder.typicode.com"
        static let path = "/posts"
    }
    
    func getPostListComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = PostAPI.scheme
        components.host = PostAPI.host
        components.path = PostAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components
    }
    func getPostCommentsComponents(postID: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = PostAPI.scheme
        components.host = PostAPI.host
        components.path = PostAPI.path + "/\(postID)/comments"
        
        components.queryItems = [
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components
    }
    
}
