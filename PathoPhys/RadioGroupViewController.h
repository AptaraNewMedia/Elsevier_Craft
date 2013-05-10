//
//  RadioGroupViewController.h
//  CraftApp
//
//  Created by PUN-MAC-012 on 29/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioGroupViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UIImageView *ImgQuestionBg;
    IBOutlet UIImageView *ImgQuestionTextBg;
    IBOutlet UIImageView *ImgQuestionSeperator;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UILabel *lblQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UILabel *lblOptionHiding;
    IBOutlet UILabel *lblOption1;
    IBOutlet UILabel *lblOption2;
    IBOutlet UILabel *lblOption3;
    IBOutlet UIScrollView *scrollRadioOption;
    UIButton *OptionButton1;
    UIButton *OptionButton2;
    UIButton *OptionButton3;
    IBOutlet UIView *viewTitle;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UILabel *lblQuestionText;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;
@property (nonatomic, retain) IBOutlet UILabel *lblOptionHiding;
@property (nonatomic, retain) IBOutlet UILabel *lblOption1;
@property (nonatomic, retain) IBOutlet UILabel *lblOption2;
@property (nonatomic, retain) IBOutlet UILabel *lblOption3;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollRadioOption;


@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void) fn_LoadDbData:(NSString *)question_id;
-(NSString *) fn_CheckAnswersBeforeSubmit;
-(void) fn_ShowSelected:(NSString *)visitedAnswers;
-(void) fn_OnSubmitTapped;

@end

