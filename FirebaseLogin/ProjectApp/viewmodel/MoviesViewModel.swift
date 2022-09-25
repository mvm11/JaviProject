import Foundation
import FirebaseAuth

struct MoviesListViewModel {
   
    var moviesList : [Result]
    
    func numberOfRowInSection() -> Int {
        //return self.moviesList.count
        return 20
    }
    
    func moviesAtIndex(_ index: Int) -> MoviesViewModel {
        let movies = self.moviesList[index]
        return MoviesViewModel(results: movies)
    }
    
    
    
}
struct MoviesViewModel {
    let results : Result
    
    
    var title : String? {
        return self.results.originalTitle
    }
    var overView : String? {
        return self.results.overview
    }
    var images : String? {
        
        return results.posterPath
        
    }
    var releaseDate : String? {
        return self.results.releaseDate
    }
    var avarage : Double? {
        
        return self.results.voteAverage
    }
    
}
