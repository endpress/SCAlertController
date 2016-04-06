//
//  ViewController.m
//  SCAlertViewController
//
//  Created by ZhangSC on 16/3/30.
//  Copyright © 2016年 ZSC. All rights reserved.
//

#import "ViewController.h"
#import "SCAlertViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)button:(UIButton *)sender {
    SCAlertViewController *c = [[SCAlertViewController alloc] initWithTitle:@"测试呢"];
    [c addTextFieldWithConfigurationHandler:^(UITextField * _Nullable textField) {
        textField.tintColor = [UIColor redColor];
    }];
    
    [c addTextFieldWithConfigurationHandler:^(UITextField * _Nullable textField) {
        textField.tintColor = [UIColor redColor];
        textField.placeholder = @"hahaha";
    }];
    
    [c addActionWithTitle:@"取消" configuration:^(UIButton * _Nullable button) {
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } completionHandler:^BOOL(UIView *alertView){
        NSLog(@"哈哈哈");
        return YES;
    }];
    
    [c addActionWithTitle:@"哈哈" configuration:^(UIButton * _Nullable button) {
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    } completionHandler:^BOOL(UIView *alertView){
        NSLog(@"哈哈哈");
        CAKeyframeAnimation *animation = [self getAnimation];
        [alertView.layer addAnimation:animation forKey:@"animation"];
        return NO;
    }];
    [self presentViewController:c animated:YES completion:nil];
    
}

- (CAKeyframeAnimation *)getAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CAMediaTimingFunction *timeimgFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.keyTimes = @[@0, @0.2, @0.4, @0.6, @1];
    animation.timingFunctions = @[timeimgFunction, timeimgFunction, timeimgFunction];
    animation.values = @[@0, @5, @0, @(-5), @0];
    animation.duration = 0.1;
    animation.repeatCount = 1;
    animation.removedOnCompletion = false;
    
    return animation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
