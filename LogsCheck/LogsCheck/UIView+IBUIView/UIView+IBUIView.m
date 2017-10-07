//
//  UIView+IBUIView.m
//  IPO
//
//  Created by Chandan on 01/03/2016.
//  Copyright © 2016 Pratham Software Inc. All rights reserved.
//

#import "UIView+IBUIView.h"

@implementation UIView (IBUIView)
@dynamic borderColor,borderWidth,cornerRadius,masksToBounds;
-(void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

-(void)setBorderWidth:(NSInteger)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

-(void)setCornerRadius:(NSInteger)cornerRadius{
	[self.layer setCornerRadius:cornerRadius];
}
-(void)setMasksToBounds:(BOOL)masksToBounds{
    [self.layer setMasksToBounds:masksToBounds];
}

@end


