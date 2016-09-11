#  J+  #
Programmed by Go Shoemake <3

- - -

##  Introduction  ##

*J+* is a data-management system for web applications using JavaScript.
It was designed for use with the *Jelli Game Engine*, but could feasibly be applied to any use.

This document contains all of the source code for the J+ data-management system.
J+ is written in Literate CoffeeScript, which means that each source file can be read as Markdown.
The code blocks (indented with four spaces) in each file are the CoffeeScript code.

This file is the [`README`](README.litcoffee), and focuses on reading data packages.
Package authors should additionally consult [`README-PKG`](README-PKG.litcoffee), which contains additional information on package creation and format.

####  Browser compatibility  ####

The anticipated (ie, untested) browser compatibility for J+ is as follows:

| Chrome | Firefox | Internet Explorer | Opera | Safari |
| :----: | :-----: | :---------------: | :---: | :----: |
|    5   |   6.0   |         9         |  12   |  5.1   |

###  Document structure:  ###

Each source file is split into two main parts.
The first, titled "Introduction", outlines and documents the features of J+ and how to use them.
The second, titled "Implementation", provides and explains its source code.
Readers looking to use J+ need largely only concern themselves with the first section, but readers aiming for a deeper understanding of how the script operates should read both.

###  Formatting conventions:  ###

Source files are written in GitHub-Flavored Markdown (GFM), utilizing fenced code-blocks for non-compiled source and the occasional table.

This is a paragraph.
It is in a section titled “Formatting conventions”.
In the Markdown source, each sentence is given its own line.
Variable names, literals, and code excerpts are represented like `this`, whereas `this()` is a function and `<this>` is an element.
This is *emphasis*, and this is **important**.
Here is a [link](http://example.com).

- This is a short unordered list
- In the source, there is minimal padding between and around lines

>   **Note :**
    This is a note.

1.  This is an ordered list
2.  Here is item #2
3.  Short list items like these don't end in periods

>   [Issue ##](https://github.com/literallybenjam/j-plus/issues) :
    This is a note regarding a known issue.

-   This is an unordered list with paragraph content.
    For these kinds of lists, there is more padding in the source and each sentence ends with a period.

-   Although this is an unordered list, an ordered list with paragraph content would be formatted in much the same way.

>   ```coffeescript
>   "This is a sample block of CoffeeScript code.
>   It will not appear in the compiled source."
>   ```

>   ```html
>   <!DOCTYPE html>
>   <p>And here is a block of HTML.</p>
>   ```

This is a line break:

- - -

The CoffeeScript source uses four spaces for indentation.
This aids in visually matching up lines when several paragraphs of text lie between them.

The following is a subsection titled “Case conventions and variable names”.

####  Case conventions and variable names  ####

>   **Note :**
    Not all of the following conventions are employed in this document.

Variables are named as follows:

- `snake_case` is used for variable and property names.
- `SCREAMING_SNAKE_CASE` is used for symbols and special static values.
- `camelCase` is used for function names
- `PascalCase` (`UpperCamelCase`) is used for object constructors.

HTML class names are written in `RUNNINGCAPS`.
This is intended to mirror the style of `Element.tagName`, as well as distinguish them from user-defined classes (which presumably are lower- or mixed-case).
Note that HTML class names are, by spec, **not** case-insensitive, and thus the all-caps representation is **required**.

Tag names are written lower-case and wrapped in less-than and greater-than signs.
This distinguishes elements specified by `<tagname>` and elements specified by `CLASS`.
Elements may also be referred to by the DOM interface they implement; for example, `<img>` may be referred to as `HTMLImageElement` when this better reflects the code.

With `data-*` attributes, `runningtext` is used for variable names, but these are *often* given hyphen-separated semantic prefixes.
So you will have `data-bitdepth` but also `data-sprite-width`.
In JavaScript, these become `dataset.bitdepth` and `dataset.spriteWidth`, respectively.

###  Usage:  ###

This script consists of a single constructor, `Jᐩ()`, which is used to load J+ data packages.

It takes a three arguments, as follows:

>   ```coffeescript
>   data = new Jᐩ(src, using, callback)
>   ```

-   `src` provides the location of the package.

-   `using` is an object which will be used to initialize the package.
    This ***must not*** change between the time the constructor is called and the time the package is loaded, as no attempt to clone the object is made until this time.
    However, as `using` is passed to the package through `window.postMessage()`, only content which can be processed throught [the structured clone algorithm](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm) is allowed.

-   `callback` is an (optional) function which should be called after the package has been loaded.
    It should be of the form `function (pkg) {}`, where `pkg` is the `Jᐩ` object.

The resulting object contains the following properties:

-   `callback`—
    *(Read-only.)*
    The callback function, as specified above.

-   `data`—
    *(Read-only.)*
    An object containing the data imported from the package.
    This object is *frozen*; that is, it is not extensible, and its properties are immutable.
    The special attribute `"📛"` contains the title of the package and may be used for package identification.

-   `origin`—
    *(Read-only.)*
    This gives the origin of `src`.

-   `loaded`—
    *(Read-only.)*
    This attribute returns `true` if the package has been loaded, and `false` if it has not.

-   `src`—
    *(Read-only.)*
    The URL that the package was loaded from.

>   **Note :**
    Emoji are used for certain property names because they are easily recognizable and difficult to accidentially reference or modify.
    All Basic Latin variable names are left fully configurable for users.

##  Implementation  ##

    "use strict";

    ###
    J+
    Programmed by Go Shoemake <3
    -----------------------------
    Implemented through Literate CoffeeScript.
    Source code and resources are available at https://github.com/literallybenjam/jplus/.
    Written for the CoffeeScript 1.10.0 compiler.
    ###

###  License:  ###

The J+ is licensed under an MIT License, provided below:

    ###
    MIT License

    Copyright (c) 2016 Go Shoemake

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    ###

###  Whitelist:  ###

J+ packages communicate using `window.postMessage()`.
Consequently, for security reasons, we need to use a whitelist to keep track of which URLs to accept messages from.
These are stored in the `loading` object alongside their associated objects and `<iframe>`s

    loading = {}

###  Message handler:  ###

The `receiveMessage` manages the loading of packages.

    receiveMessage = (e) ->

Packages are only loaded if they have been whitelisted in the `whitelist`.
`receiveMessage()` freezes their data and finishes loading the `Jᐩ` object.
Once the package has been loaded, we can remove the corresponding `<iframe>` and de-list its URL.

        return unless loading.hasOwnProperty(e.source.location.href)
        src = e.source.location.href
        obj = loading[src].obj
        Object.freeze e.data
        Object.defineProperty obj, "data", {value: e.data, enumerable: true}
        obj.callback(obj) if obj.callback?
        document.body.removeChild loading[src].frame
        delete loading[src]
        return

This creates our event listener:

    window.addEventListener "message", receiveMessage, false

###  Constructor:  ###

All of the work of J+ is done by the constructor, which is defined below:

    Jᐩ = (src, using, callback) ->

First, we need to get the absolute URL and origin associated with `src`.
The following code achieves this:

        a = document.createElement('A')
        a.href = src
        src = a.href
        src_origin = a.origin
        src_origin ?= a.protocol + "//" + a.host

Data packages are loaded using hidden `<iframe>`s.

        elt = document.createElement('IFRAME')
        elt.style.display = "none"

We need to add the domain to the whitelist.
If the domain already exists, then we throw a `TypeError`.

        throw new TypeError("package '" + src + "' has already been queued") if loading.hasOwnProperty(src)
        Object.defineProperty loading, src, {value: {obj: this, frame: elt}, enumerable: true, configurable: true}

We send our package the initialization paramaters provided by `using`, but only after the package has fully loaded.

        elt.addEventListener "load", (-> elt.contentWindow.postMessage(using, src_origin)), false

We set the `src` and append the element to the document's body.
(This is required for script execution.)
If the `<body>` element has not yet been loaded, we need to set an event handler:

        elt.src = src
        if document.body? then document.body.appendChild(elt) else document.addEventListener("DOMContentLoaded", (-> document.body.appendChild(elt)), false)

Finally, we set the read-only properties on the `Jᐩ` object itself.
These are implemented using getters.

        Object.defineProperties(this, {
            data: {value: null, configurable: true}
            origin: {value: src_origin}
            src: {value: src}
            callback: {value: callback}
        })

We can now assign the `Jᐩ()` constructor to the `window` object.

    Object.defineProperty window, "Jᐩ", {value: Object.freeze(Jᐩ)}
