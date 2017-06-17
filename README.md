# PScrollContainer
快速集成
```
pod 'PScrollContainer'
```
这是一个滑动容器库，支持自定义顶部分类样式需要实现`PScrollViewConfig`协议，类包含三个变量
```
@property (nonatomic, strong, nonnull) id<PScrollViewConfig> config;
@property (nonatomic, copy) void(^ _Nullable reloadData)(UITableView * _Nonnull tableView, NSInteger index);
@property (nonatomic, copy) UITableView *_Nonnull(^ _Nullable createTableView)(NSInteger index);
```
**config**是用来配置顶部分类的，**reloadData**是滑动过程中用来刷新数据的，**createTableView**是用来创建显示内容的tableView, 目前这个库的功能比较单一，后续会不断扩充
#如何使用
```
PScrollViewController *scrollContainer = [[PScrollViewController alloc] init];
    scrollContainer.createTableView = ^UITableView * _Nonnull(NSInteger index) {
        self.dataArray = newData;
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        return tableView;
    };
    scrollContainer.reloadData = ^(UITableView * _Nonnull tableView, NSInteger index) {
        **先清空重用之前的旧数据**
        [self.dataArray removeAllObjects];
        [tableView reloadData];
        **加载新的数据，刷新列表**
        self.dataArray = newData;
        [tableView reloadData];
    };
    scrollContainer.config = [[ConfigObj alloc] init];
    [self addChildViewController:scrollContainer];
    [self.view addSubview:scrollContainer.view];
```
