//
//  Group.m
//  CommonFrame_Pro
//
//  Created by ionitech on 15/7/15.
//  Copyright (c) 2015年 ionitech. All rights reserved.
//

#import "Group.h"

#define CURL                @"/index/findIndexMessageNum.hz"
#define WORKLIST_URL        @"/workgroup/findMeWgList.hz"
#define INVITE_URL          @"/workgroup/inviteUserList.hz"
#define NEW_GROUP           @"/workgroup/addWorkgroup.hz"
#define DETAIL_URL          @"/workgroup/intoWorkgroupDetail.hz"
#define UPDATE_URL          @"/workgroup/updateWorkgroup.hz"
#define WORKLIST_SETTING_URL  @"/workgroup/findMeWgMessageList.hz"
#define UPDATE_GROUP_SETT_URL @"/workgroup/updateWgSubscribeStatus.hz"

@implementation Group

+ (NSArray*)getGroupsByUserID:(NSString*)userID marks:(NSArray**)markArray workGroupId:(NSString *)workGroupId searchString:(NSString*)str allNum:(NSString **)allNum
{
    NSMutableArray* array = [NSMutableArray array];
    NSMutableArray* marks = [NSMutableArray array];
    
    NSData* responseString = [HttpBaseFile requestDataWithSync:[NSString stringWithFormat:@"%@?userId=%@&workGroupId=%@%@",CURL,userID, workGroupId, (str == nil ? @"" : [NSString stringWithFormat:@"&str=%@",str])]];
    
    if (responseString == nil) {
        return array;
    }
    id val = [CommonFile jsonNSDATA:responseString];
    
    NSString * allNumStr = @"";
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                
                id dataDic = [dic valueForKey:@"data"];
                
                if ([dataDic isKindOfClass:[NSDictionary class]])
                {
                    allNumStr = [dataDic valueForKey:@"allNum"];
                    
                    id dataArr = [dataDic valueForKey:@"wglist"];
                    if ([dataArr isKindOfClass:[NSArray class]])
                    {
                        NSArray* dArr = (NSArray*)dataArr;
                        
                        for (id data in dArr) {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                NSDictionary* di = (NSDictionary*)data;
                                
                                Group* cm = [Group new];
                                
                                cm.messageCount = [NSString stringWithFormat:@"%d",[[di valueForKey:@"num"] intValue]];
                                cm.workGroupImg = [di valueForKey:@"workGroupImg"];
                                cm.isAdmin = [[di valueForKey:@"isAdmin"] boolValue];
                                cm.workGroupId = [di valueForKey:@"workGroupId"];
                                cm.workGroupName = [di valueForKey:@"workGroupName"];
                                cm.workGroupMain = [di valueForKey:@"workGroupMain"];
                                
                                [array addObject:cm];
                                
                            }
                        }
                        
                    }
                    
                    
                    id markArr = [dataDic valueForKey:@"sortlist"];
                    if ([markArr isKindOfClass:[NSArray class]])
                    {
                        NSArray* dArr = (NSArray*)markArr;
                        NSArray *imageList = @[@"icon_youshijian", @"icon_youfabu",@"icon_youhuifu", @"icon_you7", @"icon_you30",@"icon_you365",@"icon_fabu", @"icon_renwu", @"icon_wenti", @"icon_jianyi", @"icon_qita", @"icon_youbiaoqian_1"];
                        
                        NSMutableArray * timeArr = [NSMutableArray array];
                        NSMutableArray * missionArr = [NSMutableArray array];
                        NSMutableArray * tagArr = [NSMutableArray array];

                        NSMutableArray * totalArr = [NSMutableArray array];
                        
                        int i = 0;
                        
                        for (id data in dArr) {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                NSDictionary* di = (NSDictionary*)data;
                                
                                Mark* m = [Mark new];
                                
                                if ([di valueForKey:@"indexSortName"] != nil) {
                                    NSString* markName = [di valueForKey:@"indexSortName"];
                                    m.labelName = markName;
                                    m.labelId = [di valueForKey:@"indexSortId"];
                                    m.labelImage = [imageList objectAtIndex:i];
                                    
                                    if(i >= 0 && i <= 5)
                                    {
                                        [timeArr addObject:m];
                                    }
                                    else if (i >= 6 && i <= 10)
                                    {
                                        [missionArr addObject:m];
                                    }
                                    else
                                    {
                                        [tagArr addObject:m];
                                    }
                                }
                                else if ([di valueForKey:@"labelName"] != nil)
                                {
                                    NSString* markName = [di valueForKey:@"labelName"];
                                    
                                    m.labelName = markName;
                                    m.labelId = [di valueForKey:@"labelId"];
                                    m.labelImage = @"icon_youbiaoqian_1";
                                    [tagArr addObject:m];
//                                    [marks addObject:m];
                                }
                            }
                            i ++;
                        }
                        
                        [totalArr addObject:tagArr];
                        [totalArr addObject:timeArr];
                        [totalArr addObject:missionArr];
                        
                        [marks addObject:totalArr];
                    }
                }
            }
        }
        
    }
    
    *markArray = marks;
    
    *allNum = allNumStr;
    
    return array;
}

+ (NSArray*)getWorkGroupListByUserID:(NSString*)userID selectArr:(NSMutableArray **)selectArr
{
    NSMutableArray* array = [NSMutableArray array];
    
    NSMutableArray * selArr = [NSMutableArray array];
    
//    NSString* responseString = [HttpBaseFile requestDataWithSync:[NSString stringWithFormat:@"%@?userId=%@",WORKLIST_URL,userID]];
    
    NSData* responseString = [HttpBaseFile requestDataWithSync:[NSString stringWithFormat:@"%@?userId=%@",WORKLIST_SETTING_URL,userID]];
    
    if (responseString == nil) {
        return array;
    }
    id val = [CommonFile jsonNSDATA:responseString];
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                
                id dataDic = [dic valueForKey:@"data"];
                
                if ([dataDic isKindOfClass:[NSArray class]])
                {
                    NSArray* dArr = (NSArray*)dataDic;
                    
                    for (id data in dArr) {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            
                            NSDictionary* di = (NSDictionary*)data;
                            
                            Group* cm = [Group new];
                            
                            cm.messageCount = [NSString stringWithFormat:@"%d",[[di valueForKey:@"num"] intValue]];
                            cm.workGroupImg = [di valueForKey:@"workGroupImg"];
                            cm.workGroupId = [di valueForKey:@"workGroupId"];
                            cm.workGroupName = [di valueForKey:@"workGroupName"];
                            cm.workGroupMain = [di valueForKey:@"workGroupMain"];
                            cm.isAdmin = [[di valueForKey:@"isAdmin"] boolValue];
                            cm.isReceive = [[di valueForKey:@"status"] boolValue];
                            
                            if(cm.isReceive)
                            {
                                [selArr addObject:cm];
                            }
                            [array addObject:cm];
                            
                            
                        }
                    }
                    
                }
                
            }
        }
        
    }
    
    *selectArr = selArr;
    
    return array;
}

+ (BOOL)inviteNewUser:(NSString*)loginUserId workGroupId:(NSString*)workGroupId source:(NSInteger)source sourceValue:(NSString*)sourceStr
{
    BOOL isOk = NO;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];

    [dic setObject:loginUserId forKey:@"userId"];
    [dic setObject:workGroupId forKey:@"workGroupId"];
    [dic setObject:@"0" forKey:@"source"];//  0:单位通讯录添加   1：短信邀请   2：邮件   3：工作组通讯录
    [dic setObject:sourceStr forKey:@"sourceStr"];
     [dic setObject:@"2" forKey:@"platform"];
    
    NSData* responseString = [HttpBaseFile requestDataWithSyncByPost:INVITE_URL postData:dic];
    
    if (responseString == nil) {
        return isOk;
    }
    
    id val = [CommonFile jsonNSDATA:responseString];
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                isOk = YES;
                NSLog(@"Dic:%@",dic);
            }
        }
        
    }
    
    return isOk;
}

+ (BOOL)createNewGroup:(NSString*)workGroupName description:(NSString*)workGroupMain groupImage:(NSString*)img workGroupId:(NSString **)workGroupId
{
    BOOL isOk = NO;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    NSString* userId = [LoginUser loginUserID];
    
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:workGroupName forKey:@"workGroupName"];
    [dic setObject:workGroupMain forKey:@"workGroupMain"];
    [dic setObject:img forKey:@"img"];
    [dic setObject:@"1015050511520001" forKey:@"orgId"];
    
    NSData* responseString = [HttpBaseFile requestDataWithSyncByPost:NEW_GROUP postData:dic];
    
    if (responseString == nil) {
        return isOk;
    }
    
    id val = [CommonFile jsonNSDATA:responseString];
    
    NSString * wgId = @"";
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                isOk = YES;
                NSLog(@"Dic:%@",dic);
                
                NSDictionary * dicc = [dic objectForKey:@"data"];
                
                wgId = [dicc valueForKey:@"workGroupId"];
            }
        }
        
    }
    
    *workGroupId = wgId;
    
    return isOk;
}

+ (BOOL)updateGroup:(NSString*)wgid name:(NSString*)workGroupName description:(NSString*)workGroupMain groupImage:(NSString*)img
{
    BOOL isOk = NO;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    NSString* userId = [LoginUser loginUserID];
    
    [dic setObject:userId forKey:@"userId"];
    [dic setObject:workGroupName forKey:@"workGroupName"];
    [dic setObject:workGroupMain forKey:@"workGroupMain"];
    [dic setObject:img forKey:@"img"];
    [dic setObject:wgid forKey:@"workGroupId"];
    
    NSData* responseString = [HttpBaseFile requestDataWithSyncByPost:UPDATE_URL postData:dic];
    
    if (responseString == nil) {
        return isOk;
    }
    
    id val = [CommonFile jsonNSDATA:responseString];
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                isOk = YES;
                NSLog(@"Dic:%@",dic);
            }
        }
        
    }
    
    return isOk;
}

+ (NSDictionary*)groupDicByWorkGroupId:(NSString*)workGroupId isAdmin:(NSString**)admin
{
    NSDictionary* dict = [NSDictionary dictionary];
    NSString* isAdmin = @"";
    
    NSData* responseString = [HttpBaseFile requestDataWithSync:[NSString stringWithFormat:@"%@?workGroupId=%@&userId=%@",DETAIL_URL,workGroupId,[LoginUser loginUserID]]];
    
    if (responseString == nil) {
        return dict;
    }
    id val = [CommonFile jsonNSDATA:responseString];
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                
                id dataDic = [dic valueForKey:@"data"];
                
                if ([dataDic isKindOfClass:[NSDictionary class]])
                {
                    dict = (NSDictionary *)dataDic;
                    
                    if ([dict valueForKey:@"isAdmin"] != nil) {
                        isAdmin = [dict valueForKey:@"isAdmin"];
                    }
                }
                
            }
        }
        
    }
    
    *admin = isAdmin;
    
    return dict;
}

+ (BOOL)updateWgSubscribeStatus:(NSString *)groupId isReceive:(BOOL) isReceive
{
    BOOL isOk = NO;
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    NSString* userId = [LoginUser loginUserID];
    
    [dic setObject:userId forKey:@"userId"];
    NSString * status = @"1";
    if(!isReceive)
    {
        status = @"0";
    }
    [dic setObject:status forKey:@"status"];
    [dic setObject:groupId forKey:@"workGroupId"];
    
    NSData* responseString = [HttpBaseFile requestDataWithSyncByPost:UPDATE_GROUP_SETT_URL postData:dic];
    
    if (responseString == nil) {
        return isOk;
    }
    
    id val = [CommonFile jsonNSDATA:responseString];
    
    if ([val isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = (NSDictionary*)val;
        
        if (dic != nil) {
            if ([[dic valueForKey:@"state"] intValue] == 1) {
                isOk = YES;
                NSLog(@"Dic:%@",dic);
            }
        }
        
    }
    
    return isOk;

}

@end
