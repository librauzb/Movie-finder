//
//  ViewController.swift
//  Movie Info
//
//  Created by O’lmasbek Axtamov on 12/6/20.
//  Copyright © 2020 O’lmasbek Axtamov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var generalView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var releasedLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var notFoundView: UIView!
    
    @IBOutlet weak var watchBtn: UIButton!
    
    var imdbURL: String?
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        
        searchTextField.delegate = self
        
        watchBtn.layer.cornerRadius = 10
        watchBtn.clipsToBounds = true
        
        searchTextField.becomeFirstResponder()
        
        notFoundView.isHidden = false
        notFoundView.backgroundColor = UIColor(patternImage: UIImage(named: "initial")!)
        
    }

    @IBAction func watchBtnPressed(_ sender: UIButton) {
        
        var url : URL?
        
        if let imdbMovieID = imdbURL{
           url = URL(string: "https://www.imdb.com/title/\(imdbMovieID)/")
            
            let alert = UIAlertController(title: "WATCH THIS MOVIE", message: "Do you want to open this movie on Safari", preferredStyle: .alert)
            let action = UIAlertAction(title: "Open", style: .default) { (action) in
                
                UIApplication.shared.open(url ?? URL(string: "https://www.imdb.com/")!)
                
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
             }))

            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    

    
}

extension ViewController: UITextFieldDelegate{
    
        @IBAction func goBtnPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let movie = searchTextField.text {
            
            let newString = movie.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            
            movieManager.fetchMovie(movieTitle: newString)
            
        }
        
        searchTextField.text = ""
        
    }
    
}

extension ViewController: MovieManagerDelegate{
    
    func didUpdateMovie(_ movieManager: MovieManager, movie: MovieModel) {

            DispatchQueue.main.async {
                
                self.descriptionTextView.text = movie.description
                self.genreLabel.text = movie.genres
                self.releasedLabel.text = movie.releasedDate
                self.titleLabel.text = movie.movieName
                
                let url = movie.imgUrl
                
                self.imdbURL = movie.imdbID
                
                let data = try? Data(contentsOf: url)

                if let imageData = data {
                    self.imageView.image = UIImage(data: imageData)
                } else{
                    self.imageView.image = UIImage(named: "imageNotFound")
                }
                
                self.notFoundView.isHidden = true
                   
            }
        
        }
        
        func didFailWithError(error: Error) {
            self.notFoundView.isHidden = false
            self.notFoundView.backgroundColor = UIColor(patternImage: UIImage(named: "notFound")!)
        }
    
}

    

