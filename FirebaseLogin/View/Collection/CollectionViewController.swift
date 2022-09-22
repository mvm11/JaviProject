
import UIKit
import WebKit

class CollectionViewController: UIViewController {
  
    var numberOfItemsPerRow:Int = 4
    var characters = [Model]()
    
    @IBOutlet weak var uiSlider: UISlider!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        super.viewDidLoad()
        parseJSON(){result in
            self.characters = result
            self.collectionView.reloadData()
        }
        self.tabBarController?.tabBar.isHidden = true
        collectionView?.collectionViewLayout.invalidateLayout()
        let duration: TimeInterval = 0.3
        UIView.animate(withDuration: duration, animations: {
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
        
    }
    
    func configureSlider() {
        uiSlider.center = self.view.center
        // minimum number of rows required
        uiSlider.minimumValue = 1
        // maximum number of rows required
        uiSlider.maximumValue = 3
        uiSlider.isContinuous = true
        uiSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(uiSlider)
        numberOfItemsPerRow = Int(uiSlider.value)
    }
    
    @objc func sliderValueChanged(_ sender:UISlider!) {
            self.collectionView.performBatchUpdates {
            self.collectionView.reloadData()
        }
    
    }
    
    func parseJSON(completion: @escaping([Model])-> Void) {
        guard let path = Bundle.main.url(forResource: "api", withExtension: "json")else{
            fatalError("Could not find json file")}
        
        guard let dataJson = try? Data(contentsOf: path)else{
            fatalError("Could not convert data")
        }
        
        let decoder = JSONDecoder()
        guard let characters = try? decoder.decode([Model].self, from: dataJson)else{
            fatalError("There was a problem decoding the data")
        }
        completion(characters)
     
    }

}
extension CollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout{
    
   
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
        CustomCollectionViewCell
        let character:Model?
        character = characters[indexPath.row]
        let string = character!.photo
        let url = URL(string: string)
        cell.apiImage.downloaded(from: url!, contentMode: .scaleAspectFit)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1.00, height: 100.0)
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
