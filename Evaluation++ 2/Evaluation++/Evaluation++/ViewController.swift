//:::
import UIKit
//:
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    //:
    @IBOutlet weak var student_name_field: UITextField!
    @IBOutlet weak var student_name_tableview: UITableView!
    //:
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    //:
    let userDefaultsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    //:
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
    }
    //:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentGrades.count
    }
    //:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = [studentName](studentGrades.keys)[indexPath.row]
        return cell
    }
    //:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = [studentName](studentGrades.keys)[indexPath.row]
        userDefaultsObj.setKey(theValue: name as AnyObject, theKey: "name")
        performSegue(withIdentifier: "seg", sender: nil)
    }
    //:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[name] = nil
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    //: Pour cacher le clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //:
    func loadUserDefaults() {
        if userDefaultsObj.doesKeyExist(theKey: "grades") {
            studentGrades = userDefaultsObj.getValue(theKey: "grades") as! [studentName: [course: grade]]
        } else {
            studentGrades = [studentName: [course: grade]]()
        }
    }
    //:
    @IBAction func addStudent(_ sender: UIButton) {
        if student_name_field.text != "" {
            studentGrades[student_name_field.text!] = [course: grade]()
            student_name_field.text = ""
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            student_name_tableview.reloadData()
        }
    }
    //:
}
//:::
