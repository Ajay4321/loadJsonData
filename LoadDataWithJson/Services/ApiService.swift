//
//  ApiService.swift
//  LoadDataWithJson
//
//  Created by Ajay Awasthi on 27/04/24.
//

import Foundation

final class ApiService{
    static let baseUrl = "https://jsonplaceholder.typicode.com"

    private enum EndPoint{
        case PostList(page: Int, limit: Int)
        
        var path: String{
            switch self {
            case .PostList(let page, let limit):
                return "posts?_page=\(page)&_limit=\(limit)"
            }
        }
        
        var url: String {
               return "\(baseUrl)/\(path)"
           }
    }
    
    // Function to fetch posts with pagination
    func fetchPosts(page: Int, limit: Int) async throws -> [Post] {
        guard Reachability.isConnectedToNetwork(),
              let url = URL(string: EndPoint.PostList(page: page, limit: limit).url) else {
                  throw CustomError.noConnection
              }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    }

}
