//
//  MovieData.swift
//  Movie Info
//
//  Created by O’lmasbek Axtamov on 12/6/20.
//  Copyright © 2020 O’lmasbek Axtamov. All rights reserved.
//

import Foundation

struct MovieData: Codable{
    
    let Title: String
    let Released: String
    let Genre: String
    let Plot: String
    let Poster: URL
    let imdbID: String
    
    
}
