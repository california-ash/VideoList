//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import "VideoItem.h"


@implementation VideoItem

- (instancetype)initWithTitle:(NSString *)title remoteURL:(NSURL *)remoteURL localURL:(NSURL *)localURL thumbnail:(UIImage *)thumbnail {
    self = [super init];
    if (self) {
        _title = [title copy];
        _remoteURL = remoteURL;
        _localURL = localURL;
        _thumbnail = thumbnail;
    }

    return self;
}

@end