//
//  ViewController.m
//  FMDBDemo2
//
//  Created by LZXuan on 15-7-17.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "ViewController.h"

#import "MyImageView.h"
#import "DBManager.h"
#import "StudentModel.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *uidTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
- (IBAction)addClick:(id)sender;
- (IBAction)deleteClick:(id)sender;
- (IBAction)updateClick:(id)sender;
- (IBAction)fetchClick:(id)sender;
@property (weak, nonatomic) IBOutlet MyImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.iconImageView.backgroundColor = [UIColor redColor];
    //增加点击事件
    [self.iconImageView addTarget:self action:@selector(imageClick:)];
    
}
- (void)imageClick:(MyImageView *)imageView {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //获取相册
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}
//cancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = info[UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        //从info获取图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        //iconImageView 的图片
        self.iconImageView.image = image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.uidTextField resignFirstResponder];
    [self.ageTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
}

- (IBAction)addClick:(id)sender {
    StudentModel *model = [[StudentModel alloc] init];
    model.uid = self.uidTextField.text;
    model.name  = self.nameTextField.text;
    model.age = self.ageTextField.text.integerValue;
    //把图片转化为二进制
    model.imageData = UIImagePNGRepresentation(self.iconImageView.image);
    //增加
    [[DBManager defaultManager] insertModel:model];
    //更新表格
    [self updateTableViewAndData];
}
- (void)updateTableViewAndData {
    //删除 数据源所有数据
    [self.dataArr removeAllObjects];
    //从数据库获取新数据
    [self.dataArr addObjectsFromArray:[[DBManager defaultManager] fetchAllData]];
    //数据源变了 刷新表格
    [self.tableView reloadData];
}

- (IBAction)deleteClick:(id)sender {
    [[DBManager defaultManager] deleteModelWithUid:self.uidTextField.text];
    //更新表格
    [self updateTableViewAndData];
}

- (IBAction)updateClick:(id)sender {
    //新对象
    StudentModel *model = [[StudentModel alloc] init];
    model.uid = self.uidTextField.text;
    model.name  = self.nameTextField.text;
    model.age = self.ageTextField.text.integerValue;
    //把图片转化为二进制
    model.imageData = UIImagePNGRepresentation(self.iconImageView.image);
    //修改数据库
    [[DBManager defaultManager] updateModelWithUid:self.uidTextField.text newModel:model];
    //刷新表格
    [self updateTableViewAndData];
}
//查询
- (IBAction)fetchClick:(id)sender {
    [self updateTableViewAndData];
}

#pragma mark - UITableView协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    StudentModel *model = self.dataArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"uid:%@ name:%@ age:%ld datalength:%ld",model.uid,model.name,model.age,model.imageData.length];
    cell.imageView.image = [UIImage imageWithData:model.imageData];
    return cell;
}

@end




