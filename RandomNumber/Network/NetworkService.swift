//
//  NetworkService.swift
//  RandomNumber
//
//  Created by Alexander Kovalov on 21.11.2022.
//

import Foundation

enum ErrorType: Error {
    case badRequest(String)
    case invalidResponse
    case cantResponse
    
    var describe: String {
        switch self {
        case .badRequest(let text): return text
        case .invalidResponse: return "Invalid response"
        case .cantResponse: return "Can't response"
        }
    }
}

private struct Constant {
    static let host = "http://numbersapi.com/"
}

final class NetworkService {
    
    enum MethodType: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    enum RequestType {
        case search(number: String)
        case random
        
        var path : String {
            switch self {
            case .search(let number): return number
            case .random: return "random/math"
            }
        }
    }
    
    static func networkRequest(methodType: MethodType, requestType: RequestType) async throws -> String {
        
        let url = URL(string: (Constant.host) + requestType.path)!
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = methodType.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ErrorType.invalidResponse
            }
            
            guard let responceText = String(data: data, encoding: .utf8) else {
                    throw ErrorType.cantResponse
            }
            return responceText
        }catch {
            throw ErrorType.badRequest(error.localizedDescription)
        }
        
    }
    
}
