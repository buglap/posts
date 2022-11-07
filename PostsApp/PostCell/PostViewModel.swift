//
//  PostViewModel.swift
//  PostsApp
//
//  Created by Jenny escobar on 18/11/22.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    var id: Int
    var title, body: String?
    @Published var isFavorite: Bool
    
    init(id: Int, title: String? = nil, body: String? = nil, isFavorite: Bool) {
        self.id = id
        self.title = title
        self.body = body
        self.isFavorite = isFavorite
    }
    
    func switchFavoriteStatus() {
        isFavorite.toggle()
    }
}
