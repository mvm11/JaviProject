
import UIKit

class CustomMovieViewCell: UITableViewCell{
   
    
    
    @IBOutlet weak var movieImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.movieImage.layer.cornerRadius = self.frame.height / 8.0
        self.movieImage.layer.masksToBounds = true
        
    }
    
}
