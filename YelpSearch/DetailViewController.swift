//
//  DetailViewController.swift
//  YelpSearch
//
//  Created by HO, SCOTT on 11/9/17.
//  Copyright © 2017 Ho, Scott. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView?
    var objects = [YelpBusiness]()
    var offset = 0
    var waiting = false
    
    var searchTerm:String?{
        didSet{
            configure()
        }
    }
    
    func configure(){
        self.title = searchTerm
        self.objects.removeAll()
        offset = 0
        loadMoreData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CollectionViewCell
        
        let url = self.objects[indexPath.row].imageUrl
        cell.iv.kf.setImage(with: url)
        if indexPath.item == self.objects.count - 20{
            loadMoreData()
        }
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.searchTerm = ""
        self.objects.removeAll()
    }
    func loadMoreData(){
        YelpFusionManager.shared.apiClient.cancelAllPendingAPIRequests()
        YelpFusionManager.shared.apiClient.searchBusinesses(byTerm: searchTerm,
                                                            location: "Los Angeles",
                                                            latitude: nil,
                                                            longitude: nil,
                                                            radius: 10000,
                                                            locale: .english_unitedStates,
                                                            limit: 30,
                                                            offset: offset,
                                                            attributes: nil) { (response, error) in
                                                                
                                                                if let response = response,
                                                                    let businesses = response.businesses,
                                                                    
                                                                    businesses.count > 0 {
                                                                    self.objects.append(contentsOf: businesses)
                                                                    self.waiting = false
                                                                    self.collectionView?.reloadData()
                                                                    businesses.map(){
                                                                        print($0.imageUrl)
                                                                    }
                                                                }
        }
        offset += 50
    }
    
}

