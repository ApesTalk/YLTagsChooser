# YLTagsChooser
用UICollectionView实现的兴趣标签选择器，可传入最多可选择标签数量。

用UICollectionView实现了高度固定，宽度不固定，每行显示的标签个数不定的瀑布流效果。本示例只简单展示了类似UIActionSheet弹出效果。可以模仿实现其他类似效果。

核心思想就是在- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath方法中通过计算上一个cell的frame和当前cell的frame来判断将当前cell显示在什么位置。具体实现见代码。

效果图：



