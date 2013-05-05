//
//  CustomChapterHeaderView.m
//  PathoPhys
//
//  Created by PUN-MAC-012 on 08/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import "CustomChapterHeaderView.h"

@implementation CustomChapterHeaderView
@synthesize headerBtn;
@synthesize imgArrow;
@synthesize imgViewBg;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *img = [UIImage imageNamed:@"chapter_tbl_row_center.png"];
        
        //UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, img.size.width, img.size.height)];
        self.backgroundColor = COLOR_CLEAR;
        
        imgViewBg = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, img.size.width, img.size.height))];
        [imgViewBg setImage:img];
        [self addSubview:imgViewBg];
        
        UIImage *img2 = [UIImage imageNamed:@"arrow_right.png"];
        imgArrow = [[UIImageView alloc] initWithFrame:(CGRectMake(720, 14, img2.size.width, img2.size.height))];
        [imgArrow setImage:img2];
        [self addSubview:imgArrow];
        
        headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.backgroundColor = COLOR_CLEAR;
        headerBtn.opaque = NO;
        headerBtn.frame = CGRectMake(0.0, 0.0, img.size.width, img.size.height);
        [headerBtn setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
        headerBtn.contentHorizontalAlignment   = UIControlContentHorizontalAlignmentLeft;
        [headerBtn.titleLabel setFont:FONT_17];
        [headerBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0, 30.0, 5.0, 5.0)];
        headerBtn.exclusiveTouch = YES;
        [self addSubview:headerBtn];
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
