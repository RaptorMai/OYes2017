
import UIKit

class DisplayNameTableViewController: UITableViewController {

    var displayName:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notification Display Name"
        self.tableView.register(UINib(nibName: "TextfieldTableViewCell", bundle: nil), forCellReuseIdentifier: "textfieldCell")
       
        NotificationCenter.default.addObserver(self, selector: #selector(DisplayNameTableViewController.reloadData), name: NSNotification.Name(rawValue: "kNotification_displayNameUpdated"), object: nil)
        
        // keyboard dismiss interactively
        self.tableView.keyboardDismissMode = .interactive
        
        
    }

    func reloadData() {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TextfieldTableViewCell = tableView.dequeueReusableCell(withIdentifier: "textfieldCell", for: indexPath) as! TextfieldTableViewCell
        cell.textfield.text = displayName
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
