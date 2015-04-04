//
//  RedGreenTableViewDelegate.h
//  RedGreenTableView
//
//  Created by chris nielubowicz on 4/4/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedGreenTableViewDelegate <UITableViewDelegate>

/*!
 @param tableView The UITableView whose cell was selected
 @param indexPath The indexPath for the selected expanded cell
 @abstract Offers customization of behavior when a user selects the expanded row at indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectExpandedRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @param tableView The UITableView for which to return a height for expanded cell
 @param indexPath The indexPath for the expanded cell
 @abstract Returns the CGFloat representing the height of an expanded cell for the RedGreenTableView
 */
- (CGFloat)tableView:(UITableView *)tableView heightForExpandedRowAtIndexPath:(NSIndexPath *)indexPath;

@end
