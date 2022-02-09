//
//  SaveMoneyViewController.m
//  SaveMoney
//
//  Created by  on 12/06/09.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SaveMoneyViewController.h"

@implementation SaveMoneyViewController

@synthesize calendarViewControllerDelegate;
@synthesize calendarLogic;
@synthesize calendarView;
@synthesize calendarViewNew;
@synthesize selectedDate;

/**
 * インスタンス化時
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Calendar", @"");
	self.view.bounds = CGRectMake(0, 0, 320, 324);
	self.view.clearsContextBeforeDrawing = NO;
	self.view.opaque = YES;
	self.view.clipsToBounds = NO;
	
	NSDate *aDate = selectedDate;
	if (aDate == nil) {
		aDate = [CalendarLogic dateForToday];
	}
	
	CalendarLogic *aCalendarLogic = [[CalendarLogic alloc] initWithDelegate:self referenceDate:aDate];
	self.calendarLogic = aCalendarLogic;
	[aCalendarLogic release];
	
	UIBarButtonItem *aClearButton = [[UIBarButtonItem alloc] 
									 initWithTitle:NSLocalizedString(@"Clear", @"") style:UIBarButtonItemStylePlain
									 target:self action:@selector(actionClearDate:)];
	self.navigationItem.rightBarButtonItem = aClearButton;
	[aClearButton release];
	
	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(0, 40, 320, 324) logic:calendarLogic];
	[aCalendarView selectButtonForDate:selectedDate];
	[self.view addSubview:aCalendarView];
	self.calendarView = aCalendarView;
	[aCalendarView release];
    
    // データベースとテーブルを作成する
    [self createDatabaseTable];
}

/**
 * インスタンス解放時
 */
- (void)dealloc
{
    [super dealloc];
	self.calendarLogic.calendarLogicDelegate = nil;
	self.calendarLogic = nil;
	self.calendarView = nil;
	self.calendarViewNew = nil;
	self.selectedDate = nil;
}

/**
 * データベースとテーブルを作成する
 */
- (void)createDatabaseTable
{
    BOOL success;
    NSError *error;	
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"money.db"];
    success = [fm fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"money.db"];
        success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if(!success){
            NSLog(@"err");
        }
    }
	
//    // DBに接続
//    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
//    if ([db open]) {
//        [db setShouldCacheStatements:YES];
//		
//        // INSERT
//        [db beginTransaction];
//        int i = 0;
//        while (i++ < 20) {
//            [db executeUpdate:@"INSERT INTO TEST (name) values (?)" , [NSString stringWithFormat:@"number %d", i]];			
//            if ([db hadError]) {
//                NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
//            }
//        }
//        [db commit];
//		
//        // SELECT
//        FMResultSet *rs = [db executeQuery:@"SELECT * FROM TEST"];
//        while ([rs next]) {
//            NSLog(@"%d %@", [rs intForColumn:@"id"], [rs stringForColumn:@"name"]);
//        }
//        [rs close];  
//        [db close];
//    }else{
//        NSLog(@"Could not open db.");
//    }    
    
//    // データベースを作成する
//    NSArray*    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString*   dir   = [paths objectAtIndex:0];
//    FMDatabase* db    = [FMDatabase databaseWithPath:[dir stringByAppendingPathComponent:@"money.db"]];
//    
//    // テーブルを作成する
//    NSString*   sql = @"CREATE TABLE IF NOT EXISTS money (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, name TEXT, money INTEGER);";
//    [db open];
//    [db executeUpdate:sql];
//    [db close];
}

- (void)actionClearDate:(id)sender
{
	self.selectedDate = nil;
	[calendarView selectButtonForDate:nil];
}

/**
 * 日付選択時
 */
- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate
{
    // 選択日付にする
	[selectedDate autorelease];
	selectedDate = [aDate retain];
	if ([calendarLogic distanceOfDateFromCurrentMonth:selectedDate] == 0) {
		[calendarView selectButtonForDate:selectedDate];
	}	
	[calendarViewControllerDelegate calendarViewController:self dateDidChange:aDate];
    
    // 詳細画面を表示する
    MoneyInfoViewController *moneyInfoViewController = [[MoneyInfoViewController alloc] initWithNibName:@"MoneyInfoViewController" bundle:nil];
    [self presentModalViewController:moneyInfoViewController animated:YES];
    [moneyInfoViewController release];    
}

/**
 * カレンダーの表示
 */
- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection
{
	BOOL animate = self.isViewLoaded;
	
	CGFloat distance = 320;
	if (aDirection < 0) {
		distance = -distance;
	}
    
	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(distance, 40, 320, 308) logic:aLogic];
	aCalendarView.userInteractionEnabled = NO;
	if ([calendarLogic distanceOfDateFromCurrentMonth:selectedDate] == 0) {
		[aCalendarView selectButtonForDate:selectedDate];
	}
	[self.view insertSubview:aCalendarView belowSubview:calendarView];
	
	self.calendarViewNew = aCalendarView;
	[aCalendarView release];
	
	if (animate) {
		[UIView beginAnimations:NULL context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationMonthSlideComplete)];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	calendarView.frame = CGRectOffset(calendarView.frame, -distance, 0);
	aCalendarView.frame = CGRectOffset(aCalendarView.frame, -distance, 0);
	
	if (animate) {
		[UIView commitAnimations];
		
	} else {
		[self animationMonthSlideComplete];
	}
}

/**
 * 月切り替え時のカレンダー表示
 */
- (void)animationMonthSlideComplete 
{
	[calendarView removeFromSuperview];
	self.calendarView = calendarViewNew;
	self.calendarViewNew = nil;    
    btnPrevMonth.enabled = YES;
	btnNextMonth.enabled = YES;
	calendarView.userInteractionEnabled = YES;
}

/**
 * 日付を設定する
 */
- (void)setSelectedDate:(NSDate *)aDate
{
	[selectedDate autorelease];
	selectedDate = [aDate retain];
	[calendarLogic setReferenceDate:aDate];
	[calendarView selectButtonForDate:aDate];
}

/**
 * 前月ボタン押下時
 */
- (IBAction)btnPrevMonthClick:(id)sender
{
    btnPrevMonth.enabled = NO;
	btnNextMonth.enabled = NO;
    [calendarLogic selectPreviousMonth];
}

/**
 * 次月ボタン押下時
 */
- (IBAction)btnNextMonthClick:(id)sender
{
    btnPrevMonth.enabled = NO;
	btnNextMonth.enabled = NO;
    [calendarLogic selectNextMonth];
}

/**
 *登録ボタン押下時
 */
- (IBAction)btnRegistClick:(id)sender
{
    // アラートの作成
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"\n\n\n"
                                                   delegate:self 
                                          cancelButtonTitle:@"登録" 
                                          otherButtonTitles:@"キャンセル", nil];
    // 名前ラベル
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 20.0, 80.0, 25.0)];
    [lblName setTextColor:[UIColor whiteColor]];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [lblName setText:@"項目名"];
    [alert addSubview:lblName];
    [lblName release];

    // 金額ラベル
    UILabel *lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 55.0, 80.0, 25.0)];
    [lblMoney setTextColor:[UIColor whiteColor]];
    [lblMoney setBackgroundColor:[UIColor clearColor]];
    [lblMoney setText:@"金額"];
    [alert addSubview:lblMoney];
    [lblMoney release];
    
    // 名前テキスト
    UITextField *txtName = [[UITextField alloc] initWithFrame:CGRectMake(80.0, 20.0, 180.0, 22.0)];
    [txtName setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:txtName];
    [txtName becomeFirstResponder];
    [txtName release];

    // 金額テキスト    
    UITextField *txtMoney = [[UITextField alloc] initWithFrame:CGRectMake(80.0, 55.0, 180.0, 22.0)];
    [txtMoney setBackgroundColor:[UIColor whiteColor]];
    [alert addSubview:txtMoney];
    [txtMoney release];

    // アラート表示
    [alert show];
    [alert release];
}

/**
 * アラートのボタン押下時
 */
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            // OKボタン押下時
            // インサート文
            
            break;
    }
    
}

@end
