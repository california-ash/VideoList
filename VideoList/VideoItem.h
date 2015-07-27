//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import <UIKit/UIKit.h>


// immutable video item model

@interface VideoItem : NSObject
@property (nonatomic, readonly, copy) NSString * title;
@property (nonatomic, readonly) NSURL *remoteURL;
@property (nonatomic, readonly) NSURL *localURL;
@property (nonatomic, readonly) UIImage * thumbnail;
- (instancetype)initWithTitle:(NSString *)title
                    remoteURL:(NSURL *)remoteURL
                     localURL:(NSURL *)localURL
                    thumbnail:(UIImage *)thumbnail;
@end