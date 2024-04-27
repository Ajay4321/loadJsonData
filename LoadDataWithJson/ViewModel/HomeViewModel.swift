//
//  HomeViewModel.swift
//  LoadDataWithJson
//
//  Created by Ajay Awasthi on 27/04/24.
//

import Foundation

final class HomeViewModel {
    
    private var postList: [Post] = []
    private let apiService: ApiService
    var posts: [Post] = []
    var currentPage = 1
    let limit = 20
    var isLoading = false
    private var hasMoreData = true
    
    init(apiService: ApiService = ApiService()) {
        self.apiService = apiService
    }
    
    func loadData(completion: @escaping (Error?) -> Void) {
        guard !isLoading && hasMoreData else { return }
        isLoading = true
        
        Task {
               do {
                   let newPosts = try await apiService.fetchPosts(page: currentPage, limit: limit)
                   if newPosts.isEmpty {
                       hasMoreData = false
                   } else {
                       self.posts.append(contentsOf: newPosts)
                       currentPage += 1
                   }
                   isLoading = false
                   DispatchQueue.main.async {
                       completion(nil)
                   }
               } catch {
                   isLoading = false
                   DispatchQueue.main.async {
                       completion(error)
                   }
               }
           }
    }
    
    func getPostCount() -> Int {
        return posts.count
    }
    
    func getPost(at index: Int) -> Post {
        return posts[index]
    }
    
}
