//
//  DetailViewController.swift
//  TheSimpsons
//
//  Created by Gavin Li on 4/3/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var downloadMsg: UILabel!
    
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var charDesc: UILabel!
    @IBOutlet weak var charImg: UIImageView!

    func configureView() {
        // Update the user interface for the detail item.
        guard let curPhoto = detailItem else { return }
        
        let titleLbl: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = .black
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        } ()
        let imageView: UIImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
            img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
            img.layer.cornerRadius = 5
            img.clipsToBounds = true
            return img
        } ()
        
        view.addSubview(titleLbl)
        view.addSubview(imageView)
        
        titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLbl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 256).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        titleLbl.text = curPhoto.title
        
        PhotoHelper.getImageFromWeb(curPhoto.url) { (dlImg, downloaded) in
            if let image = dlImg {
                imageView.image = image
                if downloaded {
                    self.downloadMsg.text = "Image downloaded from Internet"
                } else {
                    self.downloadMsg.text = "Image loaded from cache"
                }
            } else { // if you use an Else statement, it will be in background
                imageView.image = UIImage(named: "placeholder")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Photo? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
}
