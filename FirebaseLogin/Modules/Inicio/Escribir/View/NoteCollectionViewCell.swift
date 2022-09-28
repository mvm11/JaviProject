import Foundation
import UIKit

class NoteCollectionViewCell: UICollectionViewCell{
    
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteDescription: UILabel!
    @IBOutlet weak var noteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
