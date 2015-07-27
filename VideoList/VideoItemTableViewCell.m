//
// Created by x on 01.06.15.
// Copyright (c) 2015 home. All rights reserved.
//

#import "VideoItemTableViewCell.h"
#import "VideoItem.h"
#import "VideoPlayerView.h"

@interface VideoItemTableViewCell()
@property (nonatomic, readonly) VideoPlayerView * playerView;
@property (nonatomic, readonly) UIImageView * preview;
@property (nonatomic, readonly) UILabel * labelTitle;
@end

@implementation VideoItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor grayColor];

        _playerView = [[VideoPlayerView alloc] initWithFrame:self.bounds];
        _playerView.hidden = YES;
        _playerView.userInteractionEnabled = NO;
        [self addSubview:_playerView];

        _preview = [[UIImageView alloc] init];
        [self.contentView addSubview:_preview];

        _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _labelTitle.numberOfLines = 0;
        _labelTitle.textColor = [UIColor whiteColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.layer.shadowColor = [UIColor blackColor].CGColor;
        _labelTitle.layer.shadowOffset = CGSizeMake(0, 1);
        _labelTitle.layer.shadowRadius = 1;
        _labelTitle.layer.shadowOpacity = 1;
        [self.contentView addSubview:_labelTitle];

        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(onTap)]];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _labelTitle.frame = CGRectInset(self.bounds, 10, 10);
    _preview.frame = self.bounds;
    _playerView.frame = self.bounds;
}

- (void)applyVideoItem:(VideoItem *)videoItem {
    self.labelTitle.text = videoItem.title;
    self.preview.image = videoItem.thumbnail;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (videoItem.thumbnail) {
        AVPlayerItem * playerItem = [[AVPlayerItem alloc] initWithURL:videoItem.localURL];
        self.playerView.player = [AVPlayer playerWithPlayerItem:playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector (videoPlayerItemDidReachEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
    }
    else {
        self.playerView.player = nil;
    }
}

- (void)videoPlayerItemDidReachEnd {
    [self startPlaying:YES];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self startPlaying:NO];
}

- (void)startPlaying:(BOOL)start {
    self.labelTitle.hidden = start;
    self.preview.hidden = start;
    self.playerView.hidden = !start;

    if (start) {
        [self.playerView.player seekToTime:kCMTimeZero];
        [self.playerView.player play];
    }
    else
        [self.playerView.player pause];
}

- (void)onTap {
    AVPlayer * player = self.playerView.player;
    if (player) {
        BOOL isPlaying = player.rate > 0 && player.error == nil;
        [self startPlaying:!isPlaying];
    }
}

@end