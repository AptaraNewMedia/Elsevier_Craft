//
//  RadioView.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 23/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "RadioView.h"

@implementation RadioView
@synthesize btnOption1;
@synthesize btnOption2;
@synthesize btnOption3;
@synthesize btnOption4;
@synthesize btnOption5;
@synthesize btnFeedback1;
@synthesize btnFeedback2;
@synthesize btnFeedback3;
@synthesize btnFeedback4;
@synthesize btnFeedback5;
@synthesize selected;
@synthesize selectedIndex;
@synthesize feedback;
@synthesize ansImage1;
@synthesize ansImage2;
@synthesize ansImage3;
@synthesize ansImage4;
@synthesize ansImage5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        btnOption1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption1 setExclusiveTouch:YES];
        [btnOption1 setImage:[UIImage imageNamed:@"table_radio_Btn.png"] forState:UIControlStateNormal];
        [btnOption1 setBackgroundColor:COLOR_CLEAR];
        
        [self addSubview:btnOption1];
        
        btnFeedback1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFeedback1 setExclusiveTouch:YES];
        [btnFeedback1 setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[btnFeedback1 setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        [btnFeedback1 setBackgroundColor:COLOR_CLEAR];
        [self addSubview:btnFeedback1];

        btnOption2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption2 setExclusiveTouch:YES];
        [btnOption2 setImage:[UIImage imageNamed:@"table_radio_Btn.png"] forState:UIControlStateNormal];
        [btnOption2 setBackgroundColor:COLOR_CLEAR];        
        [self addSubview:btnOption2];
        
        btnFeedback2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFeedback2 setExclusiveTouch:YES];
        [btnFeedback2 setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[btnFeedback2 setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        [btnFeedback2 setBackgroundColor:COLOR_CLEAR];
        [self addSubview:btnFeedback2];

        
        btnOption3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption3 setExclusiveTouch:YES];
        [btnOption3 setImage:[UIImage imageNamed:@"table_radio_Btn.png"] forState:UIControlStateNormal];
        [btnOption3 setBackgroundColor:COLOR_CLEAR];        
        [self addSubview:btnOption3];
        
        btnFeedback3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFeedback3 setExclusiveTouch:YES];
        [btnFeedback3 setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[btnFeedback3 setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        [btnFeedback3 setBackgroundColor:COLOR_CLEAR];
        [self addSubview:btnFeedback3];

        
        btnOption4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption4 setExclusiveTouch:YES];
        [btnOption4 setImage:[UIImage imageNamed:@"table_radio_Btn.png"] forState:UIControlStateNormal];
        [btnOption4 setBackgroundColor:COLOR_CLEAR];        
        [self addSubview:btnOption4];
        
        btnFeedback4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFeedback4 setExclusiveTouch:YES];
        [btnFeedback4 setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[btnFeedback4 setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        [btnFeedback4 setBackgroundColor:COLOR_CLEAR];
        [self addSubview:btnFeedback4];

        
        btnOption5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOption5 setExclusiveTouch:YES];
        [btnOption5 setImage:[UIImage imageNamed:@"table_radio_Btn.png"] forState:UIControlStateNormal];
        [btnOption5 setBackgroundColor:COLOR_CLEAR];        
        [self addSubview:btnOption5];
        
        btnFeedback5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnFeedback5 setExclusiveTouch:YES];
        [btnFeedback5 setImage:[UIImage imageNamed:@"Btn_feed.png"] forState:UIControlStateNormal];
        //[btnFeedback5 setImage:[UIImage imageNamed:@"btn_feedback_highlight.png"] forState:UIControlStateHighlighted];
        [btnFeedback5 setBackgroundColor:COLOR_CLEAR];
        [self addSubview:btnFeedback5];

        ansImage1 = [[UIImageView alloc]init];
		[self addSubview:ansImage1];

        ansImage2 = [[UIImageView alloc]init];
		[self addSubview:ansImage2];

        ansImage3 = [[UIImageView alloc]init];
		[self addSubview:ansImage3];

        ansImage4 = [[UIImageView alloc]init];
		[self addSubview:ansImage4];

        ansImage5 = [[UIImageView alloc]init];
		[self addSubview:ansImage5];
        
        selected = @"0";        
        
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
