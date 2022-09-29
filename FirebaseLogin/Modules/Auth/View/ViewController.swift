import UIKit
import FirebaseAuth

//MARK: - @ protocols

protocol AuthViewModelDelegate {
    func showError(_ message: String)
    func hideActivityIndicator()
    func navigateToHomeViewController(_ homeViewController: UIViewController)
}

class ViewController: UIViewController {
    
    //MARK: - @IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - @ Variables
    
    var activityIndicator:UIActivityIndicatorView!
    var authViewModel : AuthViewModel = AuthViewModel()
   
    //MARK: - @ Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//            if Auth.auth().currentUser != nil {
//                let homeViewController = self.storyboard!.instantiateViewController(identifier: "HomeViewController")
//                self.navigateToHomeViewController(homeViewController)
//            }
    }
    
    fileprivate func setupUI() {
        setActivityIndicator()
        startButton.isEnabled = false
    }
    
    func setDelegates()->Void {
        authViewModel.delegate = self
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
    
    @IBAction func startButtonAction(_ sender: Any) {
        self.displayActivityIndicatorView()
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        self.authViewModel.user?.email = email
        self.authViewModel.user?.password = password
        
        self.authViewModel.checkCredentials(user: self.authViewModel.user!)
            
    }
    
    fileprivate func validateFields() -> Bool {
            return (passwordTextField.text!.count >= 8) && (isValidEmail(emailTextField.text ?? ""))
        }
        

        fileprivate func updateView() {
            if(validateFields()){
                startButton.isEnabled = true
            }else{
                startButton.isEnabled = false
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

//MARK: - @ AuthViewModel Delegate Methods

extension ViewController : AuthViewModelDelegate{
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if !self.activityIndicator.isHidden{
               DispatchQueue.main.async {
                   self.view.isUserInteractionEnabled = true
                   self.activityIndicator.stopAnimating()
                   self.activityIndicator.isHidden = true

               }
           }
        }
    }
    
    func navigateToHomeViewController(_ homeViewController: UIViewController) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(homeViewController)
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "UPS!", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

