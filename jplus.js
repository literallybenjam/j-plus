// Generated by CoffeeScript 1.10.0
(function() {
  "use strict";

  /*
  J+
  Programmed by Go Shoemake <3
  -----------------------------
  Implemented through Literate CoffeeScript.
  Source code and resources are available at https://github.com/literallybenjam/jplus/.
  Written for the CoffeeScript 1.10.0 compiler.
   */

  /*
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
   */
  var Jᐩ, loading, receiveMessage;

  loading = {};

  receiveMessage = function(e) {
    var obj, src;
    if (!loading.hasOwnProperty(e.source.location.href)) {
      return;
    }
    src = e.source.location.href;
    obj = loading[src].obj;
    Object.freeze(e.data);
    Object.defineProperty(obj, "data", {
      value: e.data,
      enumerable: true
    });
    if (obj.callback != null) {
      obj.callback(obj);
    }
    document.body.removeChild(loading[src].frame);
    delete loading[src];
  };

  window.addEventListener("message", receiveMessage, false);

  Jᐩ = function(src, using, callback) {
    var a, elt, src_origin;
    a = document.createElement('A');
    a.href = src;
    src = a.href;
    src_origin = a.origin;
    if (src_origin == null) {
      src_origin = a.protocol + "//" + a.host;
    }
    elt = document.createElement('IFRAME');
    elt.style.display = "none";
    if (loading.hasOwnProperty(src)) {
      throw new TypeError("package '" + src + "' has already been queued");
    }
    Object.defineProperty(loading, src, {
      value: {
        obj: this,
        frame: elt
      },
      enumerable: true,
      configurable: true
    });
    elt.addEventListener("load", (function() {
      return elt.contentWindow.postMessage(using, src_origin);
    }), false);
    elt.src = src;
    if (document.body != null) {
      document.body.appendChild(elt);
    } else {
      document.addEventListener("DOMContentLoaded", (function() {
        return document.body.appendChild(elt);
      }), false);
    }
    return Object.defineProperties(this, {
      data: {
        value: null,
        configurable: true
      },
      origin: {
        value: src_origin
      },
      src: {
        value: src
      },
      callback: {
        value: callback
      }
    });
  };

  Object.defineProperty(window, "Jᐩ", {
    value: Object.freeze(Jᐩ)
  });

}).call(this);
