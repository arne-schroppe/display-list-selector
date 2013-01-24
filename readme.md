
#CSS Selectors for the display list

An implementation of CSS3–selectors for flash. Selectors are
of the form

    Sprite#container > MovieClip:nth-child(2) *.headline > TextField[text='About']

The display list selector library processes selectors like this and returns a collection
of matched objects.



##Basic usage

First, initialize a factory for your selectors. The factory also holds data and settings that are relevant
for all selectors

    var selectorFactory:SelectorFactory = new DisplayListSelectorFactory();
    selectorFactory.initializeWith(stage);

Then just create selectors:

    var selector:SelectorGroup = selectorFactory.createSelector("Sprite:first-child(), MovieClip");

Before you can query an object against a selector, a `SelectorAdapter` must be created for that object. 
The `DisplayListSelectorFactory` uses the `ADDED_TO_STAGE` event to automatically add a suitable `SelectorAdapter`,
so usually you don't have to worry about this. You can just query the selector right away:

    var isMatching:Boolean = selector.isAnySelectorMatching(someDisplayObject);

Selectors are modeled after the CSS3 selector standard but not all features have been implemented
yet.


##Usage scenarios

The selector library supports two different usage scenarios by providing optimized objects for each. When
a single selector needs to be matched against a single object the mentioned `SelectorGroup` should be used.
If many selectors need to be checked against a single object, though, a more optimized object is available, the
`SelectorPool`. It is used as follows:

    var selectorPool:SelectorPool = selectorFactory.createSelectorPool();
    selectorPool.addSelector("Sprite");
    selectorPool.addSelector("MovieClip");
    selectorPool.addSelector("*:first-child()");

    var matches:Vector.<SelectorDescription> = selectorPool.getSelectorsMatchingObject(someDisplayObject);

The result is sorted by [specificity](http://www.w3.org/TR/selectors/#specificity).


##Extended selector syntax

This library also supports an extended selector syntax, that is better suited in dealing with ActionScript objects.


###The `is-a` pseudo class
The regular element selector only matches if the element's classname equals the given identifier.
The `is-a` pseudo class also matches superclasses and implemented interfaces. For example:

    :is-a(Sprite)

matches elements of type Sprite, MovieClip, and other objects that have Sprite as a super class.
Please note that the `is-a` pseudo class has a *lower* specificity than the element selector 
and therefore also has a lower specificity than other pseudo classes.


###Qualified class names
Identifiers in element selectors can also be fully qualified class names, by wrapping them
in parentheses. As an example: 

    /* Fully qualified name */
    Sprite > (net.company.tool.view.Image)


#A warning
This library lacks a lot of optimizations. For many uses it will probably be too slow.
