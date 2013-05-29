//
//  MatchPairsViewController.h
//  CraftApp
//
//  Created by Rohit Yermalkar on 20/03/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchPairsViewController_cs : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>

{
    IBOutlet UIImageView *ImgQuestionBg;
    
    IBOutlet UILabel *lblQuestionNo;
    IBOutlet UIWebView *webQuestionText;
    IBOutlet UIWebView *webviewInstructions;
    IBOutlet UIScrollView *scrollViewOptions;
    IBOutlet UIButton *btnCasestudyText;
}

@property (nonatomic, retain) IBOutlet UILabel *lblQuestionNo;
@property (nonatomic, retain) IBOutlet UIWebView *webQuestionText;
@property (nonatomic, retain) IBOutlet UIWebView *webviewInstructions;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewOptions;

@property (nonatomic) NSInteger intVisited;
@property (nonatomic, retain) NSString *strVisitedAnswer;

@property (nonatomic, retain) id parentObject;

-(void)fn_LoadDbData:(NSString *)question_id;
-(NSString *)fn_CheckAnswersBeforeSubmit;
-(void)fn_ShowSelected:(NSString *)visitedAnswers;
-(void)fn_OnSubmitTapped;
-(void)handleShowAnswers;
@end
