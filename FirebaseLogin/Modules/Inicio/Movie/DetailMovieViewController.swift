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
        String(detailMovieViewModel.movie?.popularity ?? 0.0)
        
        movieDescription.text = detailMovieViewModel.movie?.overview
        
        
    }

}
