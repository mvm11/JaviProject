import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteCollectionView: UICollectionView!
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
        noteCollectionView.reloadData()

    }
    
    //MARK: - Delegates
      private func setDelegates() {
          noteTitle.delegate = self
          noteDescription.delegate = self
          noteCollectionView.delegate = self
          noteCollectionView.dataSource = self
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
            noteCollectionView.reloadData()
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

extension NoteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteViewModel.countData()!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = noteCollectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath) as! NoteCollectionViewCell
        let note = noteViewModel.readNotes()![indexPath.row]
        
        cell.noteTitle?.text = note.noteTitle
        cell.noteDescription?.text = note.noteDescription
        
  
        cell.noteView.layer.cornerRadius = 10

       
        

        

        // add shadow on cell
        cell.contentView.backgroundColor = .clear // very important
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowOpacity = 0.25
        cell.contentView.layer.shadowRadius = 5
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.contentView.layer.shadowColor = UIColor.black.cgColor

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


