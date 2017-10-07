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
        // Do any additional setup after loading the view.
    }
    
    func setTextFeilds(){
        startPicker = UIDatePicker()
        endPicker = UIDatePicker()
        
        TxtFromDate.inputView = startPicker;
        TxtToDate.inputView = endPicker;
        
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
    internal func doneClicked(sender: UIBarButtonItem) {
        startDate = startPicker.date
        TxtFromDate.text = startDate.ToString(format: Utility.longDateFormat)
        self.view.endEditing(true)
    }
    
    internal func todoneClicked(sender: UIBarButtonItem) {
        endDate = endPicker.date
        TxtToDate.text = endDate.ToString(format: Utility.longDateFormat)
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
        return  response != nil ? response!.Logs.count : 0;
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
