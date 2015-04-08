//
//  RedGreenTableViewDataSource.h
//  RedGreenTableView
//
//  Created by chris nielubowicz on 4/4/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedGreenTableViewDataSource <UITableViewDataSource>

/*!
 @param tableView   The UITableView for which to return count of expanded cells
 @param section     The UITableView section
 @abstract Returns the number of UITableViewCells to be shown in the expanded section
 @discussion
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfExpandedRowsInSection:(NSInteger)section;

/*!
 @param tableView The UITableView for which to return an expanded cell
 @param indexPath The indexPath for the expanded cell
 @abstract Returns the UITableViewCell representing an expanded cell for the RedGreenTableView
 @discussion
    In practice, this will often be a web-style drawer-reveal-style control. Can be of a different height than cellForRowAtIndexPath.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView expandedCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
