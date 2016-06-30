//
//  UcCameraView.h
//  ChatDemo-UI3.0
//
//  Created by 江南孤鹜 on 16/6/17.
//  Copyright © 2016年 江南孤鹜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UcCameraView : UIView
@property (strong, nonatomic) PlayerManager *playerManager;

- (id)initWithStreamID:(NSString*)streamID;

-(void)startRecord;
-(void)stopRecord;

// 开始播放
-(void)startPlay;
@end
