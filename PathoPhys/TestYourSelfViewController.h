//
//  TestYourSelfViewController.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 25/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestYourSelfViewController : UIViewController
{    
    IBOutlet UIButton *bnNext;
    IBOutlet UIButton *bnPrev;
    IBOutlet UIButton *bnSubmit;
    IBOutlet UIButton *bnShowScore;
    IBOutlet UIButton *bnShowAnswer;
    IBOutlet UIButton *bnTryAgian;
    IBOutlet UILabel *lblQuestionNo;
    
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShadow;
    
    IBOutlet UINavigationBar *myNavController;    
    
    NSMutableArray *arrTestYourSelf;
    NSInteger intTotalQuestions;
    NSInteger intCurrentQuestionIndex;
}

-(void)onTryAgain;
-(void)Fn_DisableSubmit;
-(void)Fn_ShowAnswer;
-(void)disableAllButtons:(int)questionNO;
-(void)Fn_SaveBookmarkingData;
-(void)Fn_DeleteBookmarkingData;
@end
