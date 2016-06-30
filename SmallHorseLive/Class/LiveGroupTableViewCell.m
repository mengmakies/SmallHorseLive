//
//  LiveGroupTableViewCell.m
//  UCloudDemo
//
//  Created by 江南孤鹜 on 16/6/27.
//  Copyright © 2016年 Martin. All rights reserved.
//

#import "LiveGroupTableViewCell.h"

@interface LiveGroupTableViewCell()
{
    __weak IBOutlet UIImageView *imgAvatar;
    __weak IBOutlet UILabel *_lblGroupName;
    
    __weak IBOutlet UILabel *_lblOwnerName;
    __weak IBOutlet UILabel *_lblMemberCount;
    __weak IBOutlet UILabel *_lblIsOwner;
}
@end

@implementation LiveGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setGroupData:(EMGroup *)groupData{
    
    EMError *error = nil;
    EMGroup *groupDetail = [[EMClient sharedClient].groupManager fetchGroupInfo:groupData.groupId includeMembersList:YES error:&error];
    if (!error) {
        _lblGroupName.text = groupDetail.subject;
        _lblOwnerName.text = [NSString stringWithFormat:@"主播：%@", groupDetail.owner];
        _lblMemberCount.text = [NSString stringWithFormat:@"直播间人数：%ld", [groupDetail.occupants count]];
        
        NSString *userName = [EMClient sharedClient].currentUsername;
        _lblIsOwner.hidden = ![userName isEqualToString:groupDetail.owner];
    }
}

@end
