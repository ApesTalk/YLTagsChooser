# YLTagsChooser
用UICollectionView实现的兴趣标签选择器，可传入最多可选择标签数量。

用UICollectionView实现了高度固定，宽度不固定，每行显示的标签个数不定的瀑布流效果。本示例只简单展示了类似UIActionSheet弹出效果。可以模仿实现其他类似效果。

核心思想就是在- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath方法中通过计算上一个cell的frame和当前cell的frame来判断将当前cell显示在什么位置。具体实现见代码。

## 效果图：

![](https://github.com/lqcjdx/YLTagsChooser/blob/master/YLTagsChooser.gif)


## 2016-11-1更新
一、修复数据源较多的情况下部分cell不显示的bug:[https://github.com/lqcjdx/YLTagsChooser/issues/1](标签很多的时候，中间cell会不显示，而且会出现很多空白的地方 #1)

二、实现可添加sectionheader的效果。

因为有人反映自定义UICollectionViewFlowLayout的情况下，方法``- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath``不调用的问题。我也做了尝试，确实是很容易就造成这个方法不被调用。

实现步骤总结如下：

1、设置自定义UICollectionViewFlowLayout对象的headerReferenceSize属性或者实现UICollectionViewDelegateFlowLayout的``- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section``方法返回sectionheader的高度；

2、注册sectionheader:``[_myCollectionView registerClass:\[YLCollectionReusableView class]() forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YLCollectionReusableView”]``;

3、在方法``- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath中``返回自定义sectionheader;


需要注意的是在``- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect``方法中应该加上判断当前UICollectionViewLayoutAttributes的representedElementCategory属性是否是UICollectionElementCategoryCell类型的，不能在这里改变了sectionheader的高度导致显示异常。因为所有view和cell的属性都会调用该方法。


