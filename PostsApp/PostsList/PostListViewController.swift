//
//  PostCell.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import UIKit
import SwiftUI
import Combine

class PostListViewController: UIViewController {
    var stackView = UIStackView()
    var scrollView = UIScrollView()
    var removePostButton = UIButton()
    var reloadPostsButton = UIButton()
    private var postListViewModel = PostListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    @objc private let deleteAllNoFavoritesButton: UIButton = {
           var configuration = UIButton.Configuration.filled()
           configuration.title = "Remove unfavorites"
           let button = UIButton(type: .system)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.configuration = configuration
           return button
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpDeleteAllButton()
        configureScrollView()
        configureStackView()
        setupPostsBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postListViewModel.fetchLocalPost()
    }
    
    func setupPostsBinding() {
        postListViewModel.$posts.handleEvents(receiveOutput: { [weak self] items in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if !self.postListViewModel.posts.isEmpty {
                    self.stackView.removeAllSubviews()
                    self.postListViewModel.posts.forEach { post in
                        self.stackView.addArrangedSubview(self.getPostCellView(post: post))
                    }
                }
            }
        }).sink { _ in }
            .store(in: &subscriptions)
    }
    
    func setUpDeleteAllButton() {
        deleteAllNoFavoritesButton.addTarget(self, action: #selector(deleteAllNoFavoriteButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(deleteAllNoFavoritesButton)
        NSLayoutConstraint.activate([
            deleteAllNoFavoritesButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
    
    @objc func deleteAllNoFavoriteButtonTapped(_ sender: UIButton?) {
        self.postListViewModel.deleteAllUnFavoritePosts()
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: deleteAllNoFavoritesButton.topAnchor, constant: 50),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, constant: 0),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo:view.trailingAnchor)
        ])
    }
    
    func configureStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        setStackViewConstrains()
    }
    
    func getPostCellView(post: PostViewModel) -> UIView {
        let postCell = UIHostingController(rootView:  PostCellView(post: post, didTapPost:  { post in
            self.showPostDetailView(post: post)
        }, didTapFavorite: { post in
            self.postListViewModel.updatePost(post: post)
        }, didTapDelete: { post in
            self.postListViewModel.deletePost(postToDelete: post)
        }))
        return postCell.view
    }
    
    func showPostDetailView(post: PostViewModel) {
        let detailView = UIHostingController(rootView: PostDetailView(post: post))
        self.present(detailView, animated: true)
    }
    
    func setStackViewConstrains() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

#if DEBUG
struct PreviewViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            PostListViewController()
        }
    }
}
#endif
