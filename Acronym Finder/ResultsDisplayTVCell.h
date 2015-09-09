//
//  ResultsDisplayTVCell.h
//  Acronym Finder
//
//  Created by Santhosh Ramaraju on 8/27/15.
//  Copyright © 2015 Santhosh Ramaraju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsDisplayTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *longForm;
@property (weak, nonatomic) IBOutlet UILabel *yearFrom;
@property (weak, nonatomic) IBOutlet UILabel *frequency;
@property (weak, nonatomic) IBOutlet UILabel *resultNumberLabel;
@property (strong, nonatomic) NSArray *variationsArr;
-(void)loadVariations;
@end
