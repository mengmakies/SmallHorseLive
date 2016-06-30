//
//  TestViewController.m
//  UCloudMediaRecorderDemo
//
//  Created by 江南孤鹜 on 16/6/21.
//  Copyright © 2016年 zmw. All rights reserved.
//

#import "TestViewController.h"
#import "UcCameraView.h"

@interface TestViewController ()
{
    UcCameraView *_cameraView;
}
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _cameraView = [[UcCameraView alloc] initWithStreamID:@"12345688"];
    _cameraView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100);
    [self.view addSubview:_cameraView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
