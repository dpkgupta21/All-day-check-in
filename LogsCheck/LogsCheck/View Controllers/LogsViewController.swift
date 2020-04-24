//
//  LogsViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class LogsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var BtnSearch: UIButton!
    @IBOutlet weak var TxtToDate: UITextField!
    @IBOutlet weak var TxtFromDate: UITextField!
    
    @IBOutlet weak var TblContnt: UITableView!
    
    var startDate : Date!
    var endDate : Date!
    var startPicker:UIDatePicker!
    var endPicker : UIDatePicker!
    var response : LogsResponseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Logs"
        TblContnt.estimatedRowHeight = 70;
        setTextFeilds()
        GetLogs()
        // Do any additional setup after loading the view.
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date.now)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func convertDateIntoFormatString(date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date);
    }
    
    func setTextFeilds(){
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        //TxtFromDate.text = dateFormatter.string(from: startOfMonth());
        //TxtToDate.text = dateFormatter.string(from: endOfMonth());
        
        TxtFromDate.text = convertDateIntoFormatString(date: startOfMonth());
        TxtToDate.text = convertDateIntoFormatString(date: endOfMonth());

        startDate = startOfMonth();
        endDate = endOfMonth();        
        
        startPicker = UIDatePicker()
        endPicker = UIDatePicker()
        startPicker.datePickerMode = .date
        endPicker.datePickerMode = .date
        TxtFromDate.inputView = startPicker;
        TxtToDate.inputView = endPicker;
        startPicker.date = startDate;
        endPicker.date = endDate;
        
        let doneBar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:40.0))
        
        // set the color of the toolbar
        doneBar.barStyle = .blackTranslucent
        doneBar.tintColor = UIColor.white
        doneBar.backgroundColor = UIColor.blue
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClicked))
        doneBar.setItems([doneBtn], animated: true)
        
        let todoneBar = UIToolbar(frame: CGRect(x:0, y:0, width:self.view.bounds.size.width, height:40.0))
        
        // set the color of the toolbar
        todoneBar.barStyle = .blackTranslucent
        todoneBar.tintColor = UIColor.white
        todoneBar.backgroundColor = UIColor.blue
        
        let todoneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(todoneClicked))
        todoneBar.setItems([todoneBtn], animated: true)
        
        
        TxtFromDate.inputAccessoryView = doneBar;
        TxtToDate.inputAccessoryView = todoneBar;
        
        
    }
    @objc internal func doneClicked(sender: UIBarButtonItem) {
        startDate = startPicker.date
        //TxtFromDate.text = startDate.longDateString
        TxtFromDate.text = convertDateIntoFormatString(date: startDate);
        self.view.endEditing(true)
    }
    
    @objc internal func todoneClicked(sender: UIBarButtonItem) {
        endDate = endPicker.date
        //TxtToDate.text = endDate.longDateString
        TxtToDate.text = convertDateIntoFormatString(date: endDate);
        self.view.endEditing(true)
    }
    
    
    
    func GetLogs() {
        Utility.showProgressHud(text: "")
        LogsResponseModel.GetLogs(startDate: startDate, endDate: endDate ) {(logs, error) in
            DispatchQueue.main.async {
                Utility.hideProgressHud()
                if(logs != nil && logs?.ErrorMessage == nil){
                    self.response = logs
                }else if(logs != nil){
                    let info = ["title":"Error",
                                "message":logs?.ErrorMessage,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }else{
                    let info = ["title":"Error",
                                "message":error,
                                "cancel":"Ok"]
                    Utility.showAlertWithInfo(infoDic: info as NSDictionary)
                }
                self.TblContnt.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  response != nil ? response!.Logs.count - 2  : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogsCell") as! LogsCell
        cell.configureCell(data: response.Logs[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @IBAction func BtnSearchClicked(_ sender: Any) {
        if(startDate != nil && endDate != nil){
            GetLogs()
        }
    }
}
