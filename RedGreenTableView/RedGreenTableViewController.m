//
//  RedGreenTableViewController.m
//  RedGreenTableView
//
//  Created by chris nielubowicz on 3/26/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "RedGreenTableViewController.h"

@interface RedGreenTableViewController ()

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSIndexPath *extraIndexPath;

@end

@implementation RedGreenTableViewController

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([self.extraIndexPath isEqual:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"greenCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"redCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.expandedIndexPath = indexPath;
    [tableView beginUpdates];
    if (self.extraIndexPath) {
        NSIndexPath *tempIndexPath = [self.extraIndexPath copy];
        self.extraIndexPath = nil;
        [tableView deleteRowsAtIndexPaths: @[ tempIndexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
    }
    
    self.extraIndexPath = [NSIndexPath indexPathForRow:self.expandedIndexPath.row + 1
                                             inSection:self.expandedIndexPath.section];
    [tableView insertRowsAtIndexPaths:@[ self.extraIndexPath ]
                     withRowAnimation:UITableViewRowAnimationBottom];
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if ([indexPath isEqual:self.extraIndexPath]) {
        height = 88;
    }
    
    return height;
}

#pragma mark - UITableViewDatasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 15;
    if (self.extraIndexPath) {
        rows++;
    }
    
    return rows;
}

@end
