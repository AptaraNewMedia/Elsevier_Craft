//
//  RadioView.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 23/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioView : UIView

@property(nonatomic,retain) UIButton *btnOption1;
@property(nonatomic,retain) UIButton *btnOption2;
@property(nonatomic,retain) UIButton *btnOption3;
@property(nonatomic,retain) UIButton *btnOption4;
@property(nonatomic,retain) UIButton *btnOption5;

@property(nonatomic,retain) UIButton *btnFeedback1;
@property(nonatomic,retain) UIButton *btnFeedback2;
@property(nonatomic,retain) UIButton *btnFeedback3;
@property(nonatomic,retain) UIButton *btnFeedback4;
@property(nonatomic,retain) UIButton *btnFeedback5;

@property(nonatomic,retain) UIImageView *ansImage1;
@property(nonatomic,retain) UIImageView *ansImage2;
@property(nonatomic,retain) UIImageView *ansImage3;
@property(nonatomic,retain) UIImageView *ansImage4;
@property(nonatomic,retain) UIImageView *ansImage5;

@property(nonatomic,retain) NSString *selected;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic,retain) NSString *feedback;

@end
