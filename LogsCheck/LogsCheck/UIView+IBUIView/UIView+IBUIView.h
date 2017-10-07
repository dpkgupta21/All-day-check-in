//
//  UIView+IBUIView.h
//  IPO
//
//  Created by Chandan on 01/03/2016.
//  Copyright © 2016 Pratham Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IBUIView)
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable NSInteger cornerRadius;
@property (nonatomic) IBInspectable BOOL masksToBounds;
@end
