//
//  SaveMoneyViewController.h
//  SaveMoney
//
//  Created by  on 12/06/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "CalendarLogic.h"
#import "CalendarMonth.h"
#import "CalendarLogicDelegate.h"
#import "CalendarViewControllerDelegate.h"
#import "MoneyInfoViewController.h"

@interface SaveMoneyViewController : UIViewController
<UIAlertViewDelegate, UITextFieldDelegate, CalendarLogicDelegate>
{
    id <CalendarViewControllerDelegate> calendarViewControllerDelegate;
    CalendarLogic *calendarLogic;
	CalendarMonth *calendarView;
	CalendarMonth *calendarViewNew;
	NSDate *referenceDate;
    
	IBOutlet UIBarButtonItem *btnPrevMonth;
	IBOutlet UIBarButtonItem *btnNextMonth;
}

@property (nonatomic, assign) id <CalendarViewControllerDelegate> calendarViewControllerDelegate;
@property (nonatomic, retain) CalendarLogic *calendarLogic;
@property (nonatomic, retain) CalendarMonth *calendarView;
@property (nonatomic, retain) CalendarMonth *calendarViewNew;
@property (nonatomic, retain) NSDate *selectedDate;

- (void)animationMonthSlideComplete;
- (void)createDatabaseTable;
- (IBAction)btnRegistClick:(id)sender;
- (IBAction)btnPrevMonthClick:(id)sender;
- (IBAction)btnNextMonthClick:(id)sender;

@end
