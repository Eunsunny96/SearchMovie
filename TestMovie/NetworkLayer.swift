//
//  ViewController.swift
//  TestMovie
//
//  Created by sunny h on 2021/08/26.
//

import Foundation

enum MovieAPIType{
  case onlyURL(urlString: String)
  case searchMovie(query: [URLQueryItem])
  
}

enum MovieAPIError: Error{
  case badURL
}

class NetworkLayer{
  

  typealias NetworkCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
  
  func request(type: MovieAPIType, completion: @escaping NetworkCompletion){
    
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    
    do{
      let request = try buildRequest(type: type)
      
      session.dataTask(with: request){ data, response, error in
        print((response as! HTTPURLResponse).statusCode)
        
        completion(data, response, error)
        
      }.resume()
      session.finishTasksAndInvalidate()
    }catch{
      print(error)
    }
    
    
    
  }
  
  private func buildRequest(type: MovieAPIType) throws -> URLRequest{
    switch type{
      case .onlyURL(urlString: let urlString):
        guard let hasURL = URL(string: urlString) else{
          throw MovieAPIError.badURL
        }
        var request = URLRequest(url: hasURL)
        request.httpMethod = "GET"
        return request
        
      case .searchMovie(query: let query):
        var components = URLComponents(string: "https://itunes.apple.com/search")
        components?.queryItems = query
        guard let url = components?.url else{
          throw MovieAPIError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
       
    }
   
  }
  
}








