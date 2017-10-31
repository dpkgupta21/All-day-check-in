//
//  SelectTerminalsViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 02/10/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

protocol TerminalSelectDelgate {
    
    func OkClicked(terminal : String );
    func CancelClicked();
}

class SelectTerminalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TblContnt: UITableView!
    var response : TerminalResponseModel!
    var Terminals:String!
    var delegate:TerminalSelectDelgate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TblContnt.estimatedRowHeight = 40;
        self.navigationItem.title = "Roll Calls"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetTerminals();
    }
    
    func GetTerminals() {
        Utility.showProgressHud(text: "")
        TerminalResponseModel.GetTerminals(){(logs, error) in
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
        return  response != nil ? response!.Terminals.count-2 : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TerminalCell") as! TerminalCell
        cell.configureCell(data: response.Terminals[indexPath.row])
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let a = response.Terminals[indexPath.row];
        a.IsSelected = !a.IsSelected
        TblContnt.reloadData()
    }
    
    @IBAction func BtnOkClicked(_ sender: Any) {
        for item in response.Terminals {
            if(item.IsSelected){
                Terminals = Terminals != nil ? Terminals + ",\(item.TerminalID!)" : "\(item.TerminalID!)"
            }
        }
        
        if(delegate != nil){
            delegate.OkClicked(terminal: Terminals)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BtnCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if(delegate != nil){
            delegate.CancelClicked()
        }
    }
    
}
