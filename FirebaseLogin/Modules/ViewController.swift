import UIKit
import FirebaseAuth

protocol ViewModelDelegate {
    func showError(message: String)
}

class ViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    var activityIndicator:UIActivityIndicatorView!
    var authViewModel : AuthViewModel = AuthViewModel()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setActivityIndicator()
        startButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//            if Auth.auth().currentUser != nil {
//                let homeViewController = self.storyboard!.instantiateViewController(identifier: "HomeViewController")
//                self.navigateToHomeViewController(homeViewController)
//            }
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
    
    // Crear delegado en view Model
    // Desde esta clase se llaman los delegados del view model
    
    
    fileprivate func showErrorMessage(_ errorMessage : String) {
        let alertController = UIAlertController(title: "UPS!", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func validateUserLogin(_ error: Error?, _ result: AuthDataResult?) {
        switch error {
        case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
            self.showErrorMessage("Contraseña incorrecta")
            self.hideActivityIndicatorView()
        case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:
            self.showErrorMessage("Correo incorrecto")
            self.hideActivityIndicatorView()
        case .some(let error):
            self.showErrorMessage("Login error: \(error.localizedDescription)")
            self.hideActivityIndicatorView()
        case .none:
            if (result?.user) != nil {
                self.hideActivityIndicatorView()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController")
                navigateToHomeViewController(homeViewController)
                
            }
        }
    }
    
    internal func navigateToHomeViewController(_ homeViewController: UIViewController) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeViewController)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        self.displayActivityIndicatorView()
        if let email = emailTextField.text, let password = passwordTextField.text{
                self.authViewModel.checkCredentials(email: email, password: password)
                //self.validateUserLogin(error, result)
                //UserDefaults.standard.set(true, forKey: "sesion")
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

extension ViewController : ViewModelDelegate{
    func showError(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "UPS!", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

