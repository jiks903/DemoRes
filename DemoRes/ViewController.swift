//
//  ViewController.swift
//  DemoRes
//
//  Created by Jeegnesh Solanki on 01/04/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tblResList: UITableView!
    let urlString = "https://test.empyreal.in/findRestaurants"
    var resData : [Restaurant] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //getData()
        
        guard let url = Bundle.main.url(forResource: "Restaurants", withExtension: "json") else {
            print("Error: JSON file not found.")
            return
        }
        
        do {
            // Load the data from the file
            let data = try Data(contentsOf: url)
            
            // Decode the JSON data into an array of Restaurant objects
            let decoder = JSONDecoder()
            let root = try decoder.decode(Root.self, from: data)
//            let restaurants = try decoder.decode([Restaurant].self, from: data)
            
            for restaurant in root.restaurants {
                print("Restaurant: \(restaurant.name), Location: \(restaurant.location)")
                resData.append(restaurant)
            }
            DispatchQueue.main.async {
                self.tblResList.reloadData()
            }
            // Print the decoded data for testing purposes
            print("Loaded restaurants: \(root.restaurants)")
            
        } catch {
            print("Error loading or decoding JSON data: \(error)")
        }

    }
    
    //Get Data
    func getData()
    {
        fetchRestaurants { [self] result in
            switch result {
            case .success(let restaurants):
                // Print the names of all the restaurants
                for restaurant in restaurants {
                    print("Restaurant: \(restaurant.name), Location: \(restaurant.location)")
                    resData.append(restaurant)
                }
                DispatchQueue.main.async {
                    tblResList.reloadData()
                }
                
            case .failure(let error):
                print("Error fetching restaurants: \(error.localizedDescription)")
            }
        }
    }
    // Create a function to fetch the data
    func fetchRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Create a URLSession data task to fetch the data
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle the response
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                // Decode the JSON into the Root object
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: data)
                completion(.success(root.restaurants))
            } catch {
                completion(.failure(error))
            }
        }

        // Start the task
        task.resume()
    }


}
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResCell", for: indexPath) as! ResCell
        cell.lblTitle.text = resData[indexPath.row].name
        cell.lblLocation.text = resData[indexPath.row].location
        cell.lblLateLong.text = String(format: "%.6f %.6f", resData[indexPath.row].lat , resData[indexPath.row].long)
        
        //print("Restaurant: \(restaurant.name), Location: \(restaurant.location)")

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        menuVC.resData = resData[indexPath.row]
        self.navigationController?.pushViewController(menuVC, animated: true)
    }
    
    
}

