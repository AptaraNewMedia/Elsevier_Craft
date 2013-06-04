//
//  ScoreViewController.h
//  ScoreViewApp
//
//  Created by Aptara on 10/04/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"


@interface ScoreCardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,FBSessionDelegate,FBRequestDelegate,FBDialogDelegate>
{
    Facebook *facebook;
}
@property (nonatomic, retain) Facebook *facebook;
-(IBAction)onClose:(id)sender;
- (IBAction)Bn_Facebook_Tapped:(id)sender;
- (IBAction)Bn_Email_Tapped:(id)sender;

@end
