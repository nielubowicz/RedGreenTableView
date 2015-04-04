//
//  SampleDelegate.m
//  RedGreenTableView
//
//  Created by chris nielubowicz on 4/4/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "SampleDelegate.h"

@implementation SampleDelegate

#pragma mark - RedGreenTableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectExpandedRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, indexPath);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForExpandedRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 88;
}

@end
