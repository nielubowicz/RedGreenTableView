//
//  RedGreenTableViewController.m
//  RedGreenTableView
//
//  Created by chris nielubowicz on 3/26/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "RedGreenTableViewController.h"
#import "SampleDataSource.h"
#import "SampleDelegate.h"

@interface RedGreenTableViewController ()

@property (strong, nonatomic) NSMutableSet *expandedIndexPaths;
@property (strong, nonatomic) NSMutableSet *extraIndexPaths;

@property (strong, nonatomic) SampleDataSource *sampleDataSource;
@property (strong, nonatomic) SampleDelegate *sampleDelegate;

@end

@implementation RedGreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.expandedIndexPaths = [NSMutableSet set];
    self.extraIndexPaths = [NSMutableSet set];
    
    // Set up sample data source and delegate objects. In a real situation, the dataSource & delegate would probably be set externally
    self.sampleDataSource = [[SampleDataSource alloc] init];
    self.dataSource = self.sampleDataSource;
    
    self.sampleDelegate = [[SampleDelegate alloc] init];
    self.delegate = self.sampleDelegate;
}

- (void)addIndexPath:(NSIndexPath *)indexPath toIndexPaths:(NSMutableSet *)indexPathSet
{
    NSMutableSet *tempSet = [NSMutableSet setWithObject:indexPath];
    for (NSIndexPath *knownPath in indexPathSet) {
        
        if (knownPath.section == indexPath.section) {
            if (knownPath.row >= indexPath.row) {
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
        NSIndexPath *extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                         inSection:indexPath.section];

        [self removeIndexPath:extraIndexPath fromIndexPaths:self.extraIndexPaths];
        [tableView deleteRowsAtIndexPaths: @[ extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];

    } else if ([self.extraIndexPaths containsObject:indexPath]) {
        [self.delegate tableView:tableView didSelectExpandedRowAtIndexPath:indexPath];
    } else {
        
        [self addIndexPath:indexPath toIndexPaths:self.expandedIndexPaths];
        NSIndexPath *extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                         inSection:indexPath.section];
        [self addIndexPath:extraIndexPath toIndexPaths:self.extraIndexPaths];
        [tableView insertRowsAtIndexPaths:@[ extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationBottom];
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    if ([self.extraIndexPaths containsObject:indexPath]) {
        height = [self.delegate tableView:tableView heightForExpandedRowAtIndexPath:indexPath];
    }
    
    return height;
}

#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([self.extraIndexPaths containsObject:indexPath]) {
        cell = [self.dataSource tableView:tableView expandedCellForRowAtIndexPath:indexPath];
    } else {
        cell = [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.dataSource tableView:tableView numberOfRowsInSection:section];
    rows += self.extraIndexPaths.count;
    
    return rows;
}

@end
