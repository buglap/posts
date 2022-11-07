//
//  LocalPostRepository.swift
//  PostsApp
//
//  Created by Jenny escobar on 28/11/22.
//

import Foundation
import Combine
import CoreData

protocol LocalPostRepository {
    func fetchPosts(success: @escaping([PostViewModel]) -> Void, failure: @escaping (String) -> Void)
    func savePost(postToAdd: PostViewModel, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void)
    func deletePostByID(postId: Int, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void)
    func deletePostByStatus(status: Bool, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void)
}

class LocalPostRepositoryImplementation: LocalPostRepository {
    let coreDataStore: CoreDataStoring!
    private var disposables = Set<AnyCancellable>()
    
    init(coreDataStore: CoreDataStoring = CoreDataStore(name: "PostsData", in: .persistent)) {
        self.coreDataStore = coreDataStore
    }
    
    func fetchPosts(success: @escaping([PostViewModel]) -> Void, failure: @escaping (String) -> Void) {
        let request = NSFetchRequest<Post>(entityName: Post.entityName)
        coreDataStore.publisher(fetch: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    failure(error.localizedDescription)
                }
            } receiveValue: { posts in
                let result = posts.map { post in
                    PostViewModel(id: Int(post.id), title: post.title, body: post.body, isFavorite: post.isFavorite)
                }
                success(result)
            }
            .store(in: &disposables)
    }
    
    func savePost(postToAdd: PostViewModel, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        let action: Action = {
            let post: Post = self.coreDataStore.createEntity()
            post.isFavorite = postToAdd.isFavorite
            post.title = postToAdd.title
            post.body = postToAdd.body
            post.id = Int32(postToAdd.id)
        }
        coreDataStore.publisher(save: action)
            .sink { completion in
                if case .failure(let error) = completion {
                    failure(error.localizedDescription)
                }
            } receiveValue: { _ in
                success(true)
            }
            .store(in: &disposables)
    }
    
    func deletePostByID(postId: Int, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Post.entityName)
        request.predicate = NSPredicate(format: "id == %@",  NSNumber(value: postId))
        coreDataStore.publisher(delete: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    failure(error.localizedDescription)
                }
            } receiveValue: {_ in
                success(true)
            }
            .store(in: &disposables)
    }
    
    func deletePostByStatus(status: Bool, success: @escaping(Bool) -> Void, failure: @escaping (String) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Post.entityName)
        request.predicate = NSPredicate(format: "isFavorite == %@", status)
        coreDataStore
            .publisher(delete: request)
            .sink { completion in
                if case .failure(let error) = completion {
                    failure(error.localizedDescription)
                }
            } receiveValue: {_ in
                success(true)
            }
            .store(in: &disposables)
    }
    
}
