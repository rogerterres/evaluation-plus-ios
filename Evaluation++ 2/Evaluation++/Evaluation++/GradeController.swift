//:::
import UIKit
//:
class GradeController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    //:
    @IBOutlet weak var student_name_label: UILabel!
    //:
    @IBOutlet weak var course_field: UITextField!
    @IBOutlet weak var grade_field: UITextField!
    //:
    @IBOutlet weak var course_grade_tableview: UITableView!
    //:
    @IBOutlet weak var average_label: UILabel!
    //:
    typealias studentName = String
    typealias course = String
    typealias grade = Double
    //:
    let userDefaultsObj = UserDefaultsManager()
    var studentGrades: [studentName: [course: grade]]!
    var arrOfCourses: [course]!
    var arrOfGrades: [grade]!
    //:
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserDefaults()
        let name = userDefaultsObj.getValue(theKey: "name") as! String
        student_name_label.text = name
        fillUpArrays()
    }
    //:
    func calculateAverage(arrOfGrades: [Double], averageClosure: (_ sum: Double, _ numberOfGrades: Double   ) -> Double) -> Double {
        var sum: Double = 0
        for gr in arrOfGrades {
            sum += gr
        }
        return averageClosure(sum, Double(arrOfGrades.count))
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
    func loadCourseAndGrade() {
        let name = student_name_label.text
        let course_and_grade = studentGrades[name!]
        let the_course = [course](course_and_grade!.keys)[0]
        let the_grade = [grade](course_and_grade!.values)[0]
        course_field.text = the_course
        grade_field.text = String(the_grade)
    }
    //:
    func fillUpArrays() {
        let name = student_name_label.text
        let courses_and_grades = studentGrades[name!]
        arrOfCourses = [course](courses_and_grades!.keys)
        arrOfGrades = [grade](courses_and_grades!.values)
        average_label.text = String(format: "Average : %0.1f", calculateAverage(arrOfGrades: arrOfGrades){$0 / $1})
    }
    //:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfCourses.count
    }
    //:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = course_grade_tableview.dequeueReusableCell(withIdentifier: "proto")!
        if let aCourse = cell.viewWithTag(100) as! UILabel! {
            aCourse.text = arrOfCourses[indexPath.row]
        }
        if let aGrade = cell.viewWithTag(101) as! UILabel! {
            aGrade.text = String(arrOfGrades[indexPath.row])
        }
        return cell
    }
    //:
    /* func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = [studentName](studentGrades.keys)[indexPath.row]
            studentGrades[course_grade_tableview] = nil
            userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    } */
    //:
    @IBAction func save_course_and_grade(_ sender: UIButton) {
        // let value = [course_field.text!: Double(grade_field.text!)]
        let name = student_name_label.text
        var student_courses = studentGrades[name!]
        student_courses![course_field.text!] = Double(grade_field.text!)
        studentGrades[name!] = student_courses
        userDefaultsObj.setKey(theValue: studentGrades as AnyObject, theKey: "grades")
        fillUpArrays()
        course_grade_tableview.reloadData()
    }
    //: Pour cacher le clavier
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //:
}
//:::
