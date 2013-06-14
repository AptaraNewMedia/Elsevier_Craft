//
//  FlipViewButton.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 25/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipViewButton : UIButton {
	UILabel *textLabel;
    
    UILabel *descLabel;

	NSInteger selectedButton;
}

@property (nonatomic,assign) NSInteger selectedButton;
@property(nonatomic,retain) UILabel *textLabel;
@property(nonatomic,retain) UILabel *descLabel;

@end
