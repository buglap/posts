//
//  PostListViewModel.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import Foundation
import Combine
import CoreData


class PostListViewModel {
    private let postFeacher: PostFetchable
    private let localPostRepository: LocalPostRepository
    private var disposables = Set<AnyCancellable>()
    @Published var dataSource: [PostResponse] = []
    @Published var posts: [PostViewModel] = []
    @Published var localPosts: [PostViewModel] = []
    
    init(postFeacher: PostFetchable = PostFetcher(), localPostRepository: LocalPostRepository = LocalPostRepositoryImplementation()) {
        self.postFeacher = postFeacher
        self.localPostRepository = localPostRepository
    }
    
    func fetchPostList() {
        postFeacher.postList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure:
                    self.dataSource = []
                    self.setPostListWithFavorites()
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.dataSource = data
                self.setPostListWithFavorites()
            }).store(in: &disposables)
    }
    
    func fetchLocalPost() {
        localPostRepository.fetchPosts(success: { posts in
            self.localPosts = posts
            self.fetchPostList()
        }, failure: { _ in
            self.fetchPostList()
        })
    }
    
    func setPostListWithFavorites() {
        if !dataSource.isEmpty {
            self.posts =  dataSource.map { post in
                PostViewModel(id: post.id, title: post.title, body: post.body, isFavorite: localPosts.first { $0.id == post.id }?.isFavorite ?? false)
            }
        } else {
            self.posts = localPosts
        }
        self.sortByFavorite()
    }
    
    func savePostList() {
        self.posts.forEach {post in
            savePost(postToAdd: post)
        }
    }
    
    func sortByFavorite() {
        self.posts.sort { $0.isFavorite && !$1.isFavorite }
    }
    
    
    func savePost(postToAdd: PostViewModel) {
        localPostRepository.savePost(postToAdd: postToAdd, success: {_ in
            self.sortByFavorite()
        }, failure: {_ in })
    }
    
    func updatePost(post: PostViewModel) {
        localPostRepository.deletePostByID(postId: post.id, success: {_ in
            self.savePost(postToAdd: post)
        }, failure: {_ in })
    }
    
    func deletePost(postToDelete: PostViewModel) {
        localPostRepository.deletePostByID(postId: postToDelete.id, success: {_ in
            self.posts.removeAll(where: { post in post.id == postToDelete.id })
        }, failure: {_ in })
    }
    
    func deleteAllUnFavoritePosts() {
        localPostRepository.deletePostByStatus(status: false, success: {_ in
            self.posts.removeAll(where: { post in post.isFavorite == false})
        }, failure: {_ in})
    }
}
