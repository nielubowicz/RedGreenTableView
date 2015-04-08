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

@property (strong, nonatomic) NSIndexPath *expandedIndexPath;
@property (strong, nonatomic) NSMutableSet *extraIndexPaths;

@property (strong, nonatomic) SampleDataSource *sampleDataSource;
@property (strong, nonatomic) SampleDelegate *sampleDelegate;

@end

@implementation RedGreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.extraIndexPaths = [NSMutableSet set];
    
    // Set up sample data source and delegate objects. In a real situation, the dataSource & delegate would probably be set externally
    self.sampleDataSource = [[SampleDataSource alloc] init];
    self.dataSource = self.sampleDataSource;
    
    self.sampleDelegate = [[SampleDelegate alloc] init];
    self.delegate = self.sampleDelegate;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView beginUpdates]; {

        if ([self.expandedIndexPath isEqual:indexPath]) {
            self.expandedIndexPath = nil;

            [tableView deleteRowsAtIndexPaths:self.extraIndexPaths.allObjects
                             withRowAnimation:UITableViewRowAnimationTop];
            [self.extraIndexPaths removeAllObjects];
            [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];

        } else if ([self.extraIndexPaths containsObject:indexPath]) {
            [self.delegate tableView:tableView didSelectExpandedRowAtIndexPath:indexPath];
        } else {
            NSInteger currentCountOfExpandedCells = self.extraIndexPaths.count;
            NSInteger rowContractionFactor = 0;
            
            if (self.expandedIndexPath) {
                NSIndexPath *anyExtraIndexPath = [self.extraIndexPaths anyObject];
                
                // if this is the same section, and the selected indexPath is below the current set of expanded cells,
                // the indexPaths for new expanded cells needs to be offset by the current number of expanded cells
                if (anyExtraIndexPath.section == indexPath.section && indexPath.row > anyExtraIndexPath.row) {
                    rowContractionFactor = currentCountOfExpandedCells;
                }
                
                [tableView deleteRowsAtIndexPaths:self.extraIndexPaths.allObjects
                                 withRowAnimation:UITableViewRowAnimationTop];
                [self.extraIndexPaths removeAllObjects];
            }
            
            self.expandedIndexPath = [NSIndexPath indexPathForRow:indexPath.row - rowContractionFactor inSection:indexPath.section];
            
            for (int indexRow = 1; indexRow <= [self.dataSource tableView:tableView numberOfExpandedRowsInSection:indexPath.section]; indexRow++) {
                    [self.extraIndexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row + indexRow - rowContractionFactor
                                                                       inSection:indexPath.section]];
            }

            [tableView insertRowsAtIndexPaths:self.extraIndexPaths.allObjects
                             withRowAnimation:UITableViewRowAnimationBottom];
            
            [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    [tableView endUpdates];
    
    // if none of the expanded cells are visible, scroll them on screen
    if (![[tableView indexPathsForVisibleRows] containsObject:[self.extraIndexPaths anyObject]]) {
        [tableView scrollToRowAtIndexPath:[self.extraIndexPaths anyObject] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    if ([self.extraIndexPaths containsObject:indexPath]) {
        height = [self.delegate tableView:tableView heightForExpandedRowAtIndexPath:indexPath];
    } else {
        height = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
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
    rows += ( self.expandedIndexPath ? [self.dataSource tableView:tableView numberOfExpandedRowsInSection:section] : 0 );
    
    return rows;
}

@end
