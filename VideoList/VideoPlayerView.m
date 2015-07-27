//
// Created by x on 03.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import "VideoPlayerView.h"


@implementation VideoPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player
{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

@end