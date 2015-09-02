//
//  AppDelegate.m
//  CommonFrame_Pro
//
//  Created by ionitech on 15/5/22.
//  Copyright (c) 2015年 ionitech. All rights reserved.
//

#import "AppDelegate.h"
#import "ICPersonalInfoViewController.h"
#import <SlideNavigationController.h>
//#import <AVOSCloud/AVOSCloud.h>
#import "UICommon.h"
#import "ICMainViewController.h"
#import "ICWorkingDetailViewController.h"
#import "APService.h"

@interface AppDelegate ()
{
    NSString * _workGroupId;
    NSString * _taskId;
    NSString * _currentTag;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

     
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
    
    //ICPersonalInfoViewController* leftMenu = (ICPersonalInfoViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"ICPersonalInfoViewController"];
    
    //[SlideNavigationController sharedInstance].leftMenu = leftMenu;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /*
     UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
     [button setImage:[UIImage imageNamed:@"gear"] forState:UIControlStateNormal];
     [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
     [SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidClose object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Closed %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidOpen object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Opened %@", menu);
     }];
     
     [[NSNotificationCenter defaultCenter] addObserverForName:SlideNavigationControllerDidReveal object:nil queue:nil usingBlock:^(NSNotification *note) {
     NSString *menu = note.userInfo[@"menu"];
     NSLog(@"Revealed %@", menu);
     }];
     
     */
    
    /*
    //leancloud
    [AVOSCloud setApplicationId:@"8XDxjHTxkM2pCCOhgs39qwno"
                      clientKey:@"EchvO498r256FWNfuFlGmkqe"];
    if([UICommon getSystemVersion] < 8.0)
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    else
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                | UIUserNotificationTypeBadge
                                                | UIUserNotificationTypeSound
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
     */
    
//    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    return YES;
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required
    [APService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);

    int type = [[userInfo valueForKey:@"type"] intValue];
    
    NSString * sourceId = [userInfo objectForKey:@"sourceId"];
    NSString * mainStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

    // 1 任务  2：分享  3通知  4申请 5问题  6加入工作组  7：评论 8:建议
    switch (type) {
        case 6:
            
            _workGroupId = sourceId;
            
            if(_workGroupId.length)
            {
                if (application.applicationState == UIApplicationStateActive) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:mainStr
                                                                   delegate:self
                                                          cancelButtonTitle:@"关闭"
                                                          otherButtonTitles:@"查看", nil];
                    alert.tag = type;
                    [alert show];
                }
                else if (application.applicationState == UIApplicationStateInactive)
                {
                    [self jumpToMainView:_workGroupId];
                }
            }

            break;
        default:
            
            _taskId = sourceId;
            
            if(_taskId.length)
            {
                if (application.applicationState == UIApplicationStateActive) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:mainStr
                                                                   delegate:self
                                                          cancelButtonTitle:@"关闭"
                                                          otherButtonTitles:@"查看", nil];
                    alert.tag = type;
                    [alert show];
                }
                else if (application.applicationState == UIApplicationStateInactive)
                {
                    [self jumpToMissionDetail:_taskId];
                }
            }

            break;
    }
    
    /*
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    
    if ([[userInfo objectForKey:@"inviteToGroup"] isEqualToString:@"inviteToGroup"]) {
        
        _currentTag = @"inviteToGroup";
        _workGroupId = [numberFormatter stringFromNumber:[userInfo objectForKey:@"workGroupId"]];
        if(_workGroupId.length)
        {
            NSString * alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];

            if (application.applicationState == UIApplicationStateActive) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertStr
                                                               delegate:self
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:@"查看", nil];
                [alert show];
            }
            else if (application.applicationState == UIApplicationStateInactive)
            {
                [self jumpToMainView:_workGroupId];
            }
        }

    }
    else if ([[userInfo objectForKey:@"missionNotify"] isEqualToString:@"missionNotify"]) {
        
        _currentTag = @"missionNotify";

        _taskId = [numberFormatter stringFromNumber:[userInfo objectForKey:@"taskId"]];
        if(_taskId.length)
        {
            NSString * alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            
            if (application.applicationState == UIApplicationStateActive) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:alertStr
                                                               delegate:self
                                                      cancelButtonTitle:@"关闭"
                                                      otherButtonTitles:@"查看", nil];
                [alert show];
            }
            else if (application.applicationState == UIApplicationStateInactive)
            {
                [self jumpToMissionDetail:_taskId];
            }
        }
        
    }
    */
}

- (void) jumpToMissionDetail:(NSString *)taskId
{
    UIStoryboard* mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [mainStory instantiateViewControllerWithIdentifier:@"ICWorkingDetailViewController"];
    ((ICWorkingDetailViewController*)vc).taskId = taskId;
    
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:vc animated:YES];
}

- (void) jumpToMainView:(NSString *)workGroupId
{
    UIStoryboard* mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [mainStory instantiateViewControllerWithIdentifier:@"ICMainViewController"];
    ((ICMainViewController*)vc).pubGroupId = workGroupId;
    
    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
    [nav pushViewController:vc animated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        /*
        if([_currentTag isEqualToString:@"inviteToGroup"])
        {
            [self jumpToMainView:_workGroupId];
        }
        else if ([_currentTag isEqualToString:@"missionNotify"])
        {
            [self jumpToMissionDetail:_taskId];
        }*/
        
        if(alertView.tag == 6)
        {
            [self jumpToMainView:_workGroupId];
        }
        else
        {
            [self jumpToMissionDetail:_taskId];
        }
    }
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSInteger num=application.applicationIconBadgeNumber;
    if(num!=0)
    {
        [application setApplicationIconBadgeNumber:0];
        [APService setBadge:0];
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSInteger num=application.applicationIconBadgeNumber;
    if(num!=0)
    {
        [application setApplicationIconBadgeNumber:0];
        [APService setBadge:0];
        [application cancelAllLocalNotifications];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /*
    int num=application.applicationIconBadgeNumber;
    if(num!=0){
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveEventually];
        application.applicationIconBadgeNumber=0;
    }
    [application cancelAllLocalNotifications];
     */
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /*
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
     */
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败，无法获取设备 ID, 具体错误: %@", error);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSInteger num=application.applicationIconBadgeNumber;
    if(num!=0)
    {
        [application setApplicationIconBadgeNumber:0];
        [APService setBadge:0];
    }
}

@end
