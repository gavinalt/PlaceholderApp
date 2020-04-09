//
//  PhotoCollectionCell.swift
//  PlaceholderApp
//
//  Created by Gavin Li on 4/8/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellTitleLbl?.text = ""
        cellImageView?.image = UIImage(named: "placeholder")
    }
    
    func configureCell(from photo: Photo) {
        if cellTitleLbl == nil || cellImageView == nil {
            cellTitleLbl?.removeFromSuperview()
            cellImageView?.removeFromSuperview()
            
            let titleLbl: UILabel = {
                let label = UILabel()
                label.numberOfLines = 1
                label.lineBreakMode = .byTruncatingTail
                label.font = UIFont(name: "HelveticaNeue", size: 11)
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
            
            self.contentView.addSubview(titleLbl)
            self.contentView.addSubview(imageView)
            cellTitleLbl = titleLbl
            cellImageView = imageView
            
            self.contentView.bringSubviewToFront(titleLbl)
            titleLbl.isUserInteractionEnabled = true
            
            titleLbl.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
            titleLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            titleLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -2).isActive = true
            
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        }
        
        cellTitleLbl.text = photo.title
        
        PhotoHelper.getImageFromWeb(photo.thumbnailUrl) { (dlImg, downloaded) in
            if let image = dlImg {
                self.cellImageView.image = image
            } else { // if you use an Else statement, it will be in background
                self.cellImageView.image = UIImage(named: "placeholder")
            }
        }
    }
}
