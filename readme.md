

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

Before you can query an object against a selector, a SelectorAdapter must be created for that object. 
The DisplayListSelectorFactory uses the `ADDED_TO_STAGE` event to automatically add a suitable SelectorAdapter
so usually you don't have to worry about this. You can just query the match right away:

    var isMatching:Boolean = selector.isAnySelectorMatching(someDisplayObject);

Selectors are modeled after the CSS3 selector standard, but not all features have been implemented
yet.


##Usage scenarios

The selector libray supports two different usage scenarios by providing optimized objects for each. When
a single selector needs to be matched against a single object, the mentioned `SelectorGroup` should be used.
If many selectors need to be checked against a single object, a more optimized object is available though, the
`SelectorPool`. It is used as follows:

    var selectorPool:SelectorPool = selectorFactory.createSelectorPool();
    selectorPool.addSelector("Sprite");
    selectorPool.addSelector("MovieClip");
    selectorPool.addSelector("*:first-child()");
    
    var matches:Vector.<SelectorDescription> = selectorPool.getSelectorsMatchingObject(someDisplayObject);
    
The result is sorted by specificity.


##Extended syntax

This library also allows an extended syntax, that is better suited in dealing with ActionScript objects.


###The isA-matcher
The usual element selector only matches if the classname of the element itself is the given identifier. Prefixing
the identifier with ^ makes it also match superclasses and interfaces. For example:

    ^Sprite

matches elements of type Sprite, MovieClip, or other objects that have Sprite as a super class.


###Qualified class names
Identifiers in element selectors can also be fully qualified class names, by wrapping them
in parentheses, for example:

    /* Fully qualified name */
    Sprite > (net.company.tool.view.Image)