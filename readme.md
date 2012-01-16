
#CSS Selectors for the display list

An implementation of CSS3–selectors for the flash display list. Selectors are
of the form 

    Sprite#container > MovieClip:nth-child(2) *.headline > TextField[text='About']

The display list selector library processes selectors like this and returns a collection
of matched objects.


##Usage

First, initialize a context for your selectors. Usually you can conveniently use the default
context:

    DefaultSelectorContext.initializeWith(contextView);
    
Then just create objects of type Selector and query them:

    var selector:Selector = new Selector("Sprite > MovieClip:first-child()");
    var matches:Set = selector.getMatchedObjects();
    
The library monitors the display list for changes, so if objects are added and removed, all
selector instances are automatically updated. In some cases you need to inform the library
of changes though, for example if properties change. You can do this through the context.

    someObject.name = "icon";
    DefaultSelectorContext.objectWasChanged(someObject);

Selectors are modeled after the CSS3 selector standard, but not all features are implemented
yet.