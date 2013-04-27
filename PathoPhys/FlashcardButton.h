//
//  FlashcardButton.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 09/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlashcardButton : UIButton {
	
	UILabel *txtLabel;
	NSInteger selectedButton;
}

@property (nonatomic,assign) NSInteger selectedButton;
@property (nonatomic,retain) UILabel *txtLabel;

@end
