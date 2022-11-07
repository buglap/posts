//
//  Responses.swift
//  PostsApp
//
//  Created by Jenny escobar on 7/11/22.
//

import Foundation

// MARK: - Post
struct PostResponse: Codable {
    let id: Int
    let title, body: String?
}

struct CommentResponse: Codable {
    let postId, id: Int
    let name, email, body: String?
}
