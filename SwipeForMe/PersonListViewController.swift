//
//  PeopleListViewController.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/3/21.
//

import UIKit

class PersonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var people: People!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        people = People()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        people.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! PersonDetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.person = people.personArray[selectedIndexPath.row]
        }
    }
    

}

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
