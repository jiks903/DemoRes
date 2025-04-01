//
//  MenuItemsCell.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//


import UIKit

class MenuItemsCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var btnUpdown: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
     var tblView: UITableView!
    
    var tableData : [String] = []
    var resMenuSelect : [Bool?] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupTableView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupTableView() {
        // Initialize the table view
        tblView = UITableView()

        // Set the data source and delegate
        tblView.dataSource = self
        tblView.delegate = self
        
        // Add the table view as a subview
        contentView.addSubview(tblView)
        
        // Disable autoresizing mask constraints (for Auto Layout)
        tblView.translatesAutoresizingMaskIntoConstraints = false

        // Set the frame manually, based on the content view's bounds
        let yPosition = lblTitle.frame.maxY + 8 // Below the lblTitle
        
        let tableHeight: CGFloat = 300 // Height of the table, you can change this
        tblView.frame = CGRect(x: 0, y: yPosition, width: contentView.frame.width, height: tableHeight)

        // Register the custom cell from the XIB
        let nib = UINib(nibName: "MenuItemsSubCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "MenuItemsSubCell")
        for i in 0..<tableData.count{
            resMenuSelect.append(false)
        }
    }

    // MARK: - UITableViewDataSource methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom NestedCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemsSubCell", for: indexPath) as! MenuItemsSubCell
        cell.lblTitle.text = tableData[indexPath.row]
        if(resMenuSelect[indexPath.row] == true)
        {
            cell.btnSelection.setImage(UIImage(named: "check"), for: .normal)
            
            var restaurantData: [String: Any] = [
                   "name": tableData[indexPath.row]                   
               ]
            
            NotificationCenter.default.post(
                name: .didReceiveRestaurantData,
                object: nil, // You can pass an object if needed (optional)
                userInfo: ["data": restaurantData] // Passing data using userInfo
            )

        }
        else
        {
            cell.btnSelection.setImage(UIImage(named: "round"), for: .normal)
        }
        cell.btnSelection.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)

        cell.btnSelection.tag = indexPath.row

        return cell
    }

    // MARK: - UITableViewDelegate methods (optional)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(tableData[indexPath.row])")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80 // Set the height of each row to 100 points
        
    }
    
    @objc func didPressButton(_ sender: UIButton) {
        resMenuSelect[sender.tag]?.toggle()
        tblView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)

    }
}
extension Notification.Name {
    static let didReceiveRestaurantData = Notification.Name("didReceiveRestaurantData")
}
