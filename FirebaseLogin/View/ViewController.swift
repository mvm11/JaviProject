import UIKit
import FirebaseAuth

class ViewController: UIViewController, UIWindowSceneDelegate {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var window: UIWindow?
    var user = User(email: "", password: "")
    var activityIndicator:UIActivityIndicatorView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setActivityIndicator()
        startButton.isEnabled = false
    }
    
    func setDelegates()->Void {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func setActivityIndicator()->Void{
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
        self.view.addSubview(activityIndicator)
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
    
    
    
    fileprivate func showErrorMessage(_ errorMessage : String) {
        let alertController = UIAlertController(title: "UPS!", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func navegateToNextController(id: String){
        performSegue(withIdentifier: id, sender: self)
    }
    
    
    fileprivate func validateUserLogin(_ error: Error?, _ result: AuthDataResult?) {
        switch error {
        case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
            self.displayActivityIndicatorView()
            self.showErrorMessage("Contraseña incorrecta")
            self.hideActivityIndicatorView()
        case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:
            self.displayActivityIndicatorView()
            self.showErrorMessage("Correo incorrecto")
            self.hideActivityIndicatorView()
        case .some(let error):
            self.displayActivityIndicatorView()
            self.showErrorMessage("Login error: \(error.localizedDescription)")
            self.hideActivityIndicatorView()
        case .none:
            if (result?.user) != nil {
                self.hideActivityIndicatorView()
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController; self.present(nextViewController, animated: true, completion: nil)
                
                //self.navegateToNextController(id: "goToHomeViewController")
            }
        }
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password){(result, error) in
                self.displayActivityIndicatorView()
                self.validateUserLogin(error, result)
            }
        }
    }
    

    fileprivate func validateFields() -> Bool {
            return (passwordTextField.text!.count >= 8) && (isValidEmail(emailTextField.text ?? ""))
        }
        

        fileprivate func updateView() {
            if(validateFields()){
                startButton.isEnabled = true
                startButton.tintColor = UIColor.blue
            }else{
                startButton.isEnabled = false
                startButton.tintColor = UIColor.gray
            }
        }

}


func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

//MARK: - Text Field Delegate Methods

extension ViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString
            string: String) -> Bool {
            if textField == self.emailTextField {
                updateView()
            } else if textField == self.passwordTextField {
                updateView()
            }
            return true
        }
    
}

