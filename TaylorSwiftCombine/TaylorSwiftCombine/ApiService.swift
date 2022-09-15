//
//  ApiService.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//


import Foundation
import Combine

// Error enum
enum APIError: Error {
    case networkError(description: String)
    case responseError(description: String)
    case unknownError(description: String)
}

class APIService: ObservableObject {
    @Published var response = [Music]()
    @Published var errorMessage: String?
    
    private var publisherRequest: Cancellable? {
        didSet {oldValue?.cancel() }
    }
    
    // Deallocate with cancel the subscription and release the memory
    deinit {
        publisherRequest?.cancel()
    }
    
    // Load the star wars planets form the swapi
    func loadFeed() -> AnyPublisher<[Music], Error> {
        let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url!)
            .retry(2) // If request fail for any circumstance, Retry 3 times
            .mapError { error -> Error in
                // Handle Network errors
                switch error {
                case URLError.cannotFindHost:
                    return APIError.networkError(description: error.localizedDescription)
                default:
                    return APIError.unknownError(description: error.localizedDescription)
                }
            }
            .map{ $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map{ $0.results } // Map PlanetResponse results
            .mapError { error -> Error in
                // Handle JSONDecode errors
                switch error {
                case DecodingError.keyNotFound, DecodingError.typeMismatch:
                    return APIError.responseError(description: error.localizedDescription)
                default:
                    return APIError.unknownError(description: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
        
        self.publisherRequest = publisher.receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                    switch value {
                    case .finished:
                        print("API Fetch Done.");
                    case .failure(let error):
                        print(error);
                        self.errorMessage = error.localizedDescription;
                    }
            }, receiveValue: {data in
                self.response = data; // Set the array of planets to the response
            })
        
        return publisher;
    }
}
