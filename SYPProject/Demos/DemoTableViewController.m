//
//  DemoTableViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-11-14.
//
//

#import "DemoTableViewController.h"

#import "YPStyledTableViewCell.h"

@interface DemoTableViewController ()

@end

@implementation DemoTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView setRowHeight:60.0];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setSeparatorColor:[UIColor colorWithWhite:0.7 alpha:1]];
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_demoTableViewStyle==DemoTableViewStyle_Cyan)
    {
        static NSString *CellIdentifier = @"CYAN";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
            
        }
        [cell.textLabel setText:@"CYAN"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_Green)
    {
        static NSString *CellIdentifier = @"GREEN";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleGreen];
            
        }
        [cell.textLabel setText:@"GREEN"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_Purple)
    {
        static NSString *CellIdentifier = @"PURPLE";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStylePurple];
            
        }
        [cell.textLabel setText:@"PURPLE"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_Yellow)
    {
        static NSString *CellIdentifier = @"YELLOW";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleYellow];
            
        }
        [cell.textLabel setText:@"YELLOW"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_2Colors)
    {
        static NSString *CellIdentifier = @"CUSTOM2";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            
            NSMutableArray *colors = [NSMutableArray array];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [cell setSelectedBackgroundViewGradientColors:colors];
            
        }
        [cell.textLabel setText:@"CUSTOM - 2 colors"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_3Colors)
    {
        static NSString *CellIdentifier = @"CUSTOM3";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            
            NSMutableArray *colors = [NSMutableArray array];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
            [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
            [cell setSelectedBackgroundViewGradientColors:colors];
            
        }
        [cell.textLabel setText:@"CUSTOM - 3 colors"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_DottedLine)
    {
        static NSString *CellIdentifier = @"DOTTED_LINE";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
        }
        [cell.textLabel setText:@"SEPARATOR - DOTTED LINE"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_Dashes)
    {
        static NSString *CellIdentifier = @"DASH";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setStyledTableViewCellSelectionStyle:StyledTableViewCellSelectionStyleCyan];
            [cell setDashWidth:5 dashGap:3 dashStroke:1];
        }
        [cell.textLabel setText:@"SEPARATOR - DASHES"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_GradientVertical)
    {
        NSMutableArray *colors = [NSMutableArray array];
        //[colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"VERTICAL";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionVertical];
        }
        [cell.textLabel setText:@"VERTICAL (DEFAULT)"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_GradientHorizontal)
    {
        NSMutableArray *colors = [NSMutableArray array];
        //[colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"HORIZONTAL";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionHorizontal];
        }
        [cell.textLabel setText:@"HORIZONTAL"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_GradientDiagonalTopLeftToBottomRight)
    {
        NSMutableArray *colors = [NSMutableArray array];
        //[colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"DIAGONAL1";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionDiagonalTopLeftToBottomRight];
        }
        [cell.textLabel setText:@"DIAGONAL - TOP LEFT TO BOTTOM RIGHT"];
        return cell;
    }
    else if (_demoTableViewStyle==DemoTableViewStyle_GradientDiagonalBottomLeftToTopRight)
    {
        NSMutableArray *colors = [NSMutableArray array];
        //[colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:234/255.0 blue:0 alpha:1] CGColor]];
        [colors addObject:(id)[[UIColor colorWithRed:255/255.0 green:174/255.0 blue:0 alpha:1] CGColor]];
        
        static NSString *CellIdentifier = @"DIAGONAL2";
        YPStyledTableViewCell *cell = (YPStyledTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell)
        {
            cell = [[YPStyledTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.textLabel setHighlightedTextColor:[UIColor whiteColor]];
            [cell setDashWidth:1 dashGap:3 dashStroke:1];
            [cell setSelectedBackgroundViewGradientColors:colors];
            [cell setSelectionGradientDirection:StyledTableViewCellSelectionGradientDirectionDiagonalBottomLeftToTopRight];
        }
        [cell.textLabel setText:@"DIAGONAL - BOTTOM LEFT TO TOP RIGHT"];
        return cell;
    }
    else return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
