//
//  SingleSelectionViewController.h
//  CraftApp
//
//  Created by systems pune on 21/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectionViewController : UIViewController
{
    IBOutlet UIImageView *ImgQuestionBg;
    IBOutlet UIImageView *ImgQuestionTextBg;
    IBOutlet UIImageView *ImgQuestionSeperator;
    IBOutlet UIImageView *ImgOption;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UITextView *lblQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UITableView *tblOptions;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UITextView *lblQuestionText;
@property (nonatomic, retain) IBOutlet UILabel *lblInstructions;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void) fn_LoadDbData:(NSString *)question_id;
-(void) fn_ShowSelected:(NSString *)visitedAnswers;
-(NSString *) fn_CheckAnswersBeforeSubmit;
-(void) fn_OnSubmitTapped;
-(void) handleShowAnswers;
@end
