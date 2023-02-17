//
//  ApiService.swift
//  TaylorSwiftCombine
//
//  Created by Jerrick Warren on 9/15/22.
//


import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var response = [Music]()
    @Published var errorMessage: String?
    
    let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song")
    
    private var publisherRequest: Cancellable? {
        didSet {oldValue?.cancel() }
    }
    
    // Deallocate with cancel the subscription and release the memory
    deinit {
        publisherRequest?.cancel()
    }
    
    // Load the itunes music from Service
    func loadFeed() -> AnyPublisher<[Music], Error> {
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url!)
            .map{ $0.data }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map{ $0.results } // Map Music results
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
                self.response = data; // Set the array of music to the response
            })
        
        return publisher;
    }
}
