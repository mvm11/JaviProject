import Foundation

struct CollectionManager{
    
    static let shared = CollectionManager()
    
    func requestCharacters(completion: @escaping([Character])-> Void) {
        guard let path = Bundle.main.url(forResource: "api", withExtension: "json")else{
            fatalError("Could not find json file")}
        
        guard let dataJson = try? Data(contentsOf: path)else{
            fatalError("Could not convert data")
        }
        
        let decoder = JSONDecoder()
        guard let characters = try? decoder.decode([Character].self, from: dataJson)else{
            fatalError("There was a problem decoding the data")
        }
        completion(characters)
    }
}
