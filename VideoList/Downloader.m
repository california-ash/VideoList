//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import "Downloader.h"

@interface Downloader ()
@property (nonatomic, readonly, copy) NSString * path;
@property (nonatomic, readonly) NSFileManager * fileManager;
@end

@implementation Downloader

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = paths[0];
        BOOL isDir = NO;
        NSError *error;
        if (! [_fileManager fileExistsAtPath:cachePath isDirectory:&isDir] && !isDir) {
            [_fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
        }
        _path = [cachePath copy];
    }
    return self;
}

- (void)loadFileAtURL:(NSURL *)URL completionBlock:(void (^)(NSURL *))completionBlock {
    NSParameterAssert(completionBlock);
    NSString * localName = [[URL.absoluteString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString * localPath = [[self.path stringByAppendingPathComponent:localName] stringByAppendingString:URL.lastPathComponent];
    if ([self.fileManager fileExistsAtPath:localPath]) {
        completionBlock([NSURL fileURLWithPath:localPath]);
    }
    else {
        [[[NSURLSession sessionWithConfiguration:nil]
                downloadTaskWithURL:URL
                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                      if (error == nil && [self.fileManager copyItemAtPath:location.path toPath:localPath error:nil]) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              completionBlock([NSURL fileURLWithPath:localPath]);
                          });
                      }
                      else {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              completionBlock(nil);
                          });
                      }
                  }] resume];
    }
}

@end