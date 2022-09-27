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
        setActivityIndicator()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        displayActivityIndicatorView()
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setActivityIndicator()->Void{
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
    }
    
    
    func getData() {
        displayActivityIndicatorView()
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=bd7847090fea4f76f5ce0c22bd1a85b8&language=en-US&page="
        
        let service = MovieManager(baseUrl: url)
        
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

    
  

    fileprivate func setImageAttributes() {
        image.layer.borderWidth = 0.05
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
    func displayActivityIndicatorView() -> () {
        self.view.isUserInteractionEnabled = false
        self.view.bringSubviewToFront(self.activityIndicator)
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
      }

       func hideActivityIndicatorView() -> () {
         if !self.activityIndicator.isHidden{
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true

            }
        }
      }
}

extension InicioViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesViewModel == nil ? 0 : self.moviesViewModel.numberOfRowInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        
        let moviesListViewModel = self.moviesViewModel.moviesAtIndex(indexPath.row)
        
        MovieManager(baseUrl: "https://image.tmdb.org/t/p/w500").downloadImages(endPoint: moviesListViewModel.images!) { image in
            cell.movieImage.clipsToBounds = true
            cell.movieImage.layer.cornerRadius = 0.2*cell.movieImage.frame.width
            cell.movieImage.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                return CGSize(width: 159, height: 223)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
            
        }
}
