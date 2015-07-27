//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoItem;

@protocol VideoListModelDelegate <NSObject>
- (void)videoListModelDidUpdateData;
- (void)videoListModelDidUpdateItemAtIndex:(NSUInteger)index;
@end

@interface VideoListModel : NSObject
- (instancetype)initWithURL:(NSURL *)URL;
@property (nonatomic, weak) id<VideoListModelDelegate> delegate;
- (void)update;
- (NSUInteger)numberOfItems;
- (VideoItem *)videoItemAtIndex:(NSUInteger)index;
@end
