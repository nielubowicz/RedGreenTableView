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
@property (strong, nonatomic) NSIndexPath *extraIndexPath;

@property (strong, nonatomic) SampleDataSource *sampleDataSource;
@property (strong, nonatomic) SampleDelegate *sampleDelegate;

@end

@implementation RedGreenTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [tableView beginUpdates];

    if ([self.expandedIndexPath isEqual:indexPath]) {
        self.expandedIndexPath = nil;
        self.extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                 inSection:indexPath.section];

        [tableView deleteRowsAtIndexPaths: @[ self.extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationTop];
        self.extraIndexPath = nil;
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];

    } else if ([self.extraIndexPath isEqual:indexPath]) {
        [self.delegate tableView:tableView didSelectExpandedRowAtIndexPath:indexPath];
    } else {
        if (self.extraIndexPath) {
            [tableView deleteRowsAtIndexPaths: @[ self.extraIndexPath ]
                             withRowAnimation:UITableViewRowAnimationTop];
        }
        self.expandedIndexPath = indexPath;
        self.extraIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                                         inSection:indexPath.section];

        [tableView insertRowsAtIndexPaths:@[ self.extraIndexPath ]
                         withRowAnimation:UITableViewRowAnimationBottom];
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    if ([self.extraIndexPath isEqual:indexPath]) {
        height = [self.delegate tableView:tableView heightForExpandedRowAtIndexPath:indexPath];
    }
    
    return height;
}

#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([self.extraIndexPath isEqual:indexPath]) {
        cell = [self.dataSource tableView:tableView expandedCellForRowAtIndexPath:indexPath];
    } else {
        cell = [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.dataSource tableView:tableView numberOfRowsInSection:section];
    rows += ( self.expandedIndexPath ? 1 : 0 );
    
    return rows;
}

@end
