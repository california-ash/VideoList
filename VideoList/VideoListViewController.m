//
//  VideoListViewController.m
//  VideoList
//
//  Created by x on 01.06.15.
//  Copyright (c) 2015 home. All rights reserved.
//


#import "VideoListViewController.h"
#import "VideoListModel.h"
#import "VideoItemTableViewCell.h"
#import "VideoItem.h"


@interface VideoListViewController () <VideoListModelDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, readonly) VideoListModel *model;
@property (nonatomic, readonly) UITableView * tableView;
@end

@implementation VideoListViewController

static NSString * const kCellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];

    _model = [[VideoListModel alloc] initWithURL:[NSURL URLWithString:@"http://gfycat.com/cajax/getTrendingGfycats"]];
    _model.delegate = self;

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    [_tableView registerClass:[VideoItemTableViewCell class] forCellReuseIdentifier:kCellID];
    [self.view addSubview:_tableView];
}

- (void)videoListModelDidUpdateData {
    [self.tableView reloadData];
}

- (void)videoListModelDidUpdateItemAtIndex:(NSUInteger)index {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    [cell applyVideoItem:[self.model videoItemAtIndex:(NSUInteger) indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoItem * item = [self.model videoItemAtIndex:(NSUInteger) indexPath.row];
    return item.thumbnail != nil ? CGRectGetWidth(tableView.bounds)*item.thumbnail.size.height/item.thumbnail.size.width : 100;
}

@end