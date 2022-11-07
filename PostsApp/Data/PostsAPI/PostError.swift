//
//  PostError.swift
//  PostsApp
//
//  Created by Jenny escobar on 7/11/22.
//

import Foundation

enum APIError: Error {
case network(description: String)
case parsing(description: String)
}
