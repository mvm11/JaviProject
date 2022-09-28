import Alamofire
import AlamofireImage
import Foundation
import UIKit



class MovieManager {
    
    fileprivate var baseUrl = ""
    
    init(baseUrl : String) {
        
        self.baseUrl = baseUrl
        
    }
    
    func downloadMovies(endPoint : String,completion: @escaping ([Result]?)->()) {
            AF.request(self.baseUrl+endPoint).response { response in
                
                if let data = response.data {
                    do {
                        
                        let movieResponse = try JSONDecoder().decode(Welcome.self, from: data)
                        print("Esta es la respuesta de la API")
                        print(movieResponse.results)
                        completion(movieResponse.results)
                        
                    }catch {
                        
                        print("error: \(error)")
                        
                    }
                }
            }
        }
    
    
    func downloadImages(endPoint: String, completion: @escaping (UIImage?)->()) {   AF.request(self.baseUrl+endPoint).responseImage { response in
                if case .success(let image) = response.result {
                    completion(image)
                    print(response)
            }
        }
    }
}
