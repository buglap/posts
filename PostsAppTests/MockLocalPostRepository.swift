//
//  MockLocalPostRepository.swift
//  PostsAppTests
//
//  Created by Jenny escobar on 28/11/22.
//

import Foundation
@testable import PostsApp

class MockLocalPostRepository: LocalPostRepository {
    var isSuccess: Bool = true
    func fetchPosts(success: @escaping([PostViewModel]) -> Void, failure: @escaping (String) -> Void) {
        if isSuccess {
            success([PostViewModel(id: 1, isFavorite: false), PostViewModel(id: 2, isFavorite: false), PostViewModel(id: 3, isFavorite: true)])
        } else {
            failure("")
        }
    }
    
    func savePost(postToAdd: PostViewModel, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        if isSuccess {
            success(true)
        } else {
            failure("")
        }
    }
    
    func deletePostByID(postId: Int, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        if isSuccess {
            success(true)
        } else {
            failure("")
        }
    }
    
    func deletePostByStatus(status: Bool, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        if isSuccess {
            success(true)
        } else {
            failure("")
        }
    }
}
