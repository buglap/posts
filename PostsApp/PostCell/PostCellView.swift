//
//  PostCellView.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import SwiftUI

struct PostCellView: View {
    @ObservedObject var post: PostViewModel
    var didTapPost: ((PostViewModel) -> Void)?
    var didTapFavorite: ((PostViewModel) -> Void)?
    var didTapDelete: ((PostViewModel) -> Void)?
    var buttonSize: CGFloat = 25
    var font: String = "AmericanTypewriter"
    
    init(post: PostViewModel, didTapPost: ((PostViewModel) -> Void)? = nil, didTapFavorite: ((PostViewModel) -> Void)? = nil,
         didTapDelete: ((PostViewModel) -> Void)? = nil) {
        self.post = post
        self.didTapPost = didTapPost
        self.didTapFavorite = didTapFavorite
        self.didTapDelete = didTapDelete
    }
    
    var body: some View {
        HStack(alignment: .center){
            Text(post.title ?? "").font(.custom(font, size: 18)).fixedSize(horizontal: false, vertical: true)
            Spacer()
            FavoriteView(isFavorite: Binding(get: { post.isFavorite }, set: {_ in }), size: buttonSize).onTapGesture {
                post.switchFavoriteStatus()
                self.didTapFavorite?(post)
            }
            Button(role: .destructive) {
                didTapDelete?(post)
            } label: {
                Image(systemName:"trash.fill").resizable().frame(width: buttonSize, height: buttonSize)
            }
        }.padding(.horizontal, 15).onTapGesture {
            didTapPost?(post)
        }
    }
}

struct PostCellView_Previews: PreviewProvider {
    static var previews: some View {
        PostCellView(post: PostViewModel(id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto", isFavorite: false))
    }
}
