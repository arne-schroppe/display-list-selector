
#This readme file is OUTDATED and will be updated soon


#CSS Selectors for the display list

An implementation of CSS3–selectors for the flash display list. Selectors are
of the form

    Sprite#container > MovieClip:nth-child(2) *.headline > TextField[text='About']

The display list selector library processes selectors like this and returns a collection
of matched objects.




##Usage

First, initialize a context for your selectors. Usually you can conveniently use the default
context:

    DefaultSelectorContext.initializeWith(rootView);

Then just create objects of type Selector and query them:

    var selector:Selector = new Selector("Sprite > MovieClip:first-child()");
    var matches:Set = selector.getMatchedObjects();

The library monitors the display list for changes, so if objects are added and removed, all
selector instances are automatically updated. In some cases you need to inform the library
of changes though, for example if properties change. You can do this through the context.

    someObject.name = "icon";
    DefaultSelectorContext.objectWasChanged(someObject);

Selectors are modeled after the CSS3 selector standard, but not all features have been implemented
yet.


##Extended syntax

This library also allows an extended syntax, that is better suited in dealing with ActionScript objects.


###The isA-matcher
The usual element selector only matches if the classname of the element itself is the given identifier. Prefixing
the identifier with ^ makes it also match superclasses and interfaces. For example:

    ^Sprite

matches elements of type Sprite, MovieClip, or other objects that have Sprite as a super class.


###Partly or fully qualified class names
Identifiers in element selectors can also be partly and fully qualified with package names, by wrapping them
in parentheses. The use of the wildcard * is also possible. Examples of valid identifiers are:


    /* Fully qualified name */
    Sprite > (net.company.tool.view.Image)

    /* Partly qualified name */
    Sprite > (otherview.Image)

    /* Using wildcards, matches both net.company.tool.view.Image and net.company.tool.otherview.Image */
    Sprite > (net.company.tool.*.Image)
