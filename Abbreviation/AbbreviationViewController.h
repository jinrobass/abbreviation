//
//  AbbreviationViewController.h
//  Abbreviation
//
//  Created by 鈴木 淳朗 on 2014/12/20.
//  Copyright (c) 2014年 Junro Suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AbbreviationViewController : UITableViewController

@property PFObject *abb;
//@property Boolean textViewIsEditing;

@property IBOutlet UITextField *abbreviationTextField;
@property IBOutlet UITextField *longNameTextField;
@property IBOutlet UITextField *pronunciationTextField;
@property IBOutlet UITextField *sourceTextField;
@property IBOutlet UITextView *descTextView;
@property IBOutlet UIBarButtonItem *doneButton;

@end
