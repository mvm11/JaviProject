import Foundation
import FirebaseAuth

class AuthViewModel {
   var delegate: ViewModelDelegate?
    
    func checkCredentials(email: String, password: String) {
       Auth.auth().signIn(withEmail: email, password: password){(result, error) in
           switch error {
           case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:

                   self.delegate?.showError(message: "Contraseña incorrecta")
                   
           case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:

                   self.delegate?.showError(message: "Correo incorrecto")


           case .some(let error):

                   self.delegate?.showError(message: "Login error: \(error.localizedDescription)")



           case .none:
               if (result?.user) != nil {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController")
                   //navigateToHomeViewController(homeViewController)
               }
           }
       }
   }
}
