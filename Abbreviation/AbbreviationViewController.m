//
//  AbbreviationViewController.m
//  Abbreviation
//
//  Created by 鈴木 淳朗 on 2014/12/20.
//  Copyright (c) 2014年 Junro Suzuki. All rights reserved.
//

#import "AbbreviationViewController.h"

@interface AbbreviationViewController () <UITextFieldDelegate, UITextViewDelegate>

@end

@implementation AbbreviationViewController

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // doneボタンを無効化
    self.doneButton.enabled = NO;
    
    // ビューのタイトルと、テキストフィールドの設定
    if (self.abb) {
        self.title = @"Edit abb. ";
        self.abbreviationTextField.text = self.abb[@"abbreviation"];
        self.longNameTextField.text = self.abb[@"longName"];
        self.pronunciationTextField.text = self.abb[@"pronunciation"];
        self.sourceTextField.text = self.abb[@"source"];
        self.descTextView.text = self.abb[@"description"];
    } else {
        self.title = @"Add new abb.";
    }
    
    // プレースホルダーの設定
    self.abbreviationTextField.placeholder = @"略称";
    self.longNameTextField.placeholder = @"正式名称";
    self.pronunciationTextField.placeholder = @"読み方";
    self.sourceTextField.placeholder = @"情報源";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Action methods

/**
 doneボタン押下による更新または新規登録
 */
-(IBAction)done {
    // doneボタンを無効化（2度押し対策）
    self.doneButton.enabled = NO;
    
    // PFObjectインスタンスを生成
    // 更新時には既存のPFObjectを取得し、新規登録時には新規のPFObjectを取得
    PFObject *abb = self.abb ? self.abb : [PFObject objectWithClassName:@"Abb"];
    
    // 各テキストフィールドの内容をPFObjectに設定
    abb[@"initial"] = [self.abbreviationTextField.text substringToIndex:1];
    abb[@"abbreviation"] = self.abbreviationTextField.text;
    abb[@"longName"] = self.longNameTextField.text;
    abb[@"pronunciation"] = self.pronunciationTextField.text;
    abb[@"source"] = self.sourceTextField.text;
    abb[@"description"] = self.descTextView.text;
    
    // ParseのDB上に保存
    [abb saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // 失敗時にアラートを表示
        if (!succeeded) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        // 成功時に前画面に遷移
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/**
 キャンセルボタン押下による前画面遷移
 */
- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField and UITextView delegate

// リターンキー押下時にキーボードを非表示にする
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//// テキストビューが編集中かどうか判定するフラグをYESに設定
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    self.textViewIsEditing = YES;
//    NSLog(@"%d", self.textViewIsEditing);
//}

//// テキストビューを編集中の場合のみ、画面タッチ時にキーボードを非表示にする
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"fuga");
//    if (self.textViewIsEditing) {
//        NSLog(@"hoge");
//        // キーボードを非表示
//        [self.descTextView resignFirstResponder];
//        // フラグを戻す
//        self.textViewIsEditing = NO;
//    }
//}

// 省略形および正式名称の入力がされるまでdoneボタンを無効化
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = (self.abbreviationTextField.text.length > 0 && self.longNameTextField.text.length > 0);
}

//- (void)textViewDidEndEditing:(UITextView *)textView {
//    self.navigationItem.rightBarButtonItem.enabled = (self.abbreviationTextField.text.length > 0 && self.longNameTextField.text.length > 0);
//}

#pragma mark - TODO list

// TODO 検索機能
// TODO TextViewのプレースホルダー
// TODO TextView編集後にキーボード非表示
// TODO リスト表示時にスワイプで削除
// TODO UIRefreshControllでの更新
// TODO cancelボタン押下時に、更新されている時のみリストを再読み込み
// TODO 登録日、更新日の表示

@end
