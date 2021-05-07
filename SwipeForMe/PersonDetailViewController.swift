//
//  PersonDetailViewController.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/3/21.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class PersonDetailViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var campusTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var contactMethodTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var additionalCommentTextView: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var postedOnLabel: UILabel!
    
    var person: Person!
    
    let statuses = ["Requesting", "Offering"]
    let years = ["2025", "2024", "2023", "2022"]
    let campuses = ["Main (Upper)", "Main (Lower)", "Newton"]
    let balances = ["$3,000+", "$2,500 to $2,999", "$2,000 to $2,499", "$1,500 to $1,999", "$1,000 to $1,499", "$500 to $999", "$300 to $499", "$100 to $299", "$0 to $99"]
    let contactMethods = ["Instagram", "Twitter"]
    
    var statusPickerView = UIPickerView()
    var yearPickerView = UIPickerView()
    var campusPickerView = UIPickerView()
    var balancePickerView = UIPickerView()
    var contactMethodPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if tapping outside field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if person == nil {
            person = Person()
        }
        updateUserInterface()
        
        nameTextField.placeholder = "Enter Name"
        contactTextField.placeholder = "Enter Username"
        
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        
        yearPickerView.delegate = self
        yearPickerView.dataSource = self
        
        campusPickerView.delegate = self
        campusPickerView.dataSource = self
        
        balancePickerView.delegate = self
        balancePickerView.dataSource = self
        
        contactMethodPickerView.delegate = self
        contactMethodPickerView.dataSource = self
        
        statusTextField.inputView = statusPickerView
        yearTextField.inputView = yearPickerView
        campusTextField.inputView = campusPickerView
        balanceTextField.inputView = balancePickerView
        contactMethodTextField.inputView = contactMethodPickerView
        
        statusPickerView.tag = 1
        yearPickerView.tag = 2
        campusPickerView.tag = 3
        balancePickerView.tag = 4
        contactMethodPickerView.tag = 5
        
        statusTextField.placeholder = "Select Status"
        yearTextField.placeholder = "Select Class"
        campusTextField.placeholder = "Select Campus"
        balanceTextField.placeholder = "Select Balance"
        contactMethodTextField.placeholder = "Select Contact Method"
        
    }
    
    func updateUserInterface() {
        nameTextField.text = person.name
        statusTextField.text = person.status
        yearTextField.text = person.year
        campusTextField.text = person.campus
        balanceTextField.text = person.balance
        contactMethodTextField.text = person.contactMethod
        contactTextField.text = person.contactInfo
        additionalCommentTextView.text = person.additionalComment
        
        
        // TODO:- working on Posted on: Date Label
        // gotta add date to person class
        postedOnLabel.text = "posted on: \(dateFormatter.string(from: person.date))"
        
        if person.documentID == "" { // this is a new person
            addBordersToEditableObjects()
        } else {
            if person.postingUserID == Auth.auth().currentUser?.uid { // "person"" posted by current user
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                postedByLabel.text = "posted by: You"
                deleteButton.isHidden = false
                // TODO:- make delete button work
            } else {
                saveBarButton.hide()
                cancelBarButton.title = "Back"
                postedByLabel.text = "posted by: \(person.postingUserEmail)"
                // what people see when they look at posts that they didn't create
                nameTextField.isEnabled = false
                nameTextField.borderStyle = .none
                nameTextField.backgroundColor = .white
                statusTextField.isEnabled = false
                statusTextField.borderStyle = .none
                statusTextField.backgroundColor = .white
                yearTextField.isEnabled = false
                yearTextField.borderStyle = .none
                yearTextField.backgroundColor = .white
                campusTextField.isEnabled = false
                campusTextField.borderStyle = .none
                campusTextField.backgroundColor = .white
                balanceTextField.isEnabled = false
                balanceTextField.borderStyle = .none
                balanceTextField.backgroundColor = .white
                contactMethodTextField.isEnabled = false
                contactMethodTextField.borderStyle = .none
                contactMethodTextField.backgroundColor = .white
                contactTextField.isEnabled = false
                contactTextField.borderStyle = .none
                contactTextField.backgroundColor = .white
                additionalCommentTextView.isEditable = false
                additionalCommentTextView.backgroundColor = .white
            }
        }
    }
    
    func updateFromInterface() {
        person.name = nameTextField.text!
        person.status = statusTextField.text!
        person.year = yearTextField.text!
        person.campus = campusTextField.text!
        person.balance = balanceTextField.text!
        person.contactMethod = contactMethodTextField.text!
        person.contactInfo = contactTextField.text!
        person.additionalComment = additionalCommentTextView.text!
    }
    
    func addBordersToEditableObjects() {
        nameTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        statusTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        yearTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        campusTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        balanceTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        contactMethodTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        contactTextField.addBorder(width: 0.5, radius: 5.0, color: .black)
        additionalCommentTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromInterface()
        person.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data would not save to the cloud.")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        person.deleteData(person: person) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Delete unsuccessful")
            }
        }
    }
}

extension PersonDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return statuses.count
        case 2:
            return years.count
        case 3:
            return campuses.count
        case 4:
            return balances.count
        case 5:
            return contactMethods.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return statuses[row]
        case 2:
            return "\(years[row])"
        case 3:
            return campuses[row]
        case 4:
            return balances[row]
        case 5:
            return contactMethods[row]
        default:
            return "ERROR: This should NOT have happened."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            statusTextField.text = statuses[row]
            statusTextField.resignFirstResponder()
        case 2:
            yearTextField.text = "\(years[row])"
            yearTextField.resignFirstResponder()
        case 3:
            campusTextField.text = campuses[row]
            campusTextField.resignFirstResponder()
        case 4:
            balanceTextField.text = balances[row]
            balanceTextField.resignFirstResponder()
        case 5:
            contactMethodTextField.text = contactMethods[row]
            contactMethodTextField.resignFirstResponder()
        default:
            return
        }
    }
    
}
