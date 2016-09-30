//
//  ViewController.m
//  MPVolumViewDemo
//
//  Created by 李少帅 on 16/9/30.
//  Copyright © 2016年 李少帅. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) MPVolumeView *mpVolumeView;

@property (nonatomic, strong) UISlider *mpVolumeSlider;

@property (nonatomic, strong) UISlider *volumeSlider;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playBackgroundMusic];
    
    if (!_mpVolumeView) {
        if (_mpVolumeView == nil) {
            _mpVolumeView = [[MPVolumeView alloc] init];
            
            for (UIView *view in [_mpVolumeView subviews]) {
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                    _mpVolumeSlider = (UISlider *)view;
                    break;
                }
            }
            [_mpVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
            [_mpVolumeView setShowsVolumeSlider:YES];
            [_mpVolumeView sizeToFit];
        }
    }
    
    UISlider *volumeSlider = [[UISlider alloc] init];
    volumeSlider.frame = CGRectMake(50, 100, self.view.frame.size.width - 100, 40);
    [volumeSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [volumeSlider addTarget:self action:@selector(touchupOutside:) forControlEvents:UIControlEventTouchUpInside];
    _volumeSlider = volumeSlider;
    [self.view addSubview:volumeSlider];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:pan];
    
}

-(void)panGesture:(UIPanGestureRecognizer *)pan {
    CGPoint velocity = [pan velocityInView:pan.view];
    CGFloat ratio = 13000.f;
    
    CGFloat nowVolumeValue = _mpVolumeSlider.value;
    float changeValue = (nowVolumeValue - velocity.y / ratio);
    
    [_mpVolumeView setHidden:YES];
    [_mpVolumeSlider setValue:changeValue animated:YES];
    [_mpVolumeSlider sendActionsForControlEvents:UIControlEventAllEvents];
    [_volumeSlider setValue:changeValue animated:YES];
}

- (void)valueChanged:(UISlider *)sender {
    
    [_mpVolumeView setHidden:NO];
    [self.view addSubview:_mpVolumeView];
    [_mpVolumeSlider setValue:sender.value animated:NO];
}

- (void)touchupOutside:(UISlider *)sender {
    [_mpVolumeView removeFromSuperview];
}

- (void)playBackgroundMusic {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"opening" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player = player;
    player.numberOfLoops = -1;
    player.volume = 0.5f;
    [player prepareToPlay];
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
