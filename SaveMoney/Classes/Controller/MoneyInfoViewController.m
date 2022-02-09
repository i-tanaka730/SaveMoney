//
//  MoneyInfoViewController.m
//  SaveMoney
//
//  Created by  on 12/06/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoneyInfoViewController.h"

@implementation MoneyInfoViewController

/**
 * インスタンス化時
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 * キャンセルボタン押下時
 */
- (IBAction)btnCancelClick:(id)sender
{
    // 画面を閉じる
	[self dismissModalViewControllerAnimated:YES];
}

//- (CGSize)contentSizeForViewInPopoverView
//{
//	return CGSizeMake(320, 324);
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Overriden to allow any orientation.
//    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad || interfaceOrientation == UIInterfaceOrientationPortrait;
//}

@end