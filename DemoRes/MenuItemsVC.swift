//
//  MenuItemsVC.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//

import UIKit

class MenuItemsVC: UIViewController {
    
    @IBOutlet weak var tblResMenuList: UITableView!
  
    var resMenuData : Menu?
    var resMenuSelect : [Bool?] = []
    
    var popupView = UIView()
    var closeButton = UIButton(type: .system)
    var popupData : [String] = []
    var popupBoolData : [Bool] = []
    var tblPopupView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(resMenuData)
        
        for i in 0..<(resMenuData?.menuItems.count ?? 0) {
            resMenuSelect.append(false)
        }
        showPopup()
        popupView.alpha = 0
        closeButton.alpha = 0
        tblPopupView.alpha = 0
        tblResMenuList.reloadData()
        tblPopupView.reloadData()
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(handleRestaurantData(_:)),
                  name: .didReceiveRestaurantData,
                  object: nil
              )
    }
    @objc func handleRestaurantData(_ notification: Notification) {
          // Extract data from the notification's userInfo
          if let userInfo = notification.userInfo,
             let restaurantData = userInfo["data"] as? [String: Any] {
              // Handle the received data
              print("Received restaurant data: \(restaurantData)")
              
              for i in 0..<(resMenuData?.menuItems.count ?? 0) {
                  
                  for j in 0..<(resMenuData?.menuItems[i].childItems.count ?? 0) {
                      
                      if(resMenuData?.menuItems[i].childItems[j].name == (restaurantData["name"] as? String))
                      {
                          if((resMenuData?.menuItems[i].childItems[j].extraIngredients.count)! > 1)
                          {
                              popupData = (resMenuData?.menuItems[i].childItems[j].extraIngredients)!
                              for item in 0..<popupData.count {
                                  if(item == 0)
                                  {
                                      popupBoolData.append(true)
                                  }
                                  else{
                                      popupBoolData.append(false)
                                  }
                              }
                              
                              print(popupData)
                              popupView.alpha = 1
                              closeButton.alpha = 1
                              tblPopupView.alpha = 1
                              tblResMenuList.reloadData()
                              tblPopupView.reloadData()
                              return
                          }

                      }
                  }
                 
              }
          }
      }
      
      deinit {
          // Remove observer when the view controller is deallocated
          NotificationCenter.default.removeObserver(self)
      }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func showPopup() {
            popupView.frame = CGRect(x: 10, y: 100, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 200)
            popupView.backgroundColor = .white
            popupView.layer.cornerRadius = 10
            popupView.layer.shadowColor = UIColor.black.cgColor
            popupView.layer.shadowOpacity = 0.5
            popupView.layer.shadowOffset = CGSize(width: 0, height: 2)
            popupView.layer.shadowRadius = 4
            self.view.addSubview(popupView)
            
            closeButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 10, width: 40, height: 40)
            closeButton.setTitle("X", for: .normal)
            closeButton.addTarget(self, action: #selector(closePopup(_:)), for: .touchUpInside)
            popupView.addSubview(closeButton)
            
            // Add a Table View
        tblPopupView.frame = CGRect(x: 10, y: 50, width: self.view.frame.size.width - 60, height: self.view.frame.size.height - 400)
        tblPopupView.dataSource = self
        tblPopupView.delegate = self
        
            // Register the custom cell from the XIB
            let nib = UINib(nibName: "MenuItemsSubCell", bundle: nil)
        tblPopupView.register(nib, forCellReuseIdentifier: "MenuItemsSubCell")

            popupView.addSubview(tblPopupView)
        }
        @objc func closePopup(_ sender: UIButton) {
            popupView.alpha = 0
            closeButton.alpha = 0
            tblPopupView.alpha = 0
            tblResMenuList.reloadData()
            tblPopupView.reloadData()
         }


}

extension MenuItemsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (popupView.alpha == 1)
        {
            return popupData.count
            
        }
        return resMenuData?.menuItems.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (popupView.alpha == 1)
        {
            let cell = tblPopupView.dequeueReusableCell(withIdentifier: "MenuItemsSubCell", for: indexPath) as! MenuItemsSubCell
            cell.lblTitle.text = popupData[indexPath.row]
            if(popupBoolData[indexPath.row] == true)
            {
                cell.btnSelection.setImage(UIImage(named: "check"), for: .normal)
            }
            else
            {
                cell.btnSelection.setImage(UIImage(named: "round"), for: .normal)
            }
            cell.btnSelection.addTarget(self, action: #selector(didPressPopupButton(_:)), for: .touchUpInside)

            cell.btnSelection.tag = indexPath.row

            return cell

        }
        
        let cell = tblResMenuList.dequeueReusableCell(withIdentifier: "MenuItemsCell", for: indexPath) as! MenuItemsCell
        cell.lblTitle.text = resMenuData?.menuItems[indexPath.row].mainItemName
        cell.btnUpdown.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)

        cell.btnUpdown.tag = indexPath.row
        if(resMenuSelect[indexPath.row] == true)
        {
            cell.btnUpdown.setImage(UIImage(named: "check"), for: .normal)
            var tmpData : [String] = []
            var tmpBoolData : [Bool] = []
            for i in 0..<resMenuData!.menuItems[indexPath.row].childItems.count
            {
                tmpData.append(resMenuData!.menuItems[indexPath.row].childItems[i].name)
                tmpBoolData.append(false)
            }
            cell.tableData = tmpData
            cell.resMenuSelect = tmpBoolData
            cell.tblView.alpha = 1
            cell.tblView.reloadData()
        }
        else
        {
            cell.btnUpdown.setImage(UIImage(named: "round"), for: .normal)
            var tmpData : [String] = []
            var tmpBoolData : [Bool] = []
            for i in 0..<resMenuData!.menuItems[indexPath.row].childItems.count
            {
                tmpData.append(resMenuData!.menuItems[indexPath.row].childItems[i].name)
                tmpBoolData.append(false)
            }
            cell.tableData = tmpData
            cell.resMenuSelect = tmpBoolData
            cell.tblView.alpha = 0
            cell.tblView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    @objc func didPressButton(_ sender: UIButton) {
        resMenuSelect[sender.tag]?.toggle()
        tblResMenuList.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
    @objc func didPressPopupButton(_ sender: UIButton) {
        for i in 0..<popupBoolData.count
        {
            popupBoolData[i] = false
        }
            
        
        popupBoolData[sender.tag].toggle()
        tblPopupView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (popupView.alpha == 1)
        {
            var tmpData  = 0
            for i in 0..<resMenuData!.menuItems[indexPath.row].childItems.count
            {
                tmpData += 80
            }
            return 80

        }
        if(resMenuSelect[indexPath.row] == true)
        {
            var tmpData  = 0
            for i in 0..<resMenuData!.menuItems[indexPath.row].childItems.count
            {
                tmpData += 80
            }
            return CGFloat(tmpData + 80)
        }
        else{
            return 100 // Set the height of each row to 100 points
        }
    }
    
    
}

