//
//  ListController.swift
//  GTDevTools
//
//  Created by Bernie Cartin on 5/22/19.
//  Copyright © 2019 Garson Tech. All rights reserved.
//

import UIKit

/**
 Convenient list component where a Header class is not required.
 
 ## Generics ##
 T: the cell type that this list will register and dequeue.
 
 U: the item type that each cell will visually represent.
 */

open class ListController<T: ListCell<U>, U>: ListHeaderController<T, U, UICollectionReusableView> {
}
