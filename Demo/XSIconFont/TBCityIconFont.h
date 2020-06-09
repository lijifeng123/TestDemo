//
//  TBCityIconFont.h
//  IconFontExtension
//
//  Created by lijifeng on 2020/5/15.
//  Copyright © 2020 shaolie. All rights reserved.
//

#import "TBCityIconInfo.h"
#import "UIImage+TBCityIconFont.h"

#define TBCityIconInfoMake(text, imageSize, imageColor) [TBCityIconInfo iconInfoWithText:text size:imageSize color:imageColor]

@interface TBCityIconFont : NSObject

+ (UIFont *)fontWithSize: (CGFloat)size;
+ (void)setFontName:(NSString *)fontName;

@end
