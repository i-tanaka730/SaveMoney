//
//  CalendarViewControllerDelegate.h
//  Sorted
//
//  Created by Lloyd Bottomley on 30/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

@class SaveMoneyViewController;

@protocol CalendarViewControllerDelegate

- (void)calendarViewController:(SaveMoneyViewController *)aCalendarViewController dateDidChange:(NSDate *)aDate;

@end
