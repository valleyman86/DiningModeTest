//
//  DishesCardViewModel.swift
//  DiningMode
//
//  Created by Joseph Gentry on 3/23/17.
//  Copyright © 2017 OpenTable, Inc. All rights reserved.
//

import UIKit

class DishesCardViewModel: NSObject {

    public var updatedCallback:(() -> Void)? {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public var dishes:Array<Dish>! {
        didSet {
            if (self.updatedCallback != nil) {
                self.updatedCallback!()
            }
        }
    }
    
    public func dishDescription(dish: Dish) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: dish.snippet.content)
        
        let attrs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize),
            NSForegroundColorAttributeName: UIColor.red
        ]
        
        for highlightRange in dish.snippet.highlights {
            attributedString.setAttributes(attrs, range: highlightRange)
        }

        return attributedString.attributedSubstring(from: dish.snippet.range)
    }
    
    public func getDishImage(imageURL:String, completion:@escaping (UIImage) -> Void) -> Void {
        URLSession.shared.dataTask(with:URL(string:imageURL)!) { (data, response, error) in
            DispatchQueue.main.async() { () -> Void in
                completion(UIImage(data: data!)!)
            }
            }.resume()
    }
}
