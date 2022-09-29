import UIKit

class DetailMovieViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    
    var detailMovieViewModel : DetailMovieViewModel = DetailMovieViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitle.text = detailMovieViewModel.movie?.originalTitle
        movieRate.text? =
        String(detailMovieViewModel.movie?.voteAverage ?? 0.0)
        
        movieDescription.text = detailMovieViewModel.movie?.overview
        
        let movieImageURL = "https://image.tmdb.org/t/p/w500/" + (detailMovieViewModel.movie?.posterPath)!
        movieImage.downloaded(from: movieImageURL)
        movieImage.layer.cornerRadius = 30.2
        movieImage.clipsToBounds = true
        
        
    }

}
