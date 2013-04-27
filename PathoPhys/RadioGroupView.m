//
//  RadioGroupView.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 13/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "RadioGroupView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RadioGroupView
@synthesize lblQuestion;
@synthesize btnOption1;
@synthesize btnOption2;
@synthesize btnOption3;
@synthesize ansImage;
@synthesize feedbackBt;
@synthesize selected;
@synthesize selectedIndex;
@synthesize feedback;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = COLOR_CLEAR;
	
        
        lblQuestion = [[UILabel alloc] init];
		[lblQuestion setBackgroundColor:COLOR_CUSTOMBUTTON_GRAY];
        lblQuestion.textColor = COLOR_DARKGRAY;
        
        CALayer *l1 = [lblQuestion layer];
		[l1 setCornerRadius:9];
		[l1 setBorderWidth:1];
		[l1 setBorderColor:[COLOR_DARKGRAY CGColor]];
        [self addSubview:lblQuestion];
        
        btnOption1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption1 setExclusiveTouch:YES];
		[btnOption1 setBackgroundColor:COLOR_CUSTOMBUTTON_GRAY];
        
        CALayer *l2 = [btnOption1 layer];
		[l2 setCornerRadius:9];
		[l2 setBorderWidth:1];
		[l2 setBorderColor:[COLOR_DARKGRAY CGColor]];
		[self addSubview:btnOption1];
        
        
		btnOption2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption2 setExclusiveTouch:YES];
		[btnOption2 setBackgroundColor:COLOR_CUSTOMBUTTON_GRAY];
        CALayer *l3 = [btnOption2 layer];
		[l3 setCornerRadius:9];
		[l3 setBorderWidth:1];
		[l3 setBorderColor:[COLOR_DARKGRAY CGColor]];
		[self addSubview:btnOption2];

        btnOption3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption3 setExclusiveTouch:YES];
		[btnOption3 setBackgroundColor:COLOR_CUSTOMBUTTON_GRAY];
        CALayer *l4 = [btnOption3 layer];
		[l4 setCornerRadius:9];
		[l4 setBorderWidth:1];
		[l4 setBorderColor:[COLOR_DARKGRAY CGColor]];
		[self addSubview:btnOption3];
        
        ansImage = [[UIImageView alloc]init];
		[self addSubview:ansImage];
        
        feedbackBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [feedbackBt setExclusiveTouch:YES];
		[feedbackBt setBackgroundColor:[UIColor clearColor]];
		[self addSubview:feedbackBt];
        
        selected = @"0";
    }
    return self;
}

@end
