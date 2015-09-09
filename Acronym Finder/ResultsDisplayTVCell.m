//
//  ResultsDisplayTVCell.m
//  Acronym Finder
//
//  Created by Santhosh Ramaraju on 8/27/15.
//  Copyright © 2015 Santhosh Ramaraju. All rights reserved.
//

#import "ResultsDisplayTVCell.h"
@interface ResultsDisplayTVCell()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *variationsTableView;

@end
@implementation ResultsDisplayTVCell
- (void)awakeFromNib {
    // Initialization code
}
-(void)loadVariations
{
    self.variationsTableView.dataSource = self;
    self.variationsTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.variationsTableView reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.variationsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(!(cell = [self.variationsTableView dequeueReusableCellWithIdentifier:@"reuse"]))
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"reuse"];
    }
    [cell setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    NSDictionary *varDict = [self.variationsArr objectAtIndex:indexPath.row];
    if(varDict.count>0)
    cell.textLabel.text = varDict[@"lf"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Used since: %@ with Frequency: %@",varDict[@"since"],varDict[@"freq"]];
    
    return cell;
}
@end
