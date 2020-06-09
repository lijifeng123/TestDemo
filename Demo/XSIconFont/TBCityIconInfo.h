//
//  TBCityIconInfo.h
//  IconFontExtension
//
//  Created by lijifeng on 2020/5/15.
//  Copyright © 2020 shaolie. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface TBCityIconInfo : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;
+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

@end

