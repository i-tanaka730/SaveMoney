//
//  SaveMoneyAppDelegate.m
//  SaveMoney
//
//  Created by  on 12/06/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SaveMoneyAppDelegate.h"

#import "SaveMoneyViewController.h"

@implementation SaveMoneyAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[SaveMoneyViewController alloc] initWithNibName:@"SaveMoneyViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
