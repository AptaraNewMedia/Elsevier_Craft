//
//  CustomPopViewController.h
//  PathoPhys
//
//  Created by Admin on 4/22/13.
//  Copyright (c) 2013 Aptara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesPopViewController : UIViewController
{
    IBOutlet UIButton *Bn_BGButton;
    IBOutlet UIImageView *Img_NotePopup;
    IBOutlet UIImageView *Img_Seperator1;
    IBOutlet UIButton *Bn_ViewNote;    
}

@property (nonatomic, retain) IBOutlet UIButton *Bn_Addnote;
@property (nonatomic, retain) IBOutlet UIView *viewPopup;


@end
