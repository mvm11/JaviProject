import UIKit
import Alamofire

class InicioViewController: UIViewController {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    @IBOutlet weak var uiNavigationItem: UINavigationItem!
    @IBOutlet weak var image: UIImageView!
    
    private var moviesViewModel : MoviesListViewModel!
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        setImageAttributes()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        getData()
        
    }
    
    
    func getData() {
        displayActivityIndicatorView()
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=bd7847090fea4f76f5ce0c22bd1a85b8&language=en-US&page="
        
        let service = WebService(baseUrl: url)
        
        service.downloadMovies(endPoint: "1") { movies in
        if let movie = movies {
            self.moviesViewModel = MoviesListViewModel(moviesList: movie)
        }
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
                }
            }
        hideActivityIndicatorView()
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }

    fileprivate func setImageAttributes() {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
}

extension InicioViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesViewModel == nil ? 0 : self.moviesViewModel.numberOfRowInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        
        let moviesListViewModel = self.moviesViewModel.moviesAtIndex(indexPath.row)
        
        WebService(baseUrl: "https://image.tmdb.org/t/p/w500").downloadImages(endPoint: moviesListViewModel.images!) { image in
//            cell.movieImage.clipsToBounds = true
//            cell.movieImage.layer.cornerRadius = cell.movieImage.frame.height / 2
            cell.movieImage.contentMode = .scaleAspectFit
            cell.movieImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width)/CGFloat(1.0)
        return CGSize(width: width, height: width)
        
    }
    
}

