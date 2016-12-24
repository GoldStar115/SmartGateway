//
//  CalendarVC.m
//  SmartGateway
//
//  Created by Grace on 13/5/16.
//  Copyright © 2016 Grace. All rights reserved.
//

#import "CalendarVC.h"
#import "BookingVC.h"

@interface CalendarVC ()

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.alpha = 0.0;
    selectedIndex = -1;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[dm apiEngine] facilityType:self.facilityType.type_id
                    onCompletion:^(NSString *message, NSMutableArray *result) {
                        [SVProgressHUD dismiss];
                        [self showPopUp:message];
                        facilityArray = result;
                        [self refresh];
                        self.view.alpha = 1.0;
                    }
                         onError:^(NSError* error) {
                             [SVProgressHUD dismiss];
//                             [UIAlertView showWithError:error];
                             [self showError:error onCompletion:^(UIButton *sender) {
                                 if(!facilityArray)
                                     [self popViewController];
                             }];

                         }
     ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
}

- (void)refresh
{
    if(facilityArray.count > 0)
        selectedIndex = 0;
    
    pageControl.numberOfPages = facilityArray.count;
    
    for(UIView *vw in courtView.subviews)
    {
        if(vw != courtButton)
            [vw removeFromSuperview];
    }
    
    int index = 0;
    for(Facility *facility in facilityArray)
    {
        UIButton *button;
        if(index == 0)
        {
            button = courtButton;
        }
        else
        {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = courtButton.titleLabel.font;
            [button addTarget:self action:@selector(courtClicked:) forControlEvents:UIControlEventTouchUpInside];

            [button setTitleColor:[courtButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
            [button setTitleColor:[courtButton titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];

            [button setBackgroundImage:[courtButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [button setBackgroundImage:[courtButton backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected];
            
            [courtView addSubview:button];
        }
        
        button.tag = index;
        [button setTitle:facility.name forState:UIControlStateNormal];
        
        float width = self.view.frame.size.width/facilityArray.count;
        button.frame = CGRectMake(width*index, 0, width, courtButton.frame.size.height);
        
        index ++;
    }
    
    [self reloadCalendar];
}

- (void)reloadCalendar
{
    pageControl.currentPage = selectedIndex;
    Facility *facility = [facilityArray objectAtIndex:selectedIndex];
//    [headerImage sd_setImageWithURL:[NSURL URLWithString:facility.image_url] placeholderImage:[UIImage imageNamed:@"logo.png"] options:SDWebImageRefreshCached];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:facility.image_url]];
    
    FacilityDate *fdate = [facility.dates objectAtIndex:0];
    NSDate *firstDate = [[dm serverDateFormatter] dateFromString:fdate.bookdate];
    
    //always start from sunday
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:firstDate];
    NSInteger weekday = [components weekday];
    NSLog(@"first day: %d [%@]", (int)weekday, fdate.bookdate);
    if(weekday > 1)
    {
        for(int i=1; i<weekday;i++)
        {
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            dayComponent.day = -1*i;
            NSDate *yesterday = [cal dateByAddingComponents:dayComponent
                                                     toDate:firstDate
                                                    options:0];
            
            FacilityDate *fdate = [[FacilityDate alloc] init];
            fdate.bookdate = [[dm serverDateFormatter] stringFromDate:yesterday];
            fdate.date_id = @"-1";
            fdate.state = @"not_available";
            NSLog(@"add date: %@ [%d]", fdate.bookdate, (int)dayComponent.day);
            [facility.dates insertObject:fdate atIndex:0];
        }
    }
    
    NSMutableArray *months = [[NSMutableArray alloc] init];
    for(FacilityDate *fdate in facility.dates)
    {
        NSDate *date = [[dm serverDateFormatter] dateFromString:fdate.bookdate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMMM"];
        NSString *month = [df stringFromDate:date];
        if([months indexOfObject:month] == NSNotFound)
            [months addObject:month];
    }
    
    monthLabel.text = [months componentsJoinedByString:@" & "];
    
    if(facility.dates.count > 0)
    {
        FacilityDate *fdate = [facility.dates objectAtIndex:0];
        NSDate *firstDate = [[dm serverDateFormatter] dateFromString:fdate.bookdate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEE"];
        
        for(int i=0;i<7;i++)
        {
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            [dateComponents setDay:i];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:firstDate options:0];
            
            UILabel *label = (UILabel *)[dayView viewWithTag:i+1];
            label.text = [df stringFromDate:newDate];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rightClicked:(id)sender
{
    
}

- (IBAction)leftClicked:(id)sender
{
    
}

- (IBAction)courtClicked:(UIButton *)sender
{
    if(sender.selected)
        return;
    
    for(UIView *view in courtView.subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *)view;
            if(button == sender)
            {
                button.selected = YES;
            }
            else
                button.selected = NO;
        }
    }
    
    selectedIndex = (int)sender.tag;
    [self reloadCalendar];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    Facility *facility = [facilityArray objectAtIndex:selectedIndex];
    NSLog(@"dates: %d", (int)facility.dates.count);
    return facility.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifierString = @"CalendarCell";
    
    CalendarCell *cell = (CalendarCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifierString forIndexPath:indexPath];
    
    // Configure the cell
//    NSDictionary *data = [cellArray objectAtIndex:indexPath.row];
//    cell.dateLabel.text = [NSString stringWithFormat:@"%d", [[data objectForKey:@"date"] intValue]];
//    [cell setStatus:[[data objectForKey:@"status"] intValue]];
    
    Facility *facility = [facilityArray objectAtIndex:selectedIndex];
    FacilityDate *fdate = [facility.dates objectAtIndex:indexPath.row];
    NSDate *date = [[dm serverDateFormatter] dateFromString:fdate.bookdate];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [df stringFromDate:date]];
    [cell setStatus:fdate.state];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float w = collectionView.frame.size.width /7;
//    NSLog(@"cell width: %f", w);

    return CGSizeMake(floorf(w), floorf(w));
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Facility *facility = [facilityArray objectAtIndex:selectedIndex];
    FacilityDate *fdate = [facility.dates objectAtIndex:indexPath.row];
    
    if([fdate.state isEqualToString:@"not_available"])
        return NO;
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Facility *facility = [facilityArray objectAtIndex:selectedIndex];
    FacilityDate *fdate = [facility.dates objectAtIndex:indexPath.row];
    
    UIStoryboard *sb = self.storyboard;
    BookingVC *vc = [sb instantiateViewControllerWithIdentifier:@"BookingVC"];
    vc.facility = facility;
    vc.facilityDate = fdate;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
