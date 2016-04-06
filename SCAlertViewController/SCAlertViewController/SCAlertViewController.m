//
//  SCAlertViewController.m
//  Che-byMall
//
//  Created by ZhangSC on 16/3/30.
//  Copyright © 2016年 FYTech. All rights reserved.
//

#import "SCAlertViewController.h"
#import <objc/runtime.h>

#define ViewWidth   self.view.bounds.size.width
#define ViewHeight  self.view.bounds.size.height
#define GrayColor   [UIColor colorWithRed: 245.0/255.0 green: 245.0/255.0 blue: 245.0/255.0 alpha: 1.0]

static CGFloat const BackgroundColorAlpha = 0.4;
static CGFloat const SubViewHeight = 40;
static CGFloat const MaxAlertViewHeight = 500;
static CGFloat const Padding = 5.0;

static NSString *HEHE;

@interface SCAlertViewController ()


/**
 用于保存信息
 */
@property (nonatomic, strong) NSMutableArray *textFieldsArray;
@property (nonatomic, strong) NSMutableArray *buttonsArray;

/**
 TitleLabel
 */
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SCAlertViewController

#pragma mark - Set Get

- (NSArray *)textFields {
    return [_textFieldsArray copy];
}

- (NSArray *)buttons {
    return [_buttonsArray copy];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = GrayColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)alertView {
    if (_alertView == nil) {
        _alertView = [[UIView alloc] init];
        _alertView.layer.cornerRadius = 10.0;
        _alertView.layer.masksToBounds = YES;
        [self.view addSubview:_alertView];
    }
    return _alertView;
}

#pragma mark - Init

- (instancetype)initWithTitle:(NSString *)alertTitle
{
    self = [super init];
    if (self) {
        self.alertTitle = alertTitle;
        self.textFieldsArray = [NSMutableArray arrayWithCapacity:0];
        self.buttonsArray = [NSMutableArray arrayWithCapacity:0];
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:BackgroundColorAlpha];
    /// 注册键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self makeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)makeUI {
    
    /// 初始化AlertView
    NSInteger buttonsCount = self.buttonsArray.count;
    /// titleLabel + textfields + buttons 三个的高度
    CGFloat alertViewHeight = SubViewHeight + self.textFieldsArray.count * (SubViewHeight + Padding) + (buttonsCount > 2 ? buttonsCount * (SubViewHeight + Padding) : (SubViewHeight + Padding));
    alertViewHeight = MIN(MaxAlertViewHeight, alertViewHeight);
    CGFloat alertViewWidth = ViewWidth * 0.5;
    
    self.alertView.frame = CGRectMake(0, 0, alertViewWidth, alertViewHeight);
    self.alertView.center = CGPointMake(ViewWidth * 0.5, ViewHeight * 0.5);
    self.alertView.backgroundColor = GrayColor;
    /// titleLabel
    self.titleLabel.frame = CGRectMake(0, 0, alertViewWidth, SubViewHeight);
    self.titleLabel.text = self.alertTitle;
    
    /// fextfields
    for (int i = 0; i < self.textFieldsArray.count; i++) {
        UITextField *textField = self.textFieldsArray[i];
        textField.backgroundColor = [UIColor whiteColor];
        textField.frame = CGRectMake(5, (SubViewHeight + Padding) * (i + 1), alertViewWidth - 10, SubViewHeight);
        [self.alertView addSubview:textField];
    }
    
    ///buttons
    for (int i = 0; i < self.buttonsArray.count; i++) {
        UIButton *button = self.buttonsArray[i];
        if (self.buttonsArray.count <= 2) {
            CGFloat buttonWidth = alertViewWidth / self.buttonsArray.count;
            button.frame = CGRectMake(i * buttonWidth, (SubViewHeight + Padding) * (1 + self.textFieldsArray.count), buttonWidth, SubViewHeight);
        } else {
            button.frame = CGRectMake(0, (SubViewHeight + Padding) * (i + 1 + self.textFieldsArray.count), alertViewWidth, SubViewHeight);
        }
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:button];
    }
}

#pragma mark - ButtonTapped

- (void)buttonTapped:(UIButton *)button {
    BOOL (^buttonBlock)() = objc_getAssociatedObject(button, (__bridge const void *)(button));
    if (buttonBlock == nil) {
        return;
    }
    BOOL finish = buttonBlock(self.alertView);
    
    if (finish) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.view endEditing:YES];
        }];
    }
}

#pragma mark - Keyborad Nitofication

- (void)keyBoardFrameChanged:(NSNotification *)notification {
    
    ///键盘的y
    CGFloat height = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    double durationtTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:durationtTime animations:^{
        CGPoint center = self.alertView.center;
        center.y = height * 0.5;
        self.alertView.center = center;
    }];
}

#pragma mark - Public

/**
 TitleLabel 制定样式
 */
- (void)configurationTitleLabelHandler:(void (^)(UILabel *))handler {
    handler(self.titleLabel);
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))handler {
    UITextField *textField = [[UITextField alloc] init];
    if (handler != nil) {
        handler(textField);
    }
    [_textFieldsArray addObject:textField];
}

- (void)addActionWithTitle:(NSString *)title configuration:(void (^)(UIButton * _Nullable))handler completionHandler:(BOOL (^)(UIView *))completionHandler {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    if (handler != nil) {
        handler(button);
    }
    /// 将Block 和 Button 绑定，方便以后调用方法
    objc_setAssociatedObject(button, (__bridge const void *)(button), completionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [_buttonsArray addObject:button];
}
















@end
