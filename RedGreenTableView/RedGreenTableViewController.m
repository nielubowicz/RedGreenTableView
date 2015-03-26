//
//  RedGreenTableViewController.m
//  RedGreenTableView
//
//  Created by chris nielubowicz on 3/26/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "RedGreenTableViewController.h"

@interface RedGreenTableViewController ()

@property (strong, nonatomic) NSMutableSet *expandedIndexPaths;
@property (strong, nonatomic) NSMutableSet *extraIndexPaths;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSIndexPath *extraIndexPath;

@end

@implementation RedGreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.expandedIndexPaths = [NSMutableSet set];
    self.extraIndexPaths = [NSMutableSet set];
}

- (void)addIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSMutableSet *)indexPathSet
{
    NSMutableSet *tempSet = [NSMutableSet setWithObject:indexPath];
    for (NSIndexPath *knownPath in indexPathSet) {
        
        if (knownPath.section == indexPath.section) {
            if (knownPath.row > indexPath.row) {
                NSIndexPath *newKnownPath = [NSIndexPath indexPathForRow:knownPath.row + 1 inSection:knownPath.section];
                [tempSet addObject:newKnownPath];
            } else {
                [tempSet addObject:knownPath];
            }
        } else {
            [tempSet addObject:knownPath];
        }
    }
    [indexPathSet setSet:tempSet];
}

- (void)removeIndexPath:(NSIndexPath *)indexPath fromIndexPaths:(NSMutableSet *)indexPathSet
{
    NSMutableSet *tempSet = [NSMutableSet set];
    for (NSIndexPath *knownPath in indexPathSet) {
        
        if (knownPath.section == indexPath.section) {
            if (knownPath.row > indexPath.row) {
                NSIndexPath *newKnownPath = [NSIndexPath indexPathForRow:knownPath.row - 1 inSection:knownPath.section];
                [tempSet addObject:newKnownPath];
            } else if (knownPath.row < indexPath.row) {
                [tempSet addObject:knownPath];
            }
        } else {
            [tempSet addObject:knownPath];
        }
    }
    [indexPathSet setSet:tempSet];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView beginUpdates];

    if ([self.expandedIndexPaths containsObject:indexPath]) {
        [self removeIndexPath:indexPath fromIndexPaths:self.expandedIndexPaths];
        self.extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                 inSection:indexPath.section];

        [self removeIndexPath:self.extraIndexPath fromIndexPaths:self.extraIndexPaths];
        [tableView deleteRowsAtIndexPaths: @[ self.extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
        self.extraIndexPath = nil;
        
    } else {
        [self addIndexPath:indexPath toIndexPaths:self.expandedIndexPaths];
        self.extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                 inSection:indexPath.section];
        [self addIndexPath:self.extraIndexPath toIndexPaths:self.extraIndexPaths];
        [tableView insertRowsAtIndexPaths:@[ self.extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }

    [tableView endUpdates];
}


#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([self.extraIndexPaths containsObject:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"greenCell"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"redCell"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 15;
    rows += self.extraIndexPaths.count;
    
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    if ([self.extraIndexPaths containsObject:indexPath]) {
        height = 88;
    }
    
    return height;
}

@end
