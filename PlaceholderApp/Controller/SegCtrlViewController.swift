//
//  ViewController.swift
//  PlaceholderApp
//
//  Created by Gavin Li on 4/6/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class SegCtrlViewController: UIViewController {
    var photoTableVC: PhotoTableViewController? {
        didSet {
            photoTableVC?.photos = photos ?? []
        }
    }
    var photoCollectionVC: PhotoCollectionViewController? {
        didSet {
            photoCollectionVC?.photos = photos ?? []
        }
    }
    
    @IBOutlet weak var viewSwitch: UISegmentedControl!
    @IBOutlet weak var photoTableCtn: UIView!
    @IBOutlet weak var photoCollectionCtn: UIView!
    
    var photos: [Photo]? {
        didSet {
            photoTableVC?.photos = photos
            photoCollectionVC?.photos = photos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func contentShouldSwitch(_ sender: Any) {
        guard let segCtrl = sender as? UISegmentedControl else { return }
        switch segCtrl.selectedSegmentIndex {
        case 0:
            photoTableCtn.isHidden = false
            photoCollectionCtn.isHidden = true
        case 1:
            photoTableCtn.isHidden = true
            photoCollectionCtn.isHidden = false
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTable" {
            photoTableVC = segue.destination as? PhotoTableViewController
        }
        
        if segue.identifier == "showCollection" {
            photoCollectionVC = segue.destination as? PhotoCollectionViewController
        }
    }
}
