//
//  CategoryTableVC.swift
//  Mandobi
//
//  Created by Mostafa on 2/1/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit

class CategoryTableVC: LocalizationOrientedViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet var categroyTable: UITableView!
    var category = [Category]()
    let url = Links()
    var catgoryName: String!
    var catgoryID : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        categroyTable.delegate = self
        categroyTable.dataSource = self
        
        Request.getInstance().getWithOutUIDialogs(url: url.BASE_URL + "shared/category/all" + url.AUTH_PARAMETERS , completion: { (data) in
            print(data)
            let dataArray = data["list"] as! NSArray
            print(dataArray.count)
            for i in 0..<dataArray.count
            {
                let dict = dataArray[i] as! NSDictionary
                let id = dict["id"] as! Int
                let name = dict["name"] as! String
                
                let categroy = Category(id: id, name: name)
                self.category.append(categroy)
                
                
            }
            let customCat = Category(id: -1, name: LanguageHelper.getCurrentLanguage() == "ar" ? "فئة اخرى" : "Custom Category")
            self.category.append(customCat)
            self.categroyTable.reloadData()
            
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {        // #warning Incomplete implementation, return the number of sections
        return category.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.categoryLbl.text = category[indexPath.row].name
        cell.categoryId = category[indexPath.row].id
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        
    {
        if segue.identifier == "unwindToCat"
        {
            if let cell = sender as? UITableViewCell
            {
                let indexPath = categroyTable.indexPath(for: cell)

                if category[(indexPath?.row)!].id == -1{
                   BringPopUpVC.instance.showCustomeFiled(false)
                   catgoryName = category[(indexPath?.row)!].name
                   catgoryID = category[(indexPath?.row)!].id

                }
                else{
                    BringPopUpVC.instance.showCustomeFiled(true)
                    catgoryName = category[(indexPath?.row)!].name
                    catgoryID = category[(indexPath?.row)!].id
                }
                
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
