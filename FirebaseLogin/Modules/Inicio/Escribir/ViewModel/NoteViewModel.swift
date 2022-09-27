import Foundation

class NoteViewModel{
    
    private let userDefaultsKey = "Note"
    var  noteModelList = [NoteModel]()
    
    fileprivate func encodeNoteModelList() -> Data {
        return try! JSONEncoder().encode(noteModelList)
    }
    
    fileprivate func convertJSONToString(_ noteModelJSON: Data) -> String {
        return String(decoding: noteModelJSON, as: UTF8.self)
    }
    
    fileprivate func saveNoteModelString(_ noteModelString: String) {
        UserDefaults.standard.set(noteModelString, forKey: userDefaultsKey)
    }
    
    fileprivate func readUserDefaultsNoteModelString() -> String? {
        return UserDefaults.standard.string(forKey: userDefaultsKey)
    }
    
    
    fileprivate func convertStringToJSON(_ noteModelString: String) -> Data {
        return noteModelString.data(using: .utf8)!
    }
    
    
    func addNotes(data: [NoteModel]) {
        noteModelList = readNotes()!
        noteModelList.append(data[0])
        let noteModelJSON : Data = encodeNoteModelList()
        let noteModelString = convertJSONToString(noteModelJSON)
        saveNoteModelString(noteModelString)
    }
    
    fileprivate func decodeNoteModelList(_ jsonData: Data) -> [NoteModel] {
        return try! JSONDecoder().decode([NoteModel].self, from: jsonData)
    }
    
    func readNotes() -> [NoteModel]? {
        guard let noteModelString : String = readUserDefaultsNoteModelString() else {
            return []
        }
        let jsonData : Data = convertStringToJSON(noteModelString)
        let noteModel: [NoteModel] = decodeNoteModelList(jsonData)
        
        return noteModel
    }
    
    func countData() -> Int? {
           if let data = readNotes() {
               return data.count
           }
           return 0
    }
       
       func returnData() -> [NoteModel]? {
           if let items = readNotes() {
               return items
           }
           return [NoteModel]()
    }
}

