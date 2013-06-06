//
//  TrueFalseViewController.h
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrueFalseViewController : UIViewController

{
    IBOutlet UIImageView *ImgQuestionBg;
    IBOutlet UIImageView *ImgQuestionTextBg;
    IBOutlet UIImageView *ImgQuestionSeperator;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UILabel *lblQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UIButton *bnTrue;
    IBOutlet UIButton *bnFalse;
    IBOutlet UIButton *bnFeedback;
    IBOutlet UIImageView *imgViewCorrect;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UILabel *lblQuestionText;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void)fn_LoadDbData:(NSString *)question_id;
-(NSString *)fn_CheckAnswersBeforeSubmit;
-(void)fn_ShowSelected:(NSString *)visitedAnswers;
-(void)fn_OnSubmitTapped;
-(void)disableEditFields;
-(void)handleShowAnswers;

-(IBAction)onTrueFalse:(id)sender;
-(IBAction)onFeedback:(id)sender;
@end
