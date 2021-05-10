//
//  PeopleListViewController.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/3/21.
//

import UIKit

@available(iOS 13.0, *)
class PersonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    
    var people: People!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        people = People()

        tableView.delegate = self
        tableView.dataSource = self
        
        configureSegmentedControl()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        people.loadData {
            self.sortBasedOnSegmentPressed()
            self.tableView.reloadData()
        }
    }
    
    func configureSegmentedControl() {
        // set font colors for segmented control
        let whiteFontColor = [NSAttributedString.Key.foregroundColor : UIColor(named: "GeneralBackgroundColor") ?? UIColor.white]
        let redFontColor = [NSAttributedString.Key.foregroundColor : UIColor(named: "TextLabels+ButtonsColor") ?? UIColor.red]
        sortSegmentedControl.backgroundColor = UIColor(named: "GeneralBackgroundColor")
        sortSegmentedControl.selectedSegmentTintColor = UIColor(named: "TextLabels+ButtonsColor")
        sortSegmentedControl.setTitleTextAttributes(whiteFontColor, for: .selected)
        sortSegmentedControl.setTitleTextAttributes(redFontColor, for: .normal)
        
        // add that reddish color as the border to segmented control
//        sortSegmentedControl.layer.borderColor = UIColor.white.cgColor
        sortSegmentedControl.layer.borderColor = UIColor(named: "TextLabels+ButtonsColor")?.cgColor
        sortSegmentedControl.layer.borderWidth = 1.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! PersonDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.person = people.personArray[selectedIndexPath.row]
        }
    }
    
    
    
    func sortBasedOnSegmentPressed() {
        people.loadData {
            // this is here to reset the data each time
        }
        switch sortSegmentedControl.selectedSegmentIndex {
        case 0: // all
            people.loadData {
                //
            }
        case 1: // upper
            let upperCells = people.personArray.filter({ $0.campus.contains("Main (Upper)") })
            people.personArray = upperCells
        case 2: // lower
            let lowerCells = people.personArray.filter({ $0.campus.contains("Main (Lower)") })
            people.personArray = lowerCells
        case 3: // newton
            let newtonCells = people.personArray.filter({ $0.campus.contains("Newton") })
            people.personArray = newtonCells
        default:
            print("Huh? You shouldn't be here.")
        }
        tableView.reloadData()
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegmentPressed()
    }
}

@available(iOS 13.0, *)
extension PersonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PersonTableViewCell
        cell.person = people.personArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
