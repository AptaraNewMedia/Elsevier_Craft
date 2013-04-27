//
//  RadioGroupView.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 13/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadioGroupView : UIView{
    UILabel *lblQuestion;
	UIButton *btnOption1;
	UIButton *btnOption2;
	UIButton *btnOption3;
    UIImageView *ansImage;
	UIButton *feedbackBt;
    NSString *selected;
    NSInteger selectedIndex;
    NSString *feedback;
}
@property(nonatomic,retain) UILabel *lblQuestion;
@property(nonatomic,retain) UIButton *btnOption1;
@property(nonatomic,retain) UIButton *btnOption2;
@property(nonatomic,retain) UIButton *btnOption3;
@property(nonatomic,retain)	UIImageView *ansImage;
@property(nonatomic,retain)	UIButton *feedbackBt;
@property(nonatomic,retain) NSString *selected;
@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic,retain) NSString *feedback;
@end
