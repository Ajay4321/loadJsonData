//
//  Error.swift
//  LoadDataWithJson
//
//  Created by Ajay Awasthi on 27/04/24.
//

import Foundation

enum CustomError {
    case noConnection, noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData: return "Well, weird things happens."
        case .noConnection: return "No Internet Connection."
        }
    }
}
