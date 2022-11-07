//
//  FavoriteView.swift
//  PostsApp
//
//  Created by Jenny escobar on 8/11/22.
//

import SwiftUI

struct FavoriteView: View {
    @Binding var isFavorite: Bool
    var favoriteImage: String = "star.fill"
    var unfavoriteImage: String = "star"
    var size: CGFloat = 25
    var favoriteColor: Color = .mint
    var unfavoriteColor: Color = .gray
    var body: some View {
        Image(systemName: isFavorite ? favoriteImage : unfavoriteImage).resizable().frame(width: size, height: size).foregroundColor(isFavorite ? favoriteColor : unfavoriteColor)
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView(isFavorite: .constant(false))
    }
}
