import Foundation
import FirebaseAuth

class AuthViewModel {
    var delegate: AuthViewModelDelegate?
    var user : User? = User(email: "", password: "")
    
    func checkCredentials(user: User) {
        Auth.auth().signIn(withEmail: user.email, password: user.password){(result, error) in
           switch error {
           case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:

                   self.delegate?.showError("Contraseña incorrecta")
                   self.delegate?.hideActivityIndicator()
           case .some(let error as NSError) where error.code == AuthErrorCode.userNotFound.rawValue:

                   self.delegate?.showError("Correo incorrecto")
                   self.delegate?.hideActivityIndicator()
                    
           case .some(let error):

                   self.delegate?.showError("Login error: \(error.localizedDescription)")
                   self.delegate?.hideActivityIndicator()

           case .none:
               if (result?.user) != nil {
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController")
                   self.delegate?.navigateToHomeViewController(homeViewController)
                   self.delegate?.hideActivityIndicator()
               }
           }
       }
   }
}
