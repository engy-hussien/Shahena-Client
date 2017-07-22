//
//  LocationSearchTable.swift
//  Mandobi
//
//  Created by Mostafa on 1/31/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import MapKit
class LocationSearchTable : UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
//    var handleMapSearchDelegate:HandleMapSearch? = nil
    let defaults = UserDefaults.standard
    var fromOrToAddress: String!
//    var searchBar = UISearchBar()
//    
//    var resultSearchController:UISearchController? = nil
//    
//    
//    override func viewDidLoad() {
//        resultSearchController = UISearchController(searchResultsController: self)
////        resultSearchController?.searchResultsUpdater = self
//        
//        searchBar = resultSearchController!.searchBar
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Search for places"
//        navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
//        definesPresentationContext = true
//    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }

}
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        print("selectedItem \(selectedItem)")
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        return cell
    }


}


extension LocationSearchTable : UISearchResultsUpdating {    
    func updateSearchResults(for searchController: UISearchController) {
//        matchingItems.removeAll()
//        self.tableView.reloadData()
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            print("response \(response)")
            self.matchingItems = response.mapItems
            print(self.matchingItems.count)
            self.tableView.reloadData()
        }

    }

}
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: {
            let selectedItem = self.matchingItems[indexPath.row].placemark
            if self.fromOrToAddress == "to"{
//                DeliveryVC.instance.setToAddress(toAddress: selectedItem.name!, toLat: selectedItem.coordinate.latitude, toLng: selectedItem.coordinate.longitude)
            }
            else
            {
//                DeliveryVC.instance.setFromAddress(fromAddress: selectedItem.name!, fromLat: selectedItem.coordinate.latitude, fromLng: selectedItem.coordinate.longitude)
            }
        })
    }
}


