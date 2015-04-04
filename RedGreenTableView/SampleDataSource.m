//
//  SampleDataSource.m
//  RedGreenTableView
//
//  Created by chris nielubowicz on 4/4/15.
//  Copyright (c) 2015 Assorted Intelligence. All rights reserved.
//

#import "SampleDataSource.h"

@implementation SampleDataSource

#pragma mark - RedGreenTableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redCell"];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView expandedCellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"greenCell"];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

@end
