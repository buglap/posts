//
//  PostDetailView.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import SwiftUI

struct PostDetailView: View {
    var post: PostViewModel
    @ObservedObject private var postDetailViewModel: PostDetailViewModel
    var font: String = "AmericanTypewriter"
    
    init(post: PostViewModel) {
        self.post = post
        self.postDetailViewModel = PostDetailViewModel(post: post)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text(post.title ?? "").frame(width: UIScreen.main.bounds.width*0.35).font(.custom(font, size: 23)).foregroundColor(.orange)
                    Text(post.body ?? "").font(.custom(font, size: 20)).foregroundColor(.gray)
                }
                Text("Comments").opacity(postDetailViewModel.comments.isEmpty ? 0 : 1).font(.custom(font, size: 20)).padding(.top, 20)
            }.padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
            ScrollView {
                ForEach(0..<postDetailViewModel.comments.count, id: \.self) {index in
                    VStack(alignment: .leading) {
                        HStack {
                            CommentView(comment: postDetailViewModel.comments[index]).padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 15))
                        }
                    }
                }
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: PostViewModel(id: 1, title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto", isFavorite: false))
    }
}
