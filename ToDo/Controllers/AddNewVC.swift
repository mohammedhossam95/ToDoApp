//
//  AddNewVCViewController.swift
//  ToDoListDemo
//
//  Created by Dev2 on 4/9/19.
//  Copyright © 2019 Hossam__95. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddNewVC: UIViewController {
    
    //MARK: Properties

    //MARK: Outlets

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskTitleTV: UITextView!
    @IBOutlet weak var bottonConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskTitleTV.delegate = self
        taskDate.minimumDate = Date()
        
        //MARK: Hide Keyboard Notification
        let tabgetsure: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tabgetsure)
        
        
    }
    
    //MARK: Functions
    @objc fileprivate func hideKeyboard() {
        for v in self.view.subviews {
            if v.isKind(of: UITextView.self){
                v.resignFirstResponder()
            }
        }
        self.taskTitleTV.endEditing(true)
    }
    
    fileprivate func DismissVC() {
        dismiss(animated: true)
        self.taskTitleTV.resignFirstResponder()
    }
    fileprivate func showAlert(title: String, text: String){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let Confirm = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(Confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    fileprivate func showAlertSucces(title: String, text: String){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let Confirm = UIAlertAction(title: "Ok", style: .cancel) { (UIAlertAction) in
            self.DismissVC()
        }
        alertController.addAction(Confirm)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func saveNewTask(name: String, date: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKeyPath: "title")
        task.setValue(date, forKey: "date")
        task.setValue(0, forKey: "completed")
        
        do {
            try managedContext.save()
            showAlertSucces(title: "Succes", text: "Task Was saved")
        } catch let error as NSError {
            showAlert(title: "Failure", text: "Task Failed To Save")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    fileprivate func previewNotification(title: String, date: Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "ToDoTask Notification"
        content.subtitle = "The Task Is "
        content.body = title
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notification temp"
        
        let datecomponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second ] , from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponent, repeats: false)
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil{
                self.showAlert(title: "Warning", text: (error?.localizedDescription)!)
            }
        }
    }
    
    //MARK: Actions
    @IBAction func doTask(_ sender: UIButton) {
        
        if let title = taskTitleTV.text, !title.isEmpty {
            let date = taskDate.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm"
            let dateString = dateFormatter.string(from: date as Date)

            self.saveNewTask(name: title, date: dateString)
            self.previewNotification(title: title, date: taskDate.date)
            
        } else {
            showAlert(title: "Warning", text: "Task Was Empty")
        }
    }

    @IBAction func timeChange(_ sender: UIDatePicker) {
    }
    @IBAction func cancelTask(_ sender: UIButton) {
        DismissVC()
    }
}

//MARK: TExtView Delegate
extension AddNewVC: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneBtn.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            doneBtn.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.bottonConstraints.constant = 300
        UIView.animate(withDuration:0.5){
            self.view.layoutIfNeeded()
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.bottonConstraints.constant = 8
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
