//
//  LocationsSearchViewController.swift
//  Mandobi
//
//  Created by ِAmr on 2/7/17.
//  Copyright © 2017 Mostafa. All rights reserved.
//

import UIKit
import MapKit

class LocationsSearchViewController: LocalizationOrientedViewController {
    
    var resultSearchController:UISearchController? = nil
    var locationSearchTable: LocationSearchTable!
    var searchBar = UISearchBar()
    var mapsView: MKMapView? = nil
    var fromOrToAddress: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        locationSearchTable.mapView = mapsView
        locationSearchTable.fromOrToAddress = fromOrToAddress
        
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.resultSearchController?.searchBar.becomeFirstResponder()
        }
    }


}
