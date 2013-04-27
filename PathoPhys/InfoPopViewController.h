//
//  InfoPopViewController.h
//  PathoPhys
//
//  Created by Admin on 4/22/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPopViewController : UIViewController
{
    IBOutlet UIButton *Bn_BGButton;
    IBOutlet UIImageView *Img_InfoPopup;
    IBOutlet UIImageView *Img_Seperator1;
    IBOutlet UIImageView *Img_Seperator2;
    IBOutlet UIButton *Bn_AboutAuthor;
    IBOutlet UIButton *Bn_AboutApp;
    IBOutlet UIButton *Bn_ElsevierAustralia;
}

@property (nonatomic, retain) IBOutlet UIView *viewPopup;

-(IBAction)Bn_BGButton_Tapped:(id)sender;

@end
