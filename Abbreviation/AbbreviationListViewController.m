//
//  AbbreviationListViewController.m
//  Abbreviation
//
//  Created by 鈴木 淳朗 on 2014/12/20.
//  Copyright (c) 2014年 Junro Suzuki. All rights reserved.
//

#import "AbbreviationListViewController.h"
#import <Parse/Parse.h>
#import "AbbreviationViewController.h"


@interface AbbreviationListViewController ()

@property (strong, nonatomic) NSMutableArray *abbList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end

@implementation AbbreviationListViewController

- (void)viewWillAppear:(BOOL)animated {
    // 通信が終了するまで追加ボタンを無効化
    self.addButton.enabled = NO;
    
    // アルファベット順に略語リストを取得
    PFQuery *query = [PFQuery queryWithClassName:@"Abb"];
    [query orderByAscending:@"abbreviation"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        // クエリで取得した内容を略語リストにコピー
        self.abbList = [objects mutableCopy];
        // リロード
        [self.tableView reloadData];
        
        // 追加ボタンを有効化
        self.addButton.enabled = YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // セクションの数を返す
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // セクションの中の行数を返す
    return self.abbList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AbbCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *abb = self.abbList[indexPath.row];
    cell.textLabel.text = abb[@"abbreviation"];
    cell.detailTextLabel.text = abb[@"longName"];
    
    return cell;
}

@end
