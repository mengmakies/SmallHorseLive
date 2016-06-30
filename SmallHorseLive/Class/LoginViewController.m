//
//  LoginViewController.m
//  UCloudDemo
//
//  Created by 江南孤鹜 on 16/6/28.
//  Copyright © 2016年 Martin. All rights reserved.
//

#import "LoginViewController.h"
#import "UserCacheManager.h"
#import "ChatUIHelper.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *_tfdUserName;
@property (weak, nonatomic) IBOutlet UITextField *_tfdUserPwd;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doLogin:(id)sender {
    NSString *userName = __tfdUserName.text;
    NSString *pwd = __tfdUserPwd.text;
    
    [self showHudInView:self.view hint:@"Loading..."];
    [[EMClient sharedClient] asyncLoginWithUsername:userName password:pwd success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            // 保存用户信息
            [UserCacheManager saveInfo:userName imgUrl:@"http://avatar.csdn.net/A/2/1/1_mengmakies.jpg" nickName:userName];
            
            //设置是否自动登录
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            [[ChatUIHelper shareHelper] asyncGroupFromServer];
            [[ChatUIHelper shareHelper] asyncConversationFromDB];
            [[ChatUIHelper shareHelper] asyncPushOptions];
            
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
    } failure:^(EMError *aError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideHud];
            
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@""
                                                           message:aError.errorDescription
                                                          delegate:nil
                                                 cancelButtonTitle:@"ok"
                                                 otherButtonTitles:nil];
            [alert show];
            
            [self showHint:aError.errorDescription];
            NSLog(@"登录报错了：%@",aError.errorDescription);
        });
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
