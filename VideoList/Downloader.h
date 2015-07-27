//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Downloader : NSObject
- (void)loadFileAtURL:(NSURL *)URL completionBlock:(void (^)(NSURL *))completionBlock;
@end