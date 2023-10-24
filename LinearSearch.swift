import UIKit

/// Linear Search:

/// A Linear Search is one of the simplest search algorithms. It sequentially checks each element in an array until it finds the element that matches the target value.

/// Pros: Linear Search is simple to implement and understand. It doesn't require the array to be sorted.

/// Cons: It's inefficient for large datasets compared to other algorithms like Binary Search.


// MARK: - Models

struct Users: Equatable, Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
}

// MARK: - Search Algorithm

class LinearSearchAlgo {
    func linearSearch(_ array: [Users], target: Users) -> Users? {
        for element in array where element == target {
            return element
        }
        return nil
    }
}

// MARK: - API Definitions

protocol API {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
}

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPScheme: String {
    case https
}

enum JSONPlaceholderAPI: API {
    case users
    case albums
    
    var method: String { return "GET" }
    var scheme: HTTPScheme { return .https }
    var baseURL: String { return "jsonplaceholder.typicode.com" }
    var path: String { return self == .users ? "/users" : "/albums" }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL Format"
        case .invalidResponse: return "Data not found"
        }
    }
}

// MARK: - Networking Service

class NetworkingService {
    private class func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        return components
    }
    
    func fetchData<T: Decodable>(from api: API, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = NetworkingService.buildURL(endpoint: api).url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// MARK: - Main Execution

// Declare an array to hold the list of Users
var userList: [Users] = []

// Initialize the LinearSearchAlgo and NetworkingService classes
let linearSearchAlgo = LinearSearchAlgo()
let testNetworking = NetworkingService()

// Assume someUser is the user you're looking for
let someUser = Users(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles", email: "Telly.Hoeger@billy.biz")

// Fetch the data and populate the userList
testNetworking.fetchData(from: JSONPlaceholderAPI.users, responseType: [Users].self) { result in
    switch result {
    case .success(let peopleArray):
        DispatchQueue.main.async {
            userList = peopleArray
            
            // Search for the user using linear search
            if let foundUser = linearSearchAlgo.linearSearch(userList, target: someUser) {
                
                // If found, print the details
                print("User found: \(foundUser)")
                
                // Also, list all user names for demonstration
                for i in peopleArray {
                    print(i.name)
                }
            } else {
                
                // If not found, print a message
                print("User not found")
            }
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}

