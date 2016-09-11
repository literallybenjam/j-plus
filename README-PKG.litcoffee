#  J+ PKG  #
Programmed by Go Shoemake <3

- - -

##  Introduction  ##

This file contains the source code and description for the package-creation script for the J+ package management system.
It is targeted at package authors, and should be read in conjunction with the more general J+ [README](README.litcoffee).

###  Basic usage:  ###

A basic J+ package template is a JavaScript script as follows:

>   ```html
>   <!DOCTYPE html>
>   <html>
>       <title>Package Title</title>
>       <meta charset="utf-8">
>       <script type="text/javascript" src="jplus-pkg.js">
>       <script type="text/javascript">
>           /*  Package script  */
>       </script>
>       /*  (optional) Package documentation  */
>   </html>
>   ```

The [`jplus-pkg.js`](jplus-pkg.js) creates the Data, Tools, and Settings objects and references them from `window` object properties.
It additionally defines several functions which you can use when designing your package.
Consequently, it should be loaded **before** the package script(s).

Multiple package scripts are allowed, although it is recommended that scripts be loaded synchronously.
Any non-script content (with the exception of the `<title>` element) is ignored by the J+ package loader.

###  The Data object:  ###

The Data object stores all of the properties intended to be available from outside of the package.
It is accessible from `window["📦"]`, which is defined to be non-configurable and non-overwritable.

In addition, the following aliases are defined, but *may* be configured, deleted, or overwritten.
Of course, you are also free to define your own aliases.

- `window.data`
- `window["j-plus-data"]`
- `window.jplus_data`

(For consistency and simplicity, this document will always use `window["📦"]` to refer to the Data object.)

####  Permitted content  ####

The Data object is passed to external scripts via `window.postMessage()`, so only content which can be processed throught [the structured clone algorithm](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm) is allowed.

The special property `"📛"` returns the package title and is not configurable or overwritable.

###  The Settings object:  ###

The Settings object stores properties used by the J+ package loader to initialize the package.
It is accessible from `window.ℹ`, which is defined to be non-configurable and non-overwritable.

In addition, the following aliases are defined, but *may* be configured, deleted, or overwritten.
Of course, you are also free to define your own aliases.

- `window.settings`
- `window["j-plus-settings"]`
- `window.jplus_settings`

(For consistency and simplicity, this document will always use `ℹ` to refer to the Settings object.)

####  Available settings  ####

The settings configurable through the Settings object are as follows. Note that no other properties may be added to the Settings object, and these properties may not be deleted.

|     Property      |    Type    |  Initial value   | Description |
| ----------------- | :--------: | :--------------: | :---------- |
| `ℹ.initScript`   | `function` | `function () {}` | A function to run when the package has finished loading. This takes one argument, which is the initialization data. |
| `ℹ.targetorigin` |  `string`  |      `"*"`       | The target origin to be used with `window.postMessage()`. |
| `ℹ.title`        |  `string`  | `document.title` | The title of the package. |

Default values for Settings object properties are calculated when the J+ PKG script is loaded.
Consequently, the J+ PKG script should be loaded *after* the `<title>` element if the default value for `ℹ.title` is intended to be used.

###  The Tools object:  ###

The Tools object contains functions and tools for use with package creation.
It is accessible from `window["🛠"]`, which is defined to be non-configurable and non-overwritable.

In addition, the following aliases are defined, but *may* be configured, deleted, or overwritten.
Of course, you are also free to define your own aliases.

- `window.tools`
- `window["j-plus-tools"]`
- `window.jplus_tools`

(For consistency and simplicity, this document will always use `window["🛠"]` to refer to the Tools object.)

##  Implementation  ##

    "use strict";

    ###
    J+ PKG
    Programmed by Go Shoemake <3
    -----------------------------
    Implemented through Literate CoffeeScript.
    Source code and resources are available at https://github.com/literallybenjam/jplus/.
    Written for the CoffeeScript 1.10.0 compiler.
    ###

###  License:  ###

J+ PKG is licensed under an MIT License, provided below:

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

###  General variables and functions:  ###

####  Whitelist and loading parameters  ####

J+ packages communicate using `window.postMessage()`.
Consequently, for security reasons, they need a whitelist to keep track of which URLs to accept messages from.
These are stored alongside their loading parameters in `pkgs`.

    pkgs = {}

####  Initialization on load  ####

The following script processes the Settings object and notifies the parent:

    init = (using) ->

#####  initialization  #####

Our first point of order is to run the user-defined initialization script from the Settings object:

        ℹ.initScript using

#####  notifying the parent  #####

J+ packages are loaded into `<iframe>`s, and use `window.parent.postMessage()` to inform their parents that they are loaded.
Of course, if `window.parent` does not exist, nothing can be done.
The contents of this message is the Data object.

        parent?.postMessage window["📦"], ℹ.targetorigin
        return

####  Running `init()`  ####

We use a `"message"` event handler to run the initialization script after we have received initialization parameters from the parent window.
This is processed using `receiveMessage()`

    receiveMessage = (e) ->

First we want to make sure that the message came from the window's parent.

        return unless e.origin is parent.location.origin

We can now process `init()` using the provided data.

        init e.data

Now that `init()` has been run, we don't want to receive any more messages.

        window.removeEventListener "message", receiveMessage, false
        return

This creates our event listener:

    window.addEventListener "message", receiveMessage, false

###  J+:  ###

The J+ object starts out containing only one attribute, the special attribute `"📛"`, which uses a getter to get the current package title.

    data = Object.defineProperty({}, "📛", {get: -> ℹ.title})

We assign this object to its various aliases on `window`.

    Object.defineProperties window, {
        "📦": {value: data}
        "data": {value: data, writable: true, configurable: true}
        "j-plus-data": {value: data, writable: true, configurable: true}
        "jplus_data": {value: data, writable: true, configurable: true}
    }

###  Settings:  ###

Next, we can set up the Settings object with its default values.
The default values are scoped and accessed using getters and setters, in order to ensure proper typing.

    initScript = ->
    targetorigin = "*"
    title = document.title

    settings = Object.defineProperties({}, {
        initScript:
            get: -> initScript
            set: (n) -> if n instanceof Function then initScript = n else initScript = Function(n)
        targetorigin:
            get: -> targetorigin
            set: (n) -> targetorigin = String(n)
        title:
            get: -> title
            set: (n) -> title = String(n)
    })

We should freeze the Settings object to safeguard it from unscrupulous modification:

    Object.freeze settings

Finally, we need to assign references to the Settings object to our various aliases:

    Object.defineProperties window, {
        "ℹ": {value: settings}
        "settings": {value: settings, writable: true, configurable: true}
        "j-plus-settings": {value: settings, writable: true, configurable: true}
        "jplus_settings": {value: settings, writable: true, configurable: true}
    }

###  Tools:  ###

Our final order of business is to create the Tools object.
This contains all of the convenience functions that J+ PKG provides to package creators.

    tools =

The `handleEvent` function handles all events related to Tools object operation.
Notably, it manages the loading of packages.

        handleEvent: (e) ->
            switch e.type
                when "message"

Messages are only loaded if they have been whitelisted in `pkgs`.
`handleEvent()` freezes them and handles their loading parameters.
Once the package has been loaded, we can remove the corresponding `<iframe>` and de-list its URL.

                    if pkgs.hasOwnProperty(e.source.location.href)
                        from = e.source.location.href
                        Object.freeze e.data
                        Object.defineProperty(window["📦"], pkgs[from].into, {value: e.data, enumerable: true, configurable: true}) if pkgs[from].into?
                        pkgs[from].andthen(e.data) if pkgs[from].andthen?
                        document.body.removeChild pkgs[from].frame
                        delete pkgs[from]
            return

The `loadPackage()` function loads another package as a sub-module of this one.
The argument `using` provides initialization parameters which are passed to the package.
The optional argument `into` specifies a property name for the J+ object to load the package into.
If not specified, the package will not be transparent to external scripts.
The optional argument `andthen` accepts a callback function to be called after package load.

        loadPackage: (from, using, into, andthen) ->

First, we need to get the absolute URL and origin associated with `from`.
The following code achieves this:

            a = document.createElement('A')
            a.href = from
            from = a.href
            from_origin = a.origin
            from_origin ?= a.protocol + "//" + a.host

Now we can create our iframe and make it hidden.

            pkgelt = document.createElement('IFRAME')
            pkgelt.style.display = "none"

Next, we add the domain to the whitelist, alongside its loading parameters.
If the domain already exists, then we throw a `TypeError`.

            throw new TypeError("package '" + from + "' has already been queued") if pkgs[from]?
            Object.defineProperty(pkgs, from, {
                value: Object.freeze({frame: pkgelt, into: into, andthen: andthen})
                enumerable: true
                configurable: true
            })

We send our package the initialization paramaters provided by `using`, but only after the package has fully loaded.

            pkgelt.addEventListener "load", (-> pkgelt.contentWindow.postMessage(using, from_origin)), false

Finally, we set the `src` and append the element to the document's body.
(This is required for script execution.)
If the `<body>` element has not yet been loaded, we need to set an event handler:

            pkgelt.src = from
            if document.body? then document.body.appendChild(pkgelt) else document.addEventListener("DOMContentLoaded", (-> document.body.appendChild(pkgelt)), false)
            return

We should freeze the Tools object to safeguard it from unscrupulous modification:

    Object.freeze tools

Finally, we need to assign references to the Tools object to our various aliases:

    Object.defineProperties window, {
        "🛠": {value: tools}
        "tools": {value: tools, writable: true, configurable: true}
        "j-plus-tools": {value: tools, writable: true, configurable: true}
        "jplus_tools": {value: tools, writable: true, configurable: true}
    }
