
import UIKit
import WebKit

class CollectionViewController: UIViewController {
  
    //var characters = [Character]()
    var collectionViewModel : CollectionViewModel = CollectionViewModel()
    
    @IBOutlet weak var uiSlider: UISlider!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        configureDelegates()
        configureSlider()
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.collectionViewModel.loadCharacters(completion: {
            self.collectionView.reloadData()
        })
    
        self.navigationController?.navigationBar.prefersLargeTitles = false
       
    }
        
    
    func configureDelegates(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func configureSlider() {
            // minimum number of rows required
            uiSlider.minimumValue = 1
            // maximum number of rows required
            uiSlider.maximumValue = 4
            uiSlider.value = 1
            uiSlider.isContinuous = true
            uiSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            self.view.addSubview(uiSlider)
    }
    
    @objc func sliderValueChanged(_ sender:UISlider!) {
            self.collectionView.performBatchUpdates {
            self.collectionView.reloadData()
        }
    
    }
    
    
    @IBAction func updateCell(_ sender: Any) {
       
    }

}
extension CollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewModel.characters.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
        CustomCollectionViewCell
        let character:Character?
        character = collectionViewModel.characters[indexPath.row]
        let string = character!.photo
        let url = URL(string: string)
        cell.apiImage.downloaded(from: url!, contentMode: .scaleAspectFit)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width)/CGFloat(uiSlider.value)
        return CGSize(width: width, height: width)
    }
    
}
    extension UIImageView {
        func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }
