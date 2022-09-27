import Foundation

class NoteViewModel{
    
    
    
    private let userDefaultsKey = "Note"
    var  noteModelList = [NoteModel]()
    
    fileprivate func addNoteData()->Void {
        if let newData = try? JSONEncoder().encode(noteModelList) {
            UserDefaults.standard.set(newData, forKey: userDefaultsKey)
        }
    }
    
    func addNotes(data: [NoteModel]) {
        noteModelList = readNotes()!
        noteModelList.append(data[0])
    
        !noteModelList.isEmpty ? addNoteData() : addNoteData()
    }
    
    func readNotes() -> [NoteModel]? {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey), let savedItems = try? JSONDecoder().decode([NoteModel].self, from: data) else { return [NoteModel]() }
            return savedItems
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
