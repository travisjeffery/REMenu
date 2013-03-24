//
// REMenuItemView.m
// REMenu
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REMenuItemView.h"
#import <SSToolkit/SSDrawingUtilities.h>
#import <Archimedes/Archimedes.h>

@implementation REMenuItemView

- (id)initWithFrame:(CGRect)frame menu:(REMenu *)menu hasSubtitle:(BOOL)hasSubtitle
{
    self = [super initWithFrame:frame];

    if (self) {
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitButton;
        self.accessibilityHint = NSLocalizedString(@"Double tap to choose", @"Double tap to choose");

        _menu = menu;

        if (hasSubtitle) {
            // Dividing lines at 1/1.725 (vs 1/2.000) results in labels about 28-top 20-bottom or 60/40 title/subtitle (for a 48 frame height)
            //
            CGRect titleFrame = CGRectMake(_menu.textOffset.width, _menu.textOffset.height, 0, floorf(frame.size.height / 1.725));
            _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];

            CGRect subtitleFrame = CGRectMake(_menu.subtitleTextOffset.width, _menu.subtitleTextOffset.height + _titleLabel.frame.size.height, 0, floorf(frame.size.height * (1.0 - 1.0 / 1.725)));
            _subtitleLabel = [[UILabel alloc] initWithFrame:subtitleFrame];
            _subtitleLabel.numberOfLines = 0;

//            _subtitleLabel.contentMode = UIViewContentModeCenter;
            _subtitleLabel.textAlignment = _menu.subtitleTextAlignment;
            _subtitleLabel.backgroundColor = [UIColor clearColor];
            _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _subtitleLabel.isAccessibilityElement = NO;
            [self addSubview:_subtitleLabel];
        } else {
            CGRect titleFrame = CGRectMake(_menu.textOffset.width, _menu.textOffset.height, 0, frame.size.height);
            _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        }

        _titleLabel.isAccessibilityElement = NO;
//        _titleLabel.contentMode = UIViewContentModeCenter;
        _titleLabel.textAlignment = _menu.textAlignment;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_titleLabel setNumberOfLines:0];
        [self addSubview:_titleLabel];

        _imageView = [[UIImageView alloc] initWithFrame:CGRectNull];
        [self addSubview:_imageView];
        
        
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat imageOffset = floor((self.frame.size.height - _item.image.size.height) / 2.0);
    _imageView.image = _item.image;
    _imageView.frame = CGRectMake(imageOffset + _menu.imageOffset.width, imageOffset + _menu.imageOffset.height, _item.image.size.width, _item.image.size.height);
    
//    _imageView.backgroundColor = [UIColor blueColor];
//    _titleLabel.backgroundColor = [UIColor redColor];
//    _subtitleLabel.backgroundColor = [UIColor greenColor];
    
    _titleLabel.font = _menu.font;
    _titleLabel.text = _item.title;
    _titleLabel.textColor = _menu.textColor;
    _titleLabel.shadowColor = _menu.textShadowColor;
    _titleLabel.shadowOffset = _menu.textShadowOffset;
    _titleLabel.textAlignment = _menu.textAlignment;
    _subtitleLabel.font = _menu.subtitleFont;
    _subtitleLabel.text = _item.subtitle;
    _subtitleLabel.textColor = _menu.subtitleTextColor;
    _subtitleLabel.shadowColor = _menu.subtitleTextShadowColor;
    _subtitleLabel.shadowOffset = _menu.subtitleTextShadowOffset;
    _subtitleLabel.textAlignment = _menu.subtitleTextAlignment;
    self.accessibilityLabel = _titleLabel.text;
    if (_subtitleLabel.text)
        self.accessibilityLabel = [NSString stringWithFormat:@"%@, %@", _titleLabel.text, _subtitleLabel.text];
    
    [self.imageView sizeToFit];
    [[self titleLabel] sizeToFit];
    [[self subtitleLabel] sizeToFit];
    
    CGFloat titleHeight = self.titleLabel.frame.size.height;
    CGFloat subtitleHeight = self.subtitleLabel.frame.size.height;
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat sum = (CGRectGetHeight(self.imageView.frame) + titleHeight);
    CGFloat margin = abs(floorf((height - sum)/4.f));
    
    CGFloat y = margin;
    
    self.imageView.frame = CGRectMake(ceilf((CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - CGRectGetWidth(self.imageView.frame))/2.f),
                                      (height/2.f),
                                      CGRectGetWidth(self.imageView.frame),
                                      CGRectGetHeight(self.imageView.frame));
//    CGFloat midX = CGRectGetWidth([[UIScreen mainScreen] applicationFrame])/2.f;
//    self.imageView.center = CGPointMake(midX,
//                                        (height/2.f) - CGRectGetHeight(self.imageView.frame)).f);
//    
//    self.titleLabel.center = CGPointMake(midX,
//                                         (height + CGRectGetHeight(self.titleLabel.frame))
//                                         );
    
    if (margin < 20) {
        y += 10.f;
    }
    else {
        y += 20.f;
    }
    
    if (margin > 20){
        
        self.imageView.frame = CGRectMake(ceilf((CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - CGRectGetWidth(self.imageView.frame))/2.f),
                                          (height/2.f),
                                          CGRectGetWidth(self.imageView.frame),
                                          CGRectGetHeight(self.imageView.frame));
        CGFloat midX = CGRectGetWidth([[UIScreen mainScreen] applicationFrame])/2.f;
        self.imageView.center = CGPointMake(midX,
                                            (height - CGRectGetHeight(self.imageView.frame) - margin)/2.f);
        
        self.titleLabel.center = CGPointMake(midX,
                                             (height + CGRectGetHeight(self.titleLabel.frame) + margin)/2.f);
    }
    else {
        self.imageView.frame = CGRectMake(ceilf((CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - CGRectGetWidth(self.imageView.frame))/2.f), y, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
        y += (margin + CGRectGetHeight(self.imageView.frame));
        
        if (margin > 20){
            y -= 5.f;
        }
        
        self.titleLabel.frame = CGRectMake(ceilf((CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - CGRectGetWidth(self.titleLabel.frame))/2.f), y, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
        
        y += (margin + titleHeight);
        
        if (margin > 20){
            y -= 10.f;
        }
        
        self.subtitleLabel.frame = CGRectMake(ceilf((CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - CGRectGetWidth(self.subtitleLabel.frame))/2.f), y, CGRectGetWidth(self.subtitleLabel.frame), CGRectGetHeight(self.subtitleLabel.frame));
    
    }
    
  }

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _menu.highlightedBackgroundColor;
    _separatorView.backgroundColor = _menu.highlightedSeparatorColor;
    _imageView.image = _item.higlightedImage ? _item.higlightedImage : _item.image;
    _titleLabel.textColor = _menu.highlightedTextColor;
    _titleLabel.shadowColor = _menu.highlightedTextShadowColor;
    _titleLabel.shadowOffset = _menu.highlightedTextShadowOffset;
    _subtitleLabel.textColor = _menu.subtitleHighlightedTextColor;
    _subtitleLabel.shadowColor = _menu.subtitleHighlightedTextShadowColor;
    _subtitleLabel.shadowOffset = _menu.subtitleHighlightedTextShadowOffset;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    _separatorView.backgroundColor = _menu.separatorColor;
    _imageView.image = _item.image;
    _titleLabel.textColor = _menu.textColor;
    _titleLabel.shadowColor = _menu.textShadowColor;
    _titleLabel.shadowOffset = _menu.textShadowOffset;
    _subtitleLabel.textColor = _menu.subtitleTextColor;
    _subtitleLabel.shadowColor = _menu.subtitleTextShadowColor;
    _subtitleLabel.shadowOffset = _menu.subtitleTextShadowOffset;

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:.6f delay:0.f options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.backgroundColor = [UIColor clearColor];        
        _separatorView.backgroundColor = _menu.separatorColor;
        _imageView.image = _item.image;
        _titleLabel.textColor = _menu.textColor;
        _titleLabel.shadowColor = _menu.textShadowColor;
        _titleLabel.shadowOffset = _menu.textShadowOffset;
        _subtitleLabel.textColor = _menu.subtitleTextColor;
        _subtitleLabel.shadowColor = _menu.subtitleTextShadowColor;
        _subtitleLabel.shadowOffset = _menu.subtitleTextShadowOffset;
    } completion:nil];


    CGPoint endedPoint = [[touches anyObject] locationInView:self];
    if (endedPoint.y < 0 || endedPoint.y > CGRectGetHeight(self.bounds))
        return;

    if (_menu.waitUntilAnimationIsComplete) {
        __typeof (&*self) __weak weakSelf = self;
        [_menu closeWithCompletion:^{
            if (weakSelf.item.action) {
                weakSelf.item.action(weakSelf.item);
            }
        }];
    } else {
        [_menu close];
        if (self.item.action) {
            self.item.action(self.item);
        }
    }
}

@end
