//
//  CustomDragButton.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 14/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CustomDragButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomDragButton
@synthesize ansImage;
@synthesize feedbackBt;
@synthesize strFeedback;
@synthesize x;
@synthesize y;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CALayer *l2 = [self layer];
		[l2 setCornerRadius:9];
        
        ansImage = [[UIImageView alloc]init];
		[self addSubview:ansImage];
        
        feedbackBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [feedbackBt setExclusiveTouch:YES];
		[feedbackBt setBackgroundColor:COLOR_CLEAR];
		[self addSubview:feedbackBt];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
