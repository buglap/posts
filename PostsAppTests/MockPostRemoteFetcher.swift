//
//  MockPostRemoteFetcher.swift
//  PostsAppTests
//
//  Created by Jenny escobar on 28/11/22.
//

import Foundation
import Combine
@testable import PostsApp

class MockPostRemoteFetcher: PostFetchable {
    func postList() -> AnyPublisher<[PostResponse], APIError> {
        return Just([PostResponse]())
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
    
    func postComments(postID: Int) -> AnyPublisher<[CommentResponse], APIError> {
        return Just([CommentResponse]())
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
