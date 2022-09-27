import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var noteDescription: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    private var noteViewModel = NoteViewModel()
    private var notes = [NoteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isEnabled = false
        setDelegates()
        readUserDefaults()
        
        notes = noteViewModel.returnData() ?? [NoteModel]()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteTableView.reloadData()

    }
    
    //MARK: - Delegates
      private func setDelegates() {
          noteTitle.delegate = self
          noteDescription.delegate = self
          noteTableView.delegate = self
          noteTableView.dataSource = self
    }
    
    fileprivate func readUserDefaults() {
        if let data = UserDefaults.standard.object(forKey: "Note") as? [NoteModel]{
            noteViewModel.noteModelList = data
        }
    }
    
    @IBAction func addNote(_ sender: Any) {
        if let title = noteTitle.text, let description = noteDescription.text{
           let note = NoteModel(noteTitle: title, noteDescription: description)
            noteViewModel.addNotes(data: [note])
            noteTableView.reloadData()
            print("Nota agregada")
        }
    }
    
    fileprivate func validateFields() -> Bool {
        return ((!noteTitle.text!.isEmpty) && (!noteDescription.text!.isEmpty))
        }
    
    fileprivate func updateView() {
        if(validateFields()){
            addButton.isEnabled = true
        }else{
            addButton.isEnabled = false
        }
    }
    
}

extension NoteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteViewModel.countData()!
    }
    
    func setTableViewCellStyle(cell: NoteTableViewCell)->Void{
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! NoteTableViewCell
        let note = noteViewModel.readNotes()![indexPath.row]
        
        cell.noteTitle?.text = note.noteTitle
        cell.noteDescription?.text = note.noteDescription
        return cell
    }
}
//MARK: - Text Field Delegate Methods

extension NoteViewController : UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == self.noteTitle {
            updateView()
        }else if textField == self.noteDescription {
            updateView()
        }
        return true
    }
}


