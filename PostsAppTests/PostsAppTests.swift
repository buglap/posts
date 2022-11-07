//
//  PostsAppTests.swift
//  PostsAppTests
//
//  Created by Jenny escobar on 22/11/22.
//

import XCTest
@testable import PostsApp

final class PostsAppTests: XCTestCase {
    private var postListViewModel: PostListViewModel!
    
    override func setUp() async throws {
        self.postListViewModel = PostListViewModel(postFeacher: MockPostRemoteFetcher(), localPostRepository: MockLocalPostRepository())
    }
    
    func test_getLocalPosts_successfully() throws {
        postListViewModel.fetchLocalPost()
        XCTAssertEqual(postListViewModel.localPosts.count, 3)
    }
    
    func test_setup_favorites_in_descending_order() throws {
        postListViewModel.fetchLocalPost()
        postListViewModel.setPostListWithFavorites()
        if let post = postListViewModel.posts.first {
            XCTAssertEqual(post.id, 3)
        } else {
            XCTFail()
        }
    }
    
    func test_delete_all_unfavorite() throws {
        postListViewModel.fetchLocalPost()
        postListViewModel.setPostListWithFavorites()
        postListViewModel.deleteAllUnFavoritePosts()
        XCTAssertEqual(postListViewModel.posts.count, 1)
    }
    
    func test_delete_by_id() throws {
        postListViewModel.fetchLocalPost()
        postListViewModel.setPostListWithFavorites()
        postListViewModel.deletePost(postToDelete: PostViewModel(id: 1, isFavorite: false))
        XCTAssertEqual(postListViewModel.posts.count, 2)
    }

}
