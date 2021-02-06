//
//  MovieManager.swift
//  Movie Info
//
//  Created by O’lmasbek Axtamov on 12/6/20.
//  Copyright © 2020 O’lmasbek Axtamov. All rights reserved.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel)
    func didFailWithError(error: Error)
}

struct MovieManager {
    
    let movieURL = "https://www.omdbapi.com/?apikey=b6ec317d"
    
    var delegate: MovieManagerDelegate?
    
    func fetchMovie (movieTitle: String){
        let urlString = "\(movieURL)&t=\(movieTitle)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let movie = self.parseJSON(safeData) {
                        self.delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ movieData : Data) -> MovieModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
 
            let title = decodedData.Title
            let released = decodedData.Released
            let genre = decodedData.Genre
            let desc = decodedData.Plot
            let imageURL = decodedData.Poster
            let imdbID = decodedData.imdbID
            
            let movie = MovieModel(movieName: title, releasedDate: released, genres: genre, description: desc, imgUrl: imageURL, imdbID: imdbID)
            return movie
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
