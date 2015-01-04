//
//  AbbreviationListViewController.h
//  Abbreviation
//
//  Created by 鈴木 淳朗 on 2014/12/20.
//  Copyright (c) 2014年 Junro Suzuki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbbreviationViewController.h"

/**
 略語リスト画面
 */
@interface AbbreviationListViewController : UITableViewController

@property NSMutableArray *abbArray;
@property NSMutableArray *initialArray;
@property NSOrderedSet *initialSet;
@property NSMutableDictionary *sectionCountDictionary;
@property int serialNumber;
@property int selectedSerialNumber;

@property IBOutlet UIBarButtonItem *addButton;

@end
