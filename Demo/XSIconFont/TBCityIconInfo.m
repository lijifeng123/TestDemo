//
//  TBCityIconInfo.m
//  IconFontExtension
//
//  Created by lijifeng on 2020/5/15.
//  Copyright © 2020 shaolie. All rights reserved.
//

#import "TBCityIconInfo.h"

@implementation TBCityIconInfo

- (instancetype)initWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    if (self = [super init]) {
        self.text = text;
        self.size = size;
        self.color = color;
    }
    return self;
}

+ (instancetype)iconInfoWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color {
    return [[TBCityIconInfo alloc] initWithText:text size:size color:color];
}

@end
