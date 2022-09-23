import UIKit
import Alamofire

class InicioViewController: UIViewController {

    
    @IBOutlet weak var moviesUITableView: UITableView!
    @IBOutlet weak var uiNavigationItem: UINavigationItem!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var movieUITableView: UITableView!
    
    private var moviesViewModel : MoviesListViewModel!
    
    override func viewDidLoad() {
        moviesUITableView.register(UINib(nibName: "CustomMovieViewCell", bundle: nil), forCellReuseIdentifier: "movieCell")
        super.viewDidLoad()
        setImageAttributes()
        movieUITableView.delegate = self
        movieUITableView.dataSource = self
        getData()
        
        
    }
    
    func getData() {
        let url = "https://api.themoviedb.org/3/movie/popular?api_key=bd7847090fea4f76f5ce0c22bd1a85b8&language=en-US&page="
        
        let service = WebService(baseUrl: url)
        
        service.downloadMovies(endPoint: "1") { movies in
        if let movies = movies {
            self.moviesViewModel = MoviesListViewModel(moviesList: movies)
        }
            DispatchQueue.main.async {
                self.movieUITableView.reloadData()
                }
            }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }

    fileprivate func setImageAttributes() {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
    }
    
}

extension InicioViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesViewModel == nil ? 0 : self.moviesViewModel.numberOfRowInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! CustomMovieViewCell
                
                let moviesListViewModel = self.moviesViewModel.moviesAtIndex(indexPath.row)
                
                WebService(baseUrl: "https://image.tmdb.org/t/p/w500").downloadImages(endPoint: moviesListViewModel.images!) { image in
                    
                    cell.movieImage.image = image
                    
                }
                return cell
    }

    
}

