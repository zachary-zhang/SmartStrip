//
//  CommMultiselectView.m
//  SmartStrip
//
//  Created by john on 16/1/16.
//  Copyright © 2016年 张摇奖. All rights reserved.
//

#import "CommMultiselectView.h"

@implementation CommMultiselectView
{
    UIButton *doneBtn;
    NSArray *dataSoureArray;
    NSMutableArray * selectArray; ;
    NSMutableDictionary *stateDictionary;
}
-(void)prepareForContentSubView{
    contentView.height = 360;
    doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    doneBtn.right=self.width-10;
    doneBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setTitleColor:CommonBackgroundColor forState:UIControlStateNormal];
    doneBtn.titleLabel.font = defaultFont(18);
    [contentView addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    dataSoureArray = @[@"执行一次",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
    
    _zTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, doneBtn.bottom, self.width, 320)];
    _zTableView.delegate = self;
    _zTableView.dataSource = self;
    _zTableView.rowHeight = 40;
    _zTableView.scrollEnabled = NO;
    _zTableView.tableFooterView = [[UIView alloc]init];
    [contentView addSubview:_zTableView];
    stateDictionary = [NSMutableDictionary dictionary];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSoureArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:identifier];
        cell.textLabel.textColor = CommonBackgroundColor;
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    NSNumber *checked = [stateDictionary objectForKey:dataSoureArray[indexPath.row]];
    if (!checked)
        [stateDictionary setValue:(checked = [NSNumber numberWithBool:NO]) forKey:dataSoureArray[indexPath.row]];
    cell.accessoryType = [checked boolValue] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.text = dataSoureArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    NSString *key = cell.textLabel.text;
    BOOL isChecked = !([[stateDictionary objectForKey:key] boolValue]);
    NSNumber *checked = [NSNumber numberWithBool:isChecked];
    [stateDictionary setObject:checked forKey:key];
    cell.accessoryType = isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[tableView indexPathsForVisibleRows]];

    if (indexPath.row==0) {
        for (int i = 1; i < [anArrayOfIndexPath count]; i++) {
            NSIndexPath *index= [anArrayOfIndexPath objectAtIndex:i];
            isChecked=NO;
            NSNumber *checke = [NSNumber numberWithBool:isChecked];
            UITableViewCell * otherCell =[tableView cellForRowAtIndexPath:index];
            NSString *k = otherCell.textLabel.text;
            [stateDictionary setObject:checke forKey:k];
            otherCell.accessoryType =  UITableViewCellAccessoryNone;
        }        
    }
    else{
        for (int i = 0; i < 1; i++) {
            NSIndexPath *index= [anArrayOfIndexPath objectAtIndex:i];
            isChecked=NO;
            NSNumber *checke = [NSNumber numberWithBool:isChecked];
            UITableViewCell * otherCell =[tableView cellForRowAtIndexPath:index];
            NSString *k = otherCell.textLabel.text;
            [stateDictionary setObject:checke forKey:k];
            otherCell.accessoryType =  UITableViewCellAccessoryNone;
        }
    }
}
-(void)done
{
    selectArray = [NSMutableArray array];
    for (int i=0; i<stateDictionary.count; i++) {
        NSNumber* checked = stateDictionary.allValues[i];
        if (checked.intValue==1) {
            [selectArray addObject:stateDictionary.allKeys[i]];
        }
    }
    if ([self.delegate respondsToSelector:@selector(didSelectObjectWithArray:andTag:)]) {
        [self.delegate didSelectObjectWithArray:selectArray andTag:self.showTag ];
    }
    [self hide:YES];
    
}

@end
