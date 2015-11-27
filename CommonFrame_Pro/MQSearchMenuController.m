//
//  ICSideMenuController.m
//  CDSideBar
//
//  Created by ionitech on 15/6/4.
//  Copyright (c) 2015年 Christophe Dellac. All rights reserved.
//

#import "MQSearchMenuController.h"
#import "SKSTableViewCell.h"
#import "Mark.h"
#import "UICommon.h"
#import "MarkCell.h"
#import "MQSearchCollReusableView.h"

@interface MQSearchMenuController()
{
    NSIndexPath*    _indexTime;
    NSIndexPath*    _indexType;
    
    UIView * _searchTopView;
    UIView * _searchMarkView;
    
    UITextField * _txtField;
    UIButton * _searchBtn;
}


@end

@implementation MQSearchMenuController


@synthesize menuColor = _menuColor;
@synthesize isOpen = _isOpen;


#pragma mark -
#pragma mark TableViewDelaget

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    Mark * mark = _nameList[indexPath.section][indexPath.row][0];
    
    cell.titleLbl.text = mark.labelName;
    cell.iconImg.image = [UIImage imageNamed:mark.labelImage];
    cell.backgroundColor = RGBCOLOR(31, 31, 31);
    
    UILabel* bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, tableView.frame.size.width, 0.5)];
    [bottomLine setBackgroundColor:RGBCOLOR(74, 74, 74)];
    [cell.contentView addSubview:bottomLine];
    
    if ((indexPath.section == 0 && (indexPath.row == 2 || indexPath.row == 1 || indexPath.row == 0)))
        cell.expandable = YES;
    else
        cell.expandable = NO;
    
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SliderTypeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger subRow = indexPath.subRow;
    
    if(indexPath.subRow < [_nameList[indexPath.section][indexPath.row] count])
    {
        Mark * m = _nameList[indexPath.section][indexPath.row][indexPath.subRow];
        
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 17, 17)];
        [img setBackgroundColor:[UIColor clearColor]];
        [img setImage:[UIImage imageNamed:m.labelImage]];
        
        [cell.contentView addSubview:img];
        
        UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(XW(img)+ 14, 0, 200, 44)];
        [name setBackgroundColor:[UIColor clearColor]];
        [name setText:m.labelName];
        [name setTextColor:RGBCOLOR(251, 251, 251)];
        [name setFont:[UIFont systemFontOfSize:14]];
        [cell.contentView addSubview:name];
        
        cell.contentView.backgroundColor = RGBCOLOR(36, 36, 36);
        
        UILabel* bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.5, tableView.frame.size.width, 0.5)];
        [bottomLine setBackgroundColor:RGBCOLOR(74, 74, 74)];
        [cell.contentView addSubview:bottomLine];
    }
    
    return cell;
}



- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
//    
//    if ([self.delegate respondsToSelector:@selector(cdSliderCellClicked:)])
//        [self.delegate cdSliderCellClicked:indexPath];
//    //[self dismissMenu];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_nameList count];
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameList[section] count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_nameList[indexPath.section][indexPath.row] count] - 1;
}

#pragma mark - collectionview delegate / datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [_nameList[0] count];
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [_nameList[0][section] count] - 1;
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MarkCell";
    MarkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
//    NSInteger subRow = indexPath.subRow;
    
//    if(subRow < [_nameList[0][section] count])
    {
        Mark * mark = _nameList[0][section][row + 1];
        
        [cell.markBtn setTitle:mark.labelName forState:UIControlStateNormal];
        
        //    [cell.markBtn addTarget:self action:@selector(clickMarkItem:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.markBtn.tag = indexPath.row;
        
        [cell setRoundColorCorner:3.3];
        
        [cell setBorderWithColor:[UIColor grayLineColor]];
        
        cell.markBtn.selected = NO;
        
        [cell.markBtn setBackgroundColor:[UIColor grayMarkColor]];
        
        [cell.markBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [cell setBorderWithColor:[UIColor grayLineColor]];
    }
    
    return cell;

}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;

    view.backgroundColor = [UIColor backgroundColor];
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader]){
        
        Mark * mark = _nameList[0][section][0];
        
        UIImageView * iconImgView = [view viewWithTag:1];
        if(!iconImgView)
        {
            iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 13, 13)];
            iconImgView.tag = 1;
            
            [view addSubview:iconImgView];
        }
        
        UILabel * titleLbl = [view viewWithTag:2];
        if(!titleLbl)
        {
            titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(XW(iconImgView)+ 7, Y(iconImgView) - 2, 100, 16)];
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor grayTitleColor];
            titleLbl.font = Font(15);
            titleLbl.tag = 2;
            [view addSubview:titleLbl];
        }
        
        NSString * iconName = @"icon_changyong";
        
        if(indexPath.section == 0)
        {
            iconName = @"icon_shijian_1";
        }
        else if (indexPath.section == 1)
        {
            iconName = @"icon_fabu_1";
        }
        else if (indexPath.section == 2)
        {
            iconName = @"icon_biaoqian_1";
        }
        
        iconImgView.image = [UIImage imageNamed:iconName];
        titleLbl.text = mark.labelName;
    }
 
    return view;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat pstH = (SCREENWIDTH - 14 * 2 - 14 * 3)/4;
    
    return CGSizeMake(pstH, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREENWIDTH, 40);
}

#pragma mark -
#pragma mark Init

- (MQSearchMenuController*)initWithImages:(NSArray*)images  names:(NSArray*)nameList  menuButton:(UIButton*)button
{

    [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _menuButton = button;
    
    _backgroundMenuView = [[UIView alloc] init];
    _menuColor = [UIColor whiteColor];
    _buttonList = [[NSMutableArray alloc] initWithArray:images];
    _nameList = [[NSMutableArray alloc] initWithArray:nameList];
    
    
    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
//    [view addGestureRecognizer:singleTap];
//    
//    singleTap.delegate = self;
    
    _viewWidth = view.frame.size.width;
    
    UIView * topButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 24 + 53)];
    topButtonView.backgroundColor = [UIColor clearColor];
    [_backgroundMenuView addSubview: topButtonView];
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH - 46, 53, 46, 24 + 6)];
    closeBtn.titleLabel.font = Font(12);
    closeBtn.titleLabel.textColor = [UIColor whiteColor];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor backgroundColor];
    [closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setRoundCorner:3.3];
    [_backgroundMenuView addSubview:closeBtn];
    
    [self searchHeaderView];
    [_backgroundMenuView addSubview:_searchTopView];
    
    CGRect tableFrame = CGRectMake(0, YH(_searchTopView) , _viewWidth, [UIApplication sharedApplication].delegate.window.bounds.size.height - YH(_searchTopView) - 64);
    
//    _mainTableView = [[SKSTableView alloc]  initWithFrame:tableFrame];
//    _mainTableView.showsVerticalScrollIndicator = NO;
//    [_mainTableView setBackgroundColor:[UIColor blackColor]];
//    [_mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    _mainTableView.shouldExpandOnlyOneCell = YES;
//    _mainTableView.SKSTableViewDelegate = self;
//    [_backgroundMenuView addSubview:_mainTableView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 14.f;
    layout.minimumLineSpacing = 14.f;
    UIEdgeInsets insets = {.top = 0,.left = 14,.bottom = 32,.right = 14};
    layout.sectionInset = insets;
    
    _mainCollView = [[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:layout];
    _mainCollView.delegate = self;
    _mainCollView.dataSource = self;
    _mainCollView.showsVerticalScrollIndicator = NO;
    [_mainCollView setBackgroundColor:[UIColor backgroundColor]];
    [_mainCollView registerClass:[MarkCell class] forCellWithReuseIdentifier:@"MarkCell"];
    
    [_mainCollView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell"];

//    [_mainCollView registerNib:[UINib nibWithNibName:@"MQSearchCollReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MQSearchCollReusableView"];

    [_backgroundMenuView addSubview:_mainCollView];

    _backgroundMenuView.frame = CGRectMake(0, SCREENHEIGHT, _viewWidth, view.frame.size.height);
    _backgroundMenuView.backgroundColor = [UIColor clearColor];
    [view addSubview:_backgroundMenuView];
    
}

- (void) closeButtonClick
{
    [self dismissMenu];
}

- (UIView *) searchHeaderView
{
    if(!_searchTopView)
    {
        _searchTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 24 + 53, SCREENWIDTH, 62)];
        _searchTopView.backgroundColor = [UIColor backgroundColor];

    }
    
    if(!_searchMarkView)
    {
        _searchMarkView = [[UIView alloc] initWithFrame:CGRectMake(14, 14, SCREENWIDTH - 14 * 2, 34)];
        _searchMarkView.backgroundColor = [UIColor whiteColor];
        [_searchMarkView setRoundColorCorner:3.3 withColor:[UIColor grayLineColor]];
        [_searchTopView addSubview:_searchMarkView];
        
        UIImageView * searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 14, 14)];
        searchIcon.image = [UIImage imageNamed:@"icon_sousuo_huise"];
        [_searchMarkView addSubview:searchIcon];
        
        _txtField = [[UITextField alloc] initWithFrame:CGRectMake(28, 0, W(_searchMarkView) - 29, 34)];
        _txtField.tag = 1;
        _txtField.font = Font(15);
        _txtField.placeholder = @"请输入您要查找的关键字";
        [self addDoneToKeyboard:_txtField];
        [_searchMarkView addSubview:_txtField];
        
        
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(W(_searchMarkView) - 70, 0, 70, H(_searchMarkView))];
        [_searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setBackgroundImage:[UIImage imageNamed:@"btn_chazhaolan"] forState:UIControlStateNormal];

        [_searchBtn setTitle:@"查找" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:RGBCOLOR(51, 51, 51) forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = Font(15);
        [_searchMarkView addSubview:_searchBtn];
    }

    return _searchTopView;
}

- (void) hiddenKeyboard
{
    [_txtField resignFirstResponder];
}

- (void)searchBtnClicked:(id)sender
{
    
}

- (void)bgTap
{
    [self dismissMenu];
    
}

#pragma mark -
#pragma mark Gesture recognizer action

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    else if ([NSStringFromClass([touch.view class]) isEqualToString:@"PPDragDropBadgeView"]) {
        //UIView* cView = touch.view;
        UIView* pView = touch.view.superview;
        for (UIControl* control in pView.subviews) {
            if ([control isKindOfClass:[UIButton class]]) {
                UIButton* btn = (UIButton*)control;
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                break;
            }
        }
        return NO;
    }
    else if ([NSStringFromClass([touch.view class]) isEqualToString:@"ZYQTapAssetView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                         [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    //[_bgView setHidden:YES];
    if (_isOpen)
    {
        _isOpen = !_isOpen;
        [self performDismissAnimation];
    }
}

- (void)showMenu
{
    if (!_isOpen)
    {
        //[_bgView setHidden:NO];
        _isOpen = YES;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
    else
    {
        [self dismissMenu];
    }
    
    if ([self.delegate respondsToSelector:@selector(partfarmButtonClicked:)]) {
        [self.delegate partfarmButtonClicked:@"2"];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(cdSliderCellClicked:)])
        //        [self.delegate cdSliderCellClicked:button.tag];
        [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        _menuButton.alpha = 1.0f;
        _menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -SCREENHEIGHT + 64);
        }];
    });
}

@end