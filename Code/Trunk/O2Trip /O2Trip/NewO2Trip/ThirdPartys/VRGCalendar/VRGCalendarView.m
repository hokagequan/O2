//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"
#import "GridView.h"

@implementation VRGCalendarMarkInfo

- (UIView *)gridView:(CGPoint)position size:(CGSize)size {
    GridView *view = [GridView loadFromNib];
    
    NSString *name = @"calendar_mark_stock";
    view.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)self.stock];
    if (self.stock == 0) {
        name = @"calendar_mark_nostock";
        view.quantityLabel.text = @"";
    }
    
    view.markImageView.image = [UIImage imageNamed:name];
    view.daylabel.text = [NSString stringWithFormat:@"%ld", (long)self.day];
    view.frame = CGRectMake(position.x, position.y, size.width, size.height);
    
    return view;
}

@end

@interface VRGCalendarView()

@property (strong, nonatomic) UIButton *leftArrowButton;
@property (strong, nonatomic) UIButton *rightArrowButton;

@property (strong, nonatomic) NSMutableArray *markViews;
@property (strong, nonatomic) NSArray *infos;
@property (strong, nonatomic) UIImageView *selectedMarkImageView;

@end

@implementation VRGCalendarView
@synthesize currentMonth,delegate,labelCurrentMonth, animationView_A,animationView_B;
@synthesize markedDates,markedColors,calendarHeight,selectedDate;

#pragma mark - Select Date
-(void)selectDate:(int)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    NSDate *selectDate = [gregorian dateFromComponents:comps];
    
    comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *today = [gregorian dateFromComponents:comps];
    
    if ([selectDate compare:today] == NSOrderedAscending) {
        return;
    }
    
    self.selectedDate = selectDate;
    
    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];
    
//    if (selectedDateYear < currentMonthYear) {
//        [self showPreviousMonth];
//    } else if (selectedDateYear > currentMonthYear) {
//        [self showNextMonth];
//    } else if (selectedDateMonth < currentMonthMonth) {
//        [self showPreviousMonth];
//    } else if (selectedDateMonth > currentMonthMonth) {
//        [self showNextMonth];
//    } else {
//        [self setNeedsDisplay];
//    }
    [self setNeedsDisplay];
    
    if ([delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [delegate calendarView:self dateSelected:self.selectedDate];
}

#pragma mark - Mark Dates
//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[dates count]; i++) {
        [colors addObject:[UIColor colorWithHexString:@"0x383838"]];
    }
    
    self.markedColors = [NSArray arrayWithArray:colors];
    
    [self setNeedsDisplay];
}

//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors {
    self.markedDates = dates;
    self.markedColors = colors;
    
    [self setNeedsDisplay];
}

#pragma mark - Set date to now
-(void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: [NSDate date]];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month
    
    [self updateSize];
    [self setNeedsDisplay];
    [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
}

#pragma mark - Next & Previous
-(void)showNextMonth {
    if (isAnimating) return;
    self.markedDates=nil;
    isAnimating=YES;
    prepAnimationNextMonth=YES;
    
    [self setNeedsDisplay];
    
    int lastBlock = [currentMonth firstWeekDayInMonth]+[currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    //Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //New month
    self.currentMonth = [currentMonth offsetMonth:1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationNextMonth=NO;
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    //Animate
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasNextMonthDays) {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - (kVRGCalendarViewDayHeight+3);
    } else {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight -3;
    }
    
    //Animation
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameY = -animationView_A.frameHeight + kVRGCalendarViewDayHeight+3;
                         } else {
                             animationView_A.frameY = -animationView_A.frameHeight + 3;
                         }
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}

-(void)showPreviousMonth {
    if (isAnimating) return;
    isAnimating=YES;
    self.markedDates=nil;
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth]>1;
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //Prepare next screen
    self.currentMonth = [currentMonth offsetMonth:-1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationPreviousMonth=NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];
    
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasPreviousDays) {
        animationView_B.frameY = animationView_A.frameY - (animationView_B.frameHeight-kVRGCalendarViewDayHeight) + 3;
    } else {
        animationView_B.frameY = animationView_A.frameY - animationView_B.frameHeight + 3;
    }
    
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0
                     animations:^{
                         [self updateSize];
                         
                         if (hasPreviousDays) {
                             animationView_A.frameY = animationView_B.frameHeight-(kVRGCalendarViewDayHeight+3); 
                             
                         } else {
                             animationView_A.frameY = animationView_B.frameHeight-3;
                         }
                         
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}


#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

-(float)calendarHeight {
    return kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
}

-(int)numRows {
//    float lastBlock = [self.currentMonth numDaysInMonth]+([self.currentMonth firstWeekDayInMonth]-1);
//    return ceilf(lastBlock/7);
    
    return 6;
}

#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{       
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    self.selectedDate=nil;
    
    //Touch a specific day
    if (touchPoint.y > kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-kVRGCalendarViewTopBarHeight;
        
        int column = floorf(xLocation/(kVRGCalendarViewDayWidth+2));
        int row = floorf(yLocation/(kVRGCalendarViewDayHeight+2));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        return;
    }
    
    self.markedDates=nil;
    self.markedColors=nil;  
    
    CGRect rectArrowLeft = CGRectMake(0, 0, 50, 40);
    CGRect rectArrowRight = CGRectMake(self.frame.size.width-50, 0, 50, 40);
    
    //Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(self.labelCurrentMonth.frame, touchPoint)) {
        //Detect touch in current month
        int currentMonthIndex = [self.currentMonth month];
        int todayMonth = [[NSDate date] month];
        [self reset];
        if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMMM yyyy"];
//    labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    labelCurrentMonth.text = [NSString stringWithFormat:@"%ld年%ld月", (long)[self.currentMonth year], (long)[self.currentMonth month]];
    [labelCurrentMonth sizeToFit];
    labelCurrentMonth.frameX = roundf(self.frame.size.width/2 - labelCurrentMonth.frameWidth/2);
    labelCurrentMonth.frameY = 10;
    [currentMonth firstWeekDayInMonth];
    
    // Arrows
    self.leftArrowButton.frame = CGRectMake(labelCurrentMonth.frame.origin.x - 26 - self.leftArrowButton.bounds.size.width,
                                            labelCurrentMonth.frame.origin.y + labelCurrentMonth.bounds.size.height / 2 - self.leftArrowButton.bounds.size.height / 2, self.leftArrowButton.bounds.size.width,
                                            self.leftArrowButton.bounds.size.height);
    self.rightArrowButton.frame = CGRectMake(labelCurrentMonth.frame.origin.x + labelCurrentMonth.bounds.size.width + 26,
                                             labelCurrentMonth.frame.origin.y + labelCurrentMonth.bounds.size.height / 2 - self.rightArrowButton.bounds.size.height / 2, self.rightArrowButton.bounds.size.width,
                                             self.rightArrowButton.bounds.size.height);
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    //Weekdays
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat=@"EEE";
    //always assume gregorian with monday first
//    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    NSMutableArray *weekdays = [@[@"日", @"一", @"二", @"三", @"四", @"五", @"六"] mutableCopy];
    [weekdays moveObjectFromIndex:0 toIndex:6];
    
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithHexString:@"0x303030"].CGColor);
    for (int i =0; i<[weekdays count]; i++) {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [weekdayValue drawInRect:CGRectMake(i*(kVRGCalendarViewDayWidth), 10, kVRGCalendarViewDayWidth, 20) withFont:font lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
    
    int numRows = [self numRows];
    
    CGContextSetAllowsAntialiasing(context, NO);
    
    //Grid background
    float gridHeight = numRows*(kVRGCalendarViewDayHeight);
    CGRect rectangleGrid = CGRectMake(0,kVRGCalendarViewTopBarHeight,self.frame.size.width,self.frame.size.height);
    CGContextAddRect(context, rectangleGrid);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0xff0000"].CGColor);
    CGContextFillPath(context);
    
    //Grid white lines
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+1);
//    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+1);
//    for (int i = 1; i<7; i++) {
//        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight);
//        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight+gridHeight);
//        
//        if (i>numRows-1) continue;
//        //rows
//        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
//        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
//    }
    
    CGContextStrokePath(context);
    
    //Grid dark lines
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"0xf0f0f0"].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight);
    for (int i = 0; i<=7; i++) {
        //columns
        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth), kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth), kVRGCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight));
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight));
    }
    CGContextMoveToPoint(context, 0, gridHeight+kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, gridHeight+kVRGCalendarViewTopBarHeight);
    
    CGContextStrokePath(context);
    
    CGContextSetAllowsAntialiasing(context, YES);
    
    //Draw days
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithHexString:@"0xeeeeee"].CGColor);
    
    
    //NSLog(@"currentMonth month = %i, first weekday in month = %i",[self.currentMonth month],[self.currentMonth firstWeekDayInMonth]);
    
    int numBlocks = numRows*7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    int currentMonthNumDays = [currentMonth numDaysInMonth];
    int prevMonthNumDays = [previousMonth numDaysInMonth];
    
    int selectedDateBlock = ([selectedDate day]-1)+firstWeekDay;
    
    //prepAnimationPreviousMonth nog wat mee doen
    
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]<[currentMonth month]) || [selectedDate year] < [currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]>[currentMonth month]) || [selectedDate year] > [currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([selectedDate numDaysInMonth]-[selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [currentMonth numDaysInMonth] + (firstWeekDay-1) + [selectedDate day];
    }
    
    
    NSDate *todayDate = [NSDate date];
    int todayBlock = -1;
    
//    NSLog(@"currentMonth month = %i day = %i, todaydate day = %i",[currentMonth month],[currentMonth day],[todayDate month]);
    
    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    
    for (int i=0; i<numBlocks; i++) {
        int targetDate = i;
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * (kVRGCalendarViewDayWidth) - 9;
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight) + 3;
        
        // BOOL isCurrentMonth = NO;
        if (i<firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
//            NSString *hex = (isSelectedDatePreviousMonth) ? @"0xeeeeee" : @"0x999999";
//            NSString *hex = @"0xeeeeee";
//            
//            CGContextSetFillColorWithColor(context, 
//                                           [UIColor colorWithHexString:hex].CGColor);
        } else if (i>=(firstWeekDay+currentMonthNumDays)) { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
//            NSString *hex = @"0x999999";
//            CGContextSetFillColorWithColor(context, 
//                                           [UIColor colorWithHexString:hex].CGColor);
        } else { //current month
            // isCurrentMonth = YES;
            targetDate = (i-firstWeekDay)+1;
//            NSString *hex = (isSelectedDatePreviousMonth) ? @"0xeeeeee" : @"0x999999";
//            CGContextSetFillColorWithColor(context, 
//                                           [UIColor colorWithHexString:hex].CGColor);
        }
        
        if (i < todayBlock || (todayBlock == -1 && [todayDate month] > [currentMonth month])) {
            NSString *hex = @"0xeeeeee";
            
            CGContextSetFillColorWithColor(context,
                                           [UIColor colorWithHexString:hex].CGColor);
        }
        else {
            NSString *hex = @"0x999999";
            CGContextSetFillColorWithColor(context,
                                           [UIColor colorWithHexString:hex].CGColor);
        }
        
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
        
        //draw selected date
//        if (selectedDate && i==selectedDateBlock) {
//            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth+2,kVRGCalendarViewDayHeight+2);
//            CGContextAddRect(context, rectangleGrid);
//            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0x006dbc"].CGColor);
//            CGContextFillPath(context);
//            
//            CGContextSetFillColorWithColor(context, 
//                                           [UIColor whiteColor].CGColor);
//        } else if (todayBlock==i) {
//            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth+2,kVRGCalendarViewDayHeight+2);
//            CGContextAddRect(context, rectangleGrid);
//            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0x383838"].CGColor);
//            CGContextFillPath(context);
//            
//            CGContextSetFillColorWithColor(context, 
//                                           [UIColor whiteColor].CGColor);
//        }
        
        int currentIntMonth = [currentMonth month];
        
        if (selectedDate) {
            int selectedDay = [selectedDate day];
            int selectedMonth = [selectedDate month];
            
            int targetBlock = firstWeekDay + (selectedDay-1);
            
            if (selectedMonth != currentIntMonth) {
                if (selectedMonth == currentIntMonth - 1) {
                    targetBlock = (firstWeekDay - prevMonthNumDays)+(selectedDay - 1);
                }
                else if (selectedMonth == currentIntMonth + 1) {
                    targetBlock = selectedDay + (firstWeekDay+currentMonthNumDays) - 1;
                }
                else {
                    targetBlock = -1;
                }
            }
            
            if (targetBlock <= -1 || targetBlock >= 43) {
                if (self.selectedMarkImageView.superview) {
                    [self.selectedMarkImageView removeFromSuperview];
                }
            }
            else {
                int targetColumn = targetBlock%7;
                int targetRow = targetBlock/7;
                
                int targetX = targetColumn * (kVRGCalendarViewDayWidth);
                int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight);
                
                self.selectedMarkImageView.frame = CGRectMake(targetX, targetY, self.selectedMarkImageView.frame.size.width, self.selectedMarkImageView.frame.size.height);
                if (![[self subviews] containsObject:self.selectedMarkImageView]) {
                    [self addSubview:self.selectedMarkImageView];
                }
            }
        }
        
        [date drawInRect:CGRectMake(targetX, targetY, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue" size:10] lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentCenter];
    }
    
    //    CGContextClosePath(context);
    
    //Draw markings
    if (self.markViews.count > 0) {
        for (UIView *subView in self.markViews) {
            [subView removeFromSuperview];
        }
        
        [self.markViews removeAllObjects];
    }
    
    for (int i = 0; i<[self.infos count]; i++) {
        VRGCalendarMarkInfo *info = [self.infos objectAtIndex:i];

        int targetDate = info.day;

        int targetBlock = firstWeekDay + (targetDate-1);
        
        if (info.month != [currentMonth month]) {
            if (info.month == [currentMonth month] - 1) {
                targetBlock = (firstWeekDay - prevMonthNumDays)+(targetDate - 1);
            }
            else if (info.month == [currentMonth month] + 1) {
                targetBlock = targetDate + (firstWeekDay+currentMonthNumDays) - 1;
            }
            else {
                targetBlock = -1;
            }
        }
        
        if (targetBlock <= -1 || targetBlock >= 43) {
            continue;
        }
        
        int targetColumn = targetBlock%7;
        int targetRow = targetBlock/7;

        int targetX = targetColumn * (kVRGCalendarViewDayWidth);
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight);
        
        UIView *view = [info gridView:CGPointMake(targetX, targetY) size:CGSizeMake(kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight)];
        [self addSubview:view];
        
        [self.markViews addObject:view];
    }

//    if (!self.markedDates || isSelectedDatePreviousMonth || isSelectedDateNextMonth) return;
//    
//    for (int i = 0; i<[self.markedDates count]; i++) {
//        id markedDateObj = [self.markedDates objectAtIndex:i];
//        
//        int targetDate;
//        if ([markedDateObj isKindOfClass:[NSNumber class]]) {
//            targetDate = [(NSNumber *)markedDateObj intValue];
//        } else if ([markedDateObj isKindOfClass:[NSDate class]]) {
//            NSDate *date = (NSDate *)markedDateObj;
//            targetDate = [date day];
//        } else {
//            continue;
//        }
//        
//        
//        
//        int targetBlock = firstWeekDay + (targetDate-1);
//        int targetColumn = targetBlock%7;
//        int targetRow = targetBlock/7;
//        
//        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2) + 7;
//        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2) + 38;
//        
//        CGRect rectangle = CGRectMake(targetX,targetY,32,2);
//        CGContextAddRect(context, rectangle);
//        
//        UIColor *color;
//        if (selectedDate && selectedDateBlock==targetBlock) {
//            color = [UIColor whiteColor];
//        }  else if (todayBlock==targetBlock) {
//            color = [UIColor whiteColor];
//        } else {
//            color  = (UIColor *)[markedColors objectAtIndex:i];
//        }
//        
//        
//        CGContextSetFillColorWithColor(context, color.CGColor);
//        CGContextFillPath(context);
//    }
}

#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState {
    float targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Init
-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kVRGCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds=YES;
        self.backgroundColor = [UIColor whiteColor];
        
        isAnimating=NO;
        self.labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kVRGCalendarViewWidth-68, 40)];
//        [self addSubview:labelCurrentMonth];
        labelCurrentMonth.backgroundColor=[UIColor clearColor];
        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x303030"];
        labelCurrentMonth.textAlignment = NSTextAlignmentCenter;
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
        //        [self reset];
    }
    return self;
}

-(void)dealloc {
    
    self.delegate=nil;
    self.currentMonth=nil;
    self.labelCurrentMonth=nil;
    
    self.markedDates=nil;
    self.markedColors=nil;
}

#pragma mark - Property

- (UIButton *)leftArrowButton {
    if (!_leftArrowButton) {
        _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftArrowButton.frame = CGRectMake(0, 0, 10, 10);
        [_leftArrowButton setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
        [_leftArrowButton addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_leftArrowButton];
    }
    
    return _leftArrowButton;
}

- (UIButton *)rightArrowButton {
    if (!_rightArrowButton) {
        _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightArrowButton.frame = CGRectMake(0, 0, 10, 10);
        [_rightArrowButton setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_rightArrowButton addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_rightArrowButton];
    }
    
    return _rightArrowButton;
}

- (NSMutableArray *)markViews {
    if (!_markViews) {
        _markViews = [NSMutableArray array];
    }
    
    return _markViews;
}

- (NSArray *)infos {
    if (!_infos) {
        _infos = [NSArray array];
        
        // FIXME: Test
        VRGCalendarMarkInfo *info = [[VRGCalendarMarkInfo alloc] init];
        info.day = 30;
        info.month = 10;
        info.stock = 1000;
        _infos = @[info];
    }
    
    return _infos;
}

- (UIImageView *)selectedMarkImageView {
    if (!_selectedMarkImageView) {
        _selectedMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight)];
        _selectedMarkImageView.image = [UIImage imageNamed:@"calendar_select"];
    }
    
    return _selectedMarkImageView;
}

@end