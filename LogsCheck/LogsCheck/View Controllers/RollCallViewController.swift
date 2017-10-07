//
//  RollCallViewController.swift
//  LogsCheck
//
//  Created by Akash Deep Kaushik on 30/09/17.
//  Copyright © 2017 Akash Deep Kaushik. All rights reserved.
//

import UIKit

class RollCallViewController: UIViewController , UITableViewDelegate, UITableViewDataSource,TerminalSelectDelgate
{

    @IBOutlet weak var TblContnt: UITableView!

    var response : RollCallResonseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let viewController  =     self.storyboard!.instantiateViewController(withIdentifier: "SelectTerminalsViewController") as! SelectTerminalsViewController
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    func GetLogs(terminals:String) {
        Utility.showProgressHud(text: "")
        RollCallResonseModel.GetRollCalls(terminals: terminals) {(logs, error) in
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


    func OkClicked(terminal : String ){
        GetLogs(terminals: terminal)
    }
    
    func CancelClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  response != nil ? response!.RollCalls.count : 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RollCallCell") as! RollCallCell
        cell.configureCell(data: response.RollCalls[indexPath.row])
        return cell;
    }

}
