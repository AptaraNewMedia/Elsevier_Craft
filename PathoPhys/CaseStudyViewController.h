//
//  TestYourSelfViewController.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 25/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseStudyViewController : UIViewController
{    
    IBOutlet UIButton *bnNext;
    IBOutlet UIButton *bnPrev;
    IBOutlet UIButton *bnSubmit;
    IBOutlet UIButton *bnShowScore;
    IBOutlet UILabel *lblQuestionNo;
    
    IBOutlet UIImageView *imgBG;
    IBOutlet UIImageView *imgShadow;
    
    IBOutlet UINavigationBar *myNavController;
    
    NSMutableArray *arrCaseStudies;
    NSInteger intTotalQuestions;
    NSInteger intCurrentQuestionIndex;
}

-(IBAction)onNext:(id)sender;
-(IBAction)onPrev:(id)sender;
-(IBAction)onSubmit:(id)sender;

-(void)onTryAgain;
-(void) Fn_DisableSubmit;

@end
