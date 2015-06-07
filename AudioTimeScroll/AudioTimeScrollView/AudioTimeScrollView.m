//
//  AudioTimeScrollView.m
//  AudioTimeScroll
//
//  Created by SSPC139 on 2015/6/2.
//  Copyright (c) 2015年 Goston. All rights reserved.
//

#import "AudioTimeScrollView.h"

@implementation AudioTimeScrollView
{
    UILabel *timeClassInterval;
    NSMutableArray *reuseLabelArray;
    NSInteger pageNumber;
    Float64 totalPages;
    CGFloat reuseLabelWidth;
    
    CGFloat theadPosition;
    CGFloat ttailPosition;
    NSInteger headLabelTag;
    NSInteger tailLabelTag;
    
    UIView *centerBarView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        reuseLabelWidth = frame.size.width / 10;
        
        // Initial Label variables
        reuseLabelArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 11; ++i)
        {
            UILabel *reuseLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * frame.size.width / 10, 0, reuseLabelWidth, 14)];
            [reuseLabel setText:[NSString stringWithFormat:@"%ld", (long)i]];
            [reuseLabel setTextColor:[UIColor blackColor]];
            [reuseLabel setTextAlignment:NSTextAlignmentLeft];
            [reuseLabel setFont:[UIFont systemFontOfSize:10]];
            [reuseLabel setTag:i];
            CGFloat randomRed = (arc4random() % 255) / 255.f;
            CGFloat randomGreen = (arc4random() % 255) / 255.f;
            CGFloat randomBlue = (arc4random() % 255) / 255.f;
            [reuseLabel setBackgroundColor:[UIColor colorWithRed:randomRed green:randomGreen blue:randomBlue alpha:1.f]];
            [reuseLabelArray addObject:reuseLabel];
            [self addSubview:reuseLabel];
        }
        headLabelTag = 0;
        tailLabelTag = 10;
        
        theadPosition = [[reuseLabelArray firstObject] frame].origin.x;
        ttailPosition = [[reuseLabelArray lastObject] frame].origin.x + reuseLabelWidth;
        
        [self setUserInteractionEnabled:YES];
        [self setContentSize:CGSizeMake(MAXFLOAT, self.frame.size.height)];
        [self setScrollEnabled:YES];
        
        totalPages = MAXFLOAT / frame.size.width;
        pageNumber = 0;
        
        // Initial Center view variable
        centerBarView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 2) / 2, 0, 2, 40)];
        [centerBarView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:centerBarView];
        self.delegate = self;
    }
    return self;
}

-(void)caculatePageNumber
{
    pageNumber = self.contentOffset.x / self.frame.size.width;
}

-(void)changeReuseLabelFrame:(UILabel *)reuseLabel andHeadPosition:(CGFloat)headPosition andTailPosition:(CGFloat)tailPosition
{
    // Label head position and tail position
    CGFloat labelHeadPosition = reuseLabel.frame.origin.x;
    CGFloat labelTailPosition = reuseLabel.frame.origin.x + reuseLabel.frame.size.width;
    
    // Scroll view visible head position and tail position
    CGFloat scrollViewHeadPosition = self.contentOffset.x;
    CGFloat scrollViewTailPosition = self.contentOffset.x + self.frame.size.width;
    
    // Move to tail
    if (labelTailPosition < scrollViewHeadPosition)
    {
        [reuseLabel setFrame:CGRectMake(ttailPosition, 0, reuseLabelWidth, 14)];
        [reuseLabel setText:[NSString stringWithFormat:@"%ld", (pageNumber) * 10 + reuseLabel.tag]];
        ttailPosition = ttailPosition + reuseLabelWidth;
        theadPosition = theadPosition + reuseLabelWidth;

        // Circular move
        tailLabelTag = reuseLabel.tag;
        if (reuseLabel.tag + 1 > 10)
        {
            headLabelTag = 0;
        }
        else
        {
            headLabelTag = reuseLabel.tag + 1;
        }
    }
    
    // Move to head
    else if (labelHeadPosition > scrollViewTailPosition)
    {
        [reuseLabel setFrame:CGRectMake(theadPosition - reuseLabelWidth, 0, reuseLabelWidth, 14)];
        [reuseLabel setText:[NSString stringWithFormat:@"%ld", (pageNumber) * 10 + reuseLabel.tag]];
        theadPosition = theadPosition - reuseLabelWidth;
        ttailPosition = ttailPosition - reuseLabelWidth;

        // Circular move
        headLabelTag = reuseLabel.tag;
        if (reuseLabel.tag - 1 < 0)
        {
            tailLabelTag = 10;
        }
        else
        {
            tailLabelTag = reuseLabel.tag - 1;
        }
    }
}

-(void)recenterBarView
{
    // Read centerBarView's rect from super view
    CGRect convertFromRect = [self convertRect:centerBarView.frame fromView:self.superview];
    
    // Made centerBarView always in center
    [centerBarView setFrame:CGRectMake(convertFromRect.origin.x - centerBarView.frame.origin.x + self.center.x, centerBarView.frame.origin.y, centerBarView.frame.size.width, centerBarView.frame.size.height)];
}

-(void)layoutSubviews
{
    [self caculatePageNumber];
    
    for (UILabel *reuseLabel in reuseLabelArray)
    {
        if (reuseLabel.tag == headLabelTag || reuseLabel.tag == tailLabelTag)
        {
            [self changeReuseLabelFrame:reuseLabel andHeadPosition:0 andTailPosition:0];
        }
    }
    [self recenterBarView];
}

//-(void)recenterIfNecessary
//{
//    CGPoint currentOffset = self.contentOffset;
//    CGFloat contentWidth = self.contentSize.width;
//    CGFloat centerOffsetX = contentWidth - self.bounds.size.width / 2.0;
//    
//}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidScroll");
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewWillBeginDragging");
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollViewDidEndDragging");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidEndDecelerating");
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)removeFromSuperview
{
    [super removeFromSuperview];
}

-(void)dealloc
{
    
}

@end
