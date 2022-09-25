import UIKit
import AVFoundation

class GalleryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        imagePicker.delegate = self

        
        
    }
    
    private func showAlert() {

            let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                self.imagePicker.sourceType = .camera
            }))
            alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                self.imagePicker.sourceType = .photoLibrary
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        }
    


    @IBAction func selectPhoto(_ sender: Any) {
        let uiImagePickerController = UIImagePickerController()
        uiImagePickerController.sourceType = .photoLibrary
        uiImagePickerController.delegate = self
        uiImagePickerController.allowsEditing = true
        present(uiImagePickerController, animated: true)
    }
    
}

extension GalleryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
