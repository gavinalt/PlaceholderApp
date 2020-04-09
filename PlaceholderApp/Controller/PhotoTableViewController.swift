//
//  CharacterTableViewController.swift
//  TheSimpsons
//
//  Created by Gavin Li on 4/3/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class PhotoTableViewController: UIViewController {
    @IBOutlet weak var photoTable: UITableView!
    
    override func viewDidLoad() {
        photoTable.dataSource = self
        photoTable.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    // MARK: - Table view data source
    var photos: [Photo]? {
        didSet {
            if isViewLoaded {
                photoTable.reloadData()
            }
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableShowDetail" {
            if let indexPath = photoTable.indexPathForSelectedRow {
                if let curPhoto = photos?[indexPath.row] {
                    let controller = segue.destination as! DetailViewController
                    controller.detailItem = curPhoto
                }
            }
        }
    }
}

extension PhotoTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoTableCell", for: indexPath)
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        guard let curPhoto = photos?[indexPath.row] else { return cell }
        
        let titleLbl: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = .black
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
        
        cell.contentView.addSubview(titleLbl)
        cell.contentView.addSubview(imageView)
        
        titleLbl.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -10).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant:10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLbl.text = curPhoto.title
        
        PhotoHelper.getImageFromWeb(curPhoto.thumbnailUrl) { (dlImg, downloaded) in
            if let image = dlImg {
                imageView.image = image
            } else { // if you use an Else statement, it will be in background
                imageView.image = UIImage(named: "placeholder")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
