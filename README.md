# YLTagsChooser
用UICollectionView实现的兴趣标签选择器，可传入最多可选择标签数量和上一次选中的标签。

**注意：UICollectionView在cell较多的情况下，在滑动的过程中会出现某些cell一会显示一会不显示的问题已解决，欢迎star和提出优化方案。**

在这里我用UICollectionView实现了高度固定，宽度不固定，每行显示的标签个数不定的瀑布流效果。本示例只简单展示了类似UIActionSheet弹出效果。可以模仿实现其他类似效果。

核心思想就是在- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath方法中通过计算上一个cell的frame和当前cell的frame来判断将当前cell显示在什么位置。具体实现见代码。

---
A interest tag selector implemented with the UICollectionView, which allows you to pass in the maximum number of selectable tags and the last selected tags.

Here I use UICollectionView to achieve a high degree of fixed, the width is not fixed, each row shows the number of labels on the waterfall flow effect. This example only shows a similar UIActionSheet pop-up effect. It also Can be imitated to achieve other similar effects.


## 效果图 Demonstration ：

![](https://github.com/lqcjdx/YLTagsChooser/blob/master/YLTagsChooser.gif)


## 2016-11-1 update

一、修复数据源较多的情况下部分cell不显示的bug:[标签很多的时候，中间cell会不显示，而且会出现很多空白的地方 #1](https://github.com/lqcjdx/YLTagsChooser/issues/1) (fixed bug #1)

二、实现可添加sectionheader的效果。(Show how to add a UICollectionReusableView.)

因为有人反映自定义UICollectionViewFlowLayout的情况下，方法

```OBJC
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView    
           viewForSupplementaryElementOfKind:(NSString *)kind 
                                 atIndexPath:(NSIndexPath *)indexPath
```

不调用的问题。我也做了尝试，确实是很容易就造成这个方法不被调用。

实现步骤总结如下：

1、设置自定义UICollectionViewFlowLayout对象的headerReferenceSize属性或者实现UICollectionViewDelegateFlowLayout的

```OBJC
- (CGSize)collectionView:(UICollectionView *)collectionView 
                  layout:(UICollectionViewLayout*)collectionViewLayout 
referenceSizeForHeaderInSection:(NSInteger)section
```

方法返回sectionheader的高度；

2、注册sectionheader:

```OBJC
[_myCollectionView registerClass:[YLCollectionReusableView class]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader 
             withReuseIdentifier:@"YLCollectionReusableView”]
```


3、在方法

```OBJC
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView 
           viewForSupplementaryElementOfKind:(NSString *)kind 
                                 atIndexPath:(NSIndexPath *)indexPath
```

中返回自定义sectionheader;


需要注意的是在``- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect``方法中应该加上判断当前UICollectionViewLayoutAttributes的representedElementCategory属性是否是UICollectionElementCategoryCell类型的，不能在这里改变了sectionheader的高度导致显示异常。因为所有view和cell的属性都会调用该方法。

## 2017-06-15 update

一、新增默认选中的标签，下次进入页面会默认显示上次选中的标签。[Can we retain selected tag ?](https://github.com/lqcjdx/YLTagsChooser/issues/2)(fixed bug #2)

可能同一个APP内会有多个页面会使用到标签选择器，并且每次选择的标签类型不太一样，所以建议将标签封装为一个对象：YLTag，每次显示YLTagsChooser的时候传入上次选中的值。

Maybe you have multiple pages in your APP will use the tags selector, and each time you select the tags, the type is not the same, it is recommended to package the tag as an object: YLTag, each time you display YLTagsChooser, you can pass the last selected The value to it.


## 2017-09-07 update

一、支持多Section，每个section一个header，解决高度计算问题。使用方法：
将每个分区的数据单独放在一个数组中，最后这些数组都放在orignDataArray里面，调用以下方法传入数据即可。

```OBJC
[chooser refreshWithTags:orignDataArray selectedTags:selectedTags];
```

## 2017-09-08 update

一、解决UICollectionView在滑动过程中有些cell一会显示一会不显示的问题。[UICollectionView的重大bug?真相竟然是......](http://www.jianshu.com/p/c07e28d3563d)

搜索``UICollectionView some cell not appear``或``UICollectionViewCell not appear``可见相关问题。

这个bug主要是cell较多并且cell的frame属性自定义的情况下很容易发生。

因为我们的每个item的属性都是完全自定义的，所以在``layoutAttributesForElementsInRect:``方法如果直接调用``[super layoutAttributesForElementsInRect: rect]``，拿到的这个集合其实是不对的，所以或导致有些cell在滑动过程中一会消失一会显示。


### 下面简单讲一下解决思路：

自定义UICollectionViewLayout必须覆盖的方法且执行顺序如下：

```OBJC
- (void)prepareLayout;
- (CGSize)collectionViewContentSize;
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
```

- prepareLayout

布局快要生效的时候被调用，在这里将每个item的frame属性计算出来并缓存起来。

- collectionViewContentSize

UICollectionView通过它获取可滑动范围，在这里根据上面计算的值获取最大可滚动范围。

- layoutAttributesForElementsInRect:

返回指定区域内的item的布局属性（UICollectionViewLayoutAttributes对象）集合。

解决这个bug的要点是在``layoutAttributesForElementsInRect:``方法中先获取UICollectionView当前的可见范围，然后根据第一步计算并缓存起来的item属性来判断当前可见范围内有哪些item应该是可见的，把这些item对应的UICollectionViewLayoutAttributes对象放到一个数组中返回。

