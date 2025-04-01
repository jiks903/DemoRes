//
//  MenuVC.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//

import UIKit


class MenuVC: UIViewController {
    
    @IBOutlet weak var tblResMenuList: UITableView!
    var resData : Restaurant?
    var resMenuData : [Menu?] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(resData)
        
        for i in 0..<(resData?.menus.count ?? 0) {
            if(resData?.menus[i].menuStatus == true)
            {
                resMenuData.append(resData?.menus[i])
            }
        }
        tblResMenuList.reloadData()
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    


}

extension MenuVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resMenuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResCell", for: indexPath) as! ResCell
        cell.lblTitle.text = resMenuData[indexPath.row]?.menuName
        
        //print("Restaurant: \(restaurant.name), Location: \(restaurant.location)")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItemsVC = storyboard?.instantiateViewController(withIdentifier: "MenuItemsVC") as! MenuItemsVC
        menuItemsVC.resMenuData = resMenuData[indexPath.row]
        self.navigationController?.pushViewController(menuItemsVC, animated: true)
    }
    
    
}

