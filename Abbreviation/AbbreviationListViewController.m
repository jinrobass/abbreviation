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

@end

@implementation AbbreviationListViewController

#pragma mark - UIViewController lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // 追加ボタンを無効化
    self.addButton.enabled = NO;
    
    // indexPathから算出するセルの通し番号を初期化
    self.serialNumber = 0;
    
    // アルファベット順に略語リストを取得
    PFQuery *query = [PFQuery queryWithClassName:@"Abb"];
    query.limit = 1000;
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
        self.abbArray = [objects mutableCopy];
        
        // 重複ない頭文字だけのOrderedSetを生成
        self.initialArray = [[NSMutableArray alloc] init];
        PFObject *tempAbb;
        for (int i = 0; i < self.abbArray.count; i++) {
            tempAbb = self.abbArray[i];
            [self.initialArray addObject:tempAbb[@"initial"]];
        }
        self.initialSet = [[NSOrderedSet alloc] initWithArray:self.initialArray];
        
        // 重複ない頭文字をキーとし、各頭文字の略語の数をバリューに持つMutableDictionaryを生成
        self.sectionCountDictionary = [[NSMutableDictionary alloc] init];
        NSInteger num;
        for (int i = 0; i < self.initialSet.count; i++) {
            num = 0;
            for (int j = 0; j < self.initialArray.count; j++) {
                if ([self.initialArray[j] isEqualToString:self.initialSet[i]]) {
                    num++;
                }
            }
            [self.sectionCountDictionary setObject:[NSNumber numberWithInteger:num] forKey:self.initialSet[i]];
        }
        
        NSLog(@"sectionCountDict : %@", self.sectionCountDictionary);
        
        // リロード
        [self.tableView reloadData];
        
        // 追加ボタンを有効化
        self.addButton.enabled = YES;
    }];
}

#pragma mark - Table view data source

// セクションの数を設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.initialSet.count;
}

// セクションのタイトルを設定
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@", self.initialSet[section]];
}

// セクションの高さを設定
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

// セクションの中の行数を設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sectionCountDictionary objectForKey:self.initialSet[section]] unsignedIntegerValue];
}

// セルの内容を設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AbbCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    int sum = 0;
    for (int i = 0; i < indexPath.section; i++) {
        sum += [[self.sectionCountDictionary objectForKey:self.initialSet[i]] unsignedIntegerValue];
    }
    self.serialNumber = sum + indexPath.row;
    
    PFObject *abb = self.abbArray[self.serialNumber];
    cell.textLabel.text = abb[@"abbreviation"];
    cell.detailTextLabel.text = abb[@"longName"];
    
    return cell;
}

// 選択したセルの通し番号を設定
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択状態の解除
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int sum = 0;
    for (int i = 0; i < indexPath.section; i++) {
        sum += [[self.sectionCountDictionary objectForKey:self.initialSet[i]] unsignedIntegerValue];
    }
    self.selectedSerialNumber = sum + indexPath.row;
    
    PFObject *abb = self.abbArray[self.selectedSerialNumber];
    AbbreviationViewController *abbVC = [self.storyboard instantiateViewControllerWithIdentifier:@"abbVC"];
    abbVC.abb = abb;
    
    [self.navigationController pushViewController:abbVC animated:YES];
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // 更新時には既存のPFObjectを遷移先の画面に渡す
//    if ([segue.identifier isEqualToString:@"editSegue"]) {
//        PFObject *abb = self.abbArray[self.selectedSerialNumber];
//        AbbreviationViewController *abbVC = [segue destinationViewController];
//        abbVC.abb = abb;
//    }
//}

@end
