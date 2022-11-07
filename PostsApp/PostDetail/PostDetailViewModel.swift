//
//  PostDetailViewModel.swift
//  PostsApp
//
//  Created by Jenny escobar on 14/11/22.
//

import Foundation
import Combine


class PostDetailViewModel: ObservableObject {
    private let postFeacher: PostFetchable
    private var disposables = Set<AnyCancellable>()
    private var post: PostViewModel
    @Published var comments: [CommentResponse] = []
    
    init(post: PostViewModel, postFeacher: PostFetchable = PostFetcher()) {
        self.postFeacher = postFeacher
        self.post = post
        fechPostComments(postID: post.id)
    }
    
    func fechPostComments(postID: Int) {
        comments = []
        postFeacher.postComments(postID: postID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.comments = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.comments = data
            }).store(in: &disposables)
    }
}
