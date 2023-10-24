# Search Algorithms in Swift 🚀

## Overview

This repository is dedicated to the exploration and implementation of search algorithms in Swift. Specifically, this project demonstrates the use of both linear and binary search algorithms. While these algorithms are traditionally showcased with basic data types like integers, we take it a step further by adapting them to work with a custom Users type, emulating the type of data one might handle when dealing with JSON responses from an API.
### This code was constructed in Swift Playground. It might not complie the same way if it was loaded into a project.

## Features

📜 Full Implementation of Linear and Binary Search
🧑 Custom Users type to mimic JSON-like user data
🌐 Networking layer to simulate fetching user data from an API
🛠 Swift Codable for easy serialization and deserialization of user data
📚 Thorough documentation for each algorithm

## Linear Search
A Linear Search is one of the simplest search algorithms. It sequentially checks each element in an array until it finds the element that matches the target value.

Pros: Linear Search is simple to implement and understand. It doesn't require the array to be sorted.

Cons: It's inefficient for large datasets compared to other algorithms like Binary Search.

```Swift
class LinearSearchAlgo {
    func linearSearch(_ array: [Users], target: Users) -> Users? {
        for element in array where element == target {
            return element
        }
        return nil
    }
}

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
```
Output:
```
User found: Users(id: 7, name: "Kurtis Weissnat", username: "Elwyn.Skiles", email: "Telly.Hoeger@billy.biz")
```

