//
//  CommDatePickView.m
//  lovewith
//
//  Created by imqiuhang on 15/5/6.
//  Copyright (c) 2015年 lovewith.me. All rights reserved.
//

#import "CommDatePickView.h"

@implementation CommDatePickView
{
    UIButton *doneBtn;
    UIDatePicker *timeDataPick;
    BOOL isDataAndTime;
    
}

- (void)setAsDateAndTime {
    timeDataPick = [[UIDatePicker alloc] init];
    timeDataPick.datePickerMode      = UIDatePickerModeDateAndTime;
    timeDataPick.width = timeDataPick.width-20;
    self.dataPickView.datePickerMode = UIDatePickerModeDateAndTime;
    self.dataPickView.width          = screenWidth-50;
    timeDataPick.height              = self.dataPickView.height;
    timeDataPick.top                 = self.dataPickView.top;
    timeDataPick.left                = self.dataPickView.right-40;
    timeDataPick.width               = 100;
    isDataAndTime = YES;
    [contentView addSubview:timeDataPick ];
}

- (void)prepareForContentSubView {
    contentView.height =250.0;
    doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    doneBtn.right=self.width-10;
    doneBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:CommonBackgroundColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = defaultFont(18);
    [contentView addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.dataPickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0 , doneBtn.bottom, self.width, 200)];
    self.dataPickView.datePickerMode = UIDatePickerModeTime;
    [self.dataPickView setTimeZone:[NSTimeZone defaultTimeZone]];
    [contentView addSubview:self.dataPickView];

}

- (void)done {
    NSDate *date;
    if (isDataAndTime) {

          NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
         NSCalendar *calendar = [NSCalendar currentCalendar];
        
         NSDateComponents *dateComponentsDate = [calendar components:unitFlags fromDate:self.dataPickView.date];

        
        NSDateComponents *calendarTime = [calendar components:unitFlags fromDate:timeDataPick.date];
        
        [dateComponentsDate setHour:calendarTime.hour ];
        [dateComponentsDate setMinute:calendarTime.minute];

        date = [calendar dateFromComponents:dateComponentsDate];

    }else {
        date = self.dataPickView.date;
    }
    if ([self.delagate respondsToSelector:@selector(didPickDataWithDate:andTag:)]) {
        [self.delagate didPickDataWithDate:date andTag:self.showTag ];
    }
    [self hide:YES];
}
/**
 *  重写父类的方法
 *
 *  @param animation <#animation description#>
 */
-(void)hide:(BOOL)animation
{
    [super hide:animation];
    NSDate *date;
    date = self.dataPickView.date;
    if ([self.delagate respondsToSelector:@selector(didPickDataWithDate:andTag:)]) {
        [self.delagate didPickDataWithDate:date andTag:self.showTag ];
    }
}
@end
