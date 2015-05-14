//
//  ViewController.m
//  POPSpring
//
//  Created by YouXianMing on 15/5/14.
//  Copyright (c) 2015年 YouXianMing. All rights reserved.
//

#import "ViewController.h"
#import "RangeValueView.h"
#import "POP.h"
#import "NSString+RichText.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel  *secondsLabel;

@property (nonatomic, strong) UIButton *showView;
@property (nonatomic, strong) NSDate   *dateStart;

@property (nonatomic, strong) RangeValueView *rangeSpeed;
@property (nonatomic, strong) RangeValueView *rangeBounciness;
@property (nonatomic, strong) RangeValueView *rangeMass;
@property (nonatomic, strong) RangeValueView *rangeFriction;
@property (nonatomic, strong) RangeValueView *rangeTension;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initSecondLabel];
    
    
    [self initButton];
    
    
    [self initRangeViews];
}

/**
 *  初始化显示秒钟的label
 */
- (void)initSecondLabel {
    self.secondsLabel                = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    self.secondsLabel.attributedText = [self stringWithFloat:0.f];
    [self.view addSubview:self.secondsLabel];
}

/**
 *  创建富文本
 *
 *  @param value 输入的值
 *
 *  @return 返回创建好的富文本
 */
- (NSAttributedString *)stringWithFloat:(CGFloat)value {
    
    // 字符串
    NSString *stringValue  = [NSString stringWithFormat:@"%.2f", value];
    NSString *secondString = [NSString stringWithFormat:@"seconds"];
    NSString *totalString  = [NSString stringWithFormat:@"%@ %@", stringValue, secondString];
    
    // 字体
    UIFont *allFont        = [UIFont fontWithName:@"Avenir-Roman" size:14.f];
    UIFont *ValueFont      = [UIFont fontWithName:@"Avenir-Roman" size:16.f];
    
    // 配置富文本
    return [totalString createAttributedStringAndConfig:\
            @[
              [ConfigAttributedString font:allFont   range:[totalString range]],
              [ConfigAttributedString font:ValueFont range:[stringValue rangeFrom:totalString]],
              [ConfigAttributedString foregroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.4f]
                                                range:[secondString rangeFrom:totalString]]
              ]];
}

/**
 *  初始化测试动画用的按钮
 */
- (void)initButton {
    
    CGFloat width                    = 100.f;
    self.showView                    = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    self.showView.center             = CGPointMake(self.view.middleX, 175);
    self.showView.backgroundColor    = [UIColor cyanColor];
    self.showView.layer.cornerRadius = self.showView.width / 2.f;
    [self.view addSubview:self.showView];
    [self.showView addTarget:self
                      action:@selector(doAnimation)
            forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  测试用rangeView
 */
- (void)initRangeViews {
    self.rangeSpeed = [RangeValueView rangeValueViewWithFrame:CGRectMake(10, Height - 60, Width - 20, 0)
                                                         name:@"速度  Speed"
                                                     minValue:0.f
                                                     maxValue:20.f
                                                 defaultValue:12.f];
    [self.view addSubview:self.rangeSpeed];
    
    
    self.rangeBounciness = [RangeValueView rangeValueViewWithFrame:CGRectMake(10, Height - 60 - 40, Width - 20, 0)
                                                              name:@"弹力  Bounciness"
                                                          minValue:0.f
                                                          maxValue:20.f
                                                      defaultValue:4.f];
    [self.view addSubview:self.rangeBounciness];
    
    
    self.rangeMass = [RangeValueView rangeValueViewWithFrame:CGRectMake(10, Height - 60 - 40*2, Width - 20, 0)
                                                        name:@"质量  Mass"
                                                    minValue:0.1
                                                    maxValue:10.f
                                                defaultValue:1.f];
    [self.view addSubview:self.rangeMass];
    
    
    self.rangeFriction = [RangeValueView rangeValueViewWithFrame:CGRectMake(10, Height - 60 - 40*3, Width - 20, 0)
                                                            name:@"摩擦  Friction"
                                                        minValue:1
                                                        maxValue:50
                                                    defaultValue:30.486980];
    [self.view addSubview:self.rangeFriction];
    
    
    self.rangeTension = [RangeValueView rangeValueViewWithFrame:CGRectMake(10, Height - 60 - 40*4, Width - 20, 0)
                                                           name:@"拉力  Tension"
                                                       minValue:1
                                                       maxValue:1000
                                                   defaultValue:300];
    [self.view addSubview:self.rangeTension];
}

/**
 *  执行动画操作
 */
- (void)doAnimation {
    
    // 移除动画
    [self.showView.layer pop_removeAllAnimations];
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    
    // 设置代理
    spring.delegate            = self;
    
    // 动画起始值 + 动画结束值
    spring.fromValue           = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    spring.toValue             = [NSValue valueWithCGSize:CGSizeMake(2.f, 2.f)];
    
    // 参数的设置
    spring.springSpeed         = self.rangeSpeed.currentValue;
    spring.springBounciness    = self.rangeBounciness.currentValue;
    spring.dynamicsMass        = self.rangeMass.currentValue;
    spring.dynamicsFriction    = self.rangeFriction.currentValue;
    spring.dynamicsTension     = self.rangeTension.currentValue;
    
    // 执行动画
    [self.showView.layer pop_addAnimation:spring forKey:nil];
}


#pragma mark - POP动画相关代理
- (void)pop_animationDidStart:(POPAnimation *)anim {
    self.dateStart = [NSDate date];
}

- (void)pop_animationDidApply:(POPAnimation *)anim {
    CGFloat seconds                  = -[self.dateStart timeIntervalSinceNow];
    self.secondsLabel.attributedText = [self stringWithFloat:seconds];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    CGFloat seconds                  = -[self.dateStart timeIntervalSinceNow];
    self.secondsLabel.attributedText = [self stringWithFloat:seconds];
}

@end
