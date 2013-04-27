//
//  RightMatchView_Ipad.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 06/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightMatchView_Ipad : UIView{
	UIButton *dotBt;
	UIButton *customBt;
    UIImageView *ansImage;
	UIButton *feedbackBt;
}
@property(nonatomic,retain)	UIButton *customBt;
@property(nonatomic,retain)	UIButton *dotBt;
@property(nonatomic,retain)	UIImageView *ansImage;
@property(nonatomic,retain)	UIButton *feedbackBt;
@property(nonatomic,retain) NSString *strFeedback;
@end
