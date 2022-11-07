//
//  CommentView.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import SwiftUI

struct CommentView: View {
    var comment: CommentResponse
    var font: String = "AmericanTypewriter"
    var body: some View {
        VStack(alignment: .leading) {
            Text(comment.name ?? "").font(.custom(font, size: 23)).foregroundColor(.cyan)
            Text(comment.email ?? "").font(.custom(font, size: 20)).foregroundColor(.gray)
            Text(comment.body ?? "").font(.custom(font, size: 18))
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(comment: CommentResponse(postId: 1, id: 1, name: "id labore ex et quam laborum", email: "Eliseo@gardner.biz", body: "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"))
    }
}
