//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//
#import "VideoListModel.h"

#import "VideoItem.h"

#import "Downloader.h"

#import <AVFoundation/AVFoundation.h>



@interface VideoListModel ()

@property (nonatomic, readonly) NSURL * dataURL;

@property (nonatomic, copy) NSArray * items;

@property (nonatomic, readonly) Downloader * downloader;

@end



@implementation VideoListModel



- (instancetype)initWithURL:(NSURL *)URL {
    
    NSParameterAssert(URL);
    
    self = [super init];
    
    if (self) {
        
        _dataURL = URL;
        
        _downloader = [Downloader new];
        
        [self update];
        
    }
    
    return self;
    
}



- (void)update {
    
    [[[NSURLSession sessionWithConfiguration:nil]
      
      dataTaskWithURL:self.dataURL
      
      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          
          if (error != nil) {
              
              NSLog(@"load json error: %@", error);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [self.delegate videoListModelDidUpdateData];
                  
              });
              
              return;
              
          }
          
          NSError * serializationError = nil;
          
          NSDictionary * list = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
          
          NSArray * gfys = list[@"gfyList"];
          
          if (serializationError != nil) {
              
              NSLog(@"parse json error: %@", serializationError);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [self.delegate videoListModelDidUpdateData];
                  
              });
              
              return;
              
          }
          
          NSMutableArray * items = [NSMutableArray array];
          
          for (NSDictionary * d in gfys) {
              
              NSString * title = d[@"redditIdText"];
              if (title == nil || [title isKindOfClass:[NSNull class]])
                  title = d[@"title"];
              if (title == nil || [title isKindOfClass:[NSNull class]])
                  title = @"no title";
              
              NSURL * url = [NSURL URLWithString:d[@"mp4Url"]];
              
              
              if (title != nil && url != nil)
                  
                  [items addObject:[[VideoItem alloc] initWithTitle:title
                                    
                                                          remoteURL:url
                                    
                                                           localURL:nil
                                    
                                                          thumbnail:nil]];
              
          }
          
          
          
          dispatch_async(dispatch_get_main_queue(), ^{
              
              self.items = items;
              
              [self.delegate videoListModelDidUpdateData];
              
              [self loadDataForItemAtIndex:0];
              
          });
          
      }] resume];
    
}



- (void)loadDataForItemAtIndex:(NSUInteger)index {
    
    if (index >= self.items.count)
        
        return;
    
    void (^loadDataForNextItem)() = ^{
        
        [self loadDataForItemAtIndex:index + 1];
        
    };
    
    
    
    VideoItem * item = self.items[index];
    
    if (item.thumbnail == nil || item.localURL == nil) {
        
        [self.downloader loadFileAtURL:item.remoteURL completionBlock:^(NSURL *url) {
            
            if (url == nil) {
                
                loadDataForNextItem();
                
            }
            
            else {
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    AVAsset *asset = [AVAsset assetWithURL:url];
                    
                    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
                    
                    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:NULL error:NULL];
                    
                    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
                    
                    CGImageRelease(imageRef);
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (thumbnail != nil) {
                            
                            [self updateThumbnail:thumbnail localURL:url atIndex:index];
                            
                        }
                        
                        loadDataForNextItem();
                        
                    });
                    
                });
                
            }
            
        }];
        
    } else {
        
        loadDataForNextItem();
        
    }
    
}



- (void)updateThumbnail:(UIImage *)image localURL:(NSURL *)localURL atIndex: (NSUInteger)index {
    
    VideoItem * item = self.items[index];
    
    NSMutableArray * items = [self.items mutableCopy];
    
    items[index] = [[VideoItem alloc]
                    
                    initWithTitle:item.title
                    
                    remoteURL:item.remoteURL
                    
                    localURL:localURL
                    
                    thumbnail:image];
    
    self.items = items;
    
    [self.delegate videoListModelDidUpdateItemAtIndex:index];
    
}



- (NSUInteger)numberOfItems {
    
    return [self.items count];
    
}



- (VideoItem *)videoItemAtIndex:(NSUInteger)index {
    
    return self.items[index];
    
}



@end