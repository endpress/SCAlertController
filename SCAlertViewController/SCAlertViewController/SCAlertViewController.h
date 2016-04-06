//
//  SCAlertViewController.h
//  Che-byMall
//
//  Created by ZhangSC on 16/3/30.
//  Copyright © 2016年 FYTech. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SCAlertViewController : UIViewController

/**
  获取Textfield数组
 */
@property (nonatomic, copy, readonly) NSArray<UITextField  *>  * _Nullable textFields;

/**
 获取Button数组
 */
@property (nonatomic, copy, readonly) NSArray<UIButton *> * _Nullable buttons;

/**
 AlertView 只读属性， 可用来执行动画等
 */
@property (nonatomic, strong) UIView * _Nonnull alertView;

/**
 Title
 */
@property (nonatomic, copy)IBInspectable NSString * _Nullable alertTitle;

/**
 初始化
 */
- (_Nonnull instancetype)initWithTitle:( NSString * _Nonnull)alertTitle;

/**
 TitleLabel 制定样式
 */
- (void)configurationTitleLabelHandler:(void (^ __nullable)(UILabel * __nullable label))handler;

/**
 添加textfield 输入框，可以自定义样式
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField * __nullable textField))handler;

/**
 添加button， configure 用于制定button， completionHandler返回值决定是不是要dissmiss
 */
- (void)addActionWithTitle:(nullable NSString *)title configuration:(void (^ __nullable)(UIButton * __nullable button))handler completionHandler:(BOOL (^ __nullable)(UIView * _Nonnull alertView))completionHandler;

@end
