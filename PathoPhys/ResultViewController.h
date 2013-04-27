//
//  ResultViewController.h
//  PathoPhys
//
//  Created by PUN-MAC-012 on 14/04/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 
#import "FBConnect.h"


@interface ResultViewController : UIViewController<MFMailComposeViewControllerDelegate,FBSessionDelegate,FBRequestDelegate,FBDialogDelegate>{
    Facebook *facebook;
    IBOutlet UILabel *lblChapterName;
    IBOutlet UILabel *lblThematicArea;
    IBOutlet UILabel *lblScore;
    
    IBOutlet UIButton *btnFB;
    IBOutlet UIButton *btnMail;
    
    
    IBOutlet UILabel *lblChapterName_Title;
    IBOutlet UILabel *lblThematicArea_Title;
    IBOutlet UILabel *lblScore_Title;
    IBOutlet UILabel *lblShare_Title;
    IBOutlet UILabel *lblResult;
    
}
@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) IBOutlet UILabel *lblChapterName;
@property (nonatomic, retain) IBOutlet UILabel *lblThematicArea;
@property (nonatomic, retain) IBOutlet UILabel *lblScore;
@property (nonatomic, retain) IBOutlet UIButton *btnFB;
@property (nonatomic, retain) IBOutlet UIButton *btnMail;

@property (nonatomic, retain) IBOutlet UILabel *lblChapterName_Title;
@property (nonatomic, retain) IBOutlet UILabel *lblThematicArea_Title;
@property (nonatomic, retain) IBOutlet UILabel *lblScore_Title;
@property (nonatomic, retain) IBOutlet UILabel *lblShare_Title;
@property (nonatomic, retain) IBOutlet UILabel *lblResult;

@end
