//
//  CustomDragButton.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 14/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDragButton : UIButton
@property(nonatomic,retain)	UIImageView *ansImage;
@property(nonatomic,retain)	UIButton *feedbackBt;
@property(nonatomic,retain) NSString *strFeedback;
@property (nonatomic) float x;
@property (nonatomic) float y;
@end
