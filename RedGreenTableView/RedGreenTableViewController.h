//
//  RedGreenTableViewController.h
//  RedGreenTableView
//
//  Created by chris nielubowicz on 3/26/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedGreenTableViewDataSource.h"
#import "RedGreenTableViewDelegate.h"

@interface RedGreenTableViewController : UITableViewController

/*!
 @property dataSource
 @abstract RedGreenTableViewController dataSource
 @discussion
    Implements UITableViewDataSource and additional RedGreenTableViewDataSource methods
 */
@property (weak, nonatomic) id<RedGreenTableViewDataSource> dataSource;

/*!
 @property delegate
 @abstract RedGreenTableViewController delegate
 @discussion 
    Implements UITableViewDelegate and additional RedGreenTableViewDelegate methods
 */
@property (weak, nonatomic) id<RedGreenTableViewDelegate> delegate;

@end
