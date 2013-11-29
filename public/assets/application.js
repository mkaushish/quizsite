/*!
 * jQuery JavaScript Library v1.7.2
 * http://jquery.com/
 *
 * Copyright 2011, John Resig
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 * Copyright 2011, The Dojo Foundation
 * Released under the MIT, BSD, and GPL Licenses.
 *
 * Date: Wed Mar 21 12:46:34 2012 -0700
 */

(function( window, undefined ) {

// Use the correct document accordingly with window argument (sandbox)
var document = window.document,
	navigator = window.navigator,
	location = window.location;
var jQuery = (function() {

// Define a local copy of jQuery
var jQuery = function( selector, context ) {
		// The jQuery object is actually just the init constructor 'enhanced'
		return new jQuery.fn.init( selector, context, rootjQuery );
	},

	// Map over jQuery in case of overwrite
	_jQuery = window.jQuery,

	// Map over the $ in case of overwrite
	_$ = window.$,

	// A central reference to the root jQuery(document)
	rootjQuery,

	// A simple way to check for HTML strings or ID strings
	// Prioritize #id over <tag> to avoid XSS via location.hash (#9521)
	quickExpr = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/,

	// Check if a string has a non-whitespace character in it
	rnotwhite = /\S/,

	// Used for trimming whitespace
	trimLeft = /^\s+/,
	trimRight = /\s+$/,

	// Match a standalone tag
	rsingleTag = /^<(\w+)\s*\/?>(?:<\/\1>)?$/,

	// JSON RegExp
	rvalidchars = /^[\],:{}\s]*$/,
	rvalidescape = /\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,
	rvalidtokens = /"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
	rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g,

	// Useragent RegExp
	rwebkit = /(webkit)[ \/]([\w.]+)/,
	ropera = /(opera)(?:.*version)?[ \/]([\w.]+)/,
	rmsie = /(msie) ([\w.]+)/,
	rmozilla = /(mozilla)(?:.*? rv:([\w.]+))?/,

	// Matches dashed string for camelizing
	rdashAlpha = /-([a-z]|[0-9])/ig,
	rmsPrefix = /^-ms-/,

	// Used by jQuery.camelCase as callback to replace()
	fcamelCase = function( all, letter ) {
		return ( letter + "" ).toUpperCase();
	},

	// Keep a UserAgent string for use with jQuery.browser
	userAgent = navigator.userAgent,

	// For matching the engine and version of the browser
	browserMatch,

	// The deferred used on DOM ready
	readyList,

	// The ready event handler
	DOMContentLoaded,

	// Save a reference to some core methods
	toString = Object.prototype.toString,
	hasOwn = Object.prototype.hasOwnProperty,
	push = Array.prototype.push,
	slice = Array.prototype.slice,
	trim = String.prototype.trim,
	indexOf = Array.prototype.indexOf,

	// [[Class]] -> type pairs
	class2type = {};

jQuery.fn = jQuery.prototype = {
	constructor: jQuery,
	init: function( selector, context, rootjQuery ) {
		var match, elem, ret, doc;

		// Handle $(""), $(null), or $(undefined)
		if ( !selector ) {
			return this;
		}

		// Handle $(DOMElement)
		if ( selector.nodeType ) {
			this.context = this[0] = selector;
			this.length = 1;
			return this;
		}

		// The body element only exists once, optimize finding it
		if ( selector === "body" && !context && document.body ) {
			this.context = document;
			this[0] = document.body;
			this.selector = selector;
			this.length = 1;
			return this;
		}

		// Handle HTML strings
		if ( typeof selector === "string" ) {
			// Are we dealing with HTML string or an ID?
			if ( selector.charAt(0) === "<" && selector.charAt( selector.length - 1 ) === ">" && selector.length >= 3 ) {
				// Assume that strings that start and end with <> are HTML and skip the regex check
				match = [ null, selector, null ];

			} else {
				match = quickExpr.exec( selector );
			}

			// Verify a match, and that no context was specified for #id
			if ( match && (match[1] || !context) ) {

				// HANDLE: $(html) -> $(array)
				if ( match[1] ) {
					context = context instanceof jQuery ? context[0] : context;
					doc = ( context ? context.ownerDocument || context : document );

					// If a single string is passed in and it's a single tag
					// just do a createElement and skip the rest
					ret = rsingleTag.exec( selector );

					if ( ret ) {
						if ( jQuery.isPlainObject( context ) ) {
							selector = [ document.createElement( ret[1] ) ];
							jQuery.fn.attr.call( selector, context, true );

						} else {
							selector = [ doc.createElement( ret[1] ) ];
						}

					} else {
						ret = jQuery.buildFragment( [ match[1] ], [ doc ] );
						selector = ( ret.cacheable ? jQuery.clone(ret.fragment) : ret.fragment ).childNodes;
					}

					return jQuery.merge( this, selector );

				// HANDLE: $("#id")
				} else {
					elem = document.getElementById( match[2] );

					// Check parentNode to catch when Blackberry 4.6 returns
					// nodes that are no longer in the document #6963
					if ( elem && elem.parentNode ) {
						// Handle the case where IE and Opera return items
						// by name instead of ID
						if ( elem.id !== match[2] ) {
							return rootjQuery.find( selector );
						}

						// Otherwise, we inject the element directly into the jQuery object
						this.length = 1;
						this[0] = elem;
					}

					this.context = document;
					this.selector = selector;
					return this;
				}

			// HANDLE: $(expr, $(...))
			} else if ( !context || context.jquery ) {
				return ( context || rootjQuery ).find( selector );

			// HANDLE: $(expr, context)
			// (which is just equivalent to: $(context).find(expr)
			} else {
				return this.constructor( context ).find( selector );
			}

		// HANDLE: $(function)
		// Shortcut for document ready
		} else if ( jQuery.isFunction( selector ) ) {
			return rootjQuery.ready( selector );
		}

		if ( selector.selector !== undefined ) {
			this.selector = selector.selector;
			this.context = selector.context;
		}

		return jQuery.makeArray( selector, this );
	},

	// Start with an empty selector
	selector: "",

	// The current version of jQuery being used
	jquery: "1.7.2",

	// The default length of a jQuery object is 0
	length: 0,

	// The number of elements contained in the matched element set
	size: function() {
		return this.length;
	},

	toArray: function() {
		return slice.call( this, 0 );
	},

	// Get the Nth element in the matched element set OR
	// Get the whole matched element set as a clean array
	get: function( num ) {
		return num == null ?

			// Return a 'clean' array
			this.toArray() :

			// Return just the object
			( num < 0 ? this[ this.length + num ] : this[ num ] );
	},

	// Take an array of elements and push it onto the stack
	// (returning the new matched element set)
	pushStack: function( elems, name, selector ) {
		// Build a new jQuery matched element set
		var ret = this.constructor();

		if ( jQuery.isArray( elems ) ) {
			push.apply( ret, elems );

		} else {
			jQuery.merge( ret, elems );
		}

		// Add the old object onto the stack (as a reference)
		ret.prevObject = this;

		ret.context = this.context;

		if ( name === "find" ) {
			ret.selector = this.selector + ( this.selector ? " " : "" ) + selector;
		} else if ( name ) {
			ret.selector = this.selector + "." + name + "(" + selector + ")";
		}

		// Return the newly-formed element set
		return ret;
	},

	// Execute a callback for every element in the matched set.
	// (You can seed the arguments with an array of args, but this is
	// only used internally.)
	each: function( callback, args ) {
		return jQuery.each( this, callback, args );
	},

	ready: function( fn ) {
		// Attach the listeners
		jQuery.bindReady();

		// Add the callback
		readyList.add( fn );

		return this;
	},

	eq: function( i ) {
		i = +i;
		return i === -1 ?
			this.slice( i ) :
			this.slice( i, i + 1 );
	},

	first: function() {
		return this.eq( 0 );
	},

	last: function() {
		return this.eq( -1 );
	},

	slice: function() {
		return this.pushStack( slice.apply( this, arguments ),
			"slice", slice.call(arguments).join(",") );
	},

	map: function( callback ) {
		return this.pushStack( jQuery.map(this, function( elem, i ) {
			return callback.call( elem, i, elem );
		}));
	},

	end: function() {
		return this.prevObject || this.constructor(null);
	},

	// For internal use only.
	// Behaves like an Array's method, not like a jQuery method.
	push: push,
	sort: [].sort,
	splice: [].splice
};

// Give the init function the jQuery prototype for later instantiation
jQuery.fn.init.prototype = jQuery.fn;

jQuery.extend = jQuery.fn.extend = function() {
	var options, name, src, copy, copyIsArray, clone,
		target = arguments[0] || {},
		i = 1,
		length = arguments.length,
		deep = false;

	// Handle a deep copy situation
	if ( typeof target === "boolean" ) {
		deep = target;
		target = arguments[1] || {};
		// skip the boolean and the target
		i = 2;
	}

	// Handle case when target is a string or something (possible in deep copy)
	if ( typeof target !== "object" && !jQuery.isFunction(target) ) {
		target = {};
	}

	// extend jQuery itself if only one argument is passed
	if ( length === i ) {
		target = this;
		--i;
	}

	for ( ; i < length; i++ ) {
		// Only deal with non-null/undefined values
		if ( (options = arguments[ i ]) != null ) {
			// Extend the base object
			for ( name in options ) {
				src = target[ name ];
				copy = options[ name ];

				// Prevent never-ending loop
				if ( target === copy ) {
					continue;
				}

				// Recurse if we're merging plain objects or arrays
				if ( deep && copy && ( jQuery.isPlainObject(copy) || (copyIsArray = jQuery.isArray(copy)) ) ) {
					if ( copyIsArray ) {
						copyIsArray = false;
						clone = src && jQuery.isArray(src) ? src : [];

					} else {
						clone = src && jQuery.isPlainObject(src) ? src : {};
					}

					// Never move original objects, clone them
					target[ name ] = jQuery.extend( deep, clone, copy );

				// Don't bring in undefined values
				} else if ( copy !== undefined ) {
					target[ name ] = copy;
				}
			}
		}
	}

	// Return the modified object
	return target;
};

jQuery.extend({
	noConflict: function( deep ) {
		if ( window.$ === jQuery ) {
			window.$ = _$;
		}

		if ( deep && window.jQuery === jQuery ) {
			window.jQuery = _jQuery;
		}

		return jQuery;
	},

	// Is the DOM ready to be used? Set to true once it occurs.
	isReady: false,

	// A counter to track how many items to wait for before
	// the ready event fires. See #6781
	readyWait: 1,

	// Hold (or release) the ready event
	holdReady: function( hold ) {
		if ( hold ) {
			jQuery.readyWait++;
		} else {
			jQuery.ready( true );
		}
	},

	// Handle when the DOM is ready
	ready: function( wait ) {
		// Either a released hold or an DOMready/load event and not yet ready
		if ( (wait === true && !--jQuery.readyWait) || (wait !== true && !jQuery.isReady) ) {
			// Make sure body exists, at least, in case IE gets a little overzealous (ticket #5443).
			if ( !document.body ) {
				return setTimeout( jQuery.ready, 1 );
			}

			// Remember that the DOM is ready
			jQuery.isReady = true;

			// If a normal DOM Ready event fired, decrement, and wait if need be
			if ( wait !== true && --jQuery.readyWait > 0 ) {
				return;
			}

			// If there are functions bound, to execute
			readyList.fireWith( document, [ jQuery ] );

			// Trigger any bound ready events
			if ( jQuery.fn.trigger ) {
				jQuery( document ).trigger( "ready" ).off( "ready" );
			}
		}
	},

	bindReady: function() {
		if ( readyList ) {
			return;
		}

		readyList = jQuery.Callbacks( "once memory" );

		// Catch cases where $(document).ready() is called after the
		// browser event has already occurred.
		if ( document.readyState === "complete" ) {
			// Handle it asynchronously to allow scripts the opportunity to delay ready
			return setTimeout( jQuery.ready, 1 );
		}

		// Mozilla, Opera and webkit nightlies currently support this event
		if ( document.addEventListener ) {
			// Use the handy event callback
			document.addEventListener( "DOMContentLoaded", DOMContentLoaded, false );

			// A fallback to window.onload, that will always work
			window.addEventListener( "load", jQuery.ready, false );

		// If IE event model is used
		} else if ( document.attachEvent ) {
			// ensure firing before onload,
			// maybe late but safe also for iframes
			document.attachEvent( "onreadystatechange", DOMContentLoaded );

			// A fallback to window.onload, that will always work
			window.attachEvent( "onload", jQuery.ready );

			// If IE and not a frame
			// continually check to see if the document is ready
			var toplevel = false;

			try {
				toplevel = window.frameElement == null;
			} catch(e) {}

			if ( document.documentElement.doScroll && toplevel ) {
				doScrollCheck();
			}
		}
	},

	// See test/unit/core.js for details concerning isFunction.
	// Since version 1.3, DOM methods and functions like alert
	// aren't supported. They return false on IE (#2968).
	isFunction: function( obj ) {
		return jQuery.type(obj) === "function";
	},

	isArray: Array.isArray || function( obj ) {
		return jQuery.type(obj) === "array";
	},

	isWindow: function( obj ) {
		return obj != null && obj == obj.window;
	},

	isNumeric: function( obj ) {
		return !isNaN( parseFloat(obj) ) && isFinite( obj );
	},

	type: function( obj ) {
		return obj == null ?
			String( obj ) :
			class2type[ toString.call(obj) ] || "object";
	},

	isPlainObject: function( obj ) {
		// Must be an Object.
		// Because of IE, we also have to check the presence of the constructor property.
		// Make sure that DOM nodes and window objects don't pass through, as well
		if ( !obj || jQuery.type(obj) !== "object" || obj.nodeType || jQuery.isWindow( obj ) ) {
			return false;
		}

		try {
			// Not own constructor property must be Object
			if ( obj.constructor &&
				!hasOwn.call(obj, "constructor") &&
				!hasOwn.call(obj.constructor.prototype, "isPrototypeOf") ) {
				return false;
			}
		} catch ( e ) {
			// IE8,9 Will throw exceptions on certain host objects #9897
			return false;
		}

		// Own properties are enumerated firstly, so to speed up,
		// if last one is own, then all properties are own.

		var key;
		for ( key in obj ) {}

		return key === undefined || hasOwn.call( obj, key );
	},

	isEmptyObject: function( obj ) {
		for ( var name in obj ) {
			return false;
		}
		return true;
	},

	error: function( msg ) {
		throw new Error( msg );
	},

	parseJSON: function( data ) {
		if ( typeof data !== "string" || !data ) {
			return null;
		}

		// Make sure leading/trailing whitespace is removed (IE can't handle it)
		data = jQuery.trim( data );

		// Attempt to parse using the native JSON parser first
		if ( window.JSON && window.JSON.parse ) {
			return window.JSON.parse( data );
		}

		// Make sure the incoming data is actual JSON
		// Logic borrowed from http://json.org/json2.js
		if ( rvalidchars.test( data.replace( rvalidescape, "@" )
			.replace( rvalidtokens, "]" )
			.replace( rvalidbraces, "")) ) {

			return ( new Function( "return " + data ) )();

		}
		jQuery.error( "Invalid JSON: " + data );
	},

	// Cross-browser xml parsing
	parseXML: function( data ) {
		if ( typeof data !== "string" || !data ) {
			return null;
		}
		var xml, tmp;
		try {
			if ( window.DOMParser ) { // Standard
				tmp = new DOMParser();
				xml = tmp.parseFromString( data , "text/xml" );
			} else { // IE
				xml = new ActiveXObject( "Microsoft.XMLDOM" );
				xml.async = "false";
				xml.loadXML( data );
			}
		} catch( e ) {
			xml = undefined;
		}
		if ( !xml || !xml.documentElement || xml.getElementsByTagName( "parsererror" ).length ) {
			jQuery.error( "Invalid XML: " + data );
		}
		return xml;
	},

	noop: function() {},

	// Evaluates a script in a global context
	// Workarounds based on findings by Jim Driscoll
	// http://weblogs.java.net/blog/driscoll/archive/2009/09/08/eval-javascript-global-context
	globalEval: function( data ) {
		if ( data && rnotwhite.test( data ) ) {
			// We use execScript on Internet Explorer
			// We use an anonymous function so that context is window
			// rather than jQuery in Firefox
			( window.execScript || function( data ) {
				window[ "eval" ].call( window, data );
			} )( data );
		}
	},

	// Convert dashed to camelCase; used by the css and data modules
	// Microsoft forgot to hump their vendor prefix (#9572)
	camelCase: function( string ) {
		return string.replace( rmsPrefix, "ms-" ).replace( rdashAlpha, fcamelCase );
	},

	nodeName: function( elem, name ) {
		return elem.nodeName && elem.nodeName.toUpperCase() === name.toUpperCase();
	},

	// args is for internal usage only
	each: function( object, callback, args ) {
		var name, i = 0,
			length = object.length,
			isObj = length === undefined || jQuery.isFunction( object );

		if ( args ) {
			if ( isObj ) {
				for ( name in object ) {
					if ( callback.apply( object[ name ], args ) === false ) {
						break;
					}
				}
			} else {
				for ( ; i < length; ) {
					if ( callback.apply( object[ i++ ], args ) === false ) {
						break;
					}
				}
			}

		// A special, fast, case for the most common use of each
		} else {
			if ( isObj ) {
				for ( name in object ) {
					if ( callback.call( object[ name ], name, object[ name ] ) === false ) {
						break;
					}
				}
			} else {
				for ( ; i < length; ) {
					if ( callback.call( object[ i ], i, object[ i++ ] ) === false ) {
						break;
					}
				}
			}
		}

		return object;
	},

	// Use native String.trim function wherever possible
	trim: trim ?
		function( text ) {
			return text == null ?
				"" :
				trim.call( text );
		} :

		// Otherwise use our own trimming functionality
		function( text ) {
			return text == null ?
				"" :
				text.toString().replace( trimLeft, "" ).replace( trimRight, "" );
		},

	// results is for internal usage only
	makeArray: function( array, results ) {
		var ret = results || [];

		if ( array != null ) {
			// The window, strings (and functions) also have 'length'
			// Tweaked logic slightly to handle Blackberry 4.7 RegExp issues #6930
			var type = jQuery.type( array );

			if ( array.length == null || type === "string" || type === "function" || type === "regexp" || jQuery.isWindow( array ) ) {
				push.call( ret, array );
			} else {
				jQuery.merge( ret, array );
			}
		}

		return ret;
	},

	inArray: function( elem, array, i ) {
		var len;

		if ( array ) {
			if ( indexOf ) {
				return indexOf.call( array, elem, i );
			}

			len = array.length;
			i = i ? i < 0 ? Math.max( 0, len + i ) : i : 0;

			for ( ; i < len; i++ ) {
				// Skip accessing in sparse arrays
				if ( i in array && array[ i ] === elem ) {
					return i;
				}
			}
		}

		return -1;
	},

	merge: function( first, second ) {
		var i = first.length,
			j = 0;

		if ( typeof second.length === "number" ) {
			for ( var l = second.length; j < l; j++ ) {
				first[ i++ ] = second[ j ];
			}

		} else {
			while ( second[j] !== undefined ) {
				first[ i++ ] = second[ j++ ];
			}
		}

		first.length = i;

		return first;
	},

	grep: function( elems, callback, inv ) {
		var ret = [], retVal;
		inv = !!inv;

		// Go through the array, only saving the items
		// that pass the validator function
		for ( var i = 0, length = elems.length; i < length; i++ ) {
			retVal = !!callback( elems[ i ], i );
			if ( inv !== retVal ) {
				ret.push( elems[ i ] );
			}
		}

		return ret;
	},

	// arg is for internal usage only
	map: function( elems, callback, arg ) {
		var value, key, ret = [],
			i = 0,
			length = elems.length,
			// jquery objects are treated as arrays
			isArray = elems instanceof jQuery || length !== undefined && typeof length === "number" && ( ( length > 0 && elems[ 0 ] && elems[ length -1 ] ) || length === 0 || jQuery.isArray( elems ) ) ;

		// Go through the array, translating each of the items to their
		if ( isArray ) {
			for ( ; i < length; i++ ) {
				value = callback( elems[ i ], i, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}

		// Go through every key on the object,
		} else {
			for ( key in elems ) {
				value = callback( elems[ key ], key, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}
		}

		// Flatten any nested arrays
		return ret.concat.apply( [], ret );
	},

	// A global GUID counter for objects
	guid: 1,

	// Bind a function to a context, optionally partially applying any
	// arguments.
	proxy: function( fn, context ) {
		if ( typeof context === "string" ) {
			var tmp = fn[ context ];
			context = fn;
			fn = tmp;
		}

		// Quick check to determine if target is callable, in the spec
		// this throws a TypeError, but we will just return undefined.
		if ( !jQuery.isFunction( fn ) ) {
			return undefined;
		}

		// Simulated bind
		var args = slice.call( arguments, 2 ),
			proxy = function() {
				return fn.apply( context, args.concat( slice.call( arguments ) ) );
			};

		// Set the guid of unique handler to the same of original handler, so it can be removed
		proxy.guid = fn.guid = fn.guid || proxy.guid || jQuery.guid++;

		return proxy;
	},

	// Mutifunctional method to get and set values to a collection
	// The value/s can optionally be executed if it's a function
	access: function( elems, fn, key, value, chainable, emptyGet, pass ) {
		var exec,
			bulk = key == null,
			i = 0,
			length = elems.length;

		// Sets many values
		if ( key && typeof key === "object" ) {
			for ( i in key ) {
				jQuery.access( elems, fn, i, key[i], 1, emptyGet, value );
			}
			chainable = 1;

		// Sets one value
		} else if ( value !== undefined ) {
			// Optionally, function values get executed if exec is true
			exec = pass === undefined && jQuery.isFunction( value );

			if ( bulk ) {
				// Bulk operations only iterate when executing function values
				if ( exec ) {
					exec = fn;
					fn = function( elem, key, value ) {
						return exec.call( jQuery( elem ), value );
					};

				// Otherwise they run against the entire set
				} else {
					fn.call( elems, value );
					fn = null;
				}
			}

			if ( fn ) {
				for (; i < length; i++ ) {
					fn( elems[i], key, exec ? value.call( elems[i], i, fn( elems[i], key ) ) : value, pass );
				}
			}

			chainable = 1;
		}

		return chainable ?
			elems :

			// Gets
			bulk ?
				fn.call( elems ) :
				length ? fn( elems[0], key ) : emptyGet;
	},

	now: function() {
		return ( new Date() ).getTime();
	},

	// Use of jQuery.browser is frowned upon.
	// More details: http://docs.jquery.com/Utilities/jQuery.browser
	uaMatch: function( ua ) {
		ua = ua.toLowerCase();

		var match = rwebkit.exec( ua ) ||
			ropera.exec( ua ) ||
			rmsie.exec( ua ) ||
			ua.indexOf("compatible") < 0 && rmozilla.exec( ua ) ||
			[];

		return { browser: match[1] || "", version: match[2] || "0" };
	},

	sub: function() {
		function jQuerySub( selector, context ) {
			return new jQuerySub.fn.init( selector, context );
		}
		jQuery.extend( true, jQuerySub, this );
		jQuerySub.superclass = this;
		jQuerySub.fn = jQuerySub.prototype = this();
		jQuerySub.fn.constructor = jQuerySub;
		jQuerySub.sub = this.sub;
		jQuerySub.fn.init = function init( selector, context ) {
			if ( context && context instanceof jQuery && !(context instanceof jQuerySub) ) {
				context = jQuerySub( context );
			}

			return jQuery.fn.init.call( this, selector, context, rootjQuerySub );
		};
		jQuerySub.fn.init.prototype = jQuerySub.fn;
		var rootjQuerySub = jQuerySub(document);
		return jQuerySub;
	},

	browser: {}
});

// Populate the class2type map
jQuery.each("Boolean Number String Function Array Date RegExp Object".split(" "), function(i, name) {
	class2type[ "[object " + name + "]" ] = name.toLowerCase();
});

browserMatch = jQuery.uaMatch( userAgent );
if ( browserMatch.browser ) {
	jQuery.browser[ browserMatch.browser ] = true;
	jQuery.browser.version = browserMatch.version;
}

// Deprecated, use jQuery.browser.webkit instead
if ( jQuery.browser.webkit ) {
	jQuery.browser.safari = true;
}

// IE doesn't match non-breaking spaces with \s
if ( rnotwhite.test( "\xA0" ) ) {
	trimLeft = /^[\s\xA0]+/;
	trimRight = /[\s\xA0]+$/;
}

// All jQuery objects should point back to these
rootjQuery = jQuery(document);

// Cleanup functions for the document ready method
if ( document.addEventListener ) {
	DOMContentLoaded = function() {
		document.removeEventListener( "DOMContentLoaded", DOMContentLoaded, false );
		jQuery.ready();
	};

} else if ( document.attachEvent ) {
	DOMContentLoaded = function() {
		// Make sure body exists, at least, in case IE gets a little overzealous (ticket #5443).
		if ( document.readyState === "complete" ) {
			document.detachEvent( "onreadystatechange", DOMContentLoaded );
			jQuery.ready();
		}
	};
}

// The DOM ready check for Internet Explorer
function doScrollCheck() {
	if ( jQuery.isReady ) {
		return;
	}

	try {
		// If IE is used, use the trick by Diego Perini
		// http://javascript.nwbox.com/IEContentLoaded/
		document.documentElement.doScroll("left");
	} catch(e) {
		setTimeout( doScrollCheck, 1 );
		return;
	}

	// and execute any waiting functions
	jQuery.ready();
}

return jQuery;

})();


// String to Object flags format cache
var flagsCache = {};

// Convert String-formatted flags into Object-formatted ones and store in cache
function createFlags( flags ) {
	var object = flagsCache[ flags ] = {},
		i, length;
	flags = flags.split( /\s+/ );
	for ( i = 0, length = flags.length; i < length; i++ ) {
		object[ flags[i] ] = true;
	}
	return object;
}

/*
 * Create a callback list using the following parameters:
 *
 *	flags:	an optional list of space-separated flags that will change how
 *			the callback list behaves
 *
 * By default a callback list will act like an event callback list and can be
 * "fired" multiple times.
 *
 * Possible flags:
 *
 *	once:			will ensure the callback list can only be fired once (like a Deferred)
 *
 *	memory:			will keep track of previous values and will call any callback added
 *					after the list has been fired right away with the latest "memorized"
 *					values (like a Deferred)
 *
 *	unique:			will ensure a callback can only be added once (no duplicate in the list)
 *
 *	stopOnFalse:	interrupt callings when a callback returns false
 *
 */
jQuery.Callbacks = function( flags ) {

	// Convert flags from String-formatted to Object-formatted
	// (we check in cache first)
	flags = flags ? ( flagsCache[ flags ] || createFlags( flags ) ) : {};

	var // Actual callback list
		list = [],
		// Stack of fire calls for repeatable lists
		stack = [],
		// Last fire value (for non-forgettable lists)
		memory,
		// Flag to know if list was already fired
		fired,
		// Flag to know if list is currently firing
		firing,
		// First callback to fire (used internally by add and fireWith)
		firingStart,
		// End of the loop when firing
		firingLength,
		// Index of currently firing callback (modified by remove if needed)
		firingIndex,
		// Add one or several callbacks to the list
		add = function( args ) {
			var i,
				length,
				elem,
				type,
				actual;
			for ( i = 0, length = args.length; i < length; i++ ) {
				elem = args[ i ];
				type = jQuery.type( elem );
				if ( type === "array" ) {
					// Inspect recursively
					add( elem );
				} else if ( type === "function" ) {
					// Add if not in unique mode and callback is not in
					if ( !flags.unique || !self.has( elem ) ) {
						list.push( elem );
					}
				}
			}
		},
		// Fire callbacks
		fire = function( context, args ) {
			args = args || [];
			memory = !flags.memory || [ context, args ];
			fired = true;
			firing = true;
			firingIndex = firingStart || 0;
			firingStart = 0;
			firingLength = list.length;
			for ( ; list && firingIndex < firingLength; firingIndex++ ) {
				if ( list[ firingIndex ].apply( context, args ) === false && flags.stopOnFalse ) {
					memory = true; // Mark as halted
					break;
				}
			}
			firing = false;
			if ( list ) {
				if ( !flags.once ) {
					if ( stack && stack.length ) {
						memory = stack.shift();
						self.fireWith( memory[ 0 ], memory[ 1 ] );
					}
				} else if ( memory === true ) {
					self.disable();
				} else {
					list = [];
				}
			}
		},
		// Actual Callbacks object
		self = {
			// Add a callback or a collection of callbacks to the list
			add: function() {
				if ( list ) {
					var length = list.length;
					add( arguments );
					// Do we need to add the callbacks to the
					// current firing batch?
					if ( firing ) {
						firingLength = list.length;
					// With memory, if we're not firing then
					// we should call right away, unless previous
					// firing was halted (stopOnFalse)
					} else if ( memory && memory !== true ) {
						firingStart = length;
						fire( memory[ 0 ], memory[ 1 ] );
					}
				}
				return this;
			},
			// Remove a callback from the list
			remove: function() {
				if ( list ) {
					var args = arguments,
						argIndex = 0,
						argLength = args.length;
					for ( ; argIndex < argLength ; argIndex++ ) {
						for ( var i = 0; i < list.length; i++ ) {
							if ( args[ argIndex ] === list[ i ] ) {
								// Handle firingIndex and firingLength
								if ( firing ) {
									if ( i <= firingLength ) {
										firingLength--;
										if ( i <= firingIndex ) {
											firingIndex--;
										}
									}
								}
								// Remove the element
								list.splice( i--, 1 );
								// If we have some unicity property then
								// we only need to do this once
								if ( flags.unique ) {
									break;
								}
							}
						}
					}
				}
				return this;
			},
			// Control if a given callback is in the list
			has: function( fn ) {
				if ( list ) {
					var i = 0,
						length = list.length;
					for ( ; i < length; i++ ) {
						if ( fn === list[ i ] ) {
							return true;
						}
					}
				}
				return false;
			},
			// Remove all callbacks from the list
			empty: function() {
				list = [];
				return this;
			},
			// Have the list do nothing anymore
			disable: function() {
				list = stack = memory = undefined;
				return this;
			},
			// Is it disabled?
			disabled: function() {
				return !list;
			},
			// Lock the list in its current state
			lock: function() {
				stack = undefined;
				if ( !memory || memory === true ) {
					self.disable();
				}
				return this;
			},
			// Is it locked?
			locked: function() {
				return !stack;
			},
			// Call all callbacks with the given context and arguments
			fireWith: function( context, args ) {
				if ( stack ) {
					if ( firing ) {
						if ( !flags.once ) {
							stack.push( [ context, args ] );
						}
					} else if ( !( flags.once && memory ) ) {
						fire( context, args );
					}
				}
				return this;
			},
			// Call all the callbacks with the given arguments
			fire: function() {
				self.fireWith( this, arguments );
				return this;
			},
			// To know if the callbacks have already been called at least once
			fired: function() {
				return !!fired;
			}
		};

	return self;
};




var // Static reference to slice
	sliceDeferred = [].slice;

jQuery.extend({

	Deferred: function( func ) {
		var doneList = jQuery.Callbacks( "once memory" ),
			failList = jQuery.Callbacks( "once memory" ),
			progressList = jQuery.Callbacks( "memory" ),
			state = "pending",
			lists = {
				resolve: doneList,
				reject: failList,
				notify: progressList
			},
			promise = {
				done: doneList.add,
				fail: failList.add,
				progress: progressList.add,

				state: function() {
					return state;
				},

				// Deprecated
				isResolved: doneList.fired,
				isRejected: failList.fired,

				then: function( doneCallbacks, failCallbacks, progressCallbacks ) {
					deferred.done( doneCallbacks ).fail( failCallbacks ).progress( progressCallbacks );
					return this;
				},
				always: function() {
					deferred.done.apply( deferred, arguments ).fail.apply( deferred, arguments );
					return this;
				},
				pipe: function( fnDone, fnFail, fnProgress ) {
					return jQuery.Deferred(function( newDefer ) {
						jQuery.each( {
							done: [ fnDone, "resolve" ],
							fail: [ fnFail, "reject" ],
							progress: [ fnProgress, "notify" ]
						}, function( handler, data ) {
							var fn = data[ 0 ],
								action = data[ 1 ],
								returned;
							if ( jQuery.isFunction( fn ) ) {
								deferred[ handler ](function() {
									returned = fn.apply( this, arguments );
									if ( returned && jQuery.isFunction( returned.promise ) ) {
										returned.promise().then( newDefer.resolve, newDefer.reject, newDefer.notify );
									} else {
										newDefer[ action + "With" ]( this === deferred ? newDefer : this, [ returned ] );
									}
								});
							} else {
								deferred[ handler ]( newDefer[ action ] );
							}
						});
					}).promise();
				},
				// Get a promise for this deferred
				// If obj is provided, the promise aspect is added to the object
				promise: function( obj ) {
					if ( obj == null ) {
						obj = promise;
					} else {
						for ( var key in promise ) {
							obj[ key ] = promise[ key ];
						}
					}
					return obj;
				}
			},
			deferred = promise.promise({}),
			key;

		for ( key in lists ) {
			deferred[ key ] = lists[ key ].fire;
			deferred[ key + "With" ] = lists[ key ].fireWith;
		}

		// Handle state
		deferred.done( function() {
			state = "resolved";
		}, failList.disable, progressList.lock ).fail( function() {
			state = "rejected";
		}, doneList.disable, progressList.lock );

		// Call given func if any
		if ( func ) {
			func.call( deferred, deferred );
		}

		// All done!
		return deferred;
	},

	// Deferred helper
	when: function( firstParam ) {
		var args = sliceDeferred.call( arguments, 0 ),
			i = 0,
			length = args.length,
			pValues = new Array( length ),
			count = length,
			pCount = length,
			deferred = length <= 1 && firstParam && jQuery.isFunction( firstParam.promise ) ?
				firstParam :
				jQuery.Deferred(),
			promise = deferred.promise();
		function resolveFunc( i ) {
			return function( value ) {
				args[ i ] = arguments.length > 1 ? sliceDeferred.call( arguments, 0 ) : value;
				if ( !( --count ) ) {
					deferred.resolveWith( deferred, args );
				}
			};
		}
		function progressFunc( i ) {
			return function( value ) {
				pValues[ i ] = arguments.length > 1 ? sliceDeferred.call( arguments, 0 ) : value;
				deferred.notifyWith( promise, pValues );
			};
		}
		if ( length > 1 ) {
			for ( ; i < length; i++ ) {
				if ( args[ i ] && args[ i ].promise && jQuery.isFunction( args[ i ].promise ) ) {
					args[ i ].promise().then( resolveFunc(i), deferred.reject, progressFunc(i) );
				} else {
					--count;
				}
			}
			if ( !count ) {
				deferred.resolveWith( deferred, args );
			}
		} else if ( deferred !== firstParam ) {
			deferred.resolveWith( deferred, length ? [ firstParam ] : [] );
		}
		return promise;
	}
});




jQuery.support = (function() {

	var support,
		all,
		a,
		select,
		opt,
		input,
		fragment,
		tds,
		events,
		eventName,
		i,
		isSupported,
		div = document.createElement( "div" ),
		documentElement = document.documentElement;

	// Preliminary tests
	div.setAttribute("className", "t");
	div.innerHTML = "   <link/><table></table><a href='/a' style='top:1px;float:left;opacity:.55;'>a</a><input type='checkbox'/>";

	all = div.getElementsByTagName( "*" );
	a = div.getElementsByTagName( "a" )[ 0 ];

	// Can't get basic test support
	if ( !all || !all.length || !a ) {
		return {};
	}

	// First batch of supports tests
	select = document.createElement( "select" );
	opt = select.appendChild( document.createElement("option") );
	input = div.getElementsByTagName( "input" )[ 0 ];

	support = {
		// IE strips leading whitespace when .innerHTML is used
		leadingWhitespace: ( div.firstChild.nodeType === 3 ),

		// Make sure that tbody elements aren't automatically inserted
		// IE will insert them into empty tables
		tbody: !div.getElementsByTagName("tbody").length,

		// Make sure that link elements get serialized correctly by innerHTML
		// This requires a wrapper element in IE
		htmlSerialize: !!div.getElementsByTagName("link").length,

		// Get the style information from getAttribute
		// (IE uses .cssText instead)
		style: /top/.test( a.getAttribute("style") ),

		// Make sure that URLs aren't manipulated
		// (IE normalizes it by default)
		hrefNormalized: ( a.getAttribute("href") === "/a" ),

		// Make sure that element opacity exists
		// (IE uses filter instead)
		// Use a regex to work around a WebKit issue. See #5145
		opacity: /^0.55/.test( a.style.opacity ),

		// Verify style float existence
		// (IE uses styleFloat instead of cssFloat)
		cssFloat: !!a.style.cssFloat,

		// Make sure that if no value is specified for a checkbox
		// that it defaults to "on".
		// (WebKit defaults to "" instead)
		checkOn: ( input.value === "on" ),

		// Make sure that a selected-by-default option has a working selected property.
		// (WebKit defaults to false instead of true, IE too, if it's in an optgroup)
		optSelected: opt.selected,

		// Test setAttribute on camelCase class. If it works, we need attrFixes when doing get/setAttribute (ie6/7)
		getSetAttribute: div.className !== "t",

		// Tests for enctype support on a form(#6743)
		enctype: !!document.createElement("form").enctype,

		// Makes sure cloning an html5 element does not cause problems
		// Where outerHTML is undefined, this still works
		html5Clone: document.createElement("nav").cloneNode( true ).outerHTML !== "<:nav></:nav>",

		// Will be defined later
		submitBubbles: true,
		changeBubbles: true,
		focusinBubbles: false,
		deleteExpando: true,
		noCloneEvent: true,
		inlineBlockNeedsLayout: false,
		shrinkWrapBlocks: false,
		reliableMarginRight: true,
		pixelMargin: true
	};

	// jQuery.boxModel DEPRECATED in 1.3, use jQuery.support.boxModel instead
	jQuery.boxModel = support.boxModel = (document.compatMode === "CSS1Compat");

	// Make sure checked status is properly cloned
	input.checked = true;
	support.noCloneChecked = input.cloneNode( true ).checked;

	// Make sure that the options inside disabled selects aren't marked as disabled
	// (WebKit marks them as disabled)
	select.disabled = true;
	support.optDisabled = !opt.disabled;

	// Test to see if it's possible to delete an expando from an element
	// Fails in Internet Explorer
	try {
		delete div.test;
	} catch( e ) {
		support.deleteExpando = false;
	}

	if ( !div.addEventListener && div.attachEvent && div.fireEvent ) {
		div.attachEvent( "onclick", function() {
			// Cloning a node shouldn't copy over any
			// bound event handlers (IE does this)
			support.noCloneEvent = false;
		});
		div.cloneNode( true ).fireEvent( "onclick" );
	}

	// Check if a radio maintains its value
	// after being appended to the DOM
	input = document.createElement("input");
	input.value = "t";
	input.setAttribute("type", "radio");
	support.radioValue = input.value === "t";

	input.setAttribute("checked", "checked");

	// #11217 - WebKit loses check when the name is after the checked attribute
	input.setAttribute( "name", "t" );

	div.appendChild( input );
	fragment = document.createDocumentFragment();
	fragment.appendChild( div.lastChild );

	// WebKit doesn't clone checked state correctly in fragments
	support.checkClone = fragment.cloneNode( true ).cloneNode( true ).lastChild.checked;

	// Check if a disconnected checkbox will retain its checked
	// value of true after appended to the DOM (IE6/7)
	support.appendChecked = input.checked;

	fragment.removeChild( input );
	fragment.appendChild( div );

	// Technique from Juriy Zaytsev
	// http://perfectionkills.com/detecting-event-support-without-browser-sniffing/
	// We only care about the case where non-standard event systems
	// are used, namely in IE. Short-circuiting here helps us to
	// avoid an eval call (in setAttribute) which can cause CSP
	// to go haywire. See: https://developer.mozilla.org/en/Security/CSP
	if ( div.attachEvent ) {
		for ( i in {
			submit: 1,
			change: 1,
			focusin: 1
		}) {
			eventName = "on" + i;
			isSupported = ( eventName in div );
			if ( !isSupported ) {
				div.setAttribute( eventName, "return;" );
				isSupported = ( typeof div[ eventName ] === "function" );
			}
			support[ i + "Bubbles" ] = isSupported;
		}
	}

	fragment.removeChild( div );

	// Null elements to avoid leaks in IE
	fragment = select = opt = div = input = null;

	// Run tests that need a body at doc ready
	jQuery(function() {
		var container, outer, inner, table, td, offsetSupport,
			marginDiv, conMarginTop, style, html, positionTopLeftWidthHeight,
			paddingMarginBorderVisibility, paddingMarginBorder,
			body = document.getElementsByTagName("body")[0];

		if ( !body ) {
			// Return for frameset docs that don't have a body
			return;
		}

		conMarginTop = 1;
		paddingMarginBorder = "padding:0;margin:0;border:";
		positionTopLeftWidthHeight = "position:absolute;top:0;left:0;width:1px;height:1px;";
		paddingMarginBorderVisibility = paddingMarginBorder + "0;visibility:hidden;";
		style = "style='" + positionTopLeftWidthHeight + paddingMarginBorder + "5px solid #000;";
		html = "<div " + style + "display:block;'><div style='" + paddingMarginBorder + "0;display:block;overflow:hidden;'></div></div>" +
			"<table " + style + "' cellpadding='0' cellspacing='0'>" +
			"<tr><td></td></tr></table>";

		container = document.createElement("div");
		container.style.cssText = paddingMarginBorderVisibility + "width:0;height:0;position:static;top:0;margin-top:" + conMarginTop + "px";
		body.insertBefore( container, body.firstChild );

		// Construct the test element
		div = document.createElement("div");
		container.appendChild( div );

		// Check if table cells still have offsetWidth/Height when they are set
		// to display:none and there are still other visible table cells in a
		// table row; if so, offsetWidth/Height are not reliable for use when
		// determining if an element has been hidden directly using
		// display:none (it is still safe to use offsets if a parent element is
		// hidden; don safety goggles and see bug #4512 for more information).
		// (only IE 8 fails this test)
		div.innerHTML = "<table><tr><td style='" + paddingMarginBorder + "0;display:none'></td><td>t</td></tr></table>";
		tds = div.getElementsByTagName( "td" );
		isSupported = ( tds[ 0 ].offsetHeight === 0 );

		tds[ 0 ].style.display = "";
		tds[ 1 ].style.display = "none";

		// Check if empty table cells still have offsetWidth/Height
		// (IE <= 8 fail this test)
		support.reliableHiddenOffsets = isSupported && ( tds[ 0 ].offsetHeight === 0 );

		// Check if div with explicit width and no margin-right incorrectly
		// gets computed margin-right based on width of container. For more
		// info see bug #3333
		// Fails in WebKit before Feb 2011 nightlies
		// WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
		if ( window.getComputedStyle ) {
			div.innerHTML = "";
			marginDiv = document.createElement( "div" );
			marginDiv.style.width = "0";
			marginDiv.style.marginRight = "0";
			div.style.width = "2px";
			div.appendChild( marginDiv );
			support.reliableMarginRight =
				( parseInt( ( window.getComputedStyle( marginDiv, null ) || { marginRight: 0 } ).marginRight, 10 ) || 0 ) === 0;
		}

		if ( typeof div.style.zoom !== "undefined" ) {
			// Check if natively block-level elements act like inline-block
			// elements when setting their display to 'inline' and giving
			// them layout
			// (IE < 8 does this)
			div.innerHTML = "";
			div.style.width = div.style.padding = "1px";
			div.style.border = 0;
			div.style.overflow = "hidden";
			div.style.display = "inline";
			div.style.zoom = 1;
			support.inlineBlockNeedsLayout = ( div.offsetWidth === 3 );

			// Check if elements with layout shrink-wrap their children
			// (IE 6 does this)
			div.style.display = "block";
			div.style.overflow = "visible";
			div.innerHTML = "<div style='width:5px;'></div>";
			support.shrinkWrapBlocks = ( div.offsetWidth !== 3 );
		}

		div.style.cssText = positionTopLeftWidthHeight + paddingMarginBorderVisibility;
		div.innerHTML = html;

		outer = div.firstChild;
		inner = outer.firstChild;
		td = outer.nextSibling.firstChild.firstChild;

		offsetSupport = {
			doesNotAddBorder: ( inner.offsetTop !== 5 ),
			doesAddBorderForTableAndCells: ( td.offsetTop === 5 )
		};

		inner.style.position = "fixed";
		inner.style.top = "20px";

		// safari subtracts parent border width here which is 5px
		offsetSupport.fixedPosition = ( inner.offsetTop === 20 || inner.offsetTop === 15 );
		inner.style.position = inner.style.top = "";

		outer.style.overflow = "hidden";
		outer.style.position = "relative";

		offsetSupport.subtractsBorderForOverflowNotVisible = ( inner.offsetTop === -5 );
		offsetSupport.doesNotIncludeMarginInBodyOffset = ( body.offsetTop !== conMarginTop );

		if ( window.getComputedStyle ) {
			div.style.marginTop = "1%";
			support.pixelMargin = ( window.getComputedStyle( div, null ) || { marginTop: 0 } ).marginTop !== "1%";
		}

		if ( typeof container.style.zoom !== "undefined" ) {
			container.style.zoom = 1;
		}

		body.removeChild( container );
		marginDiv = div = container = null;

		jQuery.extend( support, offsetSupport );
	});

	return support;
})();




var rbrace = /^(?:\{.*\}|\[.*\])$/,
	rmultiDash = /([A-Z])/g;

jQuery.extend({
	cache: {},

	// Please use with caution
	uuid: 0,

	// Unique for each copy of jQuery on the page
	// Non-digits removed to match rinlinejQuery
	expando: "jQuery" + ( jQuery.fn.jquery + Math.random() ).replace( /\D/g, "" ),

	// The following elements throw uncatchable exceptions if you
	// attempt to add expando properties to them.
	noData: {
		"embed": true,
		// Ban all objects except for Flash (which handle expandos)
		"object": "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",
		"applet": true
	},

	hasData: function( elem ) {
		elem = elem.nodeType ? jQuery.cache[ elem[jQuery.expando] ] : elem[ jQuery.expando ];
		return !!elem && !isEmptyDataObject( elem );
	},

	data: function( elem, name, data, pvt /* Internal Use Only */ ) {
		if ( !jQuery.acceptData( elem ) ) {
			return;
		}

		var privateCache, thisCache, ret,
			internalKey = jQuery.expando,
			getByName = typeof name === "string",

			// We have to handle DOM nodes and JS objects differently because IE6-7
			// can't GC object references properly across the DOM-JS boundary
			isNode = elem.nodeType,

			// Only DOM nodes need the global jQuery cache; JS object data is
			// attached directly to the object so GC can occur automatically
			cache = isNode ? jQuery.cache : elem,

			// Only defining an ID for JS objects if its cache already exists allows
			// the code to shortcut on the same path as a DOM node with no cache
			id = isNode ? elem[ internalKey ] : elem[ internalKey ] && internalKey,
			isEvents = name === "events";

		// Avoid doing any more work than we need to when trying to get data on an
		// object that has no data at all
		if ( (!id || !cache[id] || (!isEvents && !pvt && !cache[id].data)) && getByName && data === undefined ) {
			return;
		}

		if ( !id ) {
			// Only DOM nodes need a new unique ID for each element since their data
			// ends up in the global cache
			if ( isNode ) {
				elem[ internalKey ] = id = ++jQuery.uuid;
			} else {
				id = internalKey;
			}
		}

		if ( !cache[ id ] ) {
			cache[ id ] = {};

			// Avoids exposing jQuery metadata on plain JS objects when the object
			// is serialized using JSON.stringify
			if ( !isNode ) {
				cache[ id ].toJSON = jQuery.noop;
			}
		}

		// An object can be passed to jQuery.data instead of a key/value pair; this gets
		// shallow copied over onto the existing cache
		if ( typeof name === "object" || typeof name === "function" ) {
			if ( pvt ) {
				cache[ id ] = jQuery.extend( cache[ id ], name );
			} else {
				cache[ id ].data = jQuery.extend( cache[ id ].data, name );
			}
		}

		privateCache = thisCache = cache[ id ];

		// jQuery data() is stored in a separate object inside the object's internal data
		// cache in order to avoid key collisions between internal data and user-defined
		// data.
		if ( !pvt ) {
			if ( !thisCache.data ) {
				thisCache.data = {};
			}

			thisCache = thisCache.data;
		}

		if ( data !== undefined ) {
			thisCache[ jQuery.camelCase( name ) ] = data;
		}

		// Users should not attempt to inspect the internal events object using jQuery.data,
		// it is undocumented and subject to change. But does anyone listen? No.
		if ( isEvents && !thisCache[ name ] ) {
			return privateCache.events;
		}

		// Check for both converted-to-camel and non-converted data property names
		// If a data property was specified
		if ( getByName ) {

			// First Try to find as-is property data
			ret = thisCache[ name ];

			// Test for null|undefined property data
			if ( ret == null ) {

				// Try to find the camelCased property
				ret = thisCache[ jQuery.camelCase( name ) ];
			}
		} else {
			ret = thisCache;
		}

		return ret;
	},

	removeData: function( elem, name, pvt /* Internal Use Only */ ) {
		if ( !jQuery.acceptData( elem ) ) {
			return;
		}

		var thisCache, i, l,

			// Reference to internal data cache key
			internalKey = jQuery.expando,

			isNode = elem.nodeType,

			// See jQuery.data for more information
			cache = isNode ? jQuery.cache : elem,

			// See jQuery.data for more information
			id = isNode ? elem[ internalKey ] : internalKey;

		// If there is already no cache entry for this object, there is no
		// purpose in continuing
		if ( !cache[ id ] ) {
			return;
		}

		if ( name ) {

			thisCache = pvt ? cache[ id ] : cache[ id ].data;

			if ( thisCache ) {

				// Support array or space separated string names for data keys
				if ( !jQuery.isArray( name ) ) {

					// try the string as a key before any manipulation
					if ( name in thisCache ) {
						name = [ name ];
					} else {

						// split the camel cased version by spaces unless a key with the spaces exists
						name = jQuery.camelCase( name );
						if ( name in thisCache ) {
							name = [ name ];
						} else {
							name = name.split( " " );
						}
					}
				}

				for ( i = 0, l = name.length; i < l; i++ ) {
					delete thisCache[ name[i] ];
				}

				// If there is no data left in the cache, we want to continue
				// and let the cache object itself get destroyed
				if ( !( pvt ? isEmptyDataObject : jQuery.isEmptyObject )( thisCache ) ) {
					return;
				}
			}
		}

		// See jQuery.data for more information
		if ( !pvt ) {
			delete cache[ id ].data;

			// Don't destroy the parent cache unless the internal data object
			// had been the only thing left in it
			if ( !isEmptyDataObject(cache[ id ]) ) {
				return;
			}
		}

		// Browsers that fail expando deletion also refuse to delete expandos on
		// the window, but it will allow it on all other JS objects; other browsers
		// don't care
		// Ensure that `cache` is not a window object #10080
		if ( jQuery.support.deleteExpando || !cache.setInterval ) {
			delete cache[ id ];
		} else {
			cache[ id ] = null;
		}

		// We destroyed the cache and need to eliminate the expando on the node to avoid
		// false lookups in the cache for entries that no longer exist
		if ( isNode ) {
			// IE does not allow us to delete expando properties from nodes,
			// nor does it have a removeAttribute function on Document nodes;
			// we must handle all of these cases
			if ( jQuery.support.deleteExpando ) {
				delete elem[ internalKey ];
			} else if ( elem.removeAttribute ) {
				elem.removeAttribute( internalKey );
			} else {
				elem[ internalKey ] = null;
			}
		}
	},

	// For internal use only.
	_data: function( elem, name, data ) {
		return jQuery.data( elem, name, data, true );
	},

	// A method for determining if a DOM node can handle the data expando
	acceptData: function( elem ) {
		if ( elem.nodeName ) {
			var match = jQuery.noData[ elem.nodeName.toLowerCase() ];

			if ( match ) {
				return !(match === true || elem.getAttribute("classid") !== match);
			}
		}

		return true;
	}
});

jQuery.fn.extend({
	data: function( key, value ) {
		var parts, part, attr, name, l,
			elem = this[0],
			i = 0,
			data = null;

		// Gets all values
		if ( key === undefined ) {
			if ( this.length ) {
				data = jQuery.data( elem );

				if ( elem.nodeType === 1 && !jQuery._data( elem, "parsedAttrs" ) ) {
					attr = elem.attributes;
					for ( l = attr.length; i < l; i++ ) {
						name = attr[i].name;

						if ( name.indexOf( "data-" ) === 0 ) {
							name = jQuery.camelCase( name.substring(5) );

							dataAttr( elem, name, data[ name ] );
						}
					}
					jQuery._data( elem, "parsedAttrs", true );
				}
			}

			return data;
		}

		// Sets multiple values
		if ( typeof key === "object" ) {
			return this.each(function() {
				jQuery.data( this, key );
			});
		}

		parts = key.split( ".", 2 );
		parts[1] = parts[1] ? "." + parts[1] : "";
		part = parts[1] + "!";

		return jQuery.access( this, function( value ) {

			if ( value === undefined ) {
				data = this.triggerHandler( "getData" + part, [ parts[0] ] );

				// Try to fetch any internally stored data first
				if ( data === undefined && elem ) {
					data = jQuery.data( elem, key );
					data = dataAttr( elem, key, data );
				}

				return data === undefined && parts[1] ?
					this.data( parts[0] ) :
					data;
			}

			parts[1] = value;
			this.each(function() {
				var self = jQuery( this );

				self.triggerHandler( "setData" + part, parts );
				jQuery.data( this, key, value );
				self.triggerHandler( "changeData" + part, parts );
			});
		}, null, value, arguments.length > 1, null, false );
	},

	removeData: function( key ) {
		return this.each(function() {
			jQuery.removeData( this, key );
		});
	}
});

function dataAttr( elem, key, data ) {
	// If nothing was found internally, try to fetch any
	// data from the HTML5 data-* attribute
	if ( data === undefined && elem.nodeType === 1 ) {

		var name = "data-" + key.replace( rmultiDash, "-$1" ).toLowerCase();

		data = elem.getAttribute( name );

		if ( typeof data === "string" ) {
			try {
				data = data === "true" ? true :
				data === "false" ? false :
				data === "null" ? null :
				jQuery.isNumeric( data ) ? +data :
					rbrace.test( data ) ? jQuery.parseJSON( data ) :
					data;
			} catch( e ) {}

			// Make sure we set the data so it isn't changed later
			jQuery.data( elem, key, data );

		} else {
			data = undefined;
		}
	}

	return data;
}

// checks a cache object for emptiness
function isEmptyDataObject( obj ) {
	for ( var name in obj ) {

		// if the public data object is empty, the private is still empty
		if ( name === "data" && jQuery.isEmptyObject( obj[name] ) ) {
			continue;
		}
		if ( name !== "toJSON" ) {
			return false;
		}
	}

	return true;
}




function handleQueueMarkDefer( elem, type, src ) {
	var deferDataKey = type + "defer",
		queueDataKey = type + "queue",
		markDataKey = type + "mark",
		defer = jQuery._data( elem, deferDataKey );
	if ( defer &&
		( src === "queue" || !jQuery._data(elem, queueDataKey) ) &&
		( src === "mark" || !jQuery._data(elem, markDataKey) ) ) {
		// Give room for hard-coded callbacks to fire first
		// and eventually mark/queue something else on the element
		setTimeout( function() {
			if ( !jQuery._data( elem, queueDataKey ) &&
				!jQuery._data( elem, markDataKey ) ) {
				jQuery.removeData( elem, deferDataKey, true );
				defer.fire();
			}
		}, 0 );
	}
}

jQuery.extend({

	_mark: function( elem, type ) {
		if ( elem ) {
			type = ( type || "fx" ) + "mark";
			jQuery._data( elem, type, (jQuery._data( elem, type ) || 0) + 1 );
		}
	},

	_unmark: function( force, elem, type ) {
		if ( force !== true ) {
			type = elem;
			elem = force;
			force = false;
		}
		if ( elem ) {
			type = type || "fx";
			var key = type + "mark",
				count = force ? 0 : ( (jQuery._data( elem, key ) || 1) - 1 );
			if ( count ) {
				jQuery._data( elem, key, count );
			} else {
				jQuery.removeData( elem, key, true );
				handleQueueMarkDefer( elem, type, "mark" );
			}
		}
	},

	queue: function( elem, type, data ) {
		var q;
		if ( elem ) {
			type = ( type || "fx" ) + "queue";
			q = jQuery._data( elem, type );

			// Speed up dequeue by getting out quickly if this is just a lookup
			if ( data ) {
				if ( !q || jQuery.isArray(data) ) {
					q = jQuery._data( elem, type, jQuery.makeArray(data) );
				} else {
					q.push( data );
				}
			}
			return q || [];
		}
	},

	dequeue: function( elem, type ) {
		type = type || "fx";

		var queue = jQuery.queue( elem, type ),
			fn = queue.shift(),
			hooks = {};

		// If the fx queue is dequeued, always remove the progress sentinel
		if ( fn === "inprogress" ) {
			fn = queue.shift();
		}

		if ( fn ) {
			// Add a progress sentinel to prevent the fx queue from being
			// automatically dequeued
			if ( type === "fx" ) {
				queue.unshift( "inprogress" );
			}

			jQuery._data( elem, type + ".run", hooks );
			fn.call( elem, function() {
				jQuery.dequeue( elem, type );
			}, hooks );
		}

		if ( !queue.length ) {
			jQuery.removeData( elem, type + "queue " + type + ".run", true );
			handleQueueMarkDefer( elem, type, "queue" );
		}
	}
});

jQuery.fn.extend({
	queue: function( type, data ) {
		var setter = 2;

		if ( typeof type !== "string" ) {
			data = type;
			type = "fx";
			setter--;
		}

		if ( arguments.length < setter ) {
			return jQuery.queue( this[0], type );
		}

		return data === undefined ?
			this :
			this.each(function() {
				var queue = jQuery.queue( this, type, data );

				if ( type === "fx" && queue[0] !== "inprogress" ) {
					jQuery.dequeue( this, type );
				}
			});
	},
	dequeue: function( type ) {
		return this.each(function() {
			jQuery.dequeue( this, type );
		});
	},
	// Based off of the plugin by Clint Helfers, with permission.
	// http://blindsignals.com/index.php/2009/07/jquery-delay/
	delay: function( time, type ) {
		time = jQuery.fx ? jQuery.fx.speeds[ time ] || time : time;
		type = type || "fx";

		return this.queue( type, function( next, hooks ) {
			var timeout = setTimeout( next, time );
			hooks.stop = function() {
				clearTimeout( timeout );
			};
		});
	},
	clearQueue: function( type ) {
		return this.queue( type || "fx", [] );
	},
	// Get a promise resolved when queues of a certain type
	// are emptied (fx is the type by default)
	promise: function( type, object ) {
		if ( typeof type !== "string" ) {
			object = type;
			type = undefined;
		}
		type = type || "fx";
		var defer = jQuery.Deferred(),
			elements = this,
			i = elements.length,
			count = 1,
			deferDataKey = type + "defer",
			queueDataKey = type + "queue",
			markDataKey = type + "mark",
			tmp;
		function resolve() {
			if ( !( --count ) ) {
				defer.resolveWith( elements, [ elements ] );
			}
		}
		while( i-- ) {
			if (( tmp = jQuery.data( elements[ i ], deferDataKey, undefined, true ) ||
					( jQuery.data( elements[ i ], queueDataKey, undefined, true ) ||
						jQuery.data( elements[ i ], markDataKey, undefined, true ) ) &&
					jQuery.data( elements[ i ], deferDataKey, jQuery.Callbacks( "once memory" ), true ) )) {
				count++;
				tmp.add( resolve );
			}
		}
		resolve();
		return defer.promise( object );
	}
});




var rclass = /[\n\t\r]/g,
	rspace = /\s+/,
	rreturn = /\r/g,
	rtype = /^(?:button|input)$/i,
	rfocusable = /^(?:button|input|object|select|textarea)$/i,
	rclickable = /^a(?:rea)?$/i,
	rboolean = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,
	getSetAttribute = jQuery.support.getSetAttribute,
	nodeHook, boolHook, fixSpecified;

jQuery.fn.extend({
	attr: function( name, value ) {
		return jQuery.access( this, jQuery.attr, name, value, arguments.length > 1 );
	},

	removeAttr: function( name ) {
		return this.each(function() {
			jQuery.removeAttr( this, name );
		});
	},

	prop: function( name, value ) {
		return jQuery.access( this, jQuery.prop, name, value, arguments.length > 1 );
	},

	removeProp: function( name ) {
		name = jQuery.propFix[ name ] || name;
		return this.each(function() {
			// try/catch handles cases where IE balks (such as removing a property on window)
			try {
				this[ name ] = undefined;
				delete this[ name ];
			} catch( e ) {}
		});
	},

	addClass: function( value ) {
		var classNames, i, l, elem,
			setClass, c, cl;

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( j ) {
				jQuery( this ).addClass( value.call(this, j, this.className) );
			});
		}

		if ( value && typeof value === "string" ) {
			classNames = value.split( rspace );

			for ( i = 0, l = this.length; i < l; i++ ) {
				elem = this[ i ];

				if ( elem.nodeType === 1 ) {
					if ( !elem.className && classNames.length === 1 ) {
						elem.className = value;

					} else {
						setClass = " " + elem.className + " ";

						for ( c = 0, cl = classNames.length; c < cl; c++ ) {
							if ( !~setClass.indexOf( " " + classNames[ c ] + " " ) ) {
								setClass += classNames[ c ] + " ";
							}
						}
						elem.className = jQuery.trim( setClass );
					}
				}
			}
		}

		return this;
	},

	removeClass: function( value ) {
		var classNames, i, l, elem, className, c, cl;

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( j ) {
				jQuery( this ).removeClass( value.call(this, j, this.className) );
			});
		}

		if ( (value && typeof value === "string") || value === undefined ) {
			classNames = ( value || "" ).split( rspace );

			for ( i = 0, l = this.length; i < l; i++ ) {
				elem = this[ i ];

				if ( elem.nodeType === 1 && elem.className ) {
					if ( value ) {
						className = (" " + elem.className + " ").replace( rclass, " " );
						for ( c = 0, cl = classNames.length; c < cl; c++ ) {
							className = className.replace(" " + classNames[ c ] + " ", " ");
						}
						elem.className = jQuery.trim( className );

					} else {
						elem.className = "";
					}
				}
			}
		}

		return this;
	},

	toggleClass: function( value, stateVal ) {
		var type = typeof value,
			isBool = typeof stateVal === "boolean";

		if ( jQuery.isFunction( value ) ) {
			return this.each(function( i ) {
				jQuery( this ).toggleClass( value.call(this, i, this.className, stateVal), stateVal );
			});
		}

		return this.each(function() {
			if ( type === "string" ) {
				// toggle individual class names
				var className,
					i = 0,
					self = jQuery( this ),
					state = stateVal,
					classNames = value.split( rspace );

				while ( (className = classNames[ i++ ]) ) {
					// check each className given, space seperated list
					state = isBool ? state : !self.hasClass( className );
					self[ state ? "addClass" : "removeClass" ]( className );
				}

			} else if ( type === "undefined" || type === "boolean" ) {
				if ( this.className ) {
					// store className if set
					jQuery._data( this, "__className__", this.className );
				}

				// toggle whole className
				this.className = this.className || value === false ? "" : jQuery._data( this, "__className__" ) || "";
			}
		});
	},

	hasClass: function( selector ) {
		var className = " " + selector + " ",
			i = 0,
			l = this.length;
		for ( ; i < l; i++ ) {
			if ( this[i].nodeType === 1 && (" " + this[i].className + " ").replace(rclass, " ").indexOf( className ) > -1 ) {
				return true;
			}
		}

		return false;
	},

	val: function( value ) {
		var hooks, ret, isFunction,
			elem = this[0];

		if ( !arguments.length ) {
			if ( elem ) {
				hooks = jQuery.valHooks[ elem.type ] || jQuery.valHooks[ elem.nodeName.toLowerCase() ];

				if ( hooks && "get" in hooks && (ret = hooks.get( elem, "value" )) !== undefined ) {
					return ret;
				}

				ret = elem.value;

				return typeof ret === "string" ?
					// handle most common string cases
					ret.replace(rreturn, "") :
					// handle cases where value is null/undef or number
					ret == null ? "" : ret;
			}

			return;
		}

		isFunction = jQuery.isFunction( value );

		return this.each(function( i ) {
			var self = jQuery(this), val;

			if ( this.nodeType !== 1 ) {
				return;
			}

			if ( isFunction ) {
				val = value.call( this, i, self.val() );
			} else {
				val = value;
			}

			// Treat null/undefined as ""; convert numbers to string
			if ( val == null ) {
				val = "";
			} else if ( typeof val === "number" ) {
				val += "";
			} else if ( jQuery.isArray( val ) ) {
				val = jQuery.map(val, function ( value ) {
					return value == null ? "" : value + "";
				});
			}

			hooks = jQuery.valHooks[ this.type ] || jQuery.valHooks[ this.nodeName.toLowerCase() ];

			// If set returns undefined, fall back to normal setting
			if ( !hooks || !("set" in hooks) || hooks.set( this, val, "value" ) === undefined ) {
				this.value = val;
			}
		});
	}
});

jQuery.extend({
	valHooks: {
		option: {
			get: function( elem ) {
				// attributes.value is undefined in Blackberry 4.7 but
				// uses .value. See #6932
				var val = elem.attributes.value;
				return !val || val.specified ? elem.value : elem.text;
			}
		},
		select: {
			get: function( elem ) {
				var value, i, max, option,
					index = elem.selectedIndex,
					values = [],
					options = elem.options,
					one = elem.type === "select-one";

				// Nothing was selected
				if ( index < 0 ) {
					return null;
				}

				// Loop through all the selected options
				i = one ? index : 0;
				max = one ? index + 1 : options.length;
				for ( ; i < max; i++ ) {
					option = options[ i ];

					// Don't return options that are disabled or in a disabled optgroup
					if ( option.selected && (jQuery.support.optDisabled ? !option.disabled : option.getAttribute("disabled") === null) &&
							(!option.parentNode.disabled || !jQuery.nodeName( option.parentNode, "optgroup" )) ) {

						// Get the specific value for the option
						value = jQuery( option ).val();

						// We don't need an array for one selects
						if ( one ) {
							return value;
						}

						// Multi-Selects return an array
						values.push( value );
					}
				}

				// Fixes Bug #2551 -- select.val() broken in IE after form.reset()
				if ( one && !values.length && options.length ) {
					return jQuery( options[ index ] ).val();
				}

				return values;
			},

			set: function( elem, value ) {
				var values = jQuery.makeArray( value );

				jQuery(elem).find("option").each(function() {
					this.selected = jQuery.inArray( jQuery(this).val(), values ) >= 0;
				});

				if ( !values.length ) {
					elem.selectedIndex = -1;
				}
				return values;
			}
		}
	},

	attrFn: {
		val: true,
		css: true,
		html: true,
		text: true,
		data: true,
		width: true,
		height: true,
		offset: true
	},

	attr: function( elem, name, value, pass ) {
		var ret, hooks, notxml,
			nType = elem.nodeType;

		// don't get/set attributes on text, comment and attribute nodes
		if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
			return;
		}

		if ( pass && name in jQuery.attrFn ) {
			return jQuery( elem )[ name ]( value );
		}

		// Fallback to prop when attributes are not supported
		if ( typeof elem.getAttribute === "undefined" ) {
			return jQuery.prop( elem, name, value );
		}

		notxml = nType !== 1 || !jQuery.isXMLDoc( elem );

		// All attributes are lowercase
		// Grab necessary hook if one is defined
		if ( notxml ) {
			name = name.toLowerCase();
			hooks = jQuery.attrHooks[ name ] || ( rboolean.test( name ) ? boolHook : nodeHook );
		}

		if ( value !== undefined ) {

			if ( value === null ) {
				jQuery.removeAttr( elem, name );
				return;

			} else if ( hooks && "set" in hooks && notxml && (ret = hooks.set( elem, value, name )) !== undefined ) {
				return ret;

			} else {
				elem.setAttribute( name, "" + value );
				return value;
			}

		} else if ( hooks && "get" in hooks && notxml && (ret = hooks.get( elem, name )) !== null ) {
			return ret;

		} else {

			ret = elem.getAttribute( name );

			// Non-existent attributes return null, we normalize to undefined
			return ret === null ?
				undefined :
				ret;
		}
	},

	removeAttr: function( elem, value ) {
		var propName, attrNames, name, l, isBool,
			i = 0;

		if ( value && elem.nodeType === 1 ) {
			attrNames = value.toLowerCase().split( rspace );
			l = attrNames.length;

			for ( ; i < l; i++ ) {
				name = attrNames[ i ];

				if ( name ) {
					propName = jQuery.propFix[ name ] || name;
					isBool = rboolean.test( name );

					// See #9699 for explanation of this approach (setting first, then removal)
					// Do not do this for boolean attributes (see #10870)
					if ( !isBool ) {
						jQuery.attr( elem, name, "" );
					}
					elem.removeAttribute( getSetAttribute ? name : propName );

					// Set corresponding property to false for boolean attributes
					if ( isBool && propName in elem ) {
						elem[ propName ] = false;
					}
				}
			}
		}
	},

	attrHooks: {
		type: {
			set: function( elem, value ) {
				// We can't allow the type property to be changed (since it causes problems in IE)
				if ( rtype.test( elem.nodeName ) && elem.parentNode ) {
					jQuery.error( "type property can't be changed" );
				} else if ( !jQuery.support.radioValue && value === "radio" && jQuery.nodeName(elem, "input") ) {
					// Setting the type on a radio button after the value resets the value in IE6-9
					// Reset value to it's default in case type is set after value
					// This is for element creation
					var val = elem.value;
					elem.setAttribute( "type", value );
					if ( val ) {
						elem.value = val;
					}
					return value;
				}
			}
		},
		// Use the value property for back compat
		// Use the nodeHook for button elements in IE6/7 (#1954)
		value: {
			get: function( elem, name ) {
				if ( nodeHook && jQuery.nodeName( elem, "button" ) ) {
					return nodeHook.get( elem, name );
				}
				return name in elem ?
					elem.value :
					null;
			},
			set: function( elem, value, name ) {
				if ( nodeHook && jQuery.nodeName( elem, "button" ) ) {
					return nodeHook.set( elem, value, name );
				}
				// Does not return so that setAttribute is also used
				elem.value = value;
			}
		}
	},

	propFix: {
		tabindex: "tabIndex",
		readonly: "readOnly",
		"for": "htmlFor",
		"class": "className",
		maxlength: "maxLength",
		cellspacing: "cellSpacing",
		cellpadding: "cellPadding",
		rowspan: "rowSpan",
		colspan: "colSpan",
		usemap: "useMap",
		frameborder: "frameBorder",
		contenteditable: "contentEditable"
	},

	prop: function( elem, name, value ) {
		var ret, hooks, notxml,
			nType = elem.nodeType;

		// don't get/set properties on text, comment and attribute nodes
		if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
			return;
		}

		notxml = nType !== 1 || !jQuery.isXMLDoc( elem );

		if ( notxml ) {
			// Fix name and attach hooks
			name = jQuery.propFix[ name ] || name;
			hooks = jQuery.propHooks[ name ];
		}

		if ( value !== undefined ) {
			if ( hooks && "set" in hooks && (ret = hooks.set( elem, value, name )) !== undefined ) {
				return ret;

			} else {
				return ( elem[ name ] = value );
			}

		} else {
			if ( hooks && "get" in hooks && (ret = hooks.get( elem, name )) !== null ) {
				return ret;

			} else {
				return elem[ name ];
			}
		}
	},

	propHooks: {
		tabIndex: {
			get: function( elem ) {
				// elem.tabIndex doesn't always return the correct value when it hasn't been explicitly set
				// http://fluidproject.org/blog/2008/01/09/getting-setting-and-removing-tabindex-values-with-javascript/
				var attributeNode = elem.getAttributeNode("tabindex");

				return attributeNode && attributeNode.specified ?
					parseInt( attributeNode.value, 10 ) :
					rfocusable.test( elem.nodeName ) || rclickable.test( elem.nodeName ) && elem.href ?
						0 :
						undefined;
			}
		}
	}
});

// Add the tabIndex propHook to attrHooks for back-compat (different case is intentional)
jQuery.attrHooks.tabindex = jQuery.propHooks.tabIndex;

// Hook for boolean attributes
boolHook = {
	get: function( elem, name ) {
		// Align boolean attributes with corresponding properties
		// Fall back to attribute presence where some booleans are not supported
		var attrNode,
			property = jQuery.prop( elem, name );
		return property === true || typeof property !== "boolean" && ( attrNode = elem.getAttributeNode(name) ) && attrNode.nodeValue !== false ?
			name.toLowerCase() :
			undefined;
	},
	set: function( elem, value, name ) {
		var propName;
		if ( value === false ) {
			// Remove boolean attributes when set to false
			jQuery.removeAttr( elem, name );
		} else {
			// value is true since we know at this point it's type boolean and not false
			// Set boolean attributes to the same name and set the DOM property
			propName = jQuery.propFix[ name ] || name;
			if ( propName in elem ) {
				// Only set the IDL specifically if it already exists on the element
				elem[ propName ] = true;
			}

			elem.setAttribute( name, name.toLowerCase() );
		}
		return name;
	}
};

// IE6/7 do not support getting/setting some attributes with get/setAttribute
if ( !getSetAttribute ) {

	fixSpecified = {
		name: true,
		id: true,
		coords: true
	};

	// Use this for any attribute in IE6/7
	// This fixes almost every IE6/7 issue
	nodeHook = jQuery.valHooks.button = {
		get: function( elem, name ) {
			var ret;
			ret = elem.getAttributeNode( name );
			return ret && ( fixSpecified[ name ] ? ret.nodeValue !== "" : ret.specified ) ?
				ret.nodeValue :
				undefined;
		},
		set: function( elem, value, name ) {
			// Set the existing or create a new attribute node
			var ret = elem.getAttributeNode( name );
			if ( !ret ) {
				ret = document.createAttribute( name );
				elem.setAttributeNode( ret );
			}
			return ( ret.nodeValue = value + "" );
		}
	};

	// Apply the nodeHook to tabindex
	jQuery.attrHooks.tabindex.set = nodeHook.set;

	// Set width and height to auto instead of 0 on empty string( Bug #8150 )
	// This is for removals
	jQuery.each([ "width", "height" ], function( i, name ) {
		jQuery.attrHooks[ name ] = jQuery.extend( jQuery.attrHooks[ name ], {
			set: function( elem, value ) {
				if ( value === "" ) {
					elem.setAttribute( name, "auto" );
					return value;
				}
			}
		});
	});

	// Set contenteditable to false on removals(#10429)
	// Setting to empty string throws an error as an invalid value
	jQuery.attrHooks.contenteditable = {
		get: nodeHook.get,
		set: function( elem, value, name ) {
			if ( value === "" ) {
				value = "false";
			}
			nodeHook.set( elem, value, name );
		}
	};
}


// Some attributes require a special call on IE
if ( !jQuery.support.hrefNormalized ) {
	jQuery.each([ "href", "src", "width", "height" ], function( i, name ) {
		jQuery.attrHooks[ name ] = jQuery.extend( jQuery.attrHooks[ name ], {
			get: function( elem ) {
				var ret = elem.getAttribute( name, 2 );
				return ret === null ? undefined : ret;
			}
		});
	});
}

if ( !jQuery.support.style ) {
	jQuery.attrHooks.style = {
		get: function( elem ) {
			// Return undefined in the case of empty string
			// Normalize to lowercase since IE uppercases css property names
			return elem.style.cssText.toLowerCase() || undefined;
		},
		set: function( elem, value ) {
			return ( elem.style.cssText = "" + value );
		}
	};
}

// Safari mis-reports the default selected property of an option
// Accessing the parent's selectedIndex property fixes it
if ( !jQuery.support.optSelected ) {
	jQuery.propHooks.selected = jQuery.extend( jQuery.propHooks.selected, {
		get: function( elem ) {
			var parent = elem.parentNode;

			if ( parent ) {
				parent.selectedIndex;

				// Make sure that it also works with optgroups, see #5701
				if ( parent.parentNode ) {
					parent.parentNode.selectedIndex;
				}
			}
			return null;
		}
	});
}

// IE6/7 call enctype encoding
if ( !jQuery.support.enctype ) {
	jQuery.propFix.enctype = "encoding";
}

// Radios and checkboxes getter/setter
if ( !jQuery.support.checkOn ) {
	jQuery.each([ "radio", "checkbox" ], function() {
		jQuery.valHooks[ this ] = {
			get: function( elem ) {
				// Handle the case where in Webkit "" is returned instead of "on" if a value isn't specified
				return elem.getAttribute("value") === null ? "on" : elem.value;
			}
		};
	});
}
jQuery.each([ "radio", "checkbox" ], function() {
	jQuery.valHooks[ this ] = jQuery.extend( jQuery.valHooks[ this ], {
		set: function( elem, value ) {
			if ( jQuery.isArray( value ) ) {
				return ( elem.checked = jQuery.inArray( jQuery(elem).val(), value ) >= 0 );
			}
		}
	});
});




var rformElems = /^(?:textarea|input|select)$/i,
	rtypenamespace = /^([^\.]*)?(?:\.(.+))?$/,
	rhoverHack = /(?:^|\s)hover(\.\S+)?\b/,
	rkeyEvent = /^key/,
	rmouseEvent = /^(?:mouse|contextmenu)|click/,
	rfocusMorph = /^(?:focusinfocus|focusoutblur)$/,
	rquickIs = /^(\w*)(?:#([\w\-]+))?(?:\.([\w\-]+))?$/,
	quickParse = function( selector ) {
		var quick = rquickIs.exec( selector );
		if ( quick ) {
			//   0  1    2   3
			// [ _, tag, id, class ]
			quick[1] = ( quick[1] || "" ).toLowerCase();
			quick[3] = quick[3] && new RegExp( "(?:^|\\s)" + quick[3] + "(?:\\s|$)" );
		}
		return quick;
	},
	quickIs = function( elem, m ) {
		var attrs = elem.attributes || {};
		return (
			(!m[1] || elem.nodeName.toLowerCase() === m[1]) &&
			(!m[2] || (attrs.id || {}).value === m[2]) &&
			(!m[3] || m[3].test( (attrs[ "class" ] || {}).value ))
		);
	},
	hoverHack = function( events ) {
		return jQuery.event.special.hover ? events : events.replace( rhoverHack, "mouseenter$1 mouseleave$1" );
	};

/*
 * Helper functions for managing events -- not part of the public interface.
 * Props to Dean Edwards' addEvent library for many of the ideas.
 */
jQuery.event = {

	add: function( elem, types, handler, data, selector ) {

		var elemData, eventHandle, events,
			t, tns, type, namespaces, handleObj,
			handleObjIn, quick, handlers, special;

		// Don't attach events to noData or text/comment nodes (allow plain objects tho)
		if ( elem.nodeType === 3 || elem.nodeType === 8 || !types || !handler || !(elemData = jQuery._data( elem )) ) {
			return;
		}

		// Caller can pass in an object of custom data in lieu of the handler
		if ( handler.handler ) {
			handleObjIn = handler;
			handler = handleObjIn.handler;
			selector = handleObjIn.selector;
		}

		// Make sure that the handler has a unique ID, used to find/remove it later
		if ( !handler.guid ) {
			handler.guid = jQuery.guid++;
		}

		// Init the element's event structure and main handler, if this is the first
		events = elemData.events;
		if ( !events ) {
			elemData.events = events = {};
		}
		eventHandle = elemData.handle;
		if ( !eventHandle ) {
			elemData.handle = eventHandle = function( e ) {
				// Discard the second event of a jQuery.event.trigger() and
				// when an event is called after a page has unloaded
				return typeof jQuery !== "undefined" && (!e || jQuery.event.triggered !== e.type) ?
					jQuery.event.dispatch.apply( eventHandle.elem, arguments ) :
					undefined;
			};
			// Add elem as a property of the handle fn to prevent a memory leak with IE non-native events
			eventHandle.elem = elem;
		}

		// Handle multiple events separated by a space
		// jQuery(...).bind("mouseover mouseout", fn);
		types = jQuery.trim( hoverHack(types) ).split( " " );
		for ( t = 0; t < types.length; t++ ) {

			tns = rtypenamespace.exec( types[t] ) || [];
			type = tns[1];
			namespaces = ( tns[2] || "" ).split( "." ).sort();

			// If event changes its type, use the special event handlers for the changed type
			special = jQuery.event.special[ type ] || {};

			// If selector defined, determine special event api type, otherwise given type
			type = ( selector ? special.delegateType : special.bindType ) || type;

			// Update special based on newly reset type
			special = jQuery.event.special[ type ] || {};

			// handleObj is passed to all event handlers
			handleObj = jQuery.extend({
				type: type,
				origType: tns[1],
				data: data,
				handler: handler,
				guid: handler.guid,
				selector: selector,
				quick: selector && quickParse( selector ),
				namespace: namespaces.join(".")
			}, handleObjIn );

			// Init the event handler queue if we're the first
			handlers = events[ type ];
			if ( !handlers ) {
				handlers = events[ type ] = [];
				handlers.delegateCount = 0;

				// Only use addEventListener/attachEvent if the special events handler returns false
				if ( !special.setup || special.setup.call( elem, data, namespaces, eventHandle ) === false ) {
					// Bind the global event handler to the element
					if ( elem.addEventListener ) {
						elem.addEventListener( type, eventHandle, false );

					} else if ( elem.attachEvent ) {
						elem.attachEvent( "on" + type, eventHandle );
					}
				}
			}

			if ( special.add ) {
				special.add.call( elem, handleObj );

				if ( !handleObj.handler.guid ) {
					handleObj.handler.guid = handler.guid;
				}
			}

			// Add to the element's handler list, delegates in front
			if ( selector ) {
				handlers.splice( handlers.delegateCount++, 0, handleObj );
			} else {
				handlers.push( handleObj );
			}

			// Keep track of which events have ever been used, for event optimization
			jQuery.event.global[ type ] = true;
		}

		// Nullify elem to prevent memory leaks in IE
		elem = null;
	},

	global: {},

	// Detach an event or set of events from an element
	remove: function( elem, types, handler, selector, mappedTypes ) {

		var elemData = jQuery.hasData( elem ) && jQuery._data( elem ),
			t, tns, type, origType, namespaces, origCount,
			j, events, special, handle, eventType, handleObj;

		if ( !elemData || !(events = elemData.events) ) {
			return;
		}

		// Once for each type.namespace in types; type may be omitted
		types = jQuery.trim( hoverHack( types || "" ) ).split(" ");
		for ( t = 0; t < types.length; t++ ) {
			tns = rtypenamespace.exec( types[t] ) || [];
			type = origType = tns[1];
			namespaces = tns[2];

			// Unbind all events (on this namespace, if provided) for the element
			if ( !type ) {
				for ( type in events ) {
					jQuery.event.remove( elem, type + types[ t ], handler, selector, true );
				}
				continue;
			}

			special = jQuery.event.special[ type ] || {};
			type = ( selector? special.delegateType : special.bindType ) || type;
			eventType = events[ type ] || [];
			origCount = eventType.length;
			namespaces = namespaces ? new RegExp("(^|\\.)" + namespaces.split(".").sort().join("\\.(?:.*\\.)?") + "(\\.|$)") : null;

			// Remove matching events
			for ( j = 0; j < eventType.length; j++ ) {
				handleObj = eventType[ j ];

				if ( ( mappedTypes || origType === handleObj.origType ) &&
					 ( !handler || handler.guid === handleObj.guid ) &&
					 ( !namespaces || namespaces.test( handleObj.namespace ) ) &&
					 ( !selector || selector === handleObj.selector || selector === "**" && handleObj.selector ) ) {
					eventType.splice( j--, 1 );

					if ( handleObj.selector ) {
						eventType.delegateCount--;
					}
					if ( special.remove ) {
						special.remove.call( elem, handleObj );
					}
				}
			}

			// Remove generic event handler if we removed something and no more handlers exist
			// (avoids potential for endless recursion during removal of special event handlers)
			if ( eventType.length === 0 && origCount !== eventType.length ) {
				if ( !special.teardown || special.teardown.call( elem, namespaces ) === false ) {
					jQuery.removeEvent( elem, type, elemData.handle );
				}

				delete events[ type ];
			}
		}

		// Remove the expando if it's no longer used
		if ( jQuery.isEmptyObject( events ) ) {
			handle = elemData.handle;
			if ( handle ) {
				handle.elem = null;
			}

			// removeData also checks for emptiness and clears the expando if empty
			// so use it instead of delete
			jQuery.removeData( elem, [ "events", "handle" ], true );
		}
	},

	// Events that are safe to short-circuit if no handlers are attached.
	// Native DOM events should not be added, they may have inline handlers.
	customEvent: {
		"getData": true,
		"setData": true,
		"changeData": true
	},

	trigger: function( event, data, elem, onlyHandlers ) {
		// Don't do events on text and comment nodes
		if ( elem && (elem.nodeType === 3 || elem.nodeType === 8) ) {
			return;
		}

		// Event object or event type
		var type = event.type || event,
			namespaces = [],
			cache, exclusive, i, cur, old, ontype, special, handle, eventPath, bubbleType;

		// focus/blur morphs to focusin/out; ensure we're not firing them right now
		if ( rfocusMorph.test( type + jQuery.event.triggered ) ) {
			return;
		}

		if ( type.indexOf( "!" ) >= 0 ) {
			// Exclusive events trigger only for the exact event (no namespaces)
			type = type.slice(0, -1);
			exclusive = true;
		}

		if ( type.indexOf( "." ) >= 0 ) {
			// Namespaced trigger; create a regexp to match event type in handle()
			namespaces = type.split(".");
			type = namespaces.shift();
			namespaces.sort();
		}

		if ( (!elem || jQuery.event.customEvent[ type ]) && !jQuery.event.global[ type ] ) {
			// No jQuery handlers for this event type, and it can't have inline handlers
			return;
		}

		// Caller can pass in an Event, Object, or just an event type string
		event = typeof event === "object" ?
			// jQuery.Event object
			event[ jQuery.expando ] ? event :
			// Object literal
			new jQuery.Event( type, event ) :
			// Just the event type (string)
			new jQuery.Event( type );

		event.type = type;
		event.isTrigger = true;
		event.exclusive = exclusive;
		event.namespace = namespaces.join( "." );
		event.namespace_re = event.namespace? new RegExp("(^|\\.)" + namespaces.join("\\.(?:.*\\.)?") + "(\\.|$)") : null;
		ontype = type.indexOf( ":" ) < 0 ? "on" + type : "";

		// Handle a global trigger
		if ( !elem ) {

			// TODO: Stop taunting the data cache; remove global events and always attach to document
			cache = jQuery.cache;
			for ( i in cache ) {
				if ( cache[ i ].events && cache[ i ].events[ type ] ) {
					jQuery.event.trigger( event, data, cache[ i ].handle.elem, true );
				}
			}
			return;
		}

		// Clean up the event in case it is being reused
		event.result = undefined;
		if ( !event.target ) {
			event.target = elem;
		}

		// Clone any incoming data and prepend the event, creating the handler arg list
		data = data != null ? jQuery.makeArray( data ) : [];
		data.unshift( event );

		// Allow special events to draw outside the lines
		special = jQuery.event.special[ type ] || {};
		if ( special.trigger && special.trigger.apply( elem, data ) === false ) {
			return;
		}

		// Determine event propagation path in advance, per W3C events spec (#9951)
		// Bubble up to document, then to window; watch for a global ownerDocument var (#9724)
		eventPath = [[ elem, special.bindType || type ]];
		if ( !onlyHandlers && !special.noBubble && !jQuery.isWindow( elem ) ) {

			bubbleType = special.delegateType || type;
			cur = rfocusMorph.test( bubbleType + type ) ? elem : elem.parentNode;
			old = null;
			for ( ; cur; cur = cur.parentNode ) {
				eventPath.push([ cur, bubbleType ]);
				old = cur;
			}

			// Only add window if we got to document (e.g., not plain obj or detached DOM)
			if ( old && old === elem.ownerDocument ) {
				eventPath.push([ old.defaultView || old.parentWindow || window, bubbleType ]);
			}
		}

		// Fire handlers on the event path
		for ( i = 0; i < eventPath.length && !event.isPropagationStopped(); i++ ) {

			cur = eventPath[i][0];
			event.type = eventPath[i][1];

			handle = ( jQuery._data( cur, "events" ) || {} )[ event.type ] && jQuery._data( cur, "handle" );
			if ( handle ) {
				handle.apply( cur, data );
			}
			// Note that this is a bare JS function and not a jQuery handler
			handle = ontype && cur[ ontype ];
			if ( handle && jQuery.acceptData( cur ) && handle.apply( cur, data ) === false ) {
				event.preventDefault();
			}
		}
		event.type = type;

		// If nobody prevented the default action, do it now
		if ( !onlyHandlers && !event.isDefaultPrevented() ) {

			if ( (!special._default || special._default.apply( elem.ownerDocument, data ) === false) &&
				!(type === "click" && jQuery.nodeName( elem, "a" )) && jQuery.acceptData( elem ) ) {

				// Call a native DOM method on the target with the same name name as the event.
				// Can't use an .isFunction() check here because IE6/7 fails that test.
				// Don't do default actions on window, that's where global variables be (#6170)
				// IE<9 dies on focus/blur to hidden element (#1486)
				if ( ontype && elem[ type ] && ((type !== "focus" && type !== "blur") || event.target.offsetWidth !== 0) && !jQuery.isWindow( elem ) ) {

					// Don't re-trigger an onFOO event when we call its FOO() method
					old = elem[ ontype ];

					if ( old ) {
						elem[ ontype ] = null;
					}

					// Prevent re-triggering of the same event, since we already bubbled it above
					jQuery.event.triggered = type;
					elem[ type ]();
					jQuery.event.triggered = undefined;

					if ( old ) {
						elem[ ontype ] = old;
					}
				}
			}
		}

		return event.result;
	},

	dispatch: function( event ) {

		// Make a writable jQuery.Event from the native event object
		event = jQuery.event.fix( event || window.event );

		var handlers = ( (jQuery._data( this, "events" ) || {} )[ event.type ] || []),
			delegateCount = handlers.delegateCount,
			args = [].slice.call( arguments, 0 ),
			run_all = !event.exclusive && !event.namespace,
			special = jQuery.event.special[ event.type ] || {},
			handlerQueue = [],
			i, j, cur, jqcur, ret, selMatch, matched, matches, handleObj, sel, related;

		// Use the fix-ed jQuery.Event rather than the (read-only) native event
		args[0] = event;
		event.delegateTarget = this;

		// Call the preDispatch hook for the mapped type, and let it bail if desired
		if ( special.preDispatch && special.preDispatch.call( this, event ) === false ) {
			return;
		}

		// Determine handlers that should run if there are delegated events
		// Avoid non-left-click bubbling in Firefox (#3861)
		if ( delegateCount && !(event.button && event.type === "click") ) {

			// Pregenerate a single jQuery object for reuse with .is()
			jqcur = jQuery(this);
			jqcur.context = this.ownerDocument || this;

			for ( cur = event.target; cur != this; cur = cur.parentNode || this ) {

				// Don't process events on disabled elements (#6911, #8165)
				if ( cur.disabled !== true ) {
					selMatch = {};
					matches = [];
					jqcur[0] = cur;
					for ( i = 0; i < delegateCount; i++ ) {
						handleObj = handlers[ i ];
						sel = handleObj.selector;

						if ( selMatch[ sel ] === undefined ) {
							selMatch[ sel ] = (
								handleObj.quick ? quickIs( cur, handleObj.quick ) : jqcur.is( sel )
							);
						}
						if ( selMatch[ sel ] ) {
							matches.push( handleObj );
						}
					}
					if ( matches.length ) {
						handlerQueue.push({ elem: cur, matches: matches });
					}
				}
			}
		}

		// Add the remaining (directly-bound) handlers
		if ( handlers.length > delegateCount ) {
			handlerQueue.push({ elem: this, matches: handlers.slice( delegateCount ) });
		}

		// Run delegates first; they may want to stop propagation beneath us
		for ( i = 0; i < handlerQueue.length && !event.isPropagationStopped(); i++ ) {
			matched = handlerQueue[ i ];
			event.currentTarget = matched.elem;

			for ( j = 0; j < matched.matches.length && !event.isImmediatePropagationStopped(); j++ ) {
				handleObj = matched.matches[ j ];

				// Triggered event must either 1) be non-exclusive and have no namespace, or
				// 2) have namespace(s) a subset or equal to those in the bound event (both can have no namespace).
				if ( run_all || (!event.namespace && !handleObj.namespace) || event.namespace_re && event.namespace_re.test( handleObj.namespace ) ) {

					event.data = handleObj.data;
					event.handleObj = handleObj;

					ret = ( (jQuery.event.special[ handleObj.origType ] || {}).handle || handleObj.handler )
							.apply( matched.elem, args );

					if ( ret !== undefined ) {
						event.result = ret;
						if ( ret === false ) {
							event.preventDefault();
							event.stopPropagation();
						}
					}
				}
			}
		}

		// Call the postDispatch hook for the mapped type
		if ( special.postDispatch ) {
			special.postDispatch.call( this, event );
		}

		return event.result;
	},

	// Includes some event props shared by KeyEvent and MouseEvent
	// *** attrChange attrName relatedNode srcElement  are not normalized, non-W3C, deprecated, will be removed in 1.8 ***
	props: "attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),

	fixHooks: {},

	keyHooks: {
		props: "char charCode key keyCode".split(" "),
		filter: function( event, original ) {

			// Add which for key events
			if ( event.which == null ) {
				event.which = original.charCode != null ? original.charCode : original.keyCode;
			}

			return event;
		}
	},

	mouseHooks: {
		props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),
		filter: function( event, original ) {
			var eventDoc, doc, body,
				button = original.button,
				fromElement = original.fromElement;

			// Calculate pageX/Y if missing and clientX/Y available
			if ( event.pageX == null && original.clientX != null ) {
				eventDoc = event.target.ownerDocument || document;
				doc = eventDoc.documentElement;
				body = eventDoc.body;

				event.pageX = original.clientX + ( doc && doc.scrollLeft || body && body.scrollLeft || 0 ) - ( doc && doc.clientLeft || body && body.clientLeft || 0 );
				event.pageY = original.clientY + ( doc && doc.scrollTop  || body && body.scrollTop  || 0 ) - ( doc && doc.clientTop  || body && body.clientTop  || 0 );
			}

			// Add relatedTarget, if necessary
			if ( !event.relatedTarget && fromElement ) {
				event.relatedTarget = fromElement === event.target ? original.toElement : fromElement;
			}

			// Add which for click: 1 === left; 2 === middle; 3 === right
			// Note: button is not normalized, so don't use it
			if ( !event.which && button !== undefined ) {
				event.which = ( button & 1 ? 1 : ( button & 2 ? 3 : ( button & 4 ? 2 : 0 ) ) );
			}

			return event;
		}
	},

	fix: function( event ) {
		if ( event[ jQuery.expando ] ) {
			return event;
		}

		// Create a writable copy of the event object and normalize some properties
		var i, prop,
			originalEvent = event,
			fixHook = jQuery.event.fixHooks[ event.type ] || {},
			copy = fixHook.props ? this.props.concat( fixHook.props ) : this.props;

		event = jQuery.Event( originalEvent );

		for ( i = copy.length; i; ) {
			prop = copy[ --i ];
			event[ prop ] = originalEvent[ prop ];
		}

		// Fix target property, if necessary (#1925, IE 6/7/8 & Safari2)
		if ( !event.target ) {
			event.target = originalEvent.srcElement || document;
		}

		// Target should not be a text node (#504, Safari)
		if ( event.target.nodeType === 3 ) {
			event.target = event.target.parentNode;
		}

		// For mouse/key events; add metaKey if it's not there (#3368, IE6/7/8)
		if ( event.metaKey === undefined ) {
			event.metaKey = event.ctrlKey;
		}

		return fixHook.filter? fixHook.filter( event, originalEvent ) : event;
	},

	special: {
		ready: {
			// Make sure the ready event is setup
			setup: jQuery.bindReady
		},

		load: {
			// Prevent triggered image.load events from bubbling to window.load
			noBubble: true
		},

		focus: {
			delegateType: "focusin"
		},
		blur: {
			delegateType: "focusout"
		},

		beforeunload: {
			setup: function( data, namespaces, eventHandle ) {
				// We only want to do this special case on windows
				if ( jQuery.isWindow( this ) ) {
					this.onbeforeunload = eventHandle;
				}
			},

			teardown: function( namespaces, eventHandle ) {
				if ( this.onbeforeunload === eventHandle ) {
					this.onbeforeunload = null;
				}
			}
		}
	},

	simulate: function( type, elem, event, bubble ) {
		// Piggyback on a donor event to simulate a different one.
		// Fake originalEvent to avoid donor's stopPropagation, but if the
		// simulated event prevents default then we do the same on the donor.
		var e = jQuery.extend(
			new jQuery.Event(),
			event,
			{ type: type,
				isSimulated: true,
				originalEvent: {}
			}
		);
		if ( bubble ) {
			jQuery.event.trigger( e, null, elem );
		} else {
			jQuery.event.dispatch.call( elem, e );
		}
		if ( e.isDefaultPrevented() ) {
			event.preventDefault();
		}
	}
};

// Some plugins are using, but it's undocumented/deprecated and will be removed.
// The 1.7 special event interface should provide all the hooks needed now.
jQuery.event.handle = jQuery.event.dispatch;

jQuery.removeEvent = document.removeEventListener ?
	function( elem, type, handle ) {
		if ( elem.removeEventListener ) {
			elem.removeEventListener( type, handle, false );
		}
	} :
	function( elem, type, handle ) {
		if ( elem.detachEvent ) {
			elem.detachEvent( "on" + type, handle );
		}
	};

jQuery.Event = function( src, props ) {
	// Allow instantiation without the 'new' keyword
	if ( !(this instanceof jQuery.Event) ) {
		return new jQuery.Event( src, props );
	}

	// Event object
	if ( src && src.type ) {
		this.originalEvent = src;
		this.type = src.type;

		// Events bubbling up the document may have been marked as prevented
		// by a handler lower down the tree; reflect the correct value.
		this.isDefaultPrevented = ( src.defaultPrevented || src.returnValue === false ||
			src.getPreventDefault && src.getPreventDefault() ) ? returnTrue : returnFalse;

	// Event type
	} else {
		this.type = src;
	}

	// Put explicitly provided properties onto the event object
	if ( props ) {
		jQuery.extend( this, props );
	}

	// Create a timestamp if incoming event doesn't have one
	this.timeStamp = src && src.timeStamp || jQuery.now();

	// Mark it as fixed
	this[ jQuery.expando ] = true;
};

function returnFalse() {
	return false;
}
function returnTrue() {
	return true;
}

// jQuery.Event is based on DOM3 Events as specified by the ECMAScript Language Binding
// http://www.w3.org/TR/2003/WD-DOM-Level-3-Events-20030331/ecma-script-binding.html
jQuery.Event.prototype = {
	preventDefault: function() {
		this.isDefaultPrevented = returnTrue;

		var e = this.originalEvent;
		if ( !e ) {
			return;
		}

		// if preventDefault exists run it on the original event
		if ( e.preventDefault ) {
			e.preventDefault();

		// otherwise set the returnValue property of the original event to false (IE)
		} else {
			e.returnValue = false;
		}
	},
	stopPropagation: function() {
		this.isPropagationStopped = returnTrue;

		var e = this.originalEvent;
		if ( !e ) {
			return;
		}
		// if stopPropagation exists run it on the original event
		if ( e.stopPropagation ) {
			e.stopPropagation();
		}
		// otherwise set the cancelBubble property of the original event to true (IE)
		e.cancelBubble = true;
	},
	stopImmediatePropagation: function() {
		this.isImmediatePropagationStopped = returnTrue;
		this.stopPropagation();
	},
	isDefaultPrevented: returnFalse,
	isPropagationStopped: returnFalse,
	isImmediatePropagationStopped: returnFalse
};

// Create mouseenter/leave events using mouseover/out and event-time checks
jQuery.each({
	mouseenter: "mouseover",
	mouseleave: "mouseout"
}, function( orig, fix ) {
	jQuery.event.special[ orig ] = {
		delegateType: fix,
		bindType: fix,

		handle: function( event ) {
			var target = this,
				related = event.relatedTarget,
				handleObj = event.handleObj,
				selector = handleObj.selector,
				ret;

			// For mousenter/leave call the handler if related is outside the target.
			// NB: No relatedTarget if the mouse left/entered the browser window
			if ( !related || (related !== target && !jQuery.contains( target, related )) ) {
				event.type = handleObj.origType;
				ret = handleObj.handler.apply( this, arguments );
				event.type = fix;
			}
			return ret;
		}
	};
});

// IE submit delegation
if ( !jQuery.support.submitBubbles ) {

	jQuery.event.special.submit = {
		setup: function() {
			// Only need this for delegated form submit events
			if ( jQuery.nodeName( this, "form" ) ) {
				return false;
			}

			// Lazy-add a submit handler when a descendant form may potentially be submitted
			jQuery.event.add( this, "click._submit keypress._submit", function( e ) {
				// Node name check avoids a VML-related crash in IE (#9807)
				var elem = e.target,
					form = jQuery.nodeName( elem, "input" ) || jQuery.nodeName( elem, "button" ) ? elem.form : undefined;
				if ( form && !form._submit_attached ) {
					jQuery.event.add( form, "submit._submit", function( event ) {
						event._submit_bubble = true;
					});
					form._submit_attached = true;
				}
			});
			// return undefined since we don't need an event listener
		},
		
		postDispatch: function( event ) {
			// If form was submitted by the user, bubble the event up the tree
			if ( event._submit_bubble ) {
				delete event._submit_bubble;
				if ( this.parentNode && !event.isTrigger ) {
					jQuery.event.simulate( "submit", this.parentNode, event, true );
				}
			}
		},

		teardown: function() {
			// Only need this for delegated form submit events
			if ( jQuery.nodeName( this, "form" ) ) {
				return false;
			}

			// Remove delegated handlers; cleanData eventually reaps submit handlers attached above
			jQuery.event.remove( this, "._submit" );
		}
	};
}

// IE change delegation and checkbox/radio fix
if ( !jQuery.support.changeBubbles ) {

	jQuery.event.special.change = {

		setup: function() {

			if ( rformElems.test( this.nodeName ) ) {
				// IE doesn't fire change on a check/radio until blur; trigger it on click
				// after a propertychange. Eat the blur-change in special.change.handle.
				// This still fires onchange a second time for check/radio after blur.
				if ( this.type === "checkbox" || this.type === "radio" ) {
					jQuery.event.add( this, "propertychange._change", function( event ) {
						if ( event.originalEvent.propertyName === "checked" ) {
							this._just_changed = true;
						}
					});
					jQuery.event.add( this, "click._change", function( event ) {
						if ( this._just_changed && !event.isTrigger ) {
							this._just_changed = false;
							jQuery.event.simulate( "change", this, event, true );
						}
					});
				}
				return false;
			}
			// Delegated event; lazy-add a change handler on descendant inputs
			jQuery.event.add( this, "beforeactivate._change", function( e ) {
				var elem = e.target;

				if ( rformElems.test( elem.nodeName ) && !elem._change_attached ) {
					jQuery.event.add( elem, "change._change", function( event ) {
						if ( this.parentNode && !event.isSimulated && !event.isTrigger ) {
							jQuery.event.simulate( "change", this.parentNode, event, true );
						}
					});
					elem._change_attached = true;
				}
			});
		},

		handle: function( event ) {
			var elem = event.target;

			// Swallow native change events from checkbox/radio, we already triggered them above
			if ( this !== elem || event.isSimulated || event.isTrigger || (elem.type !== "radio" && elem.type !== "checkbox") ) {
				return event.handleObj.handler.apply( this, arguments );
			}
		},

		teardown: function() {
			jQuery.event.remove( this, "._change" );

			return rformElems.test( this.nodeName );
		}
	};
}

// Create "bubbling" focus and blur events
if ( !jQuery.support.focusinBubbles ) {
	jQuery.each({ focus: "focusin", blur: "focusout" }, function( orig, fix ) {

		// Attach a single capturing handler while someone wants focusin/focusout
		var attaches = 0,
			handler = function( event ) {
				jQuery.event.simulate( fix, event.target, jQuery.event.fix( event ), true );
			};

		jQuery.event.special[ fix ] = {
			setup: function() {
				if ( attaches++ === 0 ) {
					document.addEventListener( orig, handler, true );
				}
			},
			teardown: function() {
				if ( --attaches === 0 ) {
					document.removeEventListener( orig, handler, true );
				}
			}
		};
	});
}

jQuery.fn.extend({

	on: function( types, selector, data, fn, /*INTERNAL*/ one ) {
		var origFn, type;

		// Types can be a map of types/handlers
		if ( typeof types === "object" ) {
			// ( types-Object, selector, data )
			if ( typeof selector !== "string" ) { // && selector != null
				// ( types-Object, data )
				data = data || selector;
				selector = undefined;
			}
			for ( type in types ) {
				this.on( type, selector, data, types[ type ], one );
			}
			return this;
		}

		if ( data == null && fn == null ) {
			// ( types, fn )
			fn = selector;
			data = selector = undefined;
		} else if ( fn == null ) {
			if ( typeof selector === "string" ) {
				// ( types, selector, fn )
				fn = data;
				data = undefined;
			} else {
				// ( types, data, fn )
				fn = data;
				data = selector;
				selector = undefined;
			}
		}
		if ( fn === false ) {
			fn = returnFalse;
		} else if ( !fn ) {
			return this;
		}

		if ( one === 1 ) {
			origFn = fn;
			fn = function( event ) {
				// Can use an empty set, since event contains the info
				jQuery().off( event );
				return origFn.apply( this, arguments );
			};
			// Use same guid so caller can remove using origFn
			fn.guid = origFn.guid || ( origFn.guid = jQuery.guid++ );
		}
		return this.each( function() {
			jQuery.event.add( this, types, fn, data, selector );
		});
	},
	one: function( types, selector, data, fn ) {
		return this.on( types, selector, data, fn, 1 );
	},
	off: function( types, selector, fn ) {
		if ( types && types.preventDefault && types.handleObj ) {
			// ( event )  dispatched jQuery.Event
			var handleObj = types.handleObj;
			jQuery( types.delegateTarget ).off(
				handleObj.namespace ? handleObj.origType + "." + handleObj.namespace : handleObj.origType,
				handleObj.selector,
				handleObj.handler
			);
			return this;
		}
		if ( typeof types === "object" ) {
			// ( types-object [, selector] )
			for ( var type in types ) {
				this.off( type, selector, types[ type ] );
			}
			return this;
		}
		if ( selector === false || typeof selector === "function" ) {
			// ( types [, fn] )
			fn = selector;
			selector = undefined;
		}
		if ( fn === false ) {
			fn = returnFalse;
		}
		return this.each(function() {
			jQuery.event.remove( this, types, fn, selector );
		});
	},

	bind: function( types, data, fn ) {
		return this.on( types, null, data, fn );
	},
	unbind: function( types, fn ) {
		return this.off( types, null, fn );
	},

	live: function( types, data, fn ) {
		jQuery( this.context ).on( types, this.selector, data, fn );
		return this;
	},
	die: function( types, fn ) {
		jQuery( this.context ).off( types, this.selector || "**", fn );
		return this;
	},

	delegate: function( selector, types, data, fn ) {
		return this.on( types, selector, data, fn );
	},
	undelegate: function( selector, types, fn ) {
		// ( namespace ) or ( selector, types [, fn] )
		return arguments.length == 1? this.off( selector, "**" ) : this.off( types, selector, fn );
	},

	trigger: function( type, data ) {
		return this.each(function() {
			jQuery.event.trigger( type, data, this );
		});
	},
	triggerHandler: function( type, data ) {
		if ( this[0] ) {
			return jQuery.event.trigger( type, data, this[0], true );
		}
	},

	toggle: function( fn ) {
		// Save reference to arguments for access in closure
		var args = arguments,
			guid = fn.guid || jQuery.guid++,
			i = 0,
			toggler = function( event ) {
				// Figure out which function to execute
				var lastToggle = ( jQuery._data( this, "lastToggle" + fn.guid ) || 0 ) % i;
				jQuery._data( this, "lastToggle" + fn.guid, lastToggle + 1 );

				// Make sure that clicks stop
				event.preventDefault();

				// and execute the function
				return args[ lastToggle ].apply( this, arguments ) || false;
			};

		// link all the functions, so any of them can unbind this click handler
		toggler.guid = guid;
		while ( i < args.length ) {
			args[ i++ ].guid = guid;
		}

		return this.click( toggler );
	},

	hover: function( fnOver, fnOut ) {
		return this.mouseenter( fnOver ).mouseleave( fnOut || fnOver );
	}
});

jQuery.each( ("blur focus focusin focusout load resize scroll unload click dblclick " +
	"mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave " +
	"change select submit keydown keypress keyup error contextmenu").split(" "), function( i, name ) {

	// Handle event binding
	jQuery.fn[ name ] = function( data, fn ) {
		if ( fn == null ) {
			fn = data;
			data = null;
		}

		return arguments.length > 0 ?
			this.on( name, null, data, fn ) :
			this.trigger( name );
	};

	if ( jQuery.attrFn ) {
		jQuery.attrFn[ name ] = true;
	}

	if ( rkeyEvent.test( name ) ) {
		jQuery.event.fixHooks[ name ] = jQuery.event.keyHooks;
	}

	if ( rmouseEvent.test( name ) ) {
		jQuery.event.fixHooks[ name ] = jQuery.event.mouseHooks;
	}
});



/*!
 * Sizzle CSS Selector Engine
 *  Copyright 2011, The Dojo Foundation
 *  Released under the MIT, BSD, and GPL Licenses.
 *  More information: http://sizzlejs.com/
 */
(function(){

var chunker = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g,
	expando = "sizcache" + (Math.random() + '').replace('.', ''),
	done = 0,
	toString = Object.prototype.toString,
	hasDuplicate = false,
	baseHasDuplicate = true,
	rBackslash = /\\/g,
	rReturn = /\r\n/g,
	rNonWord = /\W/;

// Here we check if the JavaScript engine is using some sort of
// optimization where it does not always call our comparision
// function. If that is the case, discard the hasDuplicate value.
//   Thus far that includes Google Chrome.
[0, 0].sort(function() {
	baseHasDuplicate = false;
	return 0;
});

var Sizzle = function( selector, context, results, seed ) {
	results = results || [];
	context = context || document;

	var origContext = context;

	if ( context.nodeType !== 1 && context.nodeType !== 9 ) {
		return [];
	}

	if ( !selector || typeof selector !== "string" ) {
		return results;
	}

	var m, set, checkSet, extra, ret, cur, pop, i,
		prune = true,
		contextXML = Sizzle.isXML( context ),
		parts = [],
		soFar = selector;

	// Reset the position of the chunker regexp (start from head)
	do {
		chunker.exec( "" );
		m = chunker.exec( soFar );

		if ( m ) {
			soFar = m[3];

			parts.push( m[1] );

			if ( m[2] ) {
				extra = m[3];
				break;
			}
		}
	} while ( m );

	if ( parts.length > 1 && origPOS.exec( selector ) ) {

		if ( parts.length === 2 && Expr.relative[ parts[0] ] ) {
			set = posProcess( parts[0] + parts[1], context, seed );

		} else {
			set = Expr.relative[ parts[0] ] ?
				[ context ] :
				Sizzle( parts.shift(), context );

			while ( parts.length ) {
				selector = parts.shift();

				if ( Expr.relative[ selector ] ) {
					selector += parts.shift();
				}

				set = posProcess( selector, set, seed );
			}
		}

	} else {
		// Take a shortcut and set the context if the root selector is an ID
		// (but not if it'll be faster if the inner selector is an ID)
		if ( !seed && parts.length > 1 && context.nodeType === 9 && !contextXML &&
				Expr.match.ID.test(parts[0]) && !Expr.match.ID.test(parts[parts.length - 1]) ) {

			ret = Sizzle.find( parts.shift(), context, contextXML );
			context = ret.expr ?
				Sizzle.filter( ret.expr, ret.set )[0] :
				ret.set[0];
		}

		if ( context ) {
			ret = seed ?
				{ expr: parts.pop(), set: makeArray(seed) } :
				Sizzle.find( parts.pop(), parts.length === 1 && (parts[0] === "~" || parts[0] === "+") && context.parentNode ? context.parentNode : context, contextXML );

			set = ret.expr ?
				Sizzle.filter( ret.expr, ret.set ) :
				ret.set;

			if ( parts.length > 0 ) {
				checkSet = makeArray( set );

			} else {
				prune = false;
			}

			while ( parts.length ) {
				cur = parts.pop();
				pop = cur;

				if ( !Expr.relative[ cur ] ) {
					cur = "";
				} else {
					pop = parts.pop();
				}

				if ( pop == null ) {
					pop = context;
				}

				Expr.relative[ cur ]( checkSet, pop, contextXML );
			}

		} else {
			checkSet = parts = [];
		}
	}

	if ( !checkSet ) {
		checkSet = set;
	}

	if ( !checkSet ) {
		Sizzle.error( cur || selector );
	}

	if ( toString.call(checkSet) === "[object Array]" ) {
		if ( !prune ) {
			results.push.apply( results, checkSet );

		} else if ( context && context.nodeType === 1 ) {
			for ( i = 0; checkSet[i] != null; i++ ) {
				if ( checkSet[i] && (checkSet[i] === true || checkSet[i].nodeType === 1 && Sizzle.contains(context, checkSet[i])) ) {
					results.push( set[i] );
				}
			}

		} else {
			for ( i = 0; checkSet[i] != null; i++ ) {
				if ( checkSet[i] && checkSet[i].nodeType === 1 ) {
					results.push( set[i] );
				}
			}
		}

	} else {
		makeArray( checkSet, results );
	}

	if ( extra ) {
		Sizzle( extra, origContext, results, seed );
		Sizzle.uniqueSort( results );
	}

	return results;
};

Sizzle.uniqueSort = function( results ) {
	if ( sortOrder ) {
		hasDuplicate = baseHasDuplicate;
		results.sort( sortOrder );

		if ( hasDuplicate ) {
			for ( var i = 1; i < results.length; i++ ) {
				if ( results[i] === results[ i - 1 ] ) {
					results.splice( i--, 1 );
				}
			}
		}
	}

	return results;
};

Sizzle.matches = function( expr, set ) {
	return Sizzle( expr, null, null, set );
};

Sizzle.matchesSelector = function( node, expr ) {
	return Sizzle( expr, null, null, [node] ).length > 0;
};

Sizzle.find = function( expr, context, isXML ) {
	var set, i, len, match, type, left;

	if ( !expr ) {
		return [];
	}

	for ( i = 0, len = Expr.order.length; i < len; i++ ) {
		type = Expr.order[i];

		if ( (match = Expr.leftMatch[ type ].exec( expr )) ) {
			left = match[1];
			match.splice( 1, 1 );

			if ( left.substr( left.length - 1 ) !== "\\" ) {
				match[1] = (match[1] || "").replace( rBackslash, "" );
				set = Expr.find[ type ]( match, context, isXML );

				if ( set != null ) {
					expr = expr.replace( Expr.match[ type ], "" );
					break;
				}
			}
		}
	}

	if ( !set ) {
		set = typeof context.getElementsByTagName !== "undefined" ?
			context.getElementsByTagName( "*" ) :
			[];
	}

	return { set: set, expr: expr };
};

Sizzle.filter = function( expr, set, inplace, not ) {
	var match, anyFound,
		type, found, item, filter, left,
		i, pass,
		old = expr,
		result = [],
		curLoop = set,
		isXMLFilter = set && set[0] && Sizzle.isXML( set[0] );

	while ( expr && set.length ) {
		for ( type in Expr.filter ) {
			if ( (match = Expr.leftMatch[ type ].exec( expr )) != null && match[2] ) {
				filter = Expr.filter[ type ];
				left = match[1];

				anyFound = false;

				match.splice(1,1);

				if ( left.substr( left.length - 1 ) === "\\" ) {
					continue;
				}

				if ( curLoop === result ) {
					result = [];
				}

				if ( Expr.preFilter[ type ] ) {
					match = Expr.preFilter[ type ]( match, curLoop, inplace, result, not, isXMLFilter );

					if ( !match ) {
						anyFound = found = true;

					} else if ( match === true ) {
						continue;
					}
				}

				if ( match ) {
					for ( i = 0; (item = curLoop[i]) != null; i++ ) {
						if ( item ) {
							found = filter( item, match, i, curLoop );
							pass = not ^ found;

							if ( inplace && found != null ) {
								if ( pass ) {
									anyFound = true;

								} else {
									curLoop[i] = false;
								}

							} else if ( pass ) {
								result.push( item );
								anyFound = true;
							}
						}
					}
				}

				if ( found !== undefined ) {
					if ( !inplace ) {
						curLoop = result;
					}

					expr = expr.replace( Expr.match[ type ], "" );

					if ( !anyFound ) {
						return [];
					}

					break;
				}
			}
		}

		// Improper expression
		if ( expr === old ) {
			if ( anyFound == null ) {
				Sizzle.error( expr );

			} else {
				break;
			}
		}

		old = expr;
	}

	return curLoop;
};

Sizzle.error = function( msg ) {
	throw new Error( "Syntax error, unrecognized expression: " + msg );
};

/**
 * Utility function for retreiving the text value of an array of DOM nodes
 * @param {Array|Element} elem
 */
var getText = Sizzle.getText = function( elem ) {
    var i, node,
		nodeType = elem.nodeType,
		ret = "";

	if ( nodeType ) {
		if ( nodeType === 1 || nodeType === 9 || nodeType === 11 ) {
			// Use textContent || innerText for elements
			if ( typeof elem.textContent === 'string' ) {
				return elem.textContent;
			} else if ( typeof elem.innerText === 'string' ) {
				// Replace IE's carriage returns
				return elem.innerText.replace( rReturn, '' );
			} else {
				// Traverse it's children
				for ( elem = elem.firstChild; elem; elem = elem.nextSibling) {
					ret += getText( elem );
				}
			}
		} else if ( nodeType === 3 || nodeType === 4 ) {
			return elem.nodeValue;
		}
	} else {

		// If no nodeType, this is expected to be an array
		for ( i = 0; (node = elem[i]); i++ ) {
			// Do not traverse comment nodes
			if ( node.nodeType !== 8 ) {
				ret += getText( node );
			}
		}
	}
	return ret;
};

var Expr = Sizzle.selectors = {
	order: [ "ID", "NAME", "TAG" ],

	match: {
		ID: /#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,
		CLASS: /\.((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,
		NAME: /\[name=['"]*((?:[\w\u00c0-\uFFFF\-]|\\.)+)['"]*\]/,
		ATTR: /\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(?:(['"])(.*?)\3|(#?(?:[\w\u00c0-\uFFFF\-]|\\.)*)|)|)\s*\]/,
		TAG: /^((?:[\w\u00c0-\uFFFF\*\-]|\\.)+)/,
		CHILD: /:(only|nth|last|first)-child(?:\(\s*(even|odd|(?:[+\-]?\d+|(?:[+\-]?\d*)?n\s*(?:[+\-]\s*\d+)?))\s*\))?/,
		POS: /:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^\-]|$)/,
		PSEUDO: /:((?:[\w\u00c0-\uFFFF\-]|\\.)+)(?:\((['"]?)((?:\([^\)]+\)|[^\(\)]*)+)\2\))?/
	},

	leftMatch: {},

	attrMap: {
		"class": "className",
		"for": "htmlFor"
	},

	attrHandle: {
		href: function( elem ) {
			return elem.getAttribute( "href" );
		},
		type: function( elem ) {
			return elem.getAttribute( "type" );
		}
	},

	relative: {
		"+": function(checkSet, part){
			var isPartStr = typeof part === "string",
				isTag = isPartStr && !rNonWord.test( part ),
				isPartStrNotTag = isPartStr && !isTag;

			if ( isTag ) {
				part = part.toLowerCase();
			}

			for ( var i = 0, l = checkSet.length, elem; i < l; i++ ) {
				if ( (elem = checkSet[i]) ) {
					while ( (elem = elem.previousSibling) && elem.nodeType !== 1 ) {}

					checkSet[i] = isPartStrNotTag || elem && elem.nodeName.toLowerCase() === part ?
						elem || false :
						elem === part;
				}
			}

			if ( isPartStrNotTag ) {
				Sizzle.filter( part, checkSet, true );
			}
		},

		">": function( checkSet, part ) {
			var elem,
				isPartStr = typeof part === "string",
				i = 0,
				l = checkSet.length;

			if ( isPartStr && !rNonWord.test( part ) ) {
				part = part.toLowerCase();

				for ( ; i < l; i++ ) {
					elem = checkSet[i];

					if ( elem ) {
						var parent = elem.parentNode;
						checkSet[i] = parent.nodeName.toLowerCase() === part ? parent : false;
					}
				}

			} else {
				for ( ; i < l; i++ ) {
					elem = checkSet[i];

					if ( elem ) {
						checkSet[i] = isPartStr ?
							elem.parentNode :
							elem.parentNode === part;
					}
				}

				if ( isPartStr ) {
					Sizzle.filter( part, checkSet, true );
				}
			}
		},

		"": function(checkSet, part, isXML){
			var nodeCheck,
				doneName = done++,
				checkFn = dirCheck;

			if ( typeof part === "string" && !rNonWord.test( part ) ) {
				part = part.toLowerCase();
				nodeCheck = part;
				checkFn = dirNodeCheck;
			}

			checkFn( "parentNode", part, doneName, checkSet, nodeCheck, isXML );
		},

		"~": function( checkSet, part, isXML ) {
			var nodeCheck,
				doneName = done++,
				checkFn = dirCheck;

			if ( typeof part === "string" && !rNonWord.test( part ) ) {
				part = part.toLowerCase();
				nodeCheck = part;
				checkFn = dirNodeCheck;
			}

			checkFn( "previousSibling", part, doneName, checkSet, nodeCheck, isXML );
		}
	},

	find: {
		ID: function( match, context, isXML ) {
			if ( typeof context.getElementById !== "undefined" && !isXML ) {
				var m = context.getElementById(match[1]);
				// Check parentNode to catch when Blackberry 4.6 returns
				// nodes that are no longer in the document #6963
				return m && m.parentNode ? [m] : [];
			}
		},

		NAME: function( match, context ) {
			if ( typeof context.getElementsByName !== "undefined" ) {
				var ret = [],
					results = context.getElementsByName( match[1] );

				for ( var i = 0, l = results.length; i < l; i++ ) {
					if ( results[i].getAttribute("name") === match[1] ) {
						ret.push( results[i] );
					}
				}

				return ret.length === 0 ? null : ret;
			}
		},

		TAG: function( match, context ) {
			if ( typeof context.getElementsByTagName !== "undefined" ) {
				return context.getElementsByTagName( match[1] );
			}
		}
	},
	preFilter: {
		CLASS: function( match, curLoop, inplace, result, not, isXML ) {
			match = " " + match[1].replace( rBackslash, "" ) + " ";

			if ( isXML ) {
				return match;
			}

			for ( var i = 0, elem; (elem = curLoop[i]) != null; i++ ) {
				if ( elem ) {
					if ( not ^ (elem.className && (" " + elem.className + " ").replace(/[\t\n\r]/g, " ").indexOf(match) >= 0) ) {
						if ( !inplace ) {
							result.push( elem );
						}

					} else if ( inplace ) {
						curLoop[i] = false;
					}
				}
			}

			return false;
		},

		ID: function( match ) {
			return match[1].replace( rBackslash, "" );
		},

		TAG: function( match, curLoop ) {
			return match[1].replace( rBackslash, "" ).toLowerCase();
		},

		CHILD: function( match ) {
			if ( match[1] === "nth" ) {
				if ( !match[2] ) {
					Sizzle.error( match[0] );
				}

				match[2] = match[2].replace(/^\+|\s*/g, '');

				// parse equations like 'even', 'odd', '5', '2n', '3n+2', '4n-1', '-n+6'
				var test = /(-?)(\d*)(?:n([+\-]?\d*))?/.exec(
					match[2] === "even" && "2n" || match[2] === "odd" && "2n+1" ||
					!/\D/.test( match[2] ) && "0n+" + match[2] || match[2]);

				// calculate the numbers (first)n+(last) including if they are negative
				match[2] = (test[1] + (test[2] || 1)) - 0;
				match[3] = test[3] - 0;
			}
			else if ( match[2] ) {
				Sizzle.error( match[0] );
			}

			// TODO: Move to normal caching system
			match[0] = done++;

			return match;
		},

		ATTR: function( match, curLoop, inplace, result, not, isXML ) {
			var name = match[1] = match[1].replace( rBackslash, "" );

			if ( !isXML && Expr.attrMap[name] ) {
				match[1] = Expr.attrMap[name];
			}

			// Handle if an un-quoted value was used
			match[4] = ( match[4] || match[5] || "" ).replace( rBackslash, "" );

			if ( match[2] === "~=" ) {
				match[4] = " " + match[4] + " ";
			}

			return match;
		},

		PSEUDO: function( match, curLoop, inplace, result, not ) {
			if ( match[1] === "not" ) {
				// If we're dealing with a complex expression, or a simple one
				if ( ( chunker.exec(match[3]) || "" ).length > 1 || /^\w/.test(match[3]) ) {
					match[3] = Sizzle(match[3], null, null, curLoop);

				} else {
					var ret = Sizzle.filter(match[3], curLoop, inplace, true ^ not);

					if ( !inplace ) {
						result.push.apply( result, ret );
					}

					return false;
				}

			} else if ( Expr.match.POS.test( match[0] ) || Expr.match.CHILD.test( match[0] ) ) {
				return true;
			}

			return match;
		},

		POS: function( match ) {
			match.unshift( true );

			return match;
		}
	},

	filters: {
		enabled: function( elem ) {
			return elem.disabled === false && elem.type !== "hidden";
		},

		disabled: function( elem ) {
			return elem.disabled === true;
		},

		checked: function( elem ) {
			return elem.checked === true;
		},

		selected: function( elem ) {
			// Accessing this property makes selected-by-default
			// options in Safari work properly
			if ( elem.parentNode ) {
				elem.parentNode.selectedIndex;
			}

			return elem.selected === true;
		},

		parent: function( elem ) {
			return !!elem.firstChild;
		},

		empty: function( elem ) {
			return !elem.firstChild;
		},

		has: function( elem, i, match ) {
			return !!Sizzle( match[3], elem ).length;
		},

		header: function( elem ) {
			return (/h\d/i).test( elem.nodeName );
		},

		text: function( elem ) {
			var attr = elem.getAttribute( "type" ), type = elem.type;
			// IE6 and 7 will map elem.type to 'text' for new HTML5 types (search, etc)
			// use getAttribute instead to test this case
			return elem.nodeName.toLowerCase() === "input" && "text" === type && ( attr === type || attr === null );
		},

		radio: function( elem ) {
			return elem.nodeName.toLowerCase() === "input" && "radio" === elem.type;
		},

		checkbox: function( elem ) {
			return elem.nodeName.toLowerCase() === "input" && "checkbox" === elem.type;
		},

		file: function( elem ) {
			return elem.nodeName.toLowerCase() === "input" && "file" === elem.type;
		},

		password: function( elem ) {
			return elem.nodeName.toLowerCase() === "input" && "password" === elem.type;
		},

		submit: function( elem ) {
			var name = elem.nodeName.toLowerCase();
			return (name === "input" || name === "button") && "submit" === elem.type;
		},

		image: function( elem ) {
			return elem.nodeName.toLowerCase() === "input" && "image" === elem.type;
		},

		reset: function( elem ) {
			var name = elem.nodeName.toLowerCase();
			return (name === "input" || name === "button") && "reset" === elem.type;
		},

		button: function( elem ) {
			var name = elem.nodeName.toLowerCase();
			return name === "input" && "button" === elem.type || name === "button";
		},

		input: function( elem ) {
			return (/input|select|textarea|button/i).test( elem.nodeName );
		},

		focus: function( elem ) {
			return elem === elem.ownerDocument.activeElement;
		}
	},
	setFilters: {
		first: function( elem, i ) {
			return i === 0;
		},

		last: function( elem, i, match, array ) {
			return i === array.length - 1;
		},

		even: function( elem, i ) {
			return i % 2 === 0;
		},

		odd: function( elem, i ) {
			return i % 2 === 1;
		},

		lt: function( elem, i, match ) {
			return i < match[3] - 0;
		},

		gt: function( elem, i, match ) {
			return i > match[3] - 0;
		},

		nth: function( elem, i, match ) {
			return match[3] - 0 === i;
		},

		eq: function( elem, i, match ) {
			return match[3] - 0 === i;
		}
	},
	filter: {
		PSEUDO: function( elem, match, i, array ) {
			var name = match[1],
				filter = Expr.filters[ name ];

			if ( filter ) {
				return filter( elem, i, match, array );

			} else if ( name === "contains" ) {
				return (elem.textContent || elem.innerText || getText([ elem ]) || "").indexOf(match[3]) >= 0;

			} else if ( name === "not" ) {
				var not = match[3];

				for ( var j = 0, l = not.length; j < l; j++ ) {
					if ( not[j] === elem ) {
						return false;
					}
				}

				return true;

			} else {
				Sizzle.error( name );
			}
		},

		CHILD: function( elem, match ) {
			var first, last,
				doneName, parent, cache,
				count, diff,
				type = match[1],
				node = elem;

			switch ( type ) {
				case "only":
				case "first":
					while ( (node = node.previousSibling) ) {
						if ( node.nodeType === 1 ) {
							return false;
						}
					}

					if ( type === "first" ) {
						return true;
					}

					node = elem;

					/* falls through */
				case "last":
					while ( (node = node.nextSibling) ) {
						if ( node.nodeType === 1 ) {
							return false;
						}
					}

					return true;

				case "nth":
					first = match[2];
					last = match[3];

					if ( first === 1 && last === 0 ) {
						return true;
					}

					doneName = match[0];
					parent = elem.parentNode;

					if ( parent && (parent[ expando ] !== doneName || !elem.nodeIndex) ) {
						count = 0;

						for ( node = parent.firstChild; node; node = node.nextSibling ) {
							if ( node.nodeType === 1 ) {
								node.nodeIndex = ++count;
							}
						}

						parent[ expando ] = doneName;
					}

					diff = elem.nodeIndex - last;

					if ( first === 0 ) {
						return diff === 0;

					} else {
						return ( diff % first === 0 && diff / first >= 0 );
					}
			}
		},

		ID: function( elem, match ) {
			return elem.nodeType === 1 && elem.getAttribute("id") === match;
		},

		TAG: function( elem, match ) {
			return (match === "*" && elem.nodeType === 1) || !!elem.nodeName && elem.nodeName.toLowerCase() === match;
		},

		CLASS: function( elem, match ) {
			return (" " + (elem.className || elem.getAttribute("class")) + " ")
				.indexOf( match ) > -1;
		},

		ATTR: function( elem, match ) {
			var name = match[1],
				result = Sizzle.attr ?
					Sizzle.attr( elem, name ) :
					Expr.attrHandle[ name ] ?
					Expr.attrHandle[ name ]( elem ) :
					elem[ name ] != null ?
						elem[ name ] :
						elem.getAttribute( name ),
				value = result + "",
				type = match[2],
				check = match[4];

			return result == null ?
				type === "!=" :
				!type && Sizzle.attr ?
				result != null :
				type === "=" ?
				value === check :
				type === "*=" ?
				value.indexOf(check) >= 0 :
				type === "~=" ?
				(" " + value + " ").indexOf(check) >= 0 :
				!check ?
				value && result !== false :
				type === "!=" ?
				value !== check :
				type === "^=" ?
				value.indexOf(check) === 0 :
				type === "$=" ?
				value.substr(value.length - check.length) === check :
				type === "|=" ?
				value === check || value.substr(0, check.length + 1) === check + "-" :
				false;
		},

		POS: function( elem, match, i, array ) {
			var name = match[2],
				filter = Expr.setFilters[ name ];

			if ( filter ) {
				return filter( elem, i, match, array );
			}
		}
	}
};

var origPOS = Expr.match.POS,
	fescape = function(all, num){
		return "\\" + (num - 0 + 1);
	};

for ( var type in Expr.match ) {
	Expr.match[ type ] = new RegExp( Expr.match[ type ].source + (/(?![^\[]*\])(?![^\(]*\))/.source) );
	Expr.leftMatch[ type ] = new RegExp( /(^(?:.|\r|\n)*?)/.source + Expr.match[ type ].source.replace(/\\(\d+)/g, fescape) );
}
// Expose origPOS
// "global" as in regardless of relation to brackets/parens
Expr.match.globalPOS = origPOS;

var makeArray = function( array, results ) {
	array = Array.prototype.slice.call( array, 0 );

	if ( results ) {
		results.push.apply( results, array );
		return results;
	}

	return array;
};

// Perform a simple check to determine if the browser is capable of
// converting a NodeList to an array using builtin methods.
// Also verifies that the returned array holds DOM nodes
// (which is not the case in the Blackberry browser)
try {
	Array.prototype.slice.call( document.documentElement.childNodes, 0 )[0].nodeType;

// Provide a fallback method if it does not work
} catch( e ) {
	makeArray = function( array, results ) {
		var i = 0,
			ret = results || [];

		if ( toString.call(array) === "[object Array]" ) {
			Array.prototype.push.apply( ret, array );

		} else {
			if ( typeof array.length === "number" ) {
				for ( var l = array.length; i < l; i++ ) {
					ret.push( array[i] );
				}

			} else {
				for ( ; array[i]; i++ ) {
					ret.push( array[i] );
				}
			}
		}

		return ret;
	};
}

var sortOrder, siblingCheck;

if ( document.documentElement.compareDocumentPosition ) {
	sortOrder = function( a, b ) {
		if ( a === b ) {
			hasDuplicate = true;
			return 0;
		}

		if ( !a.compareDocumentPosition || !b.compareDocumentPosition ) {
			return a.compareDocumentPosition ? -1 : 1;
		}

		return a.compareDocumentPosition(b) & 4 ? -1 : 1;
	};

} else {
	sortOrder = function( a, b ) {
		// The nodes are identical, we can exit early
		if ( a === b ) {
			hasDuplicate = true;
			return 0;

		// Fallback to using sourceIndex (in IE) if it's available on both nodes
		} else if ( a.sourceIndex && b.sourceIndex ) {
			return a.sourceIndex - b.sourceIndex;
		}

		var al, bl,
			ap = [],
			bp = [],
			aup = a.parentNode,
			bup = b.parentNode,
			cur = aup;

		// If the nodes are siblings (or identical) we can do a quick check
		if ( aup === bup ) {
			return siblingCheck( a, b );

		// If no parents were found then the nodes are disconnected
		} else if ( !aup ) {
			return -1;

		} else if ( !bup ) {
			return 1;
		}

		// Otherwise they're somewhere else in the tree so we need
		// to build up a full list of the parentNodes for comparison
		while ( cur ) {
			ap.unshift( cur );
			cur = cur.parentNode;
		}

		cur = bup;

		while ( cur ) {
			bp.unshift( cur );
			cur = cur.parentNode;
		}

		al = ap.length;
		bl = bp.length;

		// Start walking down the tree looking for a discrepancy
		for ( var i = 0; i < al && i < bl; i++ ) {
			if ( ap[i] !== bp[i] ) {
				return siblingCheck( ap[i], bp[i] );
			}
		}

		// We ended someplace up the tree so do a sibling check
		return i === al ?
			siblingCheck( a, bp[i], -1 ) :
			siblingCheck( ap[i], b, 1 );
	};

	siblingCheck = function( a, b, ret ) {
		if ( a === b ) {
			return ret;
		}

		var cur = a.nextSibling;

		while ( cur ) {
			if ( cur === b ) {
				return -1;
			}

			cur = cur.nextSibling;
		}

		return 1;
	};
}

// Check to see if the browser returns elements by name when
// querying by getElementById (and provide a workaround)
(function(){
	// We're going to inject a fake input element with a specified name
	var form = document.createElement("div"),
		id = "script" + (new Date()).getTime(),
		root = document.documentElement;

	form.innerHTML = "<a name='" + id + "'/>";

	// Inject it into the root element, check its status, and remove it quickly
	root.insertBefore( form, root.firstChild );

	// The workaround has to do additional checks after a getElementById
	// Which slows things down for other browsers (hence the branching)
	if ( document.getElementById( id ) ) {
		Expr.find.ID = function( match, context, isXML ) {
			if ( typeof context.getElementById !== "undefined" && !isXML ) {
				var m = context.getElementById(match[1]);

				return m ?
					m.id === match[1] || typeof m.getAttributeNode !== "undefined" && m.getAttributeNode("id").nodeValue === match[1] ?
						[m] :
						undefined :
					[];
			}
		};

		Expr.filter.ID = function( elem, match ) {
			var node = typeof elem.getAttributeNode !== "undefined" && elem.getAttributeNode("id");

			return elem.nodeType === 1 && node && node.nodeValue === match;
		};
	}

	root.removeChild( form );

	// release memory in IE
	root = form = null;
})();

(function(){
	// Check to see if the browser returns only elements
	// when doing getElementsByTagName("*")

	// Create a fake element
	var div = document.createElement("div");
	div.appendChild( document.createComment("") );

	// Make sure no comments are found
	if ( div.getElementsByTagName("*").length > 0 ) {
		Expr.find.TAG = function( match, context ) {
			var results = context.getElementsByTagName( match[1] );

			// Filter out possible comments
			if ( match[1] === "*" ) {
				var tmp = [];

				for ( var i = 0; results[i]; i++ ) {
					if ( results[i].nodeType === 1 ) {
						tmp.push( results[i] );
					}
				}

				results = tmp;
			}

			return results;
		};
	}

	// Check to see if an attribute returns normalized href attributes
	div.innerHTML = "<a href='#'></a>";

	if ( div.firstChild && typeof div.firstChild.getAttribute !== "undefined" &&
			div.firstChild.getAttribute("href") !== "#" ) {

		Expr.attrHandle.href = function( elem ) {
			return elem.getAttribute( "href", 2 );
		};
	}

	// release memory in IE
	div = null;
})();

if ( document.querySelectorAll ) {
	(function(){
		var oldSizzle = Sizzle,
			div = document.createElement("div"),
			id = "__sizzle__";

		div.innerHTML = "<p class='TEST'></p>";

		// Safari can't handle uppercase or unicode characters when
		// in quirks mode.
		if ( div.querySelectorAll && div.querySelectorAll(".TEST").length === 0 ) {
			return;
		}

		Sizzle = function( query, context, extra, seed ) {
			context = context || document;

			// Only use querySelectorAll on non-XML documents
			// (ID selectors don't work in non-HTML documents)
			if ( !seed && !Sizzle.isXML(context) ) {
				// See if we find a selector to speed up
				var match = /^(\w+$)|^\.([\w\-]+$)|^#([\w\-]+$)/.exec( query );

				if ( match && (context.nodeType === 1 || context.nodeType === 9) ) {
					// Speed-up: Sizzle("TAG")
					if ( match[1] ) {
						return makeArray( context.getElementsByTagName( query ), extra );

					// Speed-up: Sizzle(".CLASS")
					} else if ( match[2] && Expr.find.CLASS && context.getElementsByClassName ) {
						return makeArray( context.getElementsByClassName( match[2] ), extra );
					}
				}

				if ( context.nodeType === 9 ) {
					// Speed-up: Sizzle("body")
					// The body element only exists once, optimize finding it
					if ( query === "body" && context.body ) {
						return makeArray( [ context.body ], extra );

					// Speed-up: Sizzle("#ID")
					} else if ( match && match[3] ) {
						var elem = context.getElementById( match[3] );

						// Check parentNode to catch when Blackberry 4.6 returns
						// nodes that are no longer in the document #6963
						if ( elem && elem.parentNode ) {
							// Handle the case where IE and Opera return items
							// by name instead of ID
							if ( elem.id === match[3] ) {
								return makeArray( [ elem ], extra );
							}

						} else {
							return makeArray( [], extra );
						}
					}

					try {
						return makeArray( context.querySelectorAll(query), extra );
					} catch(qsaError) {}

				// qSA works strangely on Element-rooted queries
				// We can work around this by specifying an extra ID on the root
				// and working up from there (Thanks to Andrew Dupont for the technique)
				// IE 8 doesn't work on object elements
				} else if ( context.nodeType === 1 && context.nodeName.toLowerCase() !== "object" ) {
					var oldContext = context,
						old = context.getAttribute( "id" ),
						nid = old || id,
						hasParent = context.parentNode,
						relativeHierarchySelector = /^\s*[+~]/.test( query );

					if ( !old ) {
						context.setAttribute( "id", nid );
					} else {
						nid = nid.replace( /'/g, "\\$&" );
					}
					if ( relativeHierarchySelector && hasParent ) {
						context = context.parentNode;
					}

					try {
						if ( !relativeHierarchySelector || hasParent ) {
							return makeArray( context.querySelectorAll( "[id='" + nid + "'] " + query ), extra );
						}

					} catch(pseudoError) {
					} finally {
						if ( !old ) {
							oldContext.removeAttribute( "id" );
						}
					}
				}
			}

			return oldSizzle(query, context, extra, seed);
		};

		for ( var prop in oldSizzle ) {
			Sizzle[ prop ] = oldSizzle[ prop ];
		}

		// release memory in IE
		div = null;
	})();
}

(function(){
	var html = document.documentElement,
		matches = html.matchesSelector || html.mozMatchesSelector || html.webkitMatchesSelector || html.msMatchesSelector;

	if ( matches ) {
		// Check to see if it's possible to do matchesSelector
		// on a disconnected node (IE 9 fails this)
		var disconnectedMatch = !matches.call( document.createElement( "div" ), "div" ),
			pseudoWorks = false;

		try {
			// This should fail with an exception
			// Gecko does not error, returns false instead
			matches.call( document.documentElement, "[test!='']:sizzle" );

		} catch( pseudoError ) {
			pseudoWorks = true;
		}

		Sizzle.matchesSelector = function( node, expr ) {
			// Make sure that attribute selectors are quoted
			expr = expr.replace(/\=\s*([^'"\]]*)\s*\]/g, "='$1']");

			if ( !Sizzle.isXML( node ) ) {
				try {
					if ( pseudoWorks || !Expr.match.PSEUDO.test( expr ) && !/!=/.test( expr ) ) {
						var ret = matches.call( node, expr );

						// IE 9's matchesSelector returns false on disconnected nodes
						if ( ret || !disconnectedMatch ||
								// As well, disconnected nodes are said to be in a document
								// fragment in IE 9, so check for that
								node.document && node.document.nodeType !== 11 ) {
							return ret;
						}
					}
				} catch(e) {}
			}

			return Sizzle(expr, null, null, [node]).length > 0;
		};
	}
})();

(function(){
	var div = document.createElement("div");

	div.innerHTML = "<div class='test e'></div><div class='test'></div>";

	// Opera can't find a second classname (in 9.6)
	// Also, make sure that getElementsByClassName actually exists
	if ( !div.getElementsByClassName || div.getElementsByClassName("e").length === 0 ) {
		return;
	}

	// Safari caches class attributes, doesn't catch changes (in 3.2)
	div.lastChild.className = "e";

	if ( div.getElementsByClassName("e").length === 1 ) {
		return;
	}

	Expr.order.splice(1, 0, "CLASS");
	Expr.find.CLASS = function( match, context, isXML ) {
		if ( typeof context.getElementsByClassName !== "undefined" && !isXML ) {
			return context.getElementsByClassName(match[1]);
		}
	};

	// release memory in IE
	div = null;
})();

function dirNodeCheck( dir, cur, doneName, checkSet, nodeCheck, isXML ) {
	for ( var i = 0, l = checkSet.length; i < l; i++ ) {
		var elem = checkSet[i];

		if ( elem ) {
			var match = false;

			elem = elem[dir];

			while ( elem ) {
				if ( elem[ expando ] === doneName ) {
					match = checkSet[elem.sizset];
					break;
				}

				if ( elem.nodeType === 1 && !isXML ){
					elem[ expando ] = doneName;
					elem.sizset = i;
				}

				if ( elem.nodeName.toLowerCase() === cur ) {
					match = elem;
					break;
				}

				elem = elem[dir];
			}

			checkSet[i] = match;
		}
	}
}

function dirCheck( dir, cur, doneName, checkSet, nodeCheck, isXML ) {
	for ( var i = 0, l = checkSet.length; i < l; i++ ) {
		var elem = checkSet[i];

		if ( elem ) {
			var match = false;

			elem = elem[dir];

			while ( elem ) {
				if ( elem[ expando ] === doneName ) {
					match = checkSet[elem.sizset];
					break;
				}

				if ( elem.nodeType === 1 ) {
					if ( !isXML ) {
						elem[ expando ] = doneName;
						elem.sizset = i;
					}

					if ( typeof cur !== "string" ) {
						if ( elem === cur ) {
							match = true;
							break;
						}

					} else if ( Sizzle.filter( cur, [elem] ).length > 0 ) {
						match = elem;
						break;
					}
				}

				elem = elem[dir];
			}

			checkSet[i] = match;
		}
	}
}

if ( document.documentElement.contains ) {
	Sizzle.contains = function( a, b ) {
		return a !== b && (a.contains ? a.contains(b) : true);
	};

} else if ( document.documentElement.compareDocumentPosition ) {
	Sizzle.contains = function( a, b ) {
		return !!(a.compareDocumentPosition(b) & 16);
	};

} else {
	Sizzle.contains = function() {
		return false;
	};
}

Sizzle.isXML = function( elem ) {
	// documentElement is verified for cases where it doesn't yet exist
	// (such as loading iframes in IE - #4833)
	var documentElement = (elem ? elem.ownerDocument || elem : 0).documentElement;

	return documentElement ? documentElement.nodeName !== "HTML" : false;
};

var posProcess = function( selector, context, seed ) {
	var match,
		tmpSet = [],
		later = "",
		root = context.nodeType ? [context] : context;

	// Position selectors must be done after the filter
	// And so must :not(positional) so we move all PSEUDOs to the end
	while ( (match = Expr.match.PSEUDO.exec( selector )) ) {
		later += match[0];
		selector = selector.replace( Expr.match.PSEUDO, "" );
	}

	selector = Expr.relative[selector] ? selector + "*" : selector;

	for ( var i = 0, l = root.length; i < l; i++ ) {
		Sizzle( selector, root[i], tmpSet, seed );
	}

	return Sizzle.filter( later, tmpSet );
};

// EXPOSE
// Override sizzle attribute retrieval
Sizzle.attr = jQuery.attr;
Sizzle.selectors.attrMap = {};
jQuery.find = Sizzle;
jQuery.expr = Sizzle.selectors;
jQuery.expr[":"] = jQuery.expr.filters;
jQuery.unique = Sizzle.uniqueSort;
jQuery.text = Sizzle.getText;
jQuery.isXMLDoc = Sizzle.isXML;
jQuery.contains = Sizzle.contains;


})();


var runtil = /Until$/,
	rparentsprev = /^(?:parents|prevUntil|prevAll)/,
	// Note: This RegExp should be improved, or likely pulled from Sizzle
	rmultiselector = /,/,
	isSimple = /^.[^:#\[\.,]*$/,
	slice = Array.prototype.slice,
	POS = jQuery.expr.match.globalPOS,
	// methods guaranteed to produce a unique set when starting from a unique set
	guaranteedUnique = {
		children: true,
		contents: true,
		next: true,
		prev: true
	};

jQuery.fn.extend({
	find: function( selector ) {
		var self = this,
			i, l;

		if ( typeof selector !== "string" ) {
			return jQuery( selector ).filter(function() {
				for ( i = 0, l = self.length; i < l; i++ ) {
					if ( jQuery.contains( self[ i ], this ) ) {
						return true;
					}
				}
			});
		}

		var ret = this.pushStack( "", "find", selector ),
			length, n, r;

		for ( i = 0, l = this.length; i < l; i++ ) {
			length = ret.length;
			jQuery.find( selector, this[i], ret );

			if ( i > 0 ) {
				// Make sure that the results are unique
				for ( n = length; n < ret.length; n++ ) {
					for ( r = 0; r < length; r++ ) {
						if ( ret[r] === ret[n] ) {
							ret.splice(n--, 1);
							break;
						}
					}
				}
			}
		}

		return ret;
	},

	has: function( target ) {
		var targets = jQuery( target );
		return this.filter(function() {
			for ( var i = 0, l = targets.length; i < l; i++ ) {
				if ( jQuery.contains( this, targets[i] ) ) {
					return true;
				}
			}
		});
	},

	not: function( selector ) {
		return this.pushStack( winnow(this, selector, false), "not", selector);
	},

	filter: function( selector ) {
		return this.pushStack( winnow(this, selector, true), "filter", selector );
	},

	is: function( selector ) {
		return !!selector && (
			typeof selector === "string" ?
				// If this is a positional selector, check membership in the returned set
				// so $("p:first").is("p:last") won't return true for a doc with two "p".
				POS.test( selector ) ?
					jQuery( selector, this.context ).index( this[0] ) >= 0 :
					jQuery.filter( selector, this ).length > 0 :
				this.filter( selector ).length > 0 );
	},

	closest: function( selectors, context ) {
		var ret = [], i, l, cur = this[0];

		// Array (deprecated as of jQuery 1.7)
		if ( jQuery.isArray( selectors ) ) {
			var level = 1;

			while ( cur && cur.ownerDocument && cur !== context ) {
				for ( i = 0; i < selectors.length; i++ ) {

					if ( jQuery( cur ).is( selectors[ i ] ) ) {
						ret.push({ selector: selectors[ i ], elem: cur, level: level });
					}
				}

				cur = cur.parentNode;
				level++;
			}

			return ret;
		}

		// String
		var pos = POS.test( selectors ) || typeof selectors !== "string" ?
				jQuery( selectors, context || this.context ) :
				0;

		for ( i = 0, l = this.length; i < l; i++ ) {
			cur = this[i];

			while ( cur ) {
				if ( pos ? pos.index(cur) > -1 : jQuery.find.matchesSelector(cur, selectors) ) {
					ret.push( cur );
					break;

				} else {
					cur = cur.parentNode;
					if ( !cur || !cur.ownerDocument || cur === context || cur.nodeType === 11 ) {
						break;
					}
				}
			}
		}

		ret = ret.length > 1 ? jQuery.unique( ret ) : ret;

		return this.pushStack( ret, "closest", selectors );
	},

	// Determine the position of an element within
	// the matched set of elements
	index: function( elem ) {

		// No argument, return index in parent
		if ( !elem ) {
			return ( this[0] && this[0].parentNode ) ? this.prevAll().length : -1;
		}

		// index in selector
		if ( typeof elem === "string" ) {
			return jQuery.inArray( this[0], jQuery( elem ) );
		}

		// Locate the position of the desired element
		return jQuery.inArray(
			// If it receives a jQuery object, the first element is used
			elem.jquery ? elem[0] : elem, this );
	},

	add: function( selector, context ) {
		var set = typeof selector === "string" ?
				jQuery( selector, context ) :
				jQuery.makeArray( selector && selector.nodeType ? [ selector ] : selector ),
			all = jQuery.merge( this.get(), set );

		return this.pushStack( isDisconnected( set[0] ) || isDisconnected( all[0] ) ?
			all :
			jQuery.unique( all ) );
	},

	andSelf: function() {
		return this.add( this.prevObject );
	}
});

// A painfully simple check to see if an element is disconnected
// from a document (should be improved, where feasible).
function isDisconnected( node ) {
	return !node || !node.parentNode || node.parentNode.nodeType === 11;
}

jQuery.each({
	parent: function( elem ) {
		var parent = elem.parentNode;
		return parent && parent.nodeType !== 11 ? parent : null;
	},
	parents: function( elem ) {
		return jQuery.dir( elem, "parentNode" );
	},
	parentsUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "parentNode", until );
	},
	next: function( elem ) {
		return jQuery.nth( elem, 2, "nextSibling" );
	},
	prev: function( elem ) {
		return jQuery.nth( elem, 2, "previousSibling" );
	},
	nextAll: function( elem ) {
		return jQuery.dir( elem, "nextSibling" );
	},
	prevAll: function( elem ) {
		return jQuery.dir( elem, "previousSibling" );
	},
	nextUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "nextSibling", until );
	},
	prevUntil: function( elem, i, until ) {
		return jQuery.dir( elem, "previousSibling", until );
	},
	siblings: function( elem ) {
		return jQuery.sibling( ( elem.parentNode || {} ).firstChild, elem );
	},
	children: function( elem ) {
		return jQuery.sibling( elem.firstChild );
	},
	contents: function( elem ) {
		return jQuery.nodeName( elem, "iframe" ) ?
			elem.contentDocument || elem.contentWindow.document :
			jQuery.makeArray( elem.childNodes );
	}
}, function( name, fn ) {
	jQuery.fn[ name ] = function( until, selector ) {
		var ret = jQuery.map( this, fn, until );

		if ( !runtil.test( name ) ) {
			selector = until;
		}

		if ( selector && typeof selector === "string" ) {
			ret = jQuery.filter( selector, ret );
		}

		ret = this.length > 1 && !guaranteedUnique[ name ] ? jQuery.unique( ret ) : ret;

		if ( (this.length > 1 || rmultiselector.test( selector )) && rparentsprev.test( name ) ) {
			ret = ret.reverse();
		}

		return this.pushStack( ret, name, slice.call( arguments ).join(",") );
	};
});

jQuery.extend({
	filter: function( expr, elems, not ) {
		if ( not ) {
			expr = ":not(" + expr + ")";
		}

		return elems.length === 1 ?
			jQuery.find.matchesSelector(elems[0], expr) ? [ elems[0] ] : [] :
			jQuery.find.matches(expr, elems);
	},

	dir: function( elem, dir, until ) {
		var matched = [],
			cur = elem[ dir ];

		while ( cur && cur.nodeType !== 9 && (until === undefined || cur.nodeType !== 1 || !jQuery( cur ).is( until )) ) {
			if ( cur.nodeType === 1 ) {
				matched.push( cur );
			}
			cur = cur[dir];
		}
		return matched;
	},

	nth: function( cur, result, dir, elem ) {
		result = result || 1;
		var num = 0;

		for ( ; cur; cur = cur[dir] ) {
			if ( cur.nodeType === 1 && ++num === result ) {
				break;
			}
		}

		return cur;
	},

	sibling: function( n, elem ) {
		var r = [];

		for ( ; n; n = n.nextSibling ) {
			if ( n.nodeType === 1 && n !== elem ) {
				r.push( n );
			}
		}

		return r;
	}
});

// Implement the identical functionality for filter and not
function winnow( elements, qualifier, keep ) {

	// Can't pass null or undefined to indexOf in Firefox 4
	// Set to 0 to skip string check
	qualifier = qualifier || 0;

	if ( jQuery.isFunction( qualifier ) ) {
		return jQuery.grep(elements, function( elem, i ) {
			var retVal = !!qualifier.call( elem, i, elem );
			return retVal === keep;
		});

	} else if ( qualifier.nodeType ) {
		return jQuery.grep(elements, function( elem, i ) {
			return ( elem === qualifier ) === keep;
		});

	} else if ( typeof qualifier === "string" ) {
		var filtered = jQuery.grep(elements, function( elem ) {
			return elem.nodeType === 1;
		});

		if ( isSimple.test( qualifier ) ) {
			return jQuery.filter(qualifier, filtered, !keep);
		} else {
			qualifier = jQuery.filter( qualifier, filtered );
		}
	}

	return jQuery.grep(elements, function( elem, i ) {
		return ( jQuery.inArray( elem, qualifier ) >= 0 ) === keep;
	});
}




function createSafeFragment( document ) {
	var list = nodeNames.split( "|" ),
	safeFrag = document.createDocumentFragment();

	if ( safeFrag.createElement ) {
		while ( list.length ) {
			safeFrag.createElement(
				list.pop()
			);
		}
	}
	return safeFrag;
}

var nodeNames = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|" +
		"header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",
	rinlinejQuery = / jQuery\d+="(?:\d+|null)"/g,
	rleadingWhitespace = /^\s+/,
	rxhtmlTag = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,
	rtagName = /<([\w:]+)/,
	rtbody = /<tbody/i,
	rhtml = /<|&#?\w+;/,
	rnoInnerhtml = /<(?:script|style)/i,
	rnocache = /<(?:script|object|embed|option|style)/i,
	rnoshimcache = new RegExp("<(?:" + nodeNames + ")[\\s/>]", "i"),
	// checked="checked" or checked
	rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i,
	rscriptType = /\/(java|ecma)script/i,
	rcleanScript = /^\s*<!(?:\[CDATA\[|\-\-)/,
	wrapMap = {
		option: [ 1, "<select multiple='multiple'>", "</select>" ],
		legend: [ 1, "<fieldset>", "</fieldset>" ],
		thead: [ 1, "<table>", "</table>" ],
		tr: [ 2, "<table><tbody>", "</tbody></table>" ],
		td: [ 3, "<table><tbody><tr>", "</tr></tbody></table>" ],
		col: [ 2, "<table><tbody></tbody><colgroup>", "</colgroup></table>" ],
		area: [ 1, "<map>", "</map>" ],
		_default: [ 0, "", "" ]
	},
	safeFragment = createSafeFragment( document );

wrapMap.optgroup = wrapMap.option;
wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
wrapMap.th = wrapMap.td;

// IE can't serialize <link> and <script> tags normally
if ( !jQuery.support.htmlSerialize ) {
	wrapMap._default = [ 1, "div<div>", "</div>" ];
}

jQuery.fn.extend({
	text: function( value ) {
		return jQuery.access( this, function( value ) {
			return value === undefined ?
				jQuery.text( this ) :
				this.empty().append( ( this[0] && this[0].ownerDocument || document ).createTextNode( value ) );
		}, null, value, arguments.length );
	},

	wrapAll: function( html ) {
		if ( jQuery.isFunction( html ) ) {
			return this.each(function(i) {
				jQuery(this).wrapAll( html.call(this, i) );
			});
		}

		if ( this[0] ) {
			// The elements to wrap the target around
			var wrap = jQuery( html, this[0].ownerDocument ).eq(0).clone(true);

			if ( this[0].parentNode ) {
				wrap.insertBefore( this[0] );
			}

			wrap.map(function() {
				var elem = this;

				while ( elem.firstChild && elem.firstChild.nodeType === 1 ) {
					elem = elem.firstChild;
				}

				return elem;
			}).append( this );
		}

		return this;
	},

	wrapInner: function( html ) {
		if ( jQuery.isFunction( html ) ) {
			return this.each(function(i) {
				jQuery(this).wrapInner( html.call(this, i) );
			});
		}

		return this.each(function() {
			var self = jQuery( this ),
				contents = self.contents();

			if ( contents.length ) {
				contents.wrapAll( html );

			} else {
				self.append( html );
			}
		});
	},

	wrap: function( html ) {
		var isFunction = jQuery.isFunction( html );

		return this.each(function(i) {
			jQuery( this ).wrapAll( isFunction ? html.call(this, i) : html );
		});
	},

	unwrap: function() {
		return this.parent().each(function() {
			if ( !jQuery.nodeName( this, "body" ) ) {
				jQuery( this ).replaceWith( this.childNodes );
			}
		}).end();
	},

	append: function() {
		return this.domManip(arguments, true, function( elem ) {
			if ( this.nodeType === 1 ) {
				this.appendChild( elem );
			}
		});
	},

	prepend: function() {
		return this.domManip(arguments, true, function( elem ) {
			if ( this.nodeType === 1 ) {
				this.insertBefore( elem, this.firstChild );
			}
		});
	},

	before: function() {
		if ( this[0] && this[0].parentNode ) {
			return this.domManip(arguments, false, function( elem ) {
				this.parentNode.insertBefore( elem, this );
			});
		} else if ( arguments.length ) {
			var set = jQuery.clean( arguments );
			set.push.apply( set, this.toArray() );
			return this.pushStack( set, "before", arguments );
		}
	},

	after: function() {
		if ( this[0] && this[0].parentNode ) {
			return this.domManip(arguments, false, function( elem ) {
				this.parentNode.insertBefore( elem, this.nextSibling );
			});
		} else if ( arguments.length ) {
			var set = this.pushStack( this, "after", arguments );
			set.push.apply( set, jQuery.clean(arguments) );
			return set;
		}
	},

	// keepData is for internal use only--do not document
	remove: function( selector, keepData ) {
		for ( var i = 0, elem; (elem = this[i]) != null; i++ ) {
			if ( !selector || jQuery.filter( selector, [ elem ] ).length ) {
				if ( !keepData && elem.nodeType === 1 ) {
					jQuery.cleanData( elem.getElementsByTagName("*") );
					jQuery.cleanData( [ elem ] );
				}

				if ( elem.parentNode ) {
					elem.parentNode.removeChild( elem );
				}
			}
		}

		return this;
	},

	empty: function() {
		for ( var i = 0, elem; (elem = this[i]) != null; i++ ) {
			// Remove element nodes and prevent memory leaks
			if ( elem.nodeType === 1 ) {
				jQuery.cleanData( elem.getElementsByTagName("*") );
			}

			// Remove any remaining nodes
			while ( elem.firstChild ) {
				elem.removeChild( elem.firstChild );
			}
		}

		return this;
	},

	clone: function( dataAndEvents, deepDataAndEvents ) {
		dataAndEvents = dataAndEvents == null ? false : dataAndEvents;
		deepDataAndEvents = deepDataAndEvents == null ? dataAndEvents : deepDataAndEvents;

		return this.map( function () {
			return jQuery.clone( this, dataAndEvents, deepDataAndEvents );
		});
	},

	html: function( value ) {
		return jQuery.access( this, function( value ) {
			var elem = this[0] || {},
				i = 0,
				l = this.length;

			if ( value === undefined ) {
				return elem.nodeType === 1 ?
					elem.innerHTML.replace( rinlinejQuery, "" ) :
					null;
			}


			if ( typeof value === "string" && !rnoInnerhtml.test( value ) &&
				( jQuery.support.leadingWhitespace || !rleadingWhitespace.test( value ) ) &&
				!wrapMap[ ( rtagName.exec( value ) || ["", ""] )[1].toLowerCase() ] ) {

				value = value.replace( rxhtmlTag, "<$1></$2>" );

				try {
					for (; i < l; i++ ) {
						// Remove element nodes and prevent memory leaks
						elem = this[i] || {};
						if ( elem.nodeType === 1 ) {
							jQuery.cleanData( elem.getElementsByTagName( "*" ) );
							elem.innerHTML = value;
						}
					}

					elem = 0;

				// If using innerHTML throws an exception, use the fallback method
				} catch(e) {}
			}

			if ( elem ) {
				this.empty().append( value );
			}
		}, null, value, arguments.length );
	},

	replaceWith: function( value ) {
		if ( this[0] && this[0].parentNode ) {
			// Make sure that the elements are removed from the DOM before they are inserted
			// this can help fix replacing a parent with child elements
			if ( jQuery.isFunction( value ) ) {
				return this.each(function(i) {
					var self = jQuery(this), old = self.html();
					self.replaceWith( value.call( this, i, old ) );
				});
			}

			if ( typeof value !== "string" ) {
				value = jQuery( value ).detach();
			}

			return this.each(function() {
				var next = this.nextSibling,
					parent = this.parentNode;

				jQuery( this ).remove();

				if ( next ) {
					jQuery(next).before( value );
				} else {
					jQuery(parent).append( value );
				}
			});
		} else {
			return this.length ?
				this.pushStack( jQuery(jQuery.isFunction(value) ? value() : value), "replaceWith", value ) :
				this;
		}
	},

	detach: function( selector ) {
		return this.remove( selector, true );
	},

	domManip: function( args, table, callback ) {
		var results, first, fragment, parent,
			value = args[0],
			scripts = [];

		// We can't cloneNode fragments that contain checked, in WebKit
		if ( !jQuery.support.checkClone && arguments.length === 3 && typeof value === "string" && rchecked.test( value ) ) {
			return this.each(function() {
				jQuery(this).domManip( args, table, callback, true );
			});
		}

		if ( jQuery.isFunction(value) ) {
			return this.each(function(i) {
				var self = jQuery(this);
				args[0] = value.call(this, i, table ? self.html() : undefined);
				self.domManip( args, table, callback );
			});
		}

		if ( this[0] ) {
			parent = value && value.parentNode;

			// If we're in a fragment, just use that instead of building a new one
			if ( jQuery.support.parentNode && parent && parent.nodeType === 11 && parent.childNodes.length === this.length ) {
				results = { fragment: parent };

			} else {
				results = jQuery.buildFragment( args, this, scripts );
			}

			fragment = results.fragment;

			if ( fragment.childNodes.length === 1 ) {
				first = fragment = fragment.firstChild;
			} else {
				first = fragment.firstChild;
			}

			if ( first ) {
				table = table && jQuery.nodeName( first, "tr" );

				for ( var i = 0, l = this.length, lastIndex = l - 1; i < l; i++ ) {
					callback.call(
						table ?
							root(this[i], first) :
							this[i],
						// Make sure that we do not leak memory by inadvertently discarding
						// the original fragment (which might have attached data) instead of
						// using it; in addition, use the original fragment object for the last
						// item instead of first because it can end up being emptied incorrectly
						// in certain situations (Bug #8070).
						// Fragments from the fragment cache must always be cloned and never used
						// in place.
						results.cacheable || ( l > 1 && i < lastIndex ) ?
							jQuery.clone( fragment, true, true ) :
							fragment
					);
				}
			}

			if ( scripts.length ) {
				jQuery.each( scripts, function( i, elem ) {
					if ( elem.src ) {
						jQuery.ajax({
							type: "GET",
							global: false,
							url: elem.src,
							async: false,
							dataType: "script"
						});
					} else {
						jQuery.globalEval( ( elem.text || elem.textContent || elem.innerHTML || "" ).replace( rcleanScript, "/*$0*/" ) );
					}

					if ( elem.parentNode ) {
						elem.parentNode.removeChild( elem );
					}
				});
			}
		}

		return this;
	}
});

function root( elem, cur ) {
	return jQuery.nodeName(elem, "table") ?
		(elem.getElementsByTagName("tbody")[0] ||
		elem.appendChild(elem.ownerDocument.createElement("tbody"))) :
		elem;
}

function cloneCopyEvent( src, dest ) {

	if ( dest.nodeType !== 1 || !jQuery.hasData( src ) ) {
		return;
	}

	var type, i, l,
		oldData = jQuery._data( src ),
		curData = jQuery._data( dest, oldData ),
		events = oldData.events;

	if ( events ) {
		delete curData.handle;
		curData.events = {};

		for ( type in events ) {
			for ( i = 0, l = events[ type ].length; i < l; i++ ) {
				jQuery.event.add( dest, type, events[ type ][ i ] );
			}
		}
	}

	// make the cloned public data object a copy from the original
	if ( curData.data ) {
		curData.data = jQuery.extend( {}, curData.data );
	}
}

function cloneFixAttributes( src, dest ) {
	var nodeName;

	// We do not need to do anything for non-Elements
	if ( dest.nodeType !== 1 ) {
		return;
	}

	// clearAttributes removes the attributes, which we don't want,
	// but also removes the attachEvent events, which we *do* want
	if ( dest.clearAttributes ) {
		dest.clearAttributes();
	}

	// mergeAttributes, in contrast, only merges back on the
	// original attributes, not the events
	if ( dest.mergeAttributes ) {
		dest.mergeAttributes( src );
	}

	nodeName = dest.nodeName.toLowerCase();

	// IE6-8 fail to clone children inside object elements that use
	// the proprietary classid attribute value (rather than the type
	// attribute) to identify the type of content to display
	if ( nodeName === "object" ) {
		dest.outerHTML = src.outerHTML;

	} else if ( nodeName === "input" && (src.type === "checkbox" || src.type === "radio") ) {
		// IE6-8 fails to persist the checked state of a cloned checkbox
		// or radio button. Worse, IE6-7 fail to give the cloned element
		// a checked appearance if the defaultChecked value isn't also set
		if ( src.checked ) {
			dest.defaultChecked = dest.checked = src.checked;
		}

		// IE6-7 get confused and end up setting the value of a cloned
		// checkbox/radio button to an empty string instead of "on"
		if ( dest.value !== src.value ) {
			dest.value = src.value;
		}

	// IE6-8 fails to return the selected option to the default selected
	// state when cloning options
	} else if ( nodeName === "option" ) {
		dest.selected = src.defaultSelected;

	// IE6-8 fails to set the defaultValue to the correct value when
	// cloning other types of input fields
	} else if ( nodeName === "input" || nodeName === "textarea" ) {
		dest.defaultValue = src.defaultValue;

	// IE blanks contents when cloning scripts
	} else if ( nodeName === "script" && dest.text !== src.text ) {
		dest.text = src.text;
	}

	// Event data gets referenced instead of copied if the expando
	// gets copied too
	dest.removeAttribute( jQuery.expando );

	// Clear flags for bubbling special change/submit events, they must
	// be reattached when the newly cloned events are first activated
	dest.removeAttribute( "_submit_attached" );
	dest.removeAttribute( "_change_attached" );
}

jQuery.buildFragment = function( args, nodes, scripts ) {
	var fragment, cacheable, cacheresults, doc,
	first = args[ 0 ];

	// nodes may contain either an explicit document object,
	// a jQuery collection or context object.
	// If nodes[0] contains a valid object to assign to doc
	if ( nodes && nodes[0] ) {
		doc = nodes[0].ownerDocument || nodes[0];
	}

	// Ensure that an attr object doesn't incorrectly stand in as a document object
	// Chrome and Firefox seem to allow this to occur and will throw exception
	// Fixes #8950
	if ( !doc.createDocumentFragment ) {
		doc = document;
	}

	// Only cache "small" (1/2 KB) HTML strings that are associated with the main document
	// Cloning options loses the selected state, so don't cache them
	// IE 6 doesn't like it when you put <object> or <embed> elements in a fragment
	// Also, WebKit does not clone 'checked' attributes on cloneNode, so don't cache
	// Lastly, IE6,7,8 will not correctly reuse cached fragments that were created from unknown elems #10501
	if ( args.length === 1 && typeof first === "string" && first.length < 512 && doc === document &&
		first.charAt(0) === "<" && !rnocache.test( first ) &&
		(jQuery.support.checkClone || !rchecked.test( first )) &&
		(jQuery.support.html5Clone || !rnoshimcache.test( first )) ) {

		cacheable = true;

		cacheresults = jQuery.fragments[ first ];
		if ( cacheresults && cacheresults !== 1 ) {
			fragment = cacheresults;
		}
	}

	if ( !fragment ) {
		fragment = doc.createDocumentFragment();
		jQuery.clean( args, doc, fragment, scripts );
	}

	if ( cacheable ) {
		jQuery.fragments[ first ] = cacheresults ? fragment : 1;
	}

	return { fragment: fragment, cacheable: cacheable };
};

jQuery.fragments = {};

jQuery.each({
	appendTo: "append",
	prependTo: "prepend",
	insertBefore: "before",
	insertAfter: "after",
	replaceAll: "replaceWith"
}, function( name, original ) {
	jQuery.fn[ name ] = function( selector ) {
		var ret = [],
			insert = jQuery( selector ),
			parent = this.length === 1 && this[0].parentNode;

		if ( parent && parent.nodeType === 11 && parent.childNodes.length === 1 && insert.length === 1 ) {
			insert[ original ]( this[0] );
			return this;

		} else {
			for ( var i = 0, l = insert.length; i < l; i++ ) {
				var elems = ( i > 0 ? this.clone(true) : this ).get();
				jQuery( insert[i] )[ original ]( elems );
				ret = ret.concat( elems );
			}

			return this.pushStack( ret, name, insert.selector );
		}
	};
});

function getAll( elem ) {
	if ( typeof elem.getElementsByTagName !== "undefined" ) {
		return elem.getElementsByTagName( "*" );

	} else if ( typeof elem.querySelectorAll !== "undefined" ) {
		return elem.querySelectorAll( "*" );

	} else {
		return [];
	}
}

// Used in clean, fixes the defaultChecked property
function fixDefaultChecked( elem ) {
	if ( elem.type === "checkbox" || elem.type === "radio" ) {
		elem.defaultChecked = elem.checked;
	}
}
// Finds all inputs and passes them to fixDefaultChecked
function findInputs( elem ) {
	var nodeName = ( elem.nodeName || "" ).toLowerCase();
	if ( nodeName === "input" ) {
		fixDefaultChecked( elem );
	// Skip scripts, get other children
	} else if ( nodeName !== "script" && typeof elem.getElementsByTagName !== "undefined" ) {
		jQuery.grep( elem.getElementsByTagName("input"), fixDefaultChecked );
	}
}

// Derived From: http://www.iecss.com/shimprove/javascript/shimprove.1-0-1.js
function shimCloneNode( elem ) {
	var div = document.createElement( "div" );
	safeFragment.appendChild( div );

	div.innerHTML = elem.outerHTML;
	return div.firstChild;
}

jQuery.extend({
	clone: function( elem, dataAndEvents, deepDataAndEvents ) {
		var srcElements,
			destElements,
			i,
			// IE<=8 does not properly clone detached, unknown element nodes
			clone = jQuery.support.html5Clone || jQuery.isXMLDoc(elem) || !rnoshimcache.test( "<" + elem.nodeName + ">" ) ?
				elem.cloneNode( true ) :
				shimCloneNode( elem );

		if ( (!jQuery.support.noCloneEvent || !jQuery.support.noCloneChecked) &&
				(elem.nodeType === 1 || elem.nodeType === 11) && !jQuery.isXMLDoc(elem) ) {
			// IE copies events bound via attachEvent when using cloneNode.
			// Calling detachEvent on the clone will also remove the events
			// from the original. In order to get around this, we use some
			// proprietary methods to clear the events. Thanks to MooTools
			// guys for this hotness.

			cloneFixAttributes( elem, clone );

			// Using Sizzle here is crazy slow, so we use getElementsByTagName instead
			srcElements = getAll( elem );
			destElements = getAll( clone );

			// Weird iteration because IE will replace the length property
			// with an element if you are cloning the body and one of the
			// elements on the page has a name or id of "length"
			for ( i = 0; srcElements[i]; ++i ) {
				// Ensure that the destination node is not null; Fixes #9587
				if ( destElements[i] ) {
					cloneFixAttributes( srcElements[i], destElements[i] );
				}
			}
		}

		// Copy the events from the original to the clone
		if ( dataAndEvents ) {
			cloneCopyEvent( elem, clone );

			if ( deepDataAndEvents ) {
				srcElements = getAll( elem );
				destElements = getAll( clone );

				for ( i = 0; srcElements[i]; ++i ) {
					cloneCopyEvent( srcElements[i], destElements[i] );
				}
			}
		}

		srcElements = destElements = null;

		// Return the cloned set
		return clone;
	},

	clean: function( elems, context, fragment, scripts ) {
		var checkScriptType, script, j,
				ret = [];

		context = context || document;

		// !context.createElement fails in IE with an error but returns typeof 'object'
		if ( typeof context.createElement === "undefined" ) {
			context = context.ownerDocument || context[0] && context[0].ownerDocument || document;
		}

		for ( var i = 0, elem; (elem = elems[i]) != null; i++ ) {
			if ( typeof elem === "number" ) {
				elem += "";
			}

			if ( !elem ) {
				continue;
			}

			// Convert html string into DOM nodes
			if ( typeof elem === "string" ) {
				if ( !rhtml.test( elem ) ) {
					elem = context.createTextNode( elem );
				} else {
					// Fix "XHTML"-style tags in all browsers
					elem = elem.replace(rxhtmlTag, "<$1></$2>");

					// Trim whitespace, otherwise indexOf won't work as expected
					var tag = ( rtagName.exec( elem ) || ["", ""] )[1].toLowerCase(),
						wrap = wrapMap[ tag ] || wrapMap._default,
						depth = wrap[0],
						div = context.createElement("div"),
						safeChildNodes = safeFragment.childNodes,
						remove;

					// Append wrapper element to unknown element safe doc fragment
					if ( context === document ) {
						// Use the fragment we've already created for this document
						safeFragment.appendChild( div );
					} else {
						// Use a fragment created with the owner document
						createSafeFragment( context ).appendChild( div );
					}

					// Go to html and back, then peel off extra wrappers
					div.innerHTML = wrap[1] + elem + wrap[2];

					// Move to the right depth
					while ( depth-- ) {
						div = div.lastChild;
					}

					// Remove IE's autoinserted <tbody> from table fragments
					if ( !jQuery.support.tbody ) {

						// String was a <table>, *may* have spurious <tbody>
						var hasBody = rtbody.test(elem),
							tbody = tag === "table" && !hasBody ?
								div.firstChild && div.firstChild.childNodes :

								// String was a bare <thead> or <tfoot>
								wrap[1] === "<table>" && !hasBody ?
									div.childNodes :
									[];

						for ( j = tbody.length - 1; j >= 0 ; --j ) {
							if ( jQuery.nodeName( tbody[ j ], "tbody" ) && !tbody[ j ].childNodes.length ) {
								tbody[ j ].parentNode.removeChild( tbody[ j ] );
							}
						}
					}

					// IE completely kills leading whitespace when innerHTML is used
					if ( !jQuery.support.leadingWhitespace && rleadingWhitespace.test( elem ) ) {
						div.insertBefore( context.createTextNode( rleadingWhitespace.exec(elem)[0] ), div.firstChild );
					}

					elem = div.childNodes;

					// Clear elements from DocumentFragment (safeFragment or otherwise)
					// to avoid hoarding elements. Fixes #11356
					if ( div ) {
						div.parentNode.removeChild( div );

						// Guard against -1 index exceptions in FF3.6
						if ( safeChildNodes.length > 0 ) {
							remove = safeChildNodes[ safeChildNodes.length - 1 ];

							if ( remove && remove.parentNode ) {
								remove.parentNode.removeChild( remove );
							}
						}
					}
				}
			}

			// Resets defaultChecked for any radios and checkboxes
			// about to be appended to the DOM in IE 6/7 (#8060)
			var len;
			if ( !jQuery.support.appendChecked ) {
				if ( elem[0] && typeof (len = elem.length) === "number" ) {
					for ( j = 0; j < len; j++ ) {
						findInputs( elem[j] );
					}
				} else {
					findInputs( elem );
				}
			}

			if ( elem.nodeType ) {
				ret.push( elem );
			} else {
				ret = jQuery.merge( ret, elem );
			}
		}

		if ( fragment ) {
			checkScriptType = function( elem ) {
				return !elem.type || rscriptType.test( elem.type );
			};
			for ( i = 0; ret[i]; i++ ) {
				script = ret[i];
				if ( scripts && jQuery.nodeName( script, "script" ) && (!script.type || rscriptType.test( script.type )) ) {
					scripts.push( script.parentNode ? script.parentNode.removeChild( script ) : script );

				} else {
					if ( script.nodeType === 1 ) {
						var jsTags = jQuery.grep( script.getElementsByTagName( "script" ), checkScriptType );

						ret.splice.apply( ret, [i + 1, 0].concat( jsTags ) );
					}
					fragment.appendChild( script );
				}
			}
		}

		return ret;
	},

	cleanData: function( elems ) {
		var data, id,
			cache = jQuery.cache,
			special = jQuery.event.special,
			deleteExpando = jQuery.support.deleteExpando;

		for ( var i = 0, elem; (elem = elems[i]) != null; i++ ) {
			if ( elem.nodeName && jQuery.noData[elem.nodeName.toLowerCase()] ) {
				continue;
			}

			id = elem[ jQuery.expando ];

			if ( id ) {
				data = cache[ id ];

				if ( data && data.events ) {
					for ( var type in data.events ) {
						if ( special[ type ] ) {
							jQuery.event.remove( elem, type );

						// This is a shortcut to avoid jQuery.event.remove's overhead
						} else {
							jQuery.removeEvent( elem, type, data.handle );
						}
					}

					// Null the DOM reference to avoid IE6/7/8 leak (#7054)
					if ( data.handle ) {
						data.handle.elem = null;
					}
				}

				if ( deleteExpando ) {
					delete elem[ jQuery.expando ];

				} else if ( elem.removeAttribute ) {
					elem.removeAttribute( jQuery.expando );
				}

				delete cache[ id ];
			}
		}
	}
});




var ralpha = /alpha\([^)]*\)/i,
	ropacity = /opacity=([^)]*)/,
	// fixed for IE9, see #8346
	rupper = /([A-Z]|^ms)/g,
	rnum = /^[\-+]?(?:\d*\.)?\d+$/i,
	rnumnonpx = /^-?(?:\d*\.)?\d+(?!px)[^\d\s]+$/i,
	rrelNum = /^([\-+])=([\-+.\de]+)/,
	rmargin = /^margin/,

	cssShow = { position: "absolute", visibility: "hidden", display: "block" },

	// order is important!
	cssExpand = [ "Top", "Right", "Bottom", "Left" ],

	curCSS,

	getComputedStyle,
	currentStyle;

jQuery.fn.css = function( name, value ) {
	return jQuery.access( this, function( elem, name, value ) {
		return value !== undefined ?
			jQuery.style( elem, name, value ) :
			jQuery.css( elem, name );
	}, name, value, arguments.length > 1 );
};

jQuery.extend({
	// Add in style property hooks for overriding the default
	// behavior of getting and setting a style property
	cssHooks: {
		opacity: {
			get: function( elem, computed ) {
				if ( computed ) {
					// We should always get a number back from opacity
					var ret = curCSS( elem, "opacity" );
					return ret === "" ? "1" : ret;

				} else {
					return elem.style.opacity;
				}
			}
		}
	},

	// Exclude the following css properties to add px
	cssNumber: {
		"fillOpacity": true,
		"fontWeight": true,
		"lineHeight": true,
		"opacity": true,
		"orphans": true,
		"widows": true,
		"zIndex": true,
		"zoom": true
	},

	// Add in properties whose names you wish to fix before
	// setting or getting the value
	cssProps: {
		// normalize float css property
		"float": jQuery.support.cssFloat ? "cssFloat" : "styleFloat"
	},

	// Get and set the style property on a DOM Node
	style: function( elem, name, value, extra ) {
		// Don't set styles on text and comment nodes
		if ( !elem || elem.nodeType === 3 || elem.nodeType === 8 || !elem.style ) {
			return;
		}

		// Make sure that we're working with the right name
		var ret, type, origName = jQuery.camelCase( name ),
			style = elem.style, hooks = jQuery.cssHooks[ origName ];

		name = jQuery.cssProps[ origName ] || origName;

		// Check if we're setting a value
		if ( value !== undefined ) {
			type = typeof value;

			// convert relative number strings (+= or -=) to relative numbers. #7345
			if ( type === "string" && (ret = rrelNum.exec( value )) ) {
				value = ( +( ret[1] + 1) * +ret[2] ) + parseFloat( jQuery.css( elem, name ) );
				// Fixes bug #9237
				type = "number";
			}

			// Make sure that NaN and null values aren't set. See: #7116
			if ( value == null || type === "number" && isNaN( value ) ) {
				return;
			}

			// If a number was passed in, add 'px' to the (except for certain CSS properties)
			if ( type === "number" && !jQuery.cssNumber[ origName ] ) {
				value += "px";
			}

			// If a hook was provided, use that value, otherwise just set the specified value
			if ( !hooks || !("set" in hooks) || (value = hooks.set( elem, value )) !== undefined ) {
				// Wrapped to prevent IE from throwing errors when 'invalid' values are provided
				// Fixes bug #5509
				try {
					style[ name ] = value;
				} catch(e) {}
			}

		} else {
			// If a hook was provided get the non-computed value from there
			if ( hooks && "get" in hooks && (ret = hooks.get( elem, false, extra )) !== undefined ) {
				return ret;
			}

			// Otherwise just get the value from the style object
			return style[ name ];
		}
	},

	css: function( elem, name, extra ) {
		var ret, hooks;

		// Make sure that we're working with the right name
		name = jQuery.camelCase( name );
		hooks = jQuery.cssHooks[ name ];
		name = jQuery.cssProps[ name ] || name;

		// cssFloat needs a special treatment
		if ( name === "cssFloat" ) {
			name = "float";
		}

		// If a hook was provided get the computed value from there
		if ( hooks && "get" in hooks && (ret = hooks.get( elem, true, extra )) !== undefined ) {
			return ret;

		// Otherwise, if a way to get the computed value exists, use that
		} else if ( curCSS ) {
			return curCSS( elem, name );
		}
	},

	// A method for quickly swapping in/out CSS properties to get correct calculations
	swap: function( elem, options, callback ) {
		var old = {},
			ret, name;

		// Remember the old values, and insert the new ones
		for ( name in options ) {
			old[ name ] = elem.style[ name ];
			elem.style[ name ] = options[ name ];
		}

		ret = callback.call( elem );

		// Revert the old values
		for ( name in options ) {
			elem.style[ name ] = old[ name ];
		}

		return ret;
	}
});

// DEPRECATED in 1.3, Use jQuery.css() instead
jQuery.curCSS = jQuery.css;

if ( document.defaultView && document.defaultView.getComputedStyle ) {
	getComputedStyle = function( elem, name ) {
		var ret, defaultView, computedStyle, width,
			style = elem.style;

		name = name.replace( rupper, "-$1" ).toLowerCase();

		if ( (defaultView = elem.ownerDocument.defaultView) &&
				(computedStyle = defaultView.getComputedStyle( elem, null )) ) {

			ret = computedStyle.getPropertyValue( name );
			if ( ret === "" && !jQuery.contains( elem.ownerDocument.documentElement, elem ) ) {
				ret = jQuery.style( elem, name );
			}
		}

		// A tribute to the "awesome hack by Dean Edwards"
		// WebKit uses "computed value (percentage if specified)" instead of "used value" for margins
		// which is against the CSSOM draft spec: http://dev.w3.org/csswg/cssom/#resolved-values
		if ( !jQuery.support.pixelMargin && computedStyle && rmargin.test( name ) && rnumnonpx.test( ret ) ) {
			width = style.width;
			style.width = ret;
			ret = computedStyle.width;
			style.width = width;
		}

		return ret;
	};
}

if ( document.documentElement.currentStyle ) {
	currentStyle = function( elem, name ) {
		var left, rsLeft, uncomputed,
			ret = elem.currentStyle && elem.currentStyle[ name ],
			style = elem.style;

		// Avoid setting ret to empty string here
		// so we don't default to auto
		if ( ret == null && style && (uncomputed = style[ name ]) ) {
			ret = uncomputed;
		}

		// From the awesome hack by Dean Edwards
		// http://erik.eae.net/archives/2007/07/27/18.54.15/#comment-102291

		// If we're not dealing with a regular pixel number
		// but a number that has a weird ending, we need to convert it to pixels
		if ( rnumnonpx.test( ret ) ) {

			// Remember the original values
			left = style.left;
			rsLeft = elem.runtimeStyle && elem.runtimeStyle.left;

			// Put in the new values to get a computed value out
			if ( rsLeft ) {
				elem.runtimeStyle.left = elem.currentStyle.left;
			}
			style.left = name === "fontSize" ? "1em" : ret;
			ret = style.pixelLeft + "px";

			// Revert the changed values
			style.left = left;
			if ( rsLeft ) {
				elem.runtimeStyle.left = rsLeft;
			}
		}

		return ret === "" ? "auto" : ret;
	};
}

curCSS = getComputedStyle || currentStyle;

function getWidthOrHeight( elem, name, extra ) {

	// Start with offset property
	var val = name === "width" ? elem.offsetWidth : elem.offsetHeight,
		i = name === "width" ? 1 : 0,
		len = 4;

	if ( val > 0 ) {
		if ( extra !== "border" ) {
			for ( ; i < len; i += 2 ) {
				if ( !extra ) {
					val -= parseFloat( jQuery.css( elem, "padding" + cssExpand[ i ] ) ) || 0;
				}
				if ( extra === "margin" ) {
					val += parseFloat( jQuery.css( elem, extra + cssExpand[ i ] ) ) || 0;
				} else {
					val -= parseFloat( jQuery.css( elem, "border" + cssExpand[ i ] + "Width" ) ) || 0;
				}
			}
		}

		return val + "px";
	}

	// Fall back to computed then uncomputed css if necessary
	val = curCSS( elem, name );
	if ( val < 0 || val == null ) {
		val = elem.style[ name ];
	}

	// Computed unit is not pixels. Stop here and return.
	if ( rnumnonpx.test(val) ) {
		return val;
	}

	// Normalize "", auto, and prepare for extra
	val = parseFloat( val ) || 0;

	// Add padding, border, margin
	if ( extra ) {
		for ( ; i < len; i += 2 ) {
			val += parseFloat( jQuery.css( elem, "padding" + cssExpand[ i ] ) ) || 0;
			if ( extra !== "padding" ) {
				val += parseFloat( jQuery.css( elem, "border" + cssExpand[ i ] + "Width" ) ) || 0;
			}
			if ( extra === "margin" ) {
				val += parseFloat( jQuery.css( elem, extra + cssExpand[ i ]) ) || 0;
			}
		}
	}

	return val + "px";
}

jQuery.each([ "height", "width" ], function( i, name ) {
	jQuery.cssHooks[ name ] = {
		get: function( elem, computed, extra ) {
			if ( computed ) {
				if ( elem.offsetWidth !== 0 ) {
					return getWidthOrHeight( elem, name, extra );
				} else {
					return jQuery.swap( elem, cssShow, function() {
						return getWidthOrHeight( elem, name, extra );
					});
				}
			}
		},

		set: function( elem, value ) {
			return rnum.test( value ) ?
				value + "px" :
				value;
		}
	};
});

if ( !jQuery.support.opacity ) {
	jQuery.cssHooks.opacity = {
		get: function( elem, computed ) {
			// IE uses filters for opacity
			return ropacity.test( (computed && elem.currentStyle ? elem.currentStyle.filter : elem.style.filter) || "" ) ?
				( parseFloat( RegExp.$1 ) / 100 ) + "" :
				computed ? "1" : "";
		},

		set: function( elem, value ) {
			var style = elem.style,
				currentStyle = elem.currentStyle,
				opacity = jQuery.isNumeric( value ) ? "alpha(opacity=" + value * 100 + ")" : "",
				filter = currentStyle && currentStyle.filter || style.filter || "";

			// IE has trouble with opacity if it does not have layout
			// Force it by setting the zoom level
			style.zoom = 1;

			// if setting opacity to 1, and no other filters exist - attempt to remove filter attribute #6652
			if ( value >= 1 && jQuery.trim( filter.replace( ralpha, "" ) ) === "" ) {

				// Setting style.filter to null, "" & " " still leave "filter:" in the cssText
				// if "filter:" is present at all, clearType is disabled, we want to avoid this
				// style.removeAttribute is IE Only, but so apparently is this code path...
				style.removeAttribute( "filter" );

				// if there there is no filter style applied in a css rule, we are done
				if ( currentStyle && !currentStyle.filter ) {
					return;
				}
			}

			// otherwise, set new filter values
			style.filter = ralpha.test( filter ) ?
				filter.replace( ralpha, opacity ) :
				filter + " " + opacity;
		}
	};
}

jQuery(function() {
	// This hook cannot be added until DOM ready because the support test
	// for it is not run until after DOM ready
	if ( !jQuery.support.reliableMarginRight ) {
		jQuery.cssHooks.marginRight = {
			get: function( elem, computed ) {
				// WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
				// Work around by temporarily setting element display to inline-block
				return jQuery.swap( elem, { "display": "inline-block" }, function() {
					if ( computed ) {
						return curCSS( elem, "margin-right" );
					} else {
						return elem.style.marginRight;
					}
				});
			}
		};
	}
});

if ( jQuery.expr && jQuery.expr.filters ) {
	jQuery.expr.filters.hidden = function( elem ) {
		var width = elem.offsetWidth,
			height = elem.offsetHeight;

		return ( width === 0 && height === 0 ) || (!jQuery.support.reliableHiddenOffsets && ((elem.style && elem.style.display) || jQuery.css( elem, "display" )) === "none");
	};

	jQuery.expr.filters.visible = function( elem ) {
		return !jQuery.expr.filters.hidden( elem );
	};
}

// These hooks are used by animate to expand properties
jQuery.each({
	margin: "",
	padding: "",
	border: "Width"
}, function( prefix, suffix ) {

	jQuery.cssHooks[ prefix + suffix ] = {
		expand: function( value ) {
			var i,

				// assumes a single number if not a string
				parts = typeof value === "string" ? value.split(" ") : [ value ],
				expanded = {};

			for ( i = 0; i < 4; i++ ) {
				expanded[ prefix + cssExpand[ i ] + suffix ] =
					parts[ i ] || parts[ i - 2 ] || parts[ 0 ];
			}

			return expanded;
		}
	};
});




var r20 = /%20/g,
	rbracket = /\[\]$/,
	rCRLF = /\r?\n/g,
	rhash = /#.*$/,
	rheaders = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg, // IE leaves an \r character at EOL
	rinput = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,
	// #7653, #8125, #8152: local protocol detection
	rlocalProtocol = /^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/,
	rnoContent = /^(?:GET|HEAD)$/,
	rprotocol = /^\/\//,
	rquery = /\?/,
	rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
	rselectTextarea = /^(?:select|textarea)/i,
	rspacesAjax = /\s+/,
	rts = /([?&])_=[^&]*/,
	rurl = /^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+))?)?/,

	// Keep a copy of the old load method
	_load = jQuery.fn.load,

	/* Prefilters
	 * 1) They are useful to introduce custom dataTypes (see ajax/jsonp.js for an example)
	 * 2) These are called:
	 *    - BEFORE asking for a transport
	 *    - AFTER param serialization (s.data is a string if s.processData is true)
	 * 3) key is the dataType
	 * 4) the catchall symbol "*" can be used
	 * 5) execution will start with transport dataType and THEN continue down to "*" if needed
	 */
	prefilters = {},

	/* Transports bindings
	 * 1) key is the dataType
	 * 2) the catchall symbol "*" can be used
	 * 3) selection will start with transport dataType and THEN go to "*" if needed
	 */
	transports = {},

	// Document location
	ajaxLocation,

	// Document location segments
	ajaxLocParts,

	// Avoid comment-prolog char sequence (#10098); must appease lint and evade compression
	allTypes = ["*/"] + ["*"];

// #8138, IE may throw an exception when accessing
// a field from window.location if document.domain has been set
try {
	ajaxLocation = location.href;
} catch( e ) {
	// Use the href attribute of an A element
	// since IE will modify it given document.location
	ajaxLocation = document.createElement( "a" );
	ajaxLocation.href = "";
	ajaxLocation = ajaxLocation.href;
}

// Segment location into parts
ajaxLocParts = rurl.exec( ajaxLocation.toLowerCase() ) || [];

// Base "constructor" for jQuery.ajaxPrefilter and jQuery.ajaxTransport
function addToPrefiltersOrTransports( structure ) {

	// dataTypeExpression is optional and defaults to "*"
	return function( dataTypeExpression, func ) {

		if ( typeof dataTypeExpression !== "string" ) {
			func = dataTypeExpression;
			dataTypeExpression = "*";
		}

		if ( jQuery.isFunction( func ) ) {
			var dataTypes = dataTypeExpression.toLowerCase().split( rspacesAjax ),
				i = 0,
				length = dataTypes.length,
				dataType,
				list,
				placeBefore;

			// For each dataType in the dataTypeExpression
			for ( ; i < length; i++ ) {
				dataType = dataTypes[ i ];
				// We control if we're asked to add before
				// any existing element
				placeBefore = /^\+/.test( dataType );
				if ( placeBefore ) {
					dataType = dataType.substr( 1 ) || "*";
				}
				list = structure[ dataType ] = structure[ dataType ] || [];
				// then we add to the structure accordingly
				list[ placeBefore ? "unshift" : "push" ]( func );
			}
		}
	};
}

// Base inspection function for prefilters and transports
function inspectPrefiltersOrTransports( structure, options, originalOptions, jqXHR,
		dataType /* internal */, inspected /* internal */ ) {

	dataType = dataType || options.dataTypes[ 0 ];
	inspected = inspected || {};

	inspected[ dataType ] = true;

	var list = structure[ dataType ],
		i = 0,
		length = list ? list.length : 0,
		executeOnly = ( structure === prefilters ),
		selection;

	for ( ; i < length && ( executeOnly || !selection ); i++ ) {
		selection = list[ i ]( options, originalOptions, jqXHR );
		// If we got redirected to another dataType
		// we try there if executing only and not done already
		if ( typeof selection === "string" ) {
			if ( !executeOnly || inspected[ selection ] ) {
				selection = undefined;
			} else {
				options.dataTypes.unshift( selection );
				selection = inspectPrefiltersOrTransports(
						structure, options, originalOptions, jqXHR, selection, inspected );
			}
		}
	}
	// If we're only executing or nothing was selected
	// we try the catchall dataType if not done already
	if ( ( executeOnly || !selection ) && !inspected[ "*" ] ) {
		selection = inspectPrefiltersOrTransports(
				structure, options, originalOptions, jqXHR, "*", inspected );
	}
	// unnecessary when only executing (prefilters)
	// but it'll be ignored by the caller in that case
	return selection;
}

// A special extend for ajax options
// that takes "flat" options (not to be deep extended)
// Fixes #9887
function ajaxExtend( target, src ) {
	var key, deep,
		flatOptions = jQuery.ajaxSettings.flatOptions || {};
	for ( key in src ) {
		if ( src[ key ] !== undefined ) {
			( flatOptions[ key ] ? target : ( deep || ( deep = {} ) ) )[ key ] = src[ key ];
		}
	}
	if ( deep ) {
		jQuery.extend( true, target, deep );
	}
}

jQuery.fn.extend({
	load: function( url, params, callback ) {
		if ( typeof url !== "string" && _load ) {
			return _load.apply( this, arguments );

		// Don't do a request if no elements are being requested
		} else if ( !this.length ) {
			return this;
		}

		var off = url.indexOf( " " );
		if ( off >= 0 ) {
			var selector = url.slice( off, url.length );
			url = url.slice( 0, off );
		}

		// Default to a GET request
		var type = "GET";

		// If the second parameter was provided
		if ( params ) {
			// If it's a function
			if ( jQuery.isFunction( params ) ) {
				// We assume that it's the callback
				callback = params;
				params = undefined;

			// Otherwise, build a param string
			} else if ( typeof params === "object" ) {
				params = jQuery.param( params, jQuery.ajaxSettings.traditional );
				type = "POST";
			}
		}

		var self = this;

		// Request the remote document
		jQuery.ajax({
			url: url,
			type: type,
			dataType: "html",
			data: params,
			// Complete callback (responseText is used internally)
			complete: function( jqXHR, status, responseText ) {
				// Store the response as specified by the jqXHR object
				responseText = jqXHR.responseText;
				// If successful, inject the HTML into all the matched elements
				if ( jqXHR.isResolved() ) {
					// #4825: Get the actual response in case
					// a dataFilter is present in ajaxSettings
					jqXHR.done(function( r ) {
						responseText = r;
					});
					// See if a selector was specified
					self.html( selector ?
						// Create a dummy div to hold the results
						jQuery("<div>")
							// inject the contents of the document in, removing the scripts
							// to avoid any 'Permission Denied' errors in IE
							.append(responseText.replace(rscript, ""))

							// Locate the specified elements
							.find(selector) :

						// If not, just inject the full result
						responseText );
				}

				if ( callback ) {
					self.each( callback, [ responseText, status, jqXHR ] );
				}
			}
		});

		return this;
	},

	serialize: function() {
		return jQuery.param( this.serializeArray() );
	},

	serializeArray: function() {
		return this.map(function(){
			return this.elements ? jQuery.makeArray( this.elements ) : this;
		})
		.filter(function(){
			return this.name && !this.disabled &&
				( this.checked || rselectTextarea.test( this.nodeName ) ||
					rinput.test( this.type ) );
		})
		.map(function( i, elem ){
			var val = jQuery( this ).val();

			return val == null ?
				null :
				jQuery.isArray( val ) ?
					jQuery.map( val, function( val, i ){
						return { name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
					}) :
					{ name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
		}).get();
	}
});

// Attach a bunch of functions for handling common AJAX events
jQuery.each( "ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split( " " ), function( i, o ){
	jQuery.fn[ o ] = function( f ){
		return this.on( o, f );
	};
});

jQuery.each( [ "get", "post" ], function( i, method ) {
	jQuery[ method ] = function( url, data, callback, type ) {
		// shift arguments if data argument was omitted
		if ( jQuery.isFunction( data ) ) {
			type = type || callback;
			callback = data;
			data = undefined;
		}

		return jQuery.ajax({
			type: method,
			url: url,
			data: data,
			success: callback,
			dataType: type
		});
	};
});

jQuery.extend({

	getScript: function( url, callback ) {
		return jQuery.get( url, undefined, callback, "script" );
	},

	getJSON: function( url, data, callback ) {
		return jQuery.get( url, data, callback, "json" );
	},

	// Creates a full fledged settings object into target
	// with both ajaxSettings and settings fields.
	// If target is omitted, writes into ajaxSettings.
	ajaxSetup: function( target, settings ) {
		if ( settings ) {
			// Building a settings object
			ajaxExtend( target, jQuery.ajaxSettings );
		} else {
			// Extending ajaxSettings
			settings = target;
			target = jQuery.ajaxSettings;
		}
		ajaxExtend( target, settings );
		return target;
	},

	ajaxSettings: {
		url: ajaxLocation,
		isLocal: rlocalProtocol.test( ajaxLocParts[ 1 ] ),
		global: true,
		type: "GET",
		contentType: "application/x-www-form-urlencoded; charset=UTF-8",
		processData: true,
		async: true,
		/*
		timeout: 0,
		data: null,
		dataType: null,
		username: null,
		password: null,
		cache: null,
		traditional: false,
		headers: {},
		*/

		accepts: {
			xml: "application/xml, text/xml",
			html: "text/html",
			text: "text/plain",
			json: "application/json, text/javascript",
			"*": allTypes
		},

		contents: {
			xml: /xml/,
			html: /html/,
			json: /json/
		},

		responseFields: {
			xml: "responseXML",
			text: "responseText"
		},

		// List of data converters
		// 1) key format is "source_type destination_type" (a single space in-between)
		// 2) the catchall symbol "*" can be used for source_type
		converters: {

			// Convert anything to text
			"* text": window.String,

			// Text to html (true = no transformation)
			"text html": true,

			// Evaluate text as a json expression
			"text json": jQuery.parseJSON,

			// Parse text as xml
			"text xml": jQuery.parseXML
		},

		// For options that shouldn't be deep extended:
		// you can add your own custom options here if
		// and when you create one that shouldn't be
		// deep extended (see ajaxExtend)
		flatOptions: {
			context: true,
			url: true
		}
	},

	ajaxPrefilter: addToPrefiltersOrTransports( prefilters ),
	ajaxTransport: addToPrefiltersOrTransports( transports ),

	// Main method
	ajax: function( url, options ) {

		// If url is an object, simulate pre-1.5 signature
		if ( typeof url === "object" ) {
			options = url;
			url = undefined;
		}

		// Force options to be an object
		options = options || {};

		var // Create the final options object
			s = jQuery.ajaxSetup( {}, options ),
			// Callbacks context
			callbackContext = s.context || s,
			// Context for global events
			// It's the callbackContext if one was provided in the options
			// and if it's a DOM node or a jQuery collection
			globalEventContext = callbackContext !== s &&
				( callbackContext.nodeType || callbackContext instanceof jQuery ) ?
						jQuery( callbackContext ) : jQuery.event,
			// Deferreds
			deferred = jQuery.Deferred(),
			completeDeferred = jQuery.Callbacks( "once memory" ),
			// Status-dependent callbacks
			statusCode = s.statusCode || {},
			// ifModified key
			ifModifiedKey,
			// Headers (they are sent all at once)
			requestHeaders = {},
			requestHeadersNames = {},
			// Response headers
			responseHeadersString,
			responseHeaders,
			// transport
			transport,
			// timeout handle
			timeoutTimer,
			// Cross-domain detection vars
			parts,
			// The jqXHR state
			state = 0,
			// To know if global events are to be dispatched
			fireGlobals,
			// Loop variable
			i,
			// Fake xhr
			jqXHR = {

				readyState: 0,

				// Caches the header
				setRequestHeader: function( name, value ) {
					if ( !state ) {
						var lname = name.toLowerCase();
						name = requestHeadersNames[ lname ] = requestHeadersNames[ lname ] || name;
						requestHeaders[ name ] = value;
					}
					return this;
				},

				// Raw string
				getAllResponseHeaders: function() {
					return state === 2 ? responseHeadersString : null;
				},

				// Builds headers hashtable if needed
				getResponseHeader: function( key ) {
					var match;
					if ( state === 2 ) {
						if ( !responseHeaders ) {
							responseHeaders = {};
							while( ( match = rheaders.exec( responseHeadersString ) ) ) {
								responseHeaders[ match[1].toLowerCase() ] = match[ 2 ];
							}
						}
						match = responseHeaders[ key.toLowerCase() ];
					}
					return match === undefined ? null : match;
				},

				// Overrides response content-type header
				overrideMimeType: function( type ) {
					if ( !state ) {
						s.mimeType = type;
					}
					return this;
				},

				// Cancel the request
				abort: function( statusText ) {
					statusText = statusText || "abort";
					if ( transport ) {
						transport.abort( statusText );
					}
					done( 0, statusText );
					return this;
				}
			};

		// Callback for when everything is done
		// It is defined here because jslint complains if it is declared
		// at the end of the function (which would be more logical and readable)
		function done( status, nativeStatusText, responses, headers ) {

			// Called once
			if ( state === 2 ) {
				return;
			}

			// State is "done" now
			state = 2;

			// Clear timeout if it exists
			if ( timeoutTimer ) {
				clearTimeout( timeoutTimer );
			}

			// Dereference transport for early garbage collection
			// (no matter how long the jqXHR object will be used)
			transport = undefined;

			// Cache response headers
			responseHeadersString = headers || "";

			// Set readyState
			jqXHR.readyState = status > 0 ? 4 : 0;

			var isSuccess,
				success,
				error,
				statusText = nativeStatusText,
				response = responses ? ajaxHandleResponses( s, jqXHR, responses ) : undefined,
				lastModified,
				etag;

			// If successful, handle type chaining
			if ( status >= 200 && status < 300 || status === 304 ) {

				// Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
				if ( s.ifModified ) {

					if ( ( lastModified = jqXHR.getResponseHeader( "Last-Modified" ) ) ) {
						jQuery.lastModified[ ifModifiedKey ] = lastModified;
					}
					if ( ( etag = jqXHR.getResponseHeader( "Etag" ) ) ) {
						jQuery.etag[ ifModifiedKey ] = etag;
					}
				}

				// If not modified
				if ( status === 304 ) {

					statusText = "notmodified";
					isSuccess = true;

				// If we have data
				} else {

					try {
						success = ajaxConvert( s, response );
						statusText = "success";
						isSuccess = true;
					} catch(e) {
						// We have a parsererror
						statusText = "parsererror";
						error = e;
					}
				}
			} else {
				// We extract error from statusText
				// then normalize statusText and status for non-aborts
				error = statusText;
				if ( !statusText || status ) {
					statusText = "error";
					if ( status < 0 ) {
						status = 0;
					}
				}
			}

			// Set data for the fake xhr object
			jqXHR.status = status;
			jqXHR.statusText = "" + ( nativeStatusText || statusText );

			// Success/Error
			if ( isSuccess ) {
				deferred.resolveWith( callbackContext, [ success, statusText, jqXHR ] );
			} else {
				deferred.rejectWith( callbackContext, [ jqXHR, statusText, error ] );
			}

			// Status-dependent callbacks
			jqXHR.statusCode( statusCode );
			statusCode = undefined;

			if ( fireGlobals ) {
				globalEventContext.trigger( "ajax" + ( isSuccess ? "Success" : "Error" ),
						[ jqXHR, s, isSuccess ? success : error ] );
			}

			// Complete
			completeDeferred.fireWith( callbackContext, [ jqXHR, statusText ] );

			if ( fireGlobals ) {
				globalEventContext.trigger( "ajaxComplete", [ jqXHR, s ] );
				// Handle the global AJAX counter
				if ( !( --jQuery.active ) ) {
					jQuery.event.trigger( "ajaxStop" );
				}
			}
		}

		// Attach deferreds
		deferred.promise( jqXHR );
		jqXHR.success = jqXHR.done;
		jqXHR.error = jqXHR.fail;
		jqXHR.complete = completeDeferred.add;

		// Status-dependent callbacks
		jqXHR.statusCode = function( map ) {
			if ( map ) {
				var tmp;
				if ( state < 2 ) {
					for ( tmp in map ) {
						statusCode[ tmp ] = [ statusCode[tmp], map[tmp] ];
					}
				} else {
					tmp = map[ jqXHR.status ];
					jqXHR.then( tmp, tmp );
				}
			}
			return this;
		};

		// Remove hash character (#7531: and string promotion)
		// Add protocol if not provided (#5866: IE7 issue with protocol-less urls)
		// We also use the url parameter if available
		s.url = ( ( url || s.url ) + "" ).replace( rhash, "" ).replace( rprotocol, ajaxLocParts[ 1 ] + "//" );

		// Extract dataTypes list
		s.dataTypes = jQuery.trim( s.dataType || "*" ).toLowerCase().split( rspacesAjax );

		// Determine if a cross-domain request is in order
		if ( s.crossDomain == null ) {
			parts = rurl.exec( s.url.toLowerCase() );
			s.crossDomain = !!( parts &&
				( parts[ 1 ] != ajaxLocParts[ 1 ] || parts[ 2 ] != ajaxLocParts[ 2 ] ||
					( parts[ 3 ] || ( parts[ 1 ] === "http:" ? 80 : 443 ) ) !=
						( ajaxLocParts[ 3 ] || ( ajaxLocParts[ 1 ] === "http:" ? 80 : 443 ) ) )
			);
		}

		// Convert data if not already a string
		if ( s.data && s.processData && typeof s.data !== "string" ) {
			s.data = jQuery.param( s.data, s.traditional );
		}

		// Apply prefilters
		inspectPrefiltersOrTransports( prefilters, s, options, jqXHR );

		// If request was aborted inside a prefilter, stop there
		if ( state === 2 ) {
			return false;
		}

		// We can fire global events as of now if asked to
		fireGlobals = s.global;

		// Uppercase the type
		s.type = s.type.toUpperCase();

		// Determine if request has content
		s.hasContent = !rnoContent.test( s.type );

		// Watch for a new set of requests
		if ( fireGlobals && jQuery.active++ === 0 ) {
			jQuery.event.trigger( "ajaxStart" );
		}

		// More options handling for requests with no content
		if ( !s.hasContent ) {

			// If data is available, append data to url
			if ( s.data ) {
				s.url += ( rquery.test( s.url ) ? "&" : "?" ) + s.data;
				// #9682: remove data so that it's not used in an eventual retry
				delete s.data;
			}

			// Get ifModifiedKey before adding the anti-cache parameter
			ifModifiedKey = s.url;

			// Add anti-cache in url if needed
			if ( s.cache === false ) {

				var ts = jQuery.now(),
					// try replacing _= if it is there
					ret = s.url.replace( rts, "$1_=" + ts );

				// if nothing was replaced, add timestamp to the end
				s.url = ret + ( ( ret === s.url ) ? ( rquery.test( s.url ) ? "&" : "?" ) + "_=" + ts : "" );
			}
		}

		// Set the correct header, if data is being sent
		if ( s.data && s.hasContent && s.contentType !== false || options.contentType ) {
			jqXHR.setRequestHeader( "Content-Type", s.contentType );
		}

		// Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
		if ( s.ifModified ) {
			ifModifiedKey = ifModifiedKey || s.url;
			if ( jQuery.lastModified[ ifModifiedKey ] ) {
				jqXHR.setRequestHeader( "If-Modified-Since", jQuery.lastModified[ ifModifiedKey ] );
			}
			if ( jQuery.etag[ ifModifiedKey ] ) {
				jqXHR.setRequestHeader( "If-None-Match", jQuery.etag[ ifModifiedKey ] );
			}
		}

		// Set the Accepts header for the server, depending on the dataType
		jqXHR.setRequestHeader(
			"Accept",
			s.dataTypes[ 0 ] && s.accepts[ s.dataTypes[0] ] ?
				s.accepts[ s.dataTypes[0] ] + ( s.dataTypes[ 0 ] !== "*" ? ", " + allTypes + "; q=0.01" : "" ) :
				s.accepts[ "*" ]
		);

		// Check for headers option
		for ( i in s.headers ) {
			jqXHR.setRequestHeader( i, s.headers[ i ] );
		}

		// Allow custom headers/mimetypes and early abort
		if ( s.beforeSend && ( s.beforeSend.call( callbackContext, jqXHR, s ) === false || state === 2 ) ) {
				// Abort if not done already
				jqXHR.abort();
				return false;

		}

		// Install callbacks on deferreds
		for ( i in { success: 1, error: 1, complete: 1 } ) {
			jqXHR[ i ]( s[ i ] );
		}

		// Get transport
		transport = inspectPrefiltersOrTransports( transports, s, options, jqXHR );

		// If no transport, we auto-abort
		if ( !transport ) {
			done( -1, "No Transport" );
		} else {
			jqXHR.readyState = 1;
			// Send global event
			if ( fireGlobals ) {
				globalEventContext.trigger( "ajaxSend", [ jqXHR, s ] );
			}
			// Timeout
			if ( s.async && s.timeout > 0 ) {
				timeoutTimer = setTimeout( function(){
					jqXHR.abort( "timeout" );
				}, s.timeout );
			}

			try {
				state = 1;
				transport.send( requestHeaders, done );
			} catch (e) {
				// Propagate exception as error if not done
				if ( state < 2 ) {
					done( -1, e );
				// Simply rethrow otherwise
				} else {
					throw e;
				}
			}
		}

		return jqXHR;
	},

	// Serialize an array of form elements or a set of
	// key/values into a query string
	param: function( a, traditional ) {
		var s = [],
			add = function( key, value ) {
				// If value is a function, invoke it and return its value
				value = jQuery.isFunction( value ) ? value() : value;
				s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
			};

		// Set traditional to true for jQuery <= 1.3.2 behavior.
		if ( traditional === undefined ) {
			traditional = jQuery.ajaxSettings.traditional;
		}

		// If an array was passed in, assume that it is an array of form elements.
		if ( jQuery.isArray( a ) || ( a.jquery && !jQuery.isPlainObject( a ) ) ) {
			// Serialize the form elements
			jQuery.each( a, function() {
				add( this.name, this.value );
			});

		} else {
			// If traditional, encode the "old" way (the way 1.3.2 or older
			// did it), otherwise encode params recursively.
			for ( var prefix in a ) {
				buildParams( prefix, a[ prefix ], traditional, add );
			}
		}

		// Return the resulting serialization
		return s.join( "&" ).replace( r20, "+" );
	}
});

function buildParams( prefix, obj, traditional, add ) {
	if ( jQuery.isArray( obj ) ) {
		// Serialize array item.
		jQuery.each( obj, function( i, v ) {
			if ( traditional || rbracket.test( prefix ) ) {
				// Treat each array item as a scalar.
				add( prefix, v );

			} else {
				// If array item is non-scalar (array or object), encode its
				// numeric index to resolve deserialization ambiguity issues.
				// Note that rack (as of 1.0.0) can't currently deserialize
				// nested arrays properly, and attempting to do so may cause
				// a server error. Possible fixes are to modify rack's
				// deserialization algorithm or to provide an option or flag
				// to force array serialization to be shallow.
				buildParams( prefix + "[" + ( typeof v === "object" ? i : "" ) + "]", v, traditional, add );
			}
		});

	} else if ( !traditional && jQuery.type( obj ) === "object" ) {
		// Serialize object item.
		for ( var name in obj ) {
			buildParams( prefix + "[" + name + "]", obj[ name ], traditional, add );
		}

	} else {
		// Serialize scalar item.
		add( prefix, obj );
	}
}

// This is still on the jQuery object... for now
// Want to move this to jQuery.ajax some day
jQuery.extend({

	// Counter for holding the number of active queries
	active: 0,

	// Last-Modified header cache for next request
	lastModified: {},
	etag: {}

});

/* Handles responses to an ajax request:
 * - sets all responseXXX fields accordingly
 * - finds the right dataType (mediates between content-type and expected dataType)
 * - returns the corresponding response
 */
function ajaxHandleResponses( s, jqXHR, responses ) {

	var contents = s.contents,
		dataTypes = s.dataTypes,
		responseFields = s.responseFields,
		ct,
		type,
		finalDataType,
		firstDataType;

	// Fill responseXXX fields
	for ( type in responseFields ) {
		if ( type in responses ) {
			jqXHR[ responseFields[type] ] = responses[ type ];
		}
	}

	// Remove auto dataType and get content-type in the process
	while( dataTypes[ 0 ] === "*" ) {
		dataTypes.shift();
		if ( ct === undefined ) {
			ct = s.mimeType || jqXHR.getResponseHeader( "content-type" );
		}
	}

	// Check if we're dealing with a known content-type
	if ( ct ) {
		for ( type in contents ) {
			if ( contents[ type ] && contents[ type ].test( ct ) ) {
				dataTypes.unshift( type );
				break;
			}
		}
	}

	// Check to see if we have a response for the expected dataType
	if ( dataTypes[ 0 ] in responses ) {
		finalDataType = dataTypes[ 0 ];
	} else {
		// Try convertible dataTypes
		for ( type in responses ) {
			if ( !dataTypes[ 0 ] || s.converters[ type + " " + dataTypes[0] ] ) {
				finalDataType = type;
				break;
			}
			if ( !firstDataType ) {
				firstDataType = type;
			}
		}
		// Or just use first one
		finalDataType = finalDataType || firstDataType;
	}

	// If we found a dataType
	// We add the dataType to the list if needed
	// and return the corresponding response
	if ( finalDataType ) {
		if ( finalDataType !== dataTypes[ 0 ] ) {
			dataTypes.unshift( finalDataType );
		}
		return responses[ finalDataType ];
	}
}

// Chain conversions given the request and the original response
function ajaxConvert( s, response ) {

	// Apply the dataFilter if provided
	if ( s.dataFilter ) {
		response = s.dataFilter( response, s.dataType );
	}

	var dataTypes = s.dataTypes,
		converters = {},
		i,
		key,
		length = dataTypes.length,
		tmp,
		// Current and previous dataTypes
		current = dataTypes[ 0 ],
		prev,
		// Conversion expression
		conversion,
		// Conversion function
		conv,
		// Conversion functions (transitive conversion)
		conv1,
		conv2;

	// For each dataType in the chain
	for ( i = 1; i < length; i++ ) {

		// Create converters map
		// with lowercased keys
		if ( i === 1 ) {
			for ( key in s.converters ) {
				if ( typeof key === "string" ) {
					converters[ key.toLowerCase() ] = s.converters[ key ];
				}
			}
		}

		// Get the dataTypes
		prev = current;
		current = dataTypes[ i ];

		// If current is auto dataType, update it to prev
		if ( current === "*" ) {
			current = prev;
		// If no auto and dataTypes are actually different
		} else if ( prev !== "*" && prev !== current ) {

			// Get the converter
			conversion = prev + " " + current;
			conv = converters[ conversion ] || converters[ "* " + current ];

			// If there is no direct converter, search transitively
			if ( !conv ) {
				conv2 = undefined;
				for ( conv1 in converters ) {
					tmp = conv1.split( " " );
					if ( tmp[ 0 ] === prev || tmp[ 0 ] === "*" ) {
						conv2 = converters[ tmp[1] + " " + current ];
						if ( conv2 ) {
							conv1 = converters[ conv1 ];
							if ( conv1 === true ) {
								conv = conv2;
							} else if ( conv2 === true ) {
								conv = conv1;
							}
							break;
						}
					}
				}
			}
			// If we found no converter, dispatch an error
			if ( !( conv || conv2 ) ) {
				jQuery.error( "No conversion from " + conversion.replace(" "," to ") );
			}
			// If found converter is not an equivalence
			if ( conv !== true ) {
				// Convert with 1 or 2 converters accordingly
				response = conv ? conv( response ) : conv2( conv1(response) );
			}
		}
	}
	return response;
}




var jsc = jQuery.now(),
	jsre = /(\=)\?(&|$)|\?\?/i;

// Default jsonp settings
jQuery.ajaxSetup({
	jsonp: "callback",
	jsonpCallback: function() {
		return jQuery.expando + "_" + ( jsc++ );
	}
});

// Detect, normalize options and install callbacks for jsonp requests
jQuery.ajaxPrefilter( "json jsonp", function( s, originalSettings, jqXHR ) {

	var inspectData = ( typeof s.data === "string" ) && /^application\/x\-www\-form\-urlencoded/.test( s.contentType );

	if ( s.dataTypes[ 0 ] === "jsonp" ||
		s.jsonp !== false && ( jsre.test( s.url ) ||
				inspectData && jsre.test( s.data ) ) ) {

		var responseContainer,
			jsonpCallback = s.jsonpCallback =
				jQuery.isFunction( s.jsonpCallback ) ? s.jsonpCallback() : s.jsonpCallback,
			previous = window[ jsonpCallback ],
			url = s.url,
			data = s.data,
			replace = "$1" + jsonpCallback + "$2";

		if ( s.jsonp !== false ) {
			url = url.replace( jsre, replace );
			if ( s.url === url ) {
				if ( inspectData ) {
					data = data.replace( jsre, replace );
				}
				if ( s.data === data ) {
					// Add callback manually
					url += (/\?/.test( url ) ? "&" : "?") + s.jsonp + "=" + jsonpCallback;
				}
			}
		}

		s.url = url;
		s.data = data;

		// Install callback
		window[ jsonpCallback ] = function( response ) {
			responseContainer = [ response ];
		};

		// Clean-up function
		jqXHR.always(function() {
			// Set callback back to previous value
			window[ jsonpCallback ] = previous;
			// Call if it was a function and we have a response
			if ( responseContainer && jQuery.isFunction( previous ) ) {
				window[ jsonpCallback ]( responseContainer[ 0 ] );
			}
		});

		// Use data converter to retrieve json after script execution
		s.converters["script json"] = function() {
			if ( !responseContainer ) {
				jQuery.error( jsonpCallback + " was not called" );
			}
			return responseContainer[ 0 ];
		};

		// force json dataType
		s.dataTypes[ 0 ] = "json";

		// Delegate to script
		return "script";
	}
});




// Install script dataType
jQuery.ajaxSetup({
	accepts: {
		script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
	},
	contents: {
		script: /javascript|ecmascript/
	},
	converters: {
		"text script": function( text ) {
			jQuery.globalEval( text );
			return text;
		}
	}
});

// Handle cache's special case and global
jQuery.ajaxPrefilter( "script", function( s ) {
	if ( s.cache === undefined ) {
		s.cache = false;
	}
	if ( s.crossDomain ) {
		s.type = "GET";
		s.global = false;
	}
});

// Bind script tag hack transport
jQuery.ajaxTransport( "script", function(s) {

	// This transport only deals with cross domain requests
	if ( s.crossDomain ) {

		var script,
			head = document.head || document.getElementsByTagName( "head" )[0] || document.documentElement;

		return {

			send: function( _, callback ) {

				script = document.createElement( "script" );

				script.async = "async";

				if ( s.scriptCharset ) {
					script.charset = s.scriptCharset;
				}

				script.src = s.url;

				// Attach handlers for all browsers
				script.onload = script.onreadystatechange = function( _, isAbort ) {

					if ( isAbort || !script.readyState || /loaded|complete/.test( script.readyState ) ) {

						// Handle memory leak in IE
						script.onload = script.onreadystatechange = null;

						// Remove the script
						if ( head && script.parentNode ) {
							head.removeChild( script );
						}

						// Dereference the script
						script = undefined;

						// Callback if not abort
						if ( !isAbort ) {
							callback( 200, "success" );
						}
					}
				};
				// Use insertBefore instead of appendChild  to circumvent an IE6 bug.
				// This arises when a base node is used (#2709 and #4378).
				head.insertBefore( script, head.firstChild );
			},

			abort: function() {
				if ( script ) {
					script.onload( 0, 1 );
				}
			}
		};
	}
});




var // #5280: Internet Explorer will keep connections alive if we don't abort on unload
	xhrOnUnloadAbort = window.ActiveXObject ? function() {
		// Abort all pending requests
		for ( var key in xhrCallbacks ) {
			xhrCallbacks[ key ]( 0, 1 );
		}
	} : false,
	xhrId = 0,
	xhrCallbacks;

// Functions to create xhrs
function createStandardXHR() {
	try {
		return new window.XMLHttpRequest();
	} catch( e ) {}
}

function createActiveXHR() {
	try {
		return new window.ActiveXObject( "Microsoft.XMLHTTP" );
	} catch( e ) {}
}

// Create the request object
// (This is still attached to ajaxSettings for backward compatibility)
jQuery.ajaxSettings.xhr = window.ActiveXObject ?
	/* Microsoft failed to properly
	 * implement the XMLHttpRequest in IE7 (can't request local files),
	 * so we use the ActiveXObject when it is available
	 * Additionally XMLHttpRequest can be disabled in IE7/IE8 so
	 * we need a fallback.
	 */
	function() {
		return !this.isLocal && createStandardXHR() || createActiveXHR();
	} :
	// For all other browsers, use the standard XMLHttpRequest object
	createStandardXHR;

// Determine support properties
(function( xhr ) {
	jQuery.extend( jQuery.support, {
		ajax: !!xhr,
		cors: !!xhr && ( "withCredentials" in xhr )
	});
})( jQuery.ajaxSettings.xhr() );

// Create transport if the browser can provide an xhr
if ( jQuery.support.ajax ) {

	jQuery.ajaxTransport(function( s ) {
		// Cross domain only allowed if supported through XMLHttpRequest
		if ( !s.crossDomain || jQuery.support.cors ) {

			var callback;

			return {
				send: function( headers, complete ) {

					// Get a new xhr
					var xhr = s.xhr(),
						handle,
						i;

					// Open the socket
					// Passing null username, generates a login popup on Opera (#2865)
					if ( s.username ) {
						xhr.open( s.type, s.url, s.async, s.username, s.password );
					} else {
						xhr.open( s.type, s.url, s.async );
					}

					// Apply custom fields if provided
					if ( s.xhrFields ) {
						for ( i in s.xhrFields ) {
							xhr[ i ] = s.xhrFields[ i ];
						}
					}

					// Override mime type if needed
					if ( s.mimeType && xhr.overrideMimeType ) {
						xhr.overrideMimeType( s.mimeType );
					}

					// X-Requested-With header
					// For cross-domain requests, seeing as conditions for a preflight are
					// akin to a jigsaw puzzle, we simply never set it to be sure.
					// (it can always be set on a per-request basis or even using ajaxSetup)
					// For same-domain requests, won't change header if already provided.
					if ( !s.crossDomain && !headers["X-Requested-With"] ) {
						headers[ "X-Requested-With" ] = "XMLHttpRequest";
					}

					// Need an extra try/catch for cross domain requests in Firefox 3
					try {
						for ( i in headers ) {
							xhr.setRequestHeader( i, headers[ i ] );
						}
					} catch( _ ) {}

					// Do send the request
					// This may raise an exception which is actually
					// handled in jQuery.ajax (so no try/catch here)
					xhr.send( ( s.hasContent && s.data ) || null );

					// Listener
					callback = function( _, isAbort ) {

						var status,
							statusText,
							responseHeaders,
							responses,
							xml;

						// Firefox throws exceptions when accessing properties
						// of an xhr when a network error occured
						// http://helpful.knobs-dials.com/index.php/Component_returned_failure_code:_0x80040111_(NS_ERROR_NOT_AVAILABLE)
						try {

							// Was never called and is aborted or complete
							if ( callback && ( isAbort || xhr.readyState === 4 ) ) {

								// Only called once
								callback = undefined;

								// Do not keep as active anymore
								if ( handle ) {
									xhr.onreadystatechange = jQuery.noop;
									if ( xhrOnUnloadAbort ) {
										delete xhrCallbacks[ handle ];
									}
								}

								// If it's an abort
								if ( isAbort ) {
									// Abort it manually if needed
									if ( xhr.readyState !== 4 ) {
										xhr.abort();
									}
								} else {
									status = xhr.status;
									responseHeaders = xhr.getAllResponseHeaders();
									responses = {};
									xml = xhr.responseXML;

									// Construct response list
									if ( xml && xml.documentElement /* #4958 */ ) {
										responses.xml = xml;
									}

									// When requesting binary data, IE6-9 will throw an exception
									// on any attempt to access responseText (#11426)
									try {
										responses.text = xhr.responseText;
									} catch( _ ) {
									}

									// Firefox throws an exception when accessing
									// statusText for faulty cross-domain requests
									try {
										statusText = xhr.statusText;
									} catch( e ) {
										// We normalize with Webkit giving an empty statusText
										statusText = "";
									}

									// Filter status for non standard behaviors

									// If the request is local and we have data: assume a success
									// (success with no data won't get notified, that's the best we
									// can do given current implementations)
									if ( !status && s.isLocal && !s.crossDomain ) {
										status = responses.text ? 200 : 404;
									// IE - #1450: sometimes returns 1223 when it should be 204
									} else if ( status === 1223 ) {
										status = 204;
									}
								}
							}
						} catch( firefoxAccessException ) {
							if ( !isAbort ) {
								complete( -1, firefoxAccessException );
							}
						}

						// Call complete if needed
						if ( responses ) {
							complete( status, statusText, responses, responseHeaders );
						}
					};

					// if we're in sync mode or it's in cache
					// and has been retrieved directly (IE6 & IE7)
					// we need to manually fire the callback
					if ( !s.async || xhr.readyState === 4 ) {
						callback();
					} else {
						handle = ++xhrId;
						if ( xhrOnUnloadAbort ) {
							// Create the active xhrs callbacks list if needed
							// and attach the unload handler
							if ( !xhrCallbacks ) {
								xhrCallbacks = {};
								jQuery( window ).unload( xhrOnUnloadAbort );
							}
							// Add to list of active xhrs callbacks
							xhrCallbacks[ handle ] = callback;
						}
						xhr.onreadystatechange = callback;
					}
				},

				abort: function() {
					if ( callback ) {
						callback(0,1);
					}
				}
			};
		}
	});
}




var elemdisplay = {},
	iframe, iframeDoc,
	rfxtypes = /^(?:toggle|show|hide)$/,
	rfxnum = /^([+\-]=)?([\d+.\-]+)([a-z%]*)$/i,
	timerId,
	fxAttrs = [
		// height animations
		[ "height", "marginTop", "marginBottom", "paddingTop", "paddingBottom" ],
		// width animations
		[ "width", "marginLeft", "marginRight", "paddingLeft", "paddingRight" ],
		// opacity animations
		[ "opacity" ]
	],
	fxNow;

jQuery.fn.extend({
	show: function( speed, easing, callback ) {
		var elem, display;

		if ( speed || speed === 0 ) {
			return this.animate( genFx("show", 3), speed, easing, callback );

		} else {
			for ( var i = 0, j = this.length; i < j; i++ ) {
				elem = this[ i ];

				if ( elem.style ) {
					display = elem.style.display;

					// Reset the inline display of this element to learn if it is
					// being hidden by cascaded rules or not
					if ( !jQuery._data(elem, "olddisplay") && display === "none" ) {
						display = elem.style.display = "";
					}

					// Set elements which have been overridden with display: none
					// in a stylesheet to whatever the default browser style is
					// for such an element
					if ( (display === "" && jQuery.css(elem, "display") === "none") ||
						!jQuery.contains( elem.ownerDocument.documentElement, elem ) ) {
						jQuery._data( elem, "olddisplay", defaultDisplay(elem.nodeName) );
					}
				}
			}

			// Set the display of most of the elements in a second loop
			// to avoid the constant reflow
			for ( i = 0; i < j; i++ ) {
				elem = this[ i ];

				if ( elem.style ) {
					display = elem.style.display;

					if ( display === "" || display === "none" ) {
						elem.style.display = jQuery._data( elem, "olddisplay" ) || "";
					}
				}
			}

			return this;
		}
	},

	hide: function( speed, easing, callback ) {
		if ( speed || speed === 0 ) {
			return this.animate( genFx("hide", 3), speed, easing, callback);

		} else {
			var elem, display,
				i = 0,
				j = this.length;

			for ( ; i < j; i++ ) {
				elem = this[i];
				if ( elem.style ) {
					display = jQuery.css( elem, "display" );

					if ( display !== "none" && !jQuery._data( elem, "olddisplay" ) ) {
						jQuery._data( elem, "olddisplay", display );
					}
				}
			}

			// Set the display of the elements in a second loop
			// to avoid the constant reflow
			for ( i = 0; i < j; i++ ) {
				if ( this[i].style ) {
					this[i].style.display = "none";
				}
			}

			return this;
		}
	},

	// Save the old toggle function
	_toggle: jQuery.fn.toggle,

	toggle: function( fn, fn2, callback ) {
		var bool = typeof fn === "boolean";

		if ( jQuery.isFunction(fn) && jQuery.isFunction(fn2) ) {
			this._toggle.apply( this, arguments );

		} else if ( fn == null || bool ) {
			this.each(function() {
				var state = bool ? fn : jQuery(this).is(":hidden");
				jQuery(this)[ state ? "show" : "hide" ]();
			});

		} else {
			this.animate(genFx("toggle", 3), fn, fn2, callback);
		}

		return this;
	},

	fadeTo: function( speed, to, easing, callback ) {
		return this.filter(":hidden").css("opacity", 0).show().end()
					.animate({opacity: to}, speed, easing, callback);
	},

	animate: function( prop, speed, easing, callback ) {
		var optall = jQuery.speed( speed, easing, callback );

		if ( jQuery.isEmptyObject( prop ) ) {
			return this.each( optall.complete, [ false ] );
		}

		// Do not change referenced properties as per-property easing will be lost
		prop = jQuery.extend( {}, prop );

		function doAnimation() {
			// XXX 'this' does not always have a nodeName when running the
			// test suite

			if ( optall.queue === false ) {
				jQuery._mark( this );
			}

			var opt = jQuery.extend( {}, optall ),
				isElement = this.nodeType === 1,
				hidden = isElement && jQuery(this).is(":hidden"),
				name, val, p, e, hooks, replace,
				parts, start, end, unit,
				method;

			// will store per property easing and be used to determine when an animation is complete
			opt.animatedProperties = {};

			// first pass over propertys to expand / normalize
			for ( p in prop ) {
				name = jQuery.camelCase( p );
				if ( p !== name ) {
					prop[ name ] = prop[ p ];
					delete prop[ p ];
				}

				if ( ( hooks = jQuery.cssHooks[ name ] ) && "expand" in hooks ) {
					replace = hooks.expand( prop[ name ] );
					delete prop[ name ];

					// not quite $.extend, this wont overwrite keys already present.
					// also - reusing 'p' from above because we have the correct "name"
					for ( p in replace ) {
						if ( ! ( p in prop ) ) {
							prop[ p ] = replace[ p ];
						}
					}
				}
			}

			for ( name in prop ) {
				val = prop[ name ];
				// easing resolution: per property > opt.specialEasing > opt.easing > 'swing' (default)
				if ( jQuery.isArray( val ) ) {
					opt.animatedProperties[ name ] = val[ 1 ];
					val = prop[ name ] = val[ 0 ];
				} else {
					opt.animatedProperties[ name ] = opt.specialEasing && opt.specialEasing[ name ] || opt.easing || 'swing';
				}

				if ( val === "hide" && hidden || val === "show" && !hidden ) {
					return opt.complete.call( this );
				}

				if ( isElement && ( name === "height" || name === "width" ) ) {
					// Make sure that nothing sneaks out
					// Record all 3 overflow attributes because IE does not
					// change the overflow attribute when overflowX and
					// overflowY are set to the same value
					opt.overflow = [ this.style.overflow, this.style.overflowX, this.style.overflowY ];

					// Set display property to inline-block for height/width
					// animations on inline elements that are having width/height animated
					if ( jQuery.css( this, "display" ) === "inline" &&
							jQuery.css( this, "float" ) === "none" ) {

						// inline-level elements accept inline-block;
						// block-level elements need to be inline with layout
						if ( !jQuery.support.inlineBlockNeedsLayout || defaultDisplay( this.nodeName ) === "inline" ) {
							this.style.display = "inline-block";

						} else {
							this.style.zoom = 1;
						}
					}
				}
			}

			if ( opt.overflow != null ) {
				this.style.overflow = "hidden";
			}

			for ( p in prop ) {
				e = new jQuery.fx( this, opt, p );
				val = prop[ p ];

				if ( rfxtypes.test( val ) ) {

					// Tracks whether to show or hide based on private
					// data attached to the element
					method = jQuery._data( this, "toggle" + p ) || ( val === "toggle" ? hidden ? "show" : "hide" : 0 );
					if ( method ) {
						jQuery._data( this, "toggle" + p, method === "show" ? "hide" : "show" );
						e[ method ]();
					} else {
						e[ val ]();
					}

				} else {
					parts = rfxnum.exec( val );
					start = e.cur();

					if ( parts ) {
						end = parseFloat( parts[2] );
						unit = parts[3] || ( jQuery.cssNumber[ p ] ? "" : "px" );

						// We need to compute starting value
						if ( unit !== "px" ) {
							jQuery.style( this, p, (end || 1) + unit);
							start = ( (end || 1) / e.cur() ) * start;
							jQuery.style( this, p, start + unit);
						}

						// If a +=/-= token was provided, we're doing a relative animation
						if ( parts[1] ) {
							end = ( (parts[ 1 ] === "-=" ? -1 : 1) * end ) + start;
						}

						e.custom( start, end, unit );

					} else {
						e.custom( start, val, "" );
					}
				}
			}

			// For JS strict compliance
			return true;
		}

		return optall.queue === false ?
			this.each( doAnimation ) :
			this.queue( optall.queue, doAnimation );
	},

	stop: function( type, clearQueue, gotoEnd ) {
		if ( typeof type !== "string" ) {
			gotoEnd = clearQueue;
			clearQueue = type;
			type = undefined;
		}
		if ( clearQueue && type !== false ) {
			this.queue( type || "fx", [] );
		}

		return this.each(function() {
			var index,
				hadTimers = false,
				timers = jQuery.timers,
				data = jQuery._data( this );

			// clear marker counters if we know they won't be
			if ( !gotoEnd ) {
				jQuery._unmark( true, this );
			}

			function stopQueue( elem, data, index ) {
				var hooks = data[ index ];
				jQuery.removeData( elem, index, true );
				hooks.stop( gotoEnd );
			}

			if ( type == null ) {
				for ( index in data ) {
					if ( data[ index ] && data[ index ].stop && index.indexOf(".run") === index.length - 4 ) {
						stopQueue( this, data, index );
					}
				}
			} else if ( data[ index = type + ".run" ] && data[ index ].stop ){
				stopQueue( this, data, index );
			}

			for ( index = timers.length; index--; ) {
				if ( timers[ index ].elem === this && (type == null || timers[ index ].queue === type) ) {
					if ( gotoEnd ) {

						// force the next step to be the last
						timers[ index ]( true );
					} else {
						timers[ index ].saveState();
					}
					hadTimers = true;
					timers.splice( index, 1 );
				}
			}

			// start the next in the queue if the last step wasn't forced
			// timers currently will call their complete callbacks, which will dequeue
			// but only if they were gotoEnd
			if ( !( gotoEnd && hadTimers ) ) {
				jQuery.dequeue( this, type );
			}
		});
	}

});

// Animations created synchronously will run synchronously
function createFxNow() {
	setTimeout( clearFxNow, 0 );
	return ( fxNow = jQuery.now() );
}

function clearFxNow() {
	fxNow = undefined;
}

// Generate parameters to create a standard animation
function genFx( type, num ) {
	var obj = {};

	jQuery.each( fxAttrs.concat.apply([], fxAttrs.slice( 0, num )), function() {
		obj[ this ] = type;
	});

	return obj;
}

// Generate shortcuts for custom animations
jQuery.each({
	slideDown: genFx( "show", 1 ),
	slideUp: genFx( "hide", 1 ),
	slideToggle: genFx( "toggle", 1 ),
	fadeIn: { opacity: "show" },
	fadeOut: { opacity: "hide" },
	fadeToggle: { opacity: "toggle" }
}, function( name, props ) {
	jQuery.fn[ name ] = function( speed, easing, callback ) {
		return this.animate( props, speed, easing, callback );
	};
});

jQuery.extend({
	speed: function( speed, easing, fn ) {
		var opt = speed && typeof speed === "object" ? jQuery.extend( {}, speed ) : {
			complete: fn || !fn && easing ||
				jQuery.isFunction( speed ) && speed,
			duration: speed,
			easing: fn && easing || easing && !jQuery.isFunction( easing ) && easing
		};

		opt.duration = jQuery.fx.off ? 0 : typeof opt.duration === "number" ? opt.duration :
			opt.duration in jQuery.fx.speeds ? jQuery.fx.speeds[ opt.duration ] : jQuery.fx.speeds._default;

		// normalize opt.queue - true/undefined/null -> "fx"
		if ( opt.queue == null || opt.queue === true ) {
			opt.queue = "fx";
		}

		// Queueing
		opt.old = opt.complete;

		opt.complete = function( noUnmark ) {
			if ( jQuery.isFunction( opt.old ) ) {
				opt.old.call( this );
			}

			if ( opt.queue ) {
				jQuery.dequeue( this, opt.queue );
			} else if ( noUnmark !== false ) {
				jQuery._unmark( this );
			}
		};

		return opt;
	},

	easing: {
		linear: function( p ) {
			return p;
		},
		swing: function( p ) {
			return ( -Math.cos( p*Math.PI ) / 2 ) + 0.5;
		}
	},

	timers: [],

	fx: function( elem, options, prop ) {
		this.options = options;
		this.elem = elem;
		this.prop = prop;

		options.orig = options.orig || {};
	}

});

jQuery.fx.prototype = {
	// Simple function for setting a style value
	update: function() {
		if ( this.options.step ) {
			this.options.step.call( this.elem, this.now, this );
		}

		( jQuery.fx.step[ this.prop ] || jQuery.fx.step._default )( this );
	},

	// Get the current size
	cur: function() {
		if ( this.elem[ this.prop ] != null && (!this.elem.style || this.elem.style[ this.prop ] == null) ) {
			return this.elem[ this.prop ];
		}

		var parsed,
			r = jQuery.css( this.elem, this.prop );
		// Empty strings, null, undefined and "auto" are converted to 0,
		// complex values such as "rotate(1rad)" are returned as is,
		// simple values such as "10px" are parsed to Float.
		return isNaN( parsed = parseFloat( r ) ) ? !r || r === "auto" ? 0 : r : parsed;
	},

	// Start an animation from one number to another
	custom: function( from, to, unit ) {
		var self = this,
			fx = jQuery.fx;

		this.startTime = fxNow || createFxNow();
		this.end = to;
		this.now = this.start = from;
		this.pos = this.state = 0;
		this.unit = unit || this.unit || ( jQuery.cssNumber[ this.prop ] ? "" : "px" );

		function t( gotoEnd ) {
			return self.step( gotoEnd );
		}

		t.queue = this.options.queue;
		t.elem = this.elem;
		t.saveState = function() {
			if ( jQuery._data( self.elem, "fxshow" + self.prop ) === undefined ) {
				if ( self.options.hide ) {
					jQuery._data( self.elem, "fxshow" + self.prop, self.start );
				} else if ( self.options.show ) {
					jQuery._data( self.elem, "fxshow" + self.prop, self.end );
				}
			}
		};

		if ( t() && jQuery.timers.push(t) && !timerId ) {
			timerId = setInterval( fx.tick, fx.interval );
		}
	},

	// Simple 'show' function
	show: function() {
		var dataShow = jQuery._data( this.elem, "fxshow" + this.prop );

		// Remember where we started, so that we can go back to it later
		this.options.orig[ this.prop ] = dataShow || jQuery.style( this.elem, this.prop );
		this.options.show = true;

		// Begin the animation
		// Make sure that we start at a small width/height to avoid any flash of content
		if ( dataShow !== undefined ) {
			// This show is picking up where a previous hide or show left off
			this.custom( this.cur(), dataShow );
		} else {
			this.custom( this.prop === "width" || this.prop === "height" ? 1 : 0, this.cur() );
		}

		// Start by showing the element
		jQuery( this.elem ).show();
	},

	// Simple 'hide' function
	hide: function() {
		// Remember where we started, so that we can go back to it later
		this.options.orig[ this.prop ] = jQuery._data( this.elem, "fxshow" + this.prop ) || jQuery.style( this.elem, this.prop );
		this.options.hide = true;

		// Begin the animation
		this.custom( this.cur(), 0 );
	},

	// Each step of an animation
	step: function( gotoEnd ) {
		var p, n, complete,
			t = fxNow || createFxNow(),
			done = true,
			elem = this.elem,
			options = this.options;

		if ( gotoEnd || t >= options.duration + this.startTime ) {
			this.now = this.end;
			this.pos = this.state = 1;
			this.update();

			options.animatedProperties[ this.prop ] = true;

			for ( p in options.animatedProperties ) {
				if ( options.animatedProperties[ p ] !== true ) {
					done = false;
				}
			}

			if ( done ) {
				// Reset the overflow
				if ( options.overflow != null && !jQuery.support.shrinkWrapBlocks ) {

					jQuery.each( [ "", "X", "Y" ], function( index, value ) {
						elem.style[ "overflow" + value ] = options.overflow[ index ];
					});
				}

				// Hide the element if the "hide" operation was done
				if ( options.hide ) {
					jQuery( elem ).hide();
				}

				// Reset the properties, if the item has been hidden or shown
				if ( options.hide || options.show ) {
					for ( p in options.animatedProperties ) {
						jQuery.style( elem, p, options.orig[ p ] );
						jQuery.removeData( elem, "fxshow" + p, true );
						// Toggle data is no longer needed
						jQuery.removeData( elem, "toggle" + p, true );
					}
				}

				// Execute the complete function
				// in the event that the complete function throws an exception
				// we must ensure it won't be called twice. #5684

				complete = options.complete;
				if ( complete ) {

					options.complete = false;
					complete.call( elem );
				}
			}

			return false;

		} else {
			// classical easing cannot be used with an Infinity duration
			if ( options.duration == Infinity ) {
				this.now = t;
			} else {
				n = t - this.startTime;
				this.state = n / options.duration;

				// Perform the easing function, defaults to swing
				this.pos = jQuery.easing[ options.animatedProperties[this.prop] ]( this.state, n, 0, 1, options.duration );
				this.now = this.start + ( (this.end - this.start) * this.pos );
			}
			// Perform the next step of the animation
			this.update();
		}

		return true;
	}
};

jQuery.extend( jQuery.fx, {
	tick: function() {
		var timer,
			timers = jQuery.timers,
			i = 0;

		for ( ; i < timers.length; i++ ) {
			timer = timers[ i ];
			// Checks the timer has not already been removed
			if ( !timer() && timers[ i ] === timer ) {
				timers.splice( i--, 1 );
			}
		}

		if ( !timers.length ) {
			jQuery.fx.stop();
		}
	},

	interval: 13,

	stop: function() {
		clearInterval( timerId );
		timerId = null;
	},

	speeds: {
		slow: 600,
		fast: 200,
		// Default speed
		_default: 400
	},

	step: {
		opacity: function( fx ) {
			jQuery.style( fx.elem, "opacity", fx.now );
		},

		_default: function( fx ) {
			if ( fx.elem.style && fx.elem.style[ fx.prop ] != null ) {
				fx.elem.style[ fx.prop ] = fx.now + fx.unit;
			} else {
				fx.elem[ fx.prop ] = fx.now;
			}
		}
	}
});

// Ensure props that can't be negative don't go there on undershoot easing
jQuery.each( fxAttrs.concat.apply( [], fxAttrs ), function( i, prop ) {
	// exclude marginTop, marginLeft, marginBottom and marginRight from this list
	if ( prop.indexOf( "margin" ) ) {
		jQuery.fx.step[ prop ] = function( fx ) {
			jQuery.style( fx.elem, prop, Math.max(0, fx.now) + fx.unit );
		};
	}
});

if ( jQuery.expr && jQuery.expr.filters ) {
	jQuery.expr.filters.animated = function( elem ) {
		return jQuery.grep(jQuery.timers, function( fn ) {
			return elem === fn.elem;
		}).length;
	};
}

// Try to restore the default display value of an element
function defaultDisplay( nodeName ) {

	if ( !elemdisplay[ nodeName ] ) {

		var body = document.body,
			elem = jQuery( "<" + nodeName + ">" ).appendTo( body ),
			display = elem.css( "display" );
		elem.remove();

		// If the simple way fails,
		// get element's real default display by attaching it to a temp iframe
		if ( display === "none" || display === "" ) {
			// No iframe to use yet, so create it
			if ( !iframe ) {
				iframe = document.createElement( "iframe" );
				iframe.frameBorder = iframe.width = iframe.height = 0;
			}

			body.appendChild( iframe );

			// Create a cacheable copy of the iframe document on first call.
			// IE and Opera will allow us to reuse the iframeDoc without re-writing the fake HTML
			// document to it; WebKit & Firefox won't allow reusing the iframe document.
			if ( !iframeDoc || !iframe.createElement ) {
				iframeDoc = ( iframe.contentWindow || iframe.contentDocument ).document;
				iframeDoc.write( ( jQuery.support.boxModel ? "<!doctype html>" : "" ) + "<html><body>" );
				iframeDoc.close();
			}

			elem = iframeDoc.createElement( nodeName );

			iframeDoc.body.appendChild( elem );

			display = jQuery.css( elem, "display" );
			body.removeChild( iframe );
		}

		// Store the correct default display
		elemdisplay[ nodeName ] = display;
	}

	return elemdisplay[ nodeName ];
}




var getOffset,
	rtable = /^t(?:able|d|h)$/i,
	rroot = /^(?:body|html)$/i;

if ( "getBoundingClientRect" in document.documentElement ) {
	getOffset = function( elem, doc, docElem, box ) {
		try {
			box = elem.getBoundingClientRect();
		} catch(e) {}

		// Make sure we're not dealing with a disconnected DOM node
		if ( !box || !jQuery.contains( docElem, elem ) ) {
			return box ? { top: box.top, left: box.left } : { top: 0, left: 0 };
		}

		var body = doc.body,
			win = getWindow( doc ),
			clientTop  = docElem.clientTop  || body.clientTop  || 0,
			clientLeft = docElem.clientLeft || body.clientLeft || 0,
			scrollTop  = win.pageYOffset || jQuery.support.boxModel && docElem.scrollTop  || body.scrollTop,
			scrollLeft = win.pageXOffset || jQuery.support.boxModel && docElem.scrollLeft || body.scrollLeft,
			top  = box.top  + scrollTop  - clientTop,
			left = box.left + scrollLeft - clientLeft;

		return { top: top, left: left };
	};

} else {
	getOffset = function( elem, doc, docElem ) {
		var computedStyle,
			offsetParent = elem.offsetParent,
			prevOffsetParent = elem,
			body = doc.body,
			defaultView = doc.defaultView,
			prevComputedStyle = defaultView ? defaultView.getComputedStyle( elem, null ) : elem.currentStyle,
			top = elem.offsetTop,
			left = elem.offsetLeft;

		while ( (elem = elem.parentNode) && elem !== body && elem !== docElem ) {
			if ( jQuery.support.fixedPosition && prevComputedStyle.position === "fixed" ) {
				break;
			}

			computedStyle = defaultView ? defaultView.getComputedStyle(elem, null) : elem.currentStyle;
			top  -= elem.scrollTop;
			left -= elem.scrollLeft;

			if ( elem === offsetParent ) {
				top  += elem.offsetTop;
				left += elem.offsetLeft;

				if ( jQuery.support.doesNotAddBorder && !(jQuery.support.doesAddBorderForTableAndCells && rtable.test(elem.nodeName)) ) {
					top  += parseFloat( computedStyle.borderTopWidth  ) || 0;
					left += parseFloat( computedStyle.borderLeftWidth ) || 0;
				}

				prevOffsetParent = offsetParent;
				offsetParent = elem.offsetParent;
			}

			if ( jQuery.support.subtractsBorderForOverflowNotVisible && computedStyle.overflow !== "visible" ) {
				top  += parseFloat( computedStyle.borderTopWidth  ) || 0;
				left += parseFloat( computedStyle.borderLeftWidth ) || 0;
			}

			prevComputedStyle = computedStyle;
		}

		if ( prevComputedStyle.position === "relative" || prevComputedStyle.position === "static" ) {
			top  += body.offsetTop;
			left += body.offsetLeft;
		}

		if ( jQuery.support.fixedPosition && prevComputedStyle.position === "fixed" ) {
			top  += Math.max( docElem.scrollTop, body.scrollTop );
			left += Math.max( docElem.scrollLeft, body.scrollLeft );
		}

		return { top: top, left: left };
	};
}

jQuery.fn.offset = function( options ) {
	if ( arguments.length ) {
		return options === undefined ?
			this :
			this.each(function( i ) {
				jQuery.offset.setOffset( this, options, i );
			});
	}

	var elem = this[0],
		doc = elem && elem.ownerDocument;

	if ( !doc ) {
		return null;
	}

	if ( elem === doc.body ) {
		return jQuery.offset.bodyOffset( elem );
	}

	return getOffset( elem, doc, doc.documentElement );
};

jQuery.offset = {

	bodyOffset: function( body ) {
		var top = body.offsetTop,
			left = body.offsetLeft;

		if ( jQuery.support.doesNotIncludeMarginInBodyOffset ) {
			top  += parseFloat( jQuery.css(body, "marginTop") ) || 0;
			left += parseFloat( jQuery.css(body, "marginLeft") ) || 0;
		}

		return { top: top, left: left };
	},

	setOffset: function( elem, options, i ) {
		var position = jQuery.css( elem, "position" );

		// set position first, in-case top/left are set even on static elem
		if ( position === "static" ) {
			elem.style.position = "relative";
		}

		var curElem = jQuery( elem ),
			curOffset = curElem.offset(),
			curCSSTop = jQuery.css( elem, "top" ),
			curCSSLeft = jQuery.css( elem, "left" ),
			calculatePosition = ( position === "absolute" || position === "fixed" ) && jQuery.inArray("auto", [curCSSTop, curCSSLeft]) > -1,
			props = {}, curPosition = {}, curTop, curLeft;

		// need to be able to calculate position if either top or left is auto and position is either absolute or fixed
		if ( calculatePosition ) {
			curPosition = curElem.position();
			curTop = curPosition.top;
			curLeft = curPosition.left;
		} else {
			curTop = parseFloat( curCSSTop ) || 0;
			curLeft = parseFloat( curCSSLeft ) || 0;
		}

		if ( jQuery.isFunction( options ) ) {
			options = options.call( elem, i, curOffset );
		}

		if ( options.top != null ) {
			props.top = ( options.top - curOffset.top ) + curTop;
		}
		if ( options.left != null ) {
			props.left = ( options.left - curOffset.left ) + curLeft;
		}

		if ( "using" in options ) {
			options.using.call( elem, props );
		} else {
			curElem.css( props );
		}
	}
};


jQuery.fn.extend({

	position: function() {
		if ( !this[0] ) {
			return null;
		}

		var elem = this[0],

		// Get *real* offsetParent
		offsetParent = this.offsetParent(),

		// Get correct offsets
		offset       = this.offset(),
		parentOffset = rroot.test(offsetParent[0].nodeName) ? { top: 0, left: 0 } : offsetParent.offset();

		// Subtract element margins
		// note: when an element has margin: auto the offsetLeft and marginLeft
		// are the same in Safari causing offset.left to incorrectly be 0
		offset.top  -= parseFloat( jQuery.css(elem, "marginTop") ) || 0;
		offset.left -= parseFloat( jQuery.css(elem, "marginLeft") ) || 0;

		// Add offsetParent borders
		parentOffset.top  += parseFloat( jQuery.css(offsetParent[0], "borderTopWidth") ) || 0;
		parentOffset.left += parseFloat( jQuery.css(offsetParent[0], "borderLeftWidth") ) || 0;

		// Subtract the two offsets
		return {
			top:  offset.top  - parentOffset.top,
			left: offset.left - parentOffset.left
		};
	},

	offsetParent: function() {
		return this.map(function() {
			var offsetParent = this.offsetParent || document.body;
			while ( offsetParent && (!rroot.test(offsetParent.nodeName) && jQuery.css(offsetParent, "position") === "static") ) {
				offsetParent = offsetParent.offsetParent;
			}
			return offsetParent;
		});
	}
});


// Create scrollLeft and scrollTop methods
jQuery.each( {scrollLeft: "pageXOffset", scrollTop: "pageYOffset"}, function( method, prop ) {
	var top = /Y/.test( prop );

	jQuery.fn[ method ] = function( val ) {
		return jQuery.access( this, function( elem, method, val ) {
			var win = getWindow( elem );

			if ( val === undefined ) {
				return win ? (prop in win) ? win[ prop ] :
					jQuery.support.boxModel && win.document.documentElement[ method ] ||
						win.document.body[ method ] :
					elem[ method ];
			}

			if ( win ) {
				win.scrollTo(
					!top ? val : jQuery( win ).scrollLeft(),
					 top ? val : jQuery( win ).scrollTop()
				);

			} else {
				elem[ method ] = val;
			}
		}, method, val, arguments.length, null );
	};
});

function getWindow( elem ) {
	return jQuery.isWindow( elem ) ?
		elem :
		elem.nodeType === 9 ?
			elem.defaultView || elem.parentWindow :
			false;
}




// Create width, height, innerHeight, innerWidth, outerHeight and outerWidth methods
jQuery.each( { Height: "height", Width: "width" }, function( name, type ) {
	var clientProp = "client" + name,
		scrollProp = "scroll" + name,
		offsetProp = "offset" + name;

	// innerHeight and innerWidth
	jQuery.fn[ "inner" + name ] = function() {
		var elem = this[0];
		return elem ?
			elem.style ?
			parseFloat( jQuery.css( elem, type, "padding" ) ) :
			this[ type ]() :
			null;
	};

	// outerHeight and outerWidth
	jQuery.fn[ "outer" + name ] = function( margin ) {
		var elem = this[0];
		return elem ?
			elem.style ?
			parseFloat( jQuery.css( elem, type, margin ? "margin" : "border" ) ) :
			this[ type ]() :
			null;
	};

	jQuery.fn[ type ] = function( value ) {
		return jQuery.access( this, function( elem, type, value ) {
			var doc, docElemProp, orig, ret;

			if ( jQuery.isWindow( elem ) ) {
				// 3rd condition allows Nokia support, as it supports the docElem prop but not CSS1Compat
				doc = elem.document;
				docElemProp = doc.documentElement[ clientProp ];
				return jQuery.support.boxModel && docElemProp ||
					doc.body && doc.body[ clientProp ] || docElemProp;
			}

			// Get document width or height
			if ( elem.nodeType === 9 ) {
				// Either scroll[Width/Height] or offset[Width/Height], whichever is greater
				doc = elem.documentElement;

				// when a window > document, IE6 reports a offset[Width/Height] > client[Width/Height]
				// so we can't use max, as it'll choose the incorrect offset[Width/Height]
				// instead we use the correct client[Width/Height]
				// support:IE6
				if ( doc[ clientProp ] >= doc[ scrollProp ] ) {
					return doc[ clientProp ];
				}

				return Math.max(
					elem.body[ scrollProp ], doc[ scrollProp ],
					elem.body[ offsetProp ], doc[ offsetProp ]
				);
			}

			// Get width or height on the element
			if ( value === undefined ) {
				orig = jQuery.css( elem, type );
				ret = parseFloat( orig );
				return jQuery.isNumeric( ret ) ? ret : orig;
			}

			// Set the width or height on the element
			jQuery( elem ).css( type, value );
		}, type, value, arguments.length, null );
	};
});




// Expose jQuery to the global object
window.jQuery = window.$ = jQuery;

// Expose jQuery as an AMD module, but only for AMD loaders that
// understand the issues with loading multiple versions of jQuery
// in a page that all might call define(). The loader will indicate
// they have special allowances for multiple jQuery versions by
// specifying define.amd.jQuery = true. Register as a named module,
// since jQuery can be concatenated with other files that may use define,
// but not use a proper concatenation script that understands anonymous
// AMD modules. A named AMD is safest and most robust way to register.
// Lowercase jquery is used because AMD module names are derived from
// file names, and jQuery is normally delivered in a lowercase file name.
// Do this after creating the global so that if an AMD module wants to call
// noConflict to hide this version of jQuery, it will work.
if ( typeof define === "function" && define.amd && define.amd.jQuery ) {
	define( "jquery", [], function () { return jQuery; } );
}



})( window );
(function($, undefined) {

/**
 * Unobtrusive scripting adapter for jQuery
 *
 * Requires jQuery 1.6.0 or later.
 * https://github.com/rails/jquery-ujs

 * Uploading file using rails.js
 * =============================
 *
 * By default, browsers do not allow files to be uploaded via AJAX. As a result, if there are any non-blank file fields
 * in the remote form, this adapter aborts the AJAX submission and allows the form to submit through standard means.
 *
 * The `ajax:aborted:file` event allows you to bind your own handler to process the form submission however you wish.
 *
 * Ex:
 *     $('form').live('ajax:aborted:file', function(event, elements){
 *       // Implement own remote file-transfer handler here for non-blank file inputs passed in `elements`.
 *       // Returning false in this handler tells rails.js to disallow standard form submission
 *       return false;
 *     });
 *
 * The `ajax:aborted:file` event is fired when a file-type input is detected with a non-blank value.
 *
 * Third-party tools can use this hook to detect when an AJAX file upload is attempted, and then use
 * techniques like the iframe method to upload the file instead.
 *
 * Required fields in rails.js
 * ===========================
 *
 * If any blank required inputs (required="required") are detected in the remote form, the whole form submission
 * is canceled. Note that this is unlike file inputs, which still allow standard (non-AJAX) form submission.
 *
 * The `ajax:aborted:required` event allows you to bind your own handler to inform the user of blank required inputs.
 *
 * !! Note that Opera does not fire the form's submit event if there are blank required inputs, so this event may never
 *    get fired in Opera. This event is what causes other browsers to exhibit the same submit-aborting behavior.
 *
 * Ex:
 *     $('form').live('ajax:aborted:required', function(event, elements){
 *       // Returning false in this handler tells rails.js to submit the form anyway.
 *       // The blank required inputs are passed to this function in `elements`.
 *       return ! confirm("Would you like to submit the form with missing info?");
 *     });
 */

  // Cut down on the number if issues from people inadvertently including jquery_ujs twice
  // by detecting and raising an error when it happens.
  var alreadyInitialized = function() {
    var events = $(document).data('events');
    return events && events.click && $.grep(events.click, function(e) { return e.namespace === 'rails'; }).length;
  }

  if ( alreadyInitialized() ) {
    $.error('jquery-ujs has already been loaded!');
  }

  // Shorthand to make it a little easier to call public rails functions from within rails.js
  var rails;

  $.rails = rails = {
    // Link elements bound by jquery-ujs
    linkClickSelector: 'a[data-confirm], a[data-method], a[data-remote], a[data-disable-with]',

    // Select elements bound by jquery-ujs
    inputChangeSelector: 'select[data-remote], input[data-remote], textarea[data-remote]',

    // Form elements bound by jquery-ujs
    formSubmitSelector: 'form',

    // Form input elements bound by jquery-ujs
    formInputClickSelector: 'form input[type=submit], form input[type=image], form button[type=submit], form button:not([type])',

    // Form input elements disabled during form submission
    disableSelector: 'input[data-disable-with], button[data-disable-with], textarea[data-disable-with]',

    // Form input elements re-enabled after form submission
    enableSelector: 'input[data-disable-with]:disabled, button[data-disable-with]:disabled, textarea[data-disable-with]:disabled',

    // Form required input elements
    requiredInputSelector: 'input[name][required]:not([disabled]),textarea[name][required]:not([disabled])',

    // Form file input elements
    fileInputSelector: 'input:file',

    // Link onClick disable selector with possible reenable after remote submission
    linkDisableSelector: 'a[data-disable-with]',

    // Make sure that every Ajax request sends the CSRF token
    CSRFProtection: function(xhr) {
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) xhr.setRequestHeader('X-CSRF-Token', token);
    },

    // Triggers an event on an element and returns false if the event result is false
    fire: function(obj, name, data) {
      var event = $.Event(name);
      obj.trigger(event, data);
      return event.result !== false;
    },

    // Default confirm dialog, may be overridden with custom confirm dialog in $.rails.confirm
    confirm: function(message) {
      return confirm(message);
    },

    // Default ajax function, may be overridden with custom function in $.rails.ajax
    ajax: function(options) {
      return $.ajax(options);
    },

    // Default way to get an element's href. May be overridden at $.rails.href.
    href: function(element) {
      return element.attr('href');
    },

    // Submits "remote" forms and links with ajax
    handleRemote: function(element) {
      var method, url, data, elCrossDomain, crossDomain, withCredentials, dataType, options;

      if (rails.fire(element, 'ajax:before')) {
        elCrossDomain = element.data('cross-domain');
        crossDomain = elCrossDomain === undefined ? null : elCrossDomain;
        withCredentials = element.data('with-credentials') || null;
        dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType);

        if (element.is('form')) {
          method = element.attr('method');
          url = element.attr('action');
          data = element.serializeArray();
          // memoized value from clicked submit button
          var button = element.data('ujs:submit-button');
          if (button) {
            data.push(button);
            element.data('ujs:submit-button', null);
          }
        } else if (element.is(rails.inputChangeSelector)) {
          method = element.data('method');
          url = element.data('url');
          data = element.serialize();
          if (element.data('params')) data = data + "&" + element.data('params');
        } else {
          method = element.data('method');
          url = rails.href(element);
          data = element.data('params') || null;
        }

        options = {
          type: method || 'GET', data: data, dataType: dataType,
          // stopping the "ajax:beforeSend" event will cancel the ajax request
          beforeSend: function(xhr, settings) {
            if (settings.dataType === undefined) {
              xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
            }
            return rails.fire(element, 'ajax:beforeSend', [xhr, settings]);
          },
          success: function(data, status, xhr) {
            element.trigger('ajax:success', [data, status, xhr]);
          },
          complete: function(xhr, status) {
            element.trigger('ajax:complete', [xhr, status]);
          },
          error: function(xhr, status, error) {
            element.trigger('ajax:error', [xhr, status, error]);
          },
          xhrFields: {
            withCredentials: withCredentials
          },
          crossDomain: crossDomain
        };
        // Only pass url to `ajax` options if not blank
        if (url) { options.url = url; }

        var jqxhr = rails.ajax(options);
        element.trigger('ajax:send', jqxhr);
        return jqxhr;
      } else {
        return false;
      }
    },

    // Handles "data-method" on links such as:
    // <a href="/users/5" data-method="delete" rel="nofollow" data-confirm="Are you sure?">Delete</a>
    handleMethod: function(link) {
      var href = rails.href(link),
        method = link.data('method'),
        target = link.attr('target'),
        csrf_token = $('meta[name=csrf-token]').attr('content'),
        csrf_param = $('meta[name=csrf-param]').attr('content'),
        form = $('<form method="post" action="' + href + '"></form>'),
        metadata_input = '<input name="_method" value="' + method + '" type="hidden" />';

      if (csrf_param !== undefined && csrf_token !== undefined) {
        metadata_input += '<input name="' + csrf_param + '" value="' + csrf_token + '" type="hidden" />';
      }

      if (target) { form.attr('target', target); }

      form.hide().append(metadata_input).appendTo('body');
      form.submit();
    },

    /* Disables form elements:
      - Caches element value in 'ujs:enable-with' data store
      - Replaces element text with value of 'data-disable-with' attribute
      - Sets disabled property to true
    */
    disableFormElements: function(form) {
      form.find(rails.disableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        element.data('ujs:enable-with', element[method]());
        element[method](element.data('disable-with'));
        element.prop('disabled', true);
      });
    },

    /* Re-enables disabled form elements:
      - Replaces element text with cached value from 'ujs:enable-with' data store (created in `disableFormElements`)
      - Sets disabled property to false
    */
    enableFormElements: function(form) {
      form.find(rails.enableSelector).each(function() {
        var element = $(this), method = element.is('button') ? 'html' : 'val';
        if (element.data('ujs:enable-with')) element[method](element.data('ujs:enable-with'));
        element.prop('disabled', false);
      });
    },

   /* For 'data-confirm' attribute:
      - Fires `confirm` event
      - Shows the confirmation dialog
      - Fires the `confirm:complete` event

      Returns `true` if no function stops the chain and user chose yes; `false` otherwise.
      Attaching a handler to the element's `confirm` event that returns a `falsy` value cancels the confirmation dialog.
      Attaching a handler to the element's `confirm:complete` event that returns a `falsy` value makes this function
      return false. The `confirm:complete` event is fired whether or not the user answered true or false to the dialog.
   */
    allowAction: function(element) {
      var message = element.data('confirm'),
          answer = false, callback;
      if (!message) { return true; }

      if (rails.fire(element, 'confirm')) {
        answer = rails.confirm(message);
        callback = rails.fire(element, 'confirm:complete', [answer]);
      }
      return answer && callback;
    },

    // Helper function which checks for blank inputs in a form that match the specified CSS selector
    blankInputs: function(form, specifiedSelector, nonBlank) {
      var inputs = $(), input, valueToCheck,
        selector = specifiedSelector || 'input,textarea';
      form.find(selector).each(function() {
        input = $(this);
        valueToCheck = input.is(':checkbox,:radio') ? input.is(':checked') : input.val();
        // If nonBlank and valueToCheck are both truthy, or nonBlank and valueToCheck are both falsey
        if (valueToCheck == !!nonBlank) {
          inputs = inputs.add(input);
        }
      });
      return inputs.length ? inputs : false;
    },

    // Helper function which checks for non-blank inputs in a form that match the specified CSS selector
    nonBlankInputs: function(form, specifiedSelector) {
      return rails.blankInputs(form, specifiedSelector, true); // true specifies nonBlank
    },

    // Helper function, needed to provide consistent behavior in IE
    stopEverything: function(e) {
      $(e.target).trigger('ujs:everythingStopped');
      e.stopImmediatePropagation();
      return false;
    },

    // find all the submit events directly bound to the form and
    // manually invoke them. If anyone returns false then stop the loop
    callFormSubmitBindings: function(form, event) {
      var events = form.data('events'), continuePropagation = true;
      if (events !== undefined && events['submit'] !== undefined) {
        $.each(events['submit'], function(i, obj){
          if (typeof obj.handler === 'function') return continuePropagation = obj.handler(event);
        });
      }
      return continuePropagation;
    },

    //  replace element's html with the 'data-disable-with' after storing original html
    //  and prevent clicking on it
    disableElement: function(element) {
      element.data('ujs:enable-with', element.html()); // store enabled state
      element.html(element.data('disable-with')); // set to disabled state
      element.bind('click.railsDisable', function(e) { // prevent further clicking
        return rails.stopEverything(e);
      });
    },

    // restore element to its original state which was disabled by 'disableElement' above
    enableElement: function(element) {
      if (element.data('ujs:enable-with') !== undefined) {
        element.html(element.data('ujs:enable-with')); // set to old enabled state
        // this should be element.removeData('ujs:enable-with')
        // but, there is currently a bug in jquery which makes hyphenated data attributes not get removed
        element.data('ujs:enable-with', false); // clean up cache
      }
      element.unbind('click.railsDisable'); // enable element
    }

  };

  if (rails.fire($(document), 'rails:attachBindings')) {

    $.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { rails.CSRFProtection(xhr); }});

    $(document).delegate(rails.linkDisableSelector, 'ajax:complete', function() {
        rails.enableElement($(this));
    });

    $(document).delegate(rails.linkClickSelector, 'click.rails', function(e) {
      var link = $(this), method = link.data('method'), data = link.data('params');
      if (!rails.allowAction(link)) return rails.stopEverything(e);

      if (link.is(rails.linkDisableSelector)) rails.disableElement(link);

      if (link.data('remote') !== undefined) {
        if ( (e.metaKey || e.ctrlKey) && (!method || method === 'GET') && !data ) { return true; }

        if (rails.handleRemote(link) === false) { rails.enableElement(link); }
        return false;

      } else if (link.data('method')) {
        rails.handleMethod(link);
        return false;
      }
    });

    $(document).delegate(rails.inputChangeSelector, 'change.rails', function(e) {
      var link = $(this);
      if (!rails.allowAction(link)) return rails.stopEverything(e);

      rails.handleRemote(link);
      return false;
    });

    $(document).delegate(rails.formSubmitSelector, 'submit.rails', function(e) {
      var form = $(this),
        remote = form.data('remote') !== undefined,
        blankRequiredInputs = rails.blankInputs(form, rails.requiredInputSelector),
        nonBlankFileInputs = rails.nonBlankInputs(form, rails.fileInputSelector);

      if (!rails.allowAction(form)) return rails.stopEverything(e);

      // skip other logic when required values are missing or file upload is present
      if (blankRequiredInputs && form.attr("novalidate") == undefined && rails.fire(form, 'ajax:aborted:required', [blankRequiredInputs])) {
        return rails.stopEverything(e);
      }

      if (remote) {
        if (nonBlankFileInputs) {
          setTimeout(function(){ rails.disableFormElements(form); }, 13);
          return rails.fire(form, 'ajax:aborted:file', [nonBlankFileInputs]);
        }

        // If browser does not support submit bubbling, then this live-binding will be called before direct
        // bindings. Therefore, we should directly call any direct bindings before remotely submitting form.
        if (!$.support.submitBubbles && $().jquery < '1.7' && rails.callFormSubmitBindings(form, e) === false) return rails.stopEverything(e);

        rails.handleRemote(form);
        return false;

      } else {
        // slight timeout so that the submit button gets properly serialized
        setTimeout(function(){ rails.disableFormElements(form); }, 13);
      }
    });

    $(document).delegate(rails.formInputClickSelector, 'click.rails', function(event) {
      var button = $(this);

      if (!rails.allowAction(button)) return rails.stopEverything(event);

      // register the pressed submit button
      var name = button.attr('name'),
        data = name ? {name:name, value:button.val()} : null;

      button.closest('form').data('ujs:submit-button', data);
    });

    $(document).delegate(rails.formSubmitSelector, 'ajax:beforeSend.rails', function(event) {
      if (this == event.target) rails.disableFormElements($(this));
    });

    $(document).delegate(rails.formSubmitSelector, 'ajax:complete.rails', function(event) {
      if (this == event.target) rails.enableFormElements($(this));
    });

    $(function(){
      // making sure that all forms have actual up-to-date token(cached forms contain old one)
      csrf_token = $('meta[name=csrf-token]').attr('content');
      csrf_param = $('meta[name=csrf-param]').attr('content');
      $('form input[name="' + csrf_param + '"]').val(csrf_token);
    });
  }

})( jQuery );
/* ===================================================
 * bootstrap-transition.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#transitions
 * ===================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function( $ ) {

  $(function () {

    "use strict"

    /* CSS TRANSITION SUPPORT (https://gist.github.com/373874)
     * ======================================================= */

    $.support.transition = (function () {
      var thisBody = document.body || document.documentElement
        , thisStyle = thisBody.style
        , support = thisStyle.transition !== undefined || thisStyle.WebkitTransition !== undefined || thisStyle.MozTransition !== undefined || thisStyle.MsTransition !== undefined || thisStyle.OTransition !== undefined

      return support && {
        end: (function () {
          var transitionEnd = "TransitionEnd"
          if ( $.browser.webkit ) {
          	transitionEnd = "webkitTransitionEnd"
          } else if ( $.browser.mozilla ) {
          	transitionEnd = "transitionend"
          } else if ( $.browser.opera ) {
          	transitionEnd = "oTransitionEnd"
          }
          return transitionEnd
        }())
      }
    })()

  })

}( window.jQuery );/* ==========================================================
 * bootstrap-alert.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#alerts
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function( $ ){

  "use strict"

 /* ALERT CLASS DEFINITION
  * ====================== */

  var dismiss = '[data-dismiss="alert"]'
    , Alert = function ( el ) {
        $(el).on('click', dismiss, this.close)
      }

  Alert.prototype = {

    constructor: Alert

  , close: function ( e ) {
      var $this = $(this)
        , selector = $this.attr('data-target')
        , $parent

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      $parent = $(selector)
      $parent.trigger('close')

      e && e.preventDefault()

      $parent.length || ($parent = $this.hasClass('alert') ? $this : $this.parent())

      $parent
        .trigger('close')
        .removeClass('in')

      function removeElement() {
        $parent
          .trigger('closed')
          .remove()
      }

      $.support.transition && $parent.hasClass('fade') ?
        $parent.on($.support.transition.end, removeElement) :
        removeElement()
    }

  }


 /* ALERT PLUGIN DEFINITION
  * ======================= */

  $.fn.alert = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('alert')
      if (!data) $this.data('alert', (data = new Alert(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.alert.Constructor = Alert


 /* ALERT DATA-API
  * ============== */

  $(function () {
    $('body').on('click.alert.data-api', dismiss, Alert.prototype.close)
  })

}( window.jQuery );/* ============================================================
 * bootstrap-button.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#buttons
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

!function( $ ){

  "use strict"

 /* BUTTON PUBLIC CLASS DEFINITION
  * ============================== */

  var Button = function ( element, options ) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.button.defaults, options)
  }

  Button.prototype = {

      constructor: Button

    , setState: function ( state ) {
        var d = 'disabled'
          , $el = this.$element
          , data = $el.data()
          , val = $el.is('input') ? 'val' : 'html'

        state = state + 'Text'
        data.resetText || $el.data('resetText', $el[val]())

        $el[val](data[state] || this.options[state])

        // push to event loop to allow forms to submit
        setTimeout(function () {
          state == 'loadingText' ?
            $el.addClass(d).attr(d, d) :
            $el.removeClass(d).removeAttr(d)
        }, 0)
      }

    , toggle: function () {
        var $parent = this.$element.parent('[data-toggle="buttons-radio"]')

        $parent && $parent
          .find('.active')
          .removeClass('active')

        this.$element.toggleClass('active')
      }

  }


 /* BUTTON PLUGIN DEFINITION
  * ======================== */

  $.fn.button = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('button')
        , options = typeof option == 'object' && option
      if (!data) $this.data('button', (data = new Button(this, options)))
      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }

  $.fn.button.defaults = {
    loadingText: 'loading...'
  }

  $.fn.button.Constructor = Button


 /* BUTTON DATA-API
  * =============== */

  $(function () {
    $('body').on('click.button.data-api', '[data-toggle^=button]', function ( e ) {
      var $btn = $(e.target)
      if (!$btn.hasClass('btn')) $btn = $btn.closest('.btn')
      $btn.button('toggle')
    })
  })

}( window.jQuery );/* ==========================================================
 * bootstrap-carousel.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#carousel
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function( $ ){

  "use strict"

 /* CAROUSEL CLASS DEFINITION
  * ========================= */

  var Carousel = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.carousel.defaults, options)
    this.options.slide && this.slide(this.options.slide)
    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))
  }

  Carousel.prototype = {

    cycle: function () {
      this.interval = setInterval($.proxy(this.next, this), this.options.interval)
      return this
    }

  , to: function (pos) {
      var $active = this.$element.find('.active')
        , children = $active.parent().children()
        , activePos = children.index($active)
        , that = this

      if (pos > (children.length - 1) || pos < 0) return

      if (this.sliding) {
        return this.$element.one('slid', function () {
          that.to(pos)
        })
      }

      if (activePos == pos) {
        return this.pause().cycle()
      }

      return this.slide(pos > activePos ? 'next' : 'prev', $(children[pos]))
    }

  , pause: function () {
      clearInterval(this.interval)
      this.interval = null
      return this
    }

  , next: function () {
      if (this.sliding) return
      return this.slide('next')
    }

  , prev: function () {
      if (this.sliding) return
      return this.slide('prev')
    }

  , slide: function (type, next) {
      var $active = this.$element.find('.active')
        , $next = next || $active[type]()
        , isCycling = this.interval
        , direction = type == 'next' ? 'left' : 'right'
        , fallback  = type == 'next' ? 'first' : 'last'
        , that = this

      this.sliding = true

      isCycling && this.pause()

      $next = $next.length ? $next : this.$element.find('.item')[fallback]()

      if ($next.hasClass('active')) return

      if (!$.support.transition && this.$element.hasClass('slide')) {
        this.$element.trigger('slide')
        $active.removeClass('active')
        $next.addClass('active')
        this.sliding = false
        this.$element.trigger('slid')
      } else {
        $next.addClass(type)
        $next[0].offsetWidth // force reflow
        $active.addClass(direction)
        $next.addClass(direction)
        this.$element.trigger('slide')
        this.$element.one($.support.transition.end, function () {
          $next.removeClass([type, direction].join(' ')).addClass('active')
          $active.removeClass(['active', direction].join(' '))
          that.sliding = false
          setTimeout(function () { that.$element.trigger('slid') }, 0)
        })
      }

      isCycling && this.cycle()

      return this
    }

  }


 /* CAROUSEL PLUGIN DEFINITION
  * ========================== */

  $.fn.carousel = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('carousel')
        , options = typeof option == 'object' && option
      if (!data) $this.data('carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (typeof option == 'string' || (option = options.slide)) data[option]()
      else data.cycle()
    })
  }

  $.fn.carousel.defaults = {
    interval: 5000
  , pause: 'hover'
  }

  $.fn.carousel.Constructor = Carousel


 /* CAROUSEL DATA-API
  * ================= */

  $(function () {
    $('body').on('click.carousel.data-api', '[data-slide]', function ( e ) {
      var $this = $(this), href
        , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
        , options = !$target.data('modal') && $.extend({}, $target.data(), $this.data())
      $target.carousel(options)
      e.preventDefault()
    })
  })

}( window.jQuery );/* =============================================================
 * bootstrap-collapse.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

!function( $ ){

  "use strict"

  var Collapse = function ( element, options ) {
  	this.$element = $(element)
    this.options = $.extend({}, $.fn.collapse.defaults, options)

    if (this.options["parent"]) {
      this.$parent = $(this.options["parent"])
    }

    this.options.toggle && this.toggle()
  }

  Collapse.prototype = {

    constructor: Collapse

  , dimension: function () {
      var hasWidth = this.$element.hasClass('width')
      return hasWidth ? 'width' : 'height'
    }

  , show: function () {
      var dimension = this.dimension()
        , scroll = $.camelCase(['scroll', dimension].join('-'))
        , actives = this.$parent && this.$parent.find('.in')
        , hasData

      if (actives && actives.length) {
        hasData = actives.data('collapse')
        actives.collapse('hide')
        hasData || actives.data('collapse', null)
      }

      this.$element[dimension](0)
      this.transition('addClass', 'show', 'shown')
      this.$element[dimension](this.$element[0][scroll])

    }

  , hide: function () {
      var dimension = this.dimension()
      this.reset(this.$element[dimension]())
      this.transition('removeClass', 'hide', 'hidden')
      this.$element[dimension](0)
    }

  , reset: function ( size ) {
      var dimension = this.dimension()

      this.$element
        .removeClass('collapse')
        [dimension](size || 'auto')
        [0].offsetWidth

      this.$element[size ? 'addClass' : 'removeClass']('collapse')

      return this
    }

  , transition: function ( method, startEvent, completeEvent ) {
      var that = this
        , complete = function () {
            if (startEvent == 'show') that.reset()
            that.$element.trigger(completeEvent)
          }

      this.$element
        .trigger(startEvent)
        [method]('in')

      $.support.transition && this.$element.hasClass('collapse') ?
        this.$element.one($.support.transition.end, complete) :
        complete()
  	}

  , toggle: function () {
      this[this.$element.hasClass('in') ? 'hide' : 'show']()
  	}

  }

  /* COLLAPSIBLE PLUGIN DEFINITION
  * ============================== */

  $.fn.collapse = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('collapse')
        , options = typeof option == 'object' && option
      if (!data) $this.data('collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.collapse.defaults = {
    toggle: true
  }

  $.fn.collapse.Constructor = Collapse


 /* COLLAPSIBLE DATA-API
  * ==================== */

  $(function () {
    $('body').on('click.collapse.data-api', '[data-toggle=collapse]', function ( e ) {
      var $this = $(this), href
        , target = $this.attr('data-target')
          || e.preventDefault()
          || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
        , option = $(target).data('collapse') ? 'toggle' : $this.data()
      $(target).collapse(option)
    })
  })

}( window.jQuery );/* ============================================================
 * bootstrap-dropdown.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function( $ ){

  "use strict"

 /* DROPDOWN CLASS DEFINITION
  * ========================= */

  var toggle = '[data-toggle="dropdown"]'
    , Dropdown = function ( element ) {
        var $el = $(element).on('click.dropdown.data-api', this.toggle)
        $('html').on('click.dropdown.data-api', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function ( e ) {
      var $this = $(this)
        , selector = $this.attr('data-target')
        , $parent
        , isActive

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      $parent = $(selector)
      $parent.length || ($parent = $this.parent())

      isActive = $parent.hasClass('open')

      clearMenus()
      !isActive && $parent.toggleClass('open')

      return false
    }

  }

  function clearMenus() {
    $(toggle).parent().removeClass('open')
  }


  /* DROPDOWN PLUGIN DEFINITION
   * ========================== */

  $.fn.dropdown = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.dropdown.Constructor = Dropdown


  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */

  $(function () {
    $('html').on('click.dropdown.data-api', clearMenus)
    $('body').on('click.dropdown.data-api', toggle, Dropdown.prototype.toggle)
  })

}( window.jQuery );/* =========================================================
 * bootstrap-modal.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#modals
 * =========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */


!function( $ ){

  "use strict"

 /* MODAL CLASS DEFINITION
  * ====================== */

  var Modal = function ( content, options ) {
    this.options = options
    this.$element = $(content)
      .delegate('[data-dismiss="modal"]', 'click.dismiss.modal', $.proxy(this.hide, this))
  }

  Modal.prototype = {

      constructor: Modal

    , toggle: function () {
        return this[!this.isShown ? 'show' : 'hide']()
      }

    , show: function () {
        var that = this

        if (this.isShown) return

        $('body').addClass('modal-open')

        this.isShown = true
        this.$element.trigger('show')

        escape.call(this)
        backdrop.call(this, function () {
          var transition = $.support.transition && that.$element.hasClass('fade')

          !that.$element.parent().length && that.$element.appendTo(document.body) //don't move modals dom position

          that.$element
            .show()

          if (transition) {
            that.$element[0].offsetWidth // force reflow
          }

          that.$element.addClass('in')

          transition ?
            that.$element.one($.support.transition.end, function () { that.$element.trigger('shown') }) :
            that.$element.trigger('shown')

        })
      }

    , hide: function ( e ) {
        e && e.preventDefault()

        if (!this.isShown) return

        var that = this
        this.isShown = false

        $('body').removeClass('modal-open')

        escape.call(this)

        this.$element
          .trigger('hide')
          .removeClass('in')

        $.support.transition && this.$element.hasClass('fade') ?
          hideWithTransition.call(this) :
          hideModal.call(this)
      }

  }


 /* MODAL PRIVATE METHODS
  * ===================== */

  function hideWithTransition() {
    var that = this
      , timeout = setTimeout(function () {
          that.$element.off($.support.transition.end)
          hideModal.call(that)
        }, 500)

    this.$element.one($.support.transition.end, function () {
      clearTimeout(timeout)
      hideModal.call(that)
    })
  }

  function hideModal( that ) {
    this.$element
      .hide()
      .trigger('hidden')

    backdrop.call(this)
  }

  function backdrop( callback ) {
    var that = this
      , animate = this.$element.hasClass('fade') ? 'fade' : ''

    if (this.isShown && this.options.backdrop) {
      var doAnimate = $.support.transition && animate

      this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
        .appendTo(document.body)

      if (this.options.backdrop != 'static') {
        this.$backdrop.click($.proxy(this.hide, this))
      }

      if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

      this.$backdrop.addClass('in')

      doAnimate ?
        this.$backdrop.one($.support.transition.end, callback) :
        callback()

    } else if (!this.isShown && this.$backdrop) {
      this.$backdrop.removeClass('in')

      $.support.transition && this.$element.hasClass('fade')?
        this.$backdrop.one($.support.transition.end, $.proxy(removeBackdrop, this)) :
        removeBackdrop.call(this)

    } else if (callback) {
      callback()
    }
  }

  function removeBackdrop() {
    this.$backdrop.remove()
    this.$backdrop = null
  }

  function escape() {
    var that = this
    if (this.isShown && this.options.keyboard) {
      $(document).on('keyup.dismiss.modal', function ( e ) {
        e.which == 27 && that.hide()
      })
    } else if (!this.isShown) {
      $(document).off('keyup.dismiss.modal')
    }
  }


 /* MODAL PLUGIN DEFINITION
  * ======================= */

  $.fn.modal = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('modal')
        , options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option]()
      else if (options.show) data.show()
    })
  }

  $.fn.modal.defaults = {
      backdrop: true
    , keyboard: true
    , show: true
  }

  $.fn.modal.Constructor = Modal


 /* MODAL DATA-API
  * ============== */

  $(function () {
    $('body').on('click.modal.data-api', '[data-toggle="modal"]', function ( e ) {
      var $this = $(this), href
        , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
        , option = $target.data('modal') ? 'toggle' : $.extend({}, $target.data(), $this.data())

      e.preventDefault()
      $target.modal(option)
    })
  })

}( window.jQuery );/* ===========================================================
 * bootstrap-tooltip.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#tooltips
 * Inspired by the original jQuery.tipsy by Jason Frame
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */

!function( $ ) {

  "use strict"

 /* TOOLTIP PUBLIC CLASS DEFINITION
  * =============================== */

  var Tooltip = function ( element, options ) {
    this.init('tooltip', element, options)
  }

  Tooltip.prototype = {

    constructor: Tooltip

  , init: function ( type, element, options ) {
      var eventIn
        , eventOut

      this.type = type
      this.$element = $(element)
      this.options = this.getOptions(options)
      this.enabled = true

      if (this.options.trigger != 'manual') {
        eventIn  = this.options.trigger == 'hover' ? 'mouseenter' : 'focus'
        eventOut = this.options.trigger == 'hover' ? 'mouseleave' : 'blur'
        this.$element.on(eventIn, this.options.selector, $.proxy(this.enter, this))
        this.$element.on(eventOut, this.options.selector, $.proxy(this.leave, this))
      }

      this.options.selector ?
        (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
        this.fixTitle()
    }

  , getOptions: function ( options ) {
      options = $.extend({}, $.fn[this.type].defaults, options, this.$element.data())

      if (options.delay && typeof options.delay == 'number') {
        options.delay = {
          show: options.delay
        , hide: options.delay
        }
      }

      return options
    }

  , enter: function ( e ) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)

      if (!self.options.delay || !self.options.delay.show) {
        self.show()
      } else {
        self.hoverState = 'in'
        setTimeout(function() {
          if (self.hoverState == 'in') {
            self.show()
          }
        }, self.options.delay.show)
      }
    }

  , leave: function ( e ) {
      var self = $(e.currentTarget)[this.type](this._options).data(this.type)

      if (!self.options.delay || !self.options.delay.hide) {
        self.hide()
      } else {
        self.hoverState = 'out'
        setTimeout(function() {
          if (self.hoverState == 'out') {
            self.hide()
          }
        }, self.options.delay.hide)
      }
    }

  , show: function () {
      var $tip
        , inside
        , pos
        , actualWidth
        , actualHeight
        , placement
        , tp

      if (this.hasContent() && this.enabled) {
        $tip = this.tip()
        this.setContent()

        if (this.options.animation) {
          $tip.addClass('fade')
        }

        placement = typeof this.options.placement == 'function' ?
          this.options.placement.call(this, $tip[0], this.$element[0]) :
          this.options.placement

        inside = /in/.test(placement)

        $tip
          .remove()
          .css({ top: 0, left: 0, display: 'block' })
          .appendTo(inside ? this.$element : document.body)

        pos = this.getPosition(inside)

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight

        switch (inside ? placement.split(' ')[1] : placement) {
          case 'bottom':
            tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'top':
            tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'left':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
            break
          case 'right':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}
            break
        }

        $tip
          .css(tp)
          .addClass(placement)
          .addClass('in')
      }
    }

  , setContent: function () {
      var $tip = this.tip()
      $tip.find('.tooltip-inner').html(this.getTitle())
      $tip.removeClass('fade in top bottom left right')
    }

  , hide: function () {
      var that = this
        , $tip = this.tip()

      $tip.removeClass('in')

      function removeWithAnimation() {
        var timeout = setTimeout(function () {
          $tip.off($.support.transition.end).remove()
        }, 500)

        $tip.one($.support.transition.end, function () {
          clearTimeout(timeout)
          $tip.remove()
        })
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        removeWithAnimation() :
        $tip.remove()
    }

  , fixTitle: function () {
      var $e = this.$element
      if ($e.attr('title') || typeof($e.attr('data-original-title')) != 'string') {
        $e.attr('data-original-title', $e.attr('title') || '').removeAttr('title')
      }
    }

  , hasContent: function () {
      return this.getTitle()
    }

  , getPosition: function (inside) {
      return $.extend({}, (inside ? {top: 0, left: 0} : this.$element.offset()), {
        width: this.$element[0].offsetWidth
      , height: this.$element[0].offsetHeight
      })
    }

  , getTitle: function () {
      var title
        , $e = this.$element
        , o = this.options

      title = $e.attr('data-original-title')
        || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

      title = (title || '').toString().replace(/(^\s*|\s*$)/, "")

      return title
    }

  , tip: function () {
      return this.$tip = this.$tip || $(this.options.template)
    }

  , validate: function () {
      if (!this.$element[0].parentNode) {
        this.hide()
        this.$element = null
        this.options = null
      }
    }

  , enable: function () {
      this.enabled = true
    }

  , disable: function () {
      this.enabled = false
    }

  , toggleEnabled: function () {
      this.enabled = !this.enabled
    }

  , toggle: function () {
      this[this.tip().hasClass('in') ? 'hide' : 'show']()
    }

  }


 /* TOOLTIP PLUGIN DEFINITION
  * ========================= */

  $.fn.tooltip = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tooltip')
        , options = typeof option == 'object' && option
      if (!data) $this.data('tooltip', (data = new Tooltip(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tooltip.Constructor = Tooltip

  $.fn.tooltip.defaults = {
    animation: true
  , delay: 0
  , selector: false
  , placement: 'top'
  , trigger: 'hover'
  , title: ''
  , template: '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
  }

}( window.jQuery );/* ===========================================================
 * bootstrap-popover.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#popovers
 * ===========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * =========================================================== */


!function( $ ) {

 "use strict"

  var Popover = function ( element, options ) {
    this.init('popover', element, options)
  }

  /* NOTE: POPOVER EXTENDS BOOTSTRAP-TOOLTIP.js
     ========================================== */

  Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype, {

    constructor: Popover

  , setContent: function () {
      var $tip = this.tip()
        , title = this.getTitle()
        , content = this.getContent()

      $tip.find('.popover-title')[ $.type(title) == 'object' ? 'append' : 'html' ](title)
      $tip.find('.popover-content > *')[ $.type(content) == 'object' ? 'append' : 'html' ](content)

      $tip.removeClass('fade top bottom left right in')
    }

  , hasContent: function () {
      return this.getTitle() || this.getContent()
    }

  , getContent: function () {
      var content
        , $e = this.$element
        , o = this.options

      content = $e.attr('data-content')
        || (typeof o.content == 'function' ? o.content.call($e[0]) :  o.content)

      content = content.toString().replace(/(^\s*|\s*$)/, "")

      return content
    }

  , tip: function() {
      if (!this.$tip) {
        this.$tip = $(this.options.template)
      }
      return this.$tip
    }

  })


 /* POPOVER PLUGIN DEFINITION
  * ======================= */

  $.fn.popover = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('popover')
        , options = typeof option == 'object' && option
      if (!data) $this.data('popover', (data = new Popover(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.popover.Constructor = Popover

  $.fn.popover.defaults = $.extend({} , $.fn.tooltip.defaults, {
    placement: 'right'
  , content: ''
  , template: '<div class="popover"><div class="arrow"></div><div class="popover-inner"><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div></div>'
  })

}( window.jQuery );/* =============================================================
 * bootstrap-scrollspy.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#scrollspy
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================== */

!function ( $ ) {

  "use strict"

  /* SCROLLSPY CLASS DEFINITION
   * ========================== */

  function ScrollSpy( element, options) {
    var process = $.proxy(this.process, this)
      , $element = $(element).is('body') ? $(window) : $(element)
      , href
    this.options = $.extend({}, $.fn.scrollspy.defaults, options)
    this.$scrollElement = $element.on('scroll.scroll.data-api', process)
    this.selector = (this.options.target
      || ((href = $(element).attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
      || '') + ' .nav li > a'
    this.$body = $('body').on('click.scroll.data-api', this.selector, process)
    this.refresh()
    this.process()
  }

  ScrollSpy.prototype = {

      constructor: ScrollSpy

    , refresh: function () {
        this.targets = this.$body
          .find(this.selector)
          .map(function () {
            var href = $(this).attr('href')
            return /^#\w/.test(href) && $(href).length ? href : null
          })

        this.offsets = $.map(this.targets, function (id) {
          return $(id).position().top
        })
      }

    , process: function () {
        var scrollTop = this.$scrollElement.scrollTop() + this.options.offset
          , offsets = this.offsets
          , targets = this.targets
          , activeTarget = this.activeTarget
          , i

        for (i = offsets.length; i--;) {
          activeTarget != targets[i]
            && scrollTop >= offsets[i]
            && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
            && this.activate( targets[i] )
        }
      }

    , activate: function (target) {
        var active

        this.activeTarget = target

        this.$body
          .find(this.selector).parent('.active')
          .removeClass('active')

        active = this.$body
          .find(this.selector + '[href="' + target + '"]')
          .parent('li')
          .addClass('active')

        if ( active.parent('.dropdown-menu') )  {
          active.closest('li.dropdown').addClass('active')
        }
      }

  }


 /* SCROLLSPY PLUGIN DEFINITION
  * =========================== */

  $.fn.scrollspy = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('scrollspy')
        , options = typeof option == 'object' && option
      if (!data) $this.data('scrollspy', (data = new ScrollSpy(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.scrollspy.Constructor = ScrollSpy

  $.fn.scrollspy.defaults = {
    offset: 10
  }


 /* SCROLLSPY DATA-API
  * ================== */

  $(function () {
    $('[data-spy="scroll"]').each(function () {
      var $spy = $(this)
      $spy.scrollspy($spy.data())
    })
  })

}( window.jQuery );/* ========================================================
 * bootstrap-tab.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#tabs
 * ========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */


!function( $ ){

  "use strict"

 /* TAB CLASS DEFINITION
  * ==================== */

  var Tab = function ( element ) {
    this.element = $(element)
  }

  Tab.prototype = {

    constructor: Tab

  , show: function () {
      var $this = this.element
        , $ul = $this.closest('ul:not(.dropdown-menu)')
        , selector = $this.attr('data-target')
        , previous
        , $target

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      if ( $this.parent('li').hasClass('active') ) return

      previous = $ul.find('.active a').last()[0]

      $this.trigger({
        type: 'show'
      , relatedTarget: previous
      })

      $target = $(selector)

      this.activate($this.parent('li'), $ul)
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown'
        , relatedTarget: previous
        })
      })
    }

  , activate: function ( element, container, callback) {
      var $active = container.find('> .active')
        , transition = callback
            && $.support.transition
            && $active.hasClass('fade')

      function next() {
        $active
          .removeClass('active')
          .find('> .dropdown-menu > .active')
          .removeClass('active')

        element.addClass('active')

        if (transition) {
          element[0].offsetWidth // reflow for transition
          element.addClass('in')
        } else {
          element.removeClass('fade')
        }

        if ( element.parent('.dropdown-menu') ) {
          element.closest('li.dropdown').addClass('active')
        }

        callback && callback()
      }

      transition ?
        $active.one($.support.transition.end, next) :
        next()

      $active.removeClass('in')
    }
  }


 /* TAB PLUGIN DEFINITION
  * ===================== */

  $.fn.tab = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tab')
      if (!data) $this.data('tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tab.Constructor = Tab


 /* TAB DATA-API
  * ============ */

  $(function () {
    $('body').on('click.tab.data-api', '[data-toggle="tab"], [data-toggle="pill"]', function (e) {
      e.preventDefault()
      $(this).tab('show')
    })
  })

}( window.jQuery );/* =============================================================
 * bootstrap-typeahead.js v2.0.2
 * http://twitter.github.com/bootstrap/javascript.html#typeahead
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */

!function( $ ){

  "use strict"

  var Typeahead = function ( element, options ) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.typeahead.defaults, options)
    this.matcher = this.options.matcher || this.matcher
    this.sorter = this.options.sorter || this.sorter
    this.highlighter = this.options.highlighter || this.highlighter
    this.$menu = $(this.options.menu).appendTo('body')
    this.source = this.options.source
    this.shown = false
    this.listen()
  }

  Typeahead.prototype = {

    constructor: Typeahead

  , select: function () {
      var val = this.$menu.find('.active').attr('data-value')
      this.$element.val(val)
      this.$element.change();
      return this.hide()
    }

  , show: function () {
      var pos = $.extend({}, this.$element.offset(), {
        height: this.$element[0].offsetHeight
      })

      this.$menu.css({
        top: pos.top + pos.height
      , left: pos.left
      })

      this.$menu.show()
      this.shown = true
      return this
    }

  , hide: function () {
      this.$menu.hide()
      this.shown = false
      return this
    }

  , lookup: function (event) {
      var that = this
        , items
        , q

      this.query = this.$element.val()

      if (!this.query) {
        return this.shown ? this.hide() : this
      }

      items = $.grep(this.source, function (item) {
        if (that.matcher(item)) return item
      })

      items = this.sorter(items)

      if (!items.length) {
        return this.shown ? this.hide() : this
      }

      return this.render(items.slice(0, this.options.items)).show()
    }

  , matcher: function (item) {
      return ~item.toLowerCase().indexOf(this.query.toLowerCase())
    }

  , sorter: function (items) {
      var beginswith = []
        , caseSensitive = []
        , caseInsensitive = []
        , item

      while (item = items.shift()) {
        if (!item.toLowerCase().indexOf(this.query.toLowerCase())) beginswith.push(item)
        else if (~item.indexOf(this.query)) caseSensitive.push(item)
        else caseInsensitive.push(item)
      }

      return beginswith.concat(caseSensitive, caseInsensitive)
    }

  , highlighter: function (item) {
      return item.replace(new RegExp('(' + this.query + ')', 'ig'), function ($1, match) {
        return '<strong>' + match + '</strong>'
      })
    }

  , render: function (items) {
      var that = this

      items = $(items).map(function (i, item) {
        i = $(that.options.item).attr('data-value', item)
        i.find('a').html(that.highlighter(item))
        return i[0]
      })

      items.first().addClass('active')
      this.$menu.html(items)
      return this
    }

  , next: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , next = active.next()

      if (!next.length) {
        next = $(this.$menu.find('li')[0])
      }

      next.addClass('active')
    }

  , prev: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , prev = active.prev()

      if (!prev.length) {
        prev = this.$menu.find('li').last()
      }

      prev.addClass('active')
    }

  , listen: function () {
      this.$element
        .on('blur',     $.proxy(this.blur, this))
        .on('keypress', $.proxy(this.keypress, this))
        .on('keyup',    $.proxy(this.keyup, this))

      if ($.browser.webkit || $.browser.msie) {
        this.$element.on('keydown', $.proxy(this.keypress, this))
      }

      this.$menu
        .on('click', $.proxy(this.click, this))
        .on('mouseenter', 'li', $.proxy(this.mouseenter, this))
    }

  , keyup: function (e) {
      switch(e.keyCode) {
        case 40: // down arrow
        case 38: // up arrow
          break

        case 9: // tab
        case 13: // enter
          if (!this.shown) return
          this.select()
          break

        case 27: // escape
          if (!this.shown) return
          this.hide()
          break

        default:
          this.lookup()
      }

      e.stopPropagation()
      e.preventDefault()
  }

  , keypress: function (e) {
      if (!this.shown) return

      switch(e.keyCode) {
        case 9: // tab
        case 13: // enter
        case 27: // escape
          e.preventDefault()
          break

        case 38: // up arrow
          e.preventDefault()
          this.prev()
          break

        case 40: // down arrow
          e.preventDefault()
          this.next()
          break
      }

      e.stopPropagation()
    }

  , blur: function (e) {
      var that = this
      setTimeout(function () { that.hide() }, 150)
    }

  , click: function (e) {
      e.stopPropagation()
      e.preventDefault()
      this.select()
    }

  , mouseenter: function (e) {
      this.$menu.find('.active').removeClass('active')
      $(e.currentTarget).addClass('active')
    }

  }


  /* TYPEAHEAD PLUGIN DEFINITION
   * =========================== */

  $.fn.typeahead = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('typeahead')
        , options = typeof option == 'object' && option
      if (!data) $this.data('typeahead', (data = new Typeahead(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.typeahead.defaults = {
    source: []
  , items: 8
  , menu: '<ul class="typeahead dropdown-menu"></ul>'
  , item: '<li><a href="#"></a></li>'
  }

  $.fn.typeahead.Constructor = Typeahead


 /* TYPEAHEAD DATA-API
  * ================== */

  $(function () {
    $('body').on('focus.typeahead.data-api', '[data-provide="typeahead"]', function (e) {
      var $this = $(this)
      if ($this.data('typeahead')) return
      e.preventDefault()
      $this.typeahead($this.data())
    })
  })

}( window.jQuery );

function addingForm(name, n1, n2, sign){
  lt=1+Math.max(n1.length, n2.length);
  var ht="<table id=laddtable_"+name+" border=0>\n";
  ht+="<tr>\n"
    for(i=0; i<lt-n1.length; i++){
      ht+="<td> </td>\n";
    }
  for(i=0; i<n1.length; i++){
    ht+="<td>"+n1[i]+"</td>\n";
  }
  ht+="</tr>\n"
    ht+="<tr>\n"
    for(i=0; i<lt-n2.length; i++){
      if(i==0){	
        ht+="<td>"+sign+"</td>\n";
      }
      else {ht+="<td> </td>\n";}
    }
  for(i=0; i<n2.length; i++){
    ht+="<td>"+n2[i]+"</td>\n";
  }
  ht+="</tr>\n"
    ht+="<tr>\n"
    for(i=0; i<lt; i++){
      ht+="<td><input type=text class="+name+"_linps id="+name+"_lin"+i+" maxlength=1 style=\"width:15px; height:20px\"></td>\n";
    }
  ht+="</tr>\n"
    ht+="</table>";
  $('#ladding_'+name).append(ht);
  $('#laddtable_'+name).attr("style", "background-color:transparent; font:10pt Courier;");
  $("#"+name+"_lin"+(lt-1)).select();
  tot=[];
  $("."+name+"_linps").keypress(function(e){
    String.fromCharCode(e.keyCode)
    if(e.keyCode > 47 && e.keyCode < 58) {
      tot[$(this).attr("id")[$(this).attr("id").length-1]]=String.fromCharCode(e.keyCode);
      $(this).attr("value", String.fromCharCode(e.keyCode));
      $("#"+name).attr("value", tot.join(""));
    }
  });
  for (var j=1; j<lt; j++)
  {
    $("#"+name+"_lin"+j).keypress({j:j}, function(e){
        $("#"+name+"_lin"+(e.data.j-1)).select();
    });
  }

}
;
function badges_look(){
 	//bclr=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
 	bclr=["gold","silver","bronze"];
	for(i=0; i < $(".badges").length; i++){
		$(".badges").eq(i).css("top", 10*parseInt(i/5)-20);
		$(".badges").eq(i).css("left", 10*parseInt(i % 5));
	}
	$("#get_badge").parent().hover(function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 20*parseInt(i/5)-10-20);
			$(".badges").eq(i).css("left", 20*parseInt(i % 5)-10);
		}
	}, function(){
		for(i=0; i < $(".badges").length; i++){
			$(".badges").eq(i).css("top", 10*parseInt(i/5)-20);
			$(".badges").eq(i).css("left", 10*parseInt(i % 5));
		}
	});
	for(i=0; i < $(".badgesbw").length; i++){
		$(".badgesbw").eq(i).css("top", 10*parseInt(i/5)-20);
		$(".badgesbw").eq(i).css("left", 10*parseInt(i % 5));
	}
	$("#get_badge2").parent().hover(function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 20*parseInt(i/5)-10-20);
			$(".badgesbw").eq(i).css("left", 20*parseInt(i % 5)-10);
		}
	}, function(){
		for(i=0; i < $(".badgesbw").length; i++){
			$(".badgesbw").eq(i).css("top", 10*parseInt(i/5)-20);
			$(".badgesbw").eq(i).css("left", 10*parseInt(i % 5));
		}
	});
}
;
(function() {


}).call(this);
function webkit(){
	if(!$.browser.webkit){
		$('body').append('<div id=dimmer onclick=\'hide_webkit()\' style=\'display:block\'></div>');
		$('#dimmer').append('<div id=\'chrome_div\'></div>');
		$('#chrome_div').append('<a href=\'http://www.google.com/chrome\'><img class=\'chrome_icon\' src=\'/assets/chrome_icon.png\'/></a>');
		$('#chrome_div').append('<a href=\'http://google.com/chrome\'><p class=\'chrome_text\'>Click Here to Download Google Chrome for the Best SmarterGrades Experience</p></a>');
	}
}
function hide_webkit(){
	$('#dimmer').hide();
}
;
(function ($) {
  function name(elt) {
    return elt.attr('data-name')
  }

  function hidden_field(elt) {
    return $('[name="' + name(elt) + '"]');
  }

  function has_hidden_field(elt) {
    return hidden_field(elt).length >= 1;
  }

  function add_hidden_field(elt) {
    console.log('adding hidden_fiel?d ' + elt + ' : ' + name(elt) + ' ' + has_hidden_field(elt));
    if(!has_hidden_field(elt)) {
      console.log('adding hidden_field');
      elt.after('<input name="' + name(elt) + '" id="' + 
                  name(elt) + '" type="hidden" value="1">');
      console.log('success: ' + has_hidden_field(elt));
    }
  }

  function remove_hidden_field(elt) {
    hidden_field(elt).remove();
  }

  function check(elt) {
    elt.removeClass("unchecked");
    elt.addClass("checked");
    add_hidden_field(elt);
  }

  function uncheck(elt) {
    elt.removeClass("checked");
    elt.addClass("unchecked");
    remove_hidden_field(elt);
  }

  function swaptext(elt) {
    var tmp = elt.attr('data-alt');
    if(tmp == undefined) { return; }

    elt.attr('data-alt', elt.text());
    elt.text(tmp);
  }

  function toggle(elt) {
    if(elt.hasClass("checked")) {
      uncheck(elt);
    } else {
      check(elt);;
    }
    swaptext(elt)
  }

  $.fn.checkBox = function(){
    return this.each( function() {
      var $elt = $(this);

      if($elt.hasClass("checked") && !has_hidden_field($elt)) {
        add_hidden_field($elt);
      }

      $elt.css('cursor', 'pointer');
      $elt.click(function() {
        toggle($elt)
      });
    });
  }

  $.fn.checkBoxToggle = function() {
    toggle(this);
  }
})($);
(function() {


}).call(this);
(function() {


}).call(this);
function commaBox(name){
  $("#"+name).click(function(e){
    if($("#"+name).attr("value")=="0"){
      $("#"+name).attr("value", "1");
      $("#"+name).addClass("commachecked");
    }
    else{
      $("#"+name).attr("value", "0");
      $("#"+name).removeClass("commachecked");
    }
  });
}


;
(function() {


}).call(this);
function hide_custom_problem_form() {
  $('#dimmer').unbind('click');

  $('#custom_problem_form').hide();
  $('#custom_problem_form').find('.input-field,textarea').attr('value', '');
  $('#dimmer').hide();
}

// change the problem_type_id field for the custom_problem form
// and show it!
function custom_problem_form(ptype_id, ptype_name) {
  var cp_form = $('#custom_problem_form');
  if(cp_form.length == 0) {
    $('body').prepend("<div id=custom_problem_form class=problem_overlay></div>");
    cp_form = $('#custom_problem_form');
  }

  var dimmer = $('#dimmer');
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div>");
    dimmer = $('#dimmer');
  }

  cp_form.find('[name~=problem_type_id]').attr('value', ptype_id);
  cp_form.find('h2:first').text(ptype_name + ": Create Problem");
  cp_form.show();

  dimmer.show();
  dimmer.click(hide_custom_problem_form);
}
;
//function tmpBSinitBlah() {
//	// $('li.stat').click(function() {
//	// var class_id = $(this).attr('data-classrm')
//	//   , ptype_id = $(this).attr('data-ptype');
//
//	// console.log("class: " + class_id + "\tptype_id: " + ptype_id)
//	// $.ajax(('/details_concept?classroom=' + class_id + '&problem_type=' + ptype_id),
//	// 	   { type : "POST", dataType : "script" });
//	// });
//
//	// $('li.probs_done').each(function() {
//	// 	setProbsDonePercent($(this), params.class_size);
//	// });
//
//	// $('li.percent').each(function() {
//
//	// });
//
//	// $('li.stu_attempted').each(function() {
//	// 	setAttemptedPercent($(this), params.class_size);
//	// });
//}

function initConcepts() {
//  alert("hello");
//
	$('li.stat li').each(function() {
		initConceptStat($(this));
    $(this).tooltip();
	});
}

function initConceptStat(stat) {		
	var $div = stat.children('div').first()
	  , w = $div.attr("data-percent");

  stat.addClass("stat-bar");

  if(w == undefined) {
    $div.css('background-color', 'gray');
    $div.css('width', '100%');
  }
  else {
    $div.css("width", ""+w+"%");
  }
}
;
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function hideExplanation(){
	$('#problem_overlay .explanation').hide();
	$('#problem_overlay .problem').show();
	$('#hide_explanation').replaceWith(
		'<a class="button-blue" id="see_explanation" href="#" ' +
		'onclick="showExplanation(); return false;">See Explanation</a>'
		);
  initProblem();
  closeWithDimmer();
}

function showExplanation(){
	$('#problem_overlay .explanation').show();
	$('#problem_overlay .problem').hide();
	$('#see_explanation').replaceWith(
		'<a class="button-blue" id="hide_explanation" href="#" ' +
		'onclick="hideExplanation(); return false;">Stop Explanation</a>'
		);
  initProblem();
  closeWithDimmer();
}
;
if(!window['googleLT_']){window['googleLT_']=(new Date()).getTime();}if (!window['google']) {
window['google'] = {};
}
if (!window['google']['loader']) {
window['google']['loader'] = {};
google.loader.ServiceBase = 'https://www.google.com/uds';
google.loader.GoogleApisBase = 'https://ajax.googleapis.com/ajax';
google.loader.ApiKey = 'notsupplied';
google.loader.KeyVerified = true;
google.loader.LoadFailure = false;
google.loader.Secure = true;
google.loader.GoogleLocale = 'www.google.com';
google.loader.ClientLocation = null;
google.loader.AdditionalParams = '';
(function() {var d=encodeURIComponent,g=window,h=document;function l(a,b){return a.load=b}var m="push",n="replace",q="charAt",r="indexOf",t="ServiceBase",u="name",v="getTime",w="length",x="prototype",y="setTimeout",z="loader",A="substring",B="join",C="toLowerCase";function D(a){return a in E?E[a]:E[a]=-1!=navigator.userAgent[C]()[r](a)}var E={};function F(a,b){var c=function(){};c.prototype=b[x];a.U=b[x];a.prototype=new c}
function G(a,b,c){var e=Array[x].slice.call(arguments,2)||[];return function(){var c=e.concat(Array[x].slice.call(arguments));return a.apply(b,c)}}function H(a){a=Error(a);a.toString=function(){return this.message};return a}function I(a,b){for(var c=a.split(/\./),e=g,f=0;f<c[w]-1;f++)e[c[f]]||(e[c[f]]={}),e=e[c[f]];e[c[c[w]-1]]=b}function J(a,b,c){a[b]=c}if(!K)var K=I;if(!L)var L=J;google[z].v={};K("google.loader.callbacks",google[z].v);var M={},N={};google[z].eval={};K("google.loader.eval",google[z].eval);
l(google,function(a,b,c){function e(a){var b=a.split(".");if(2<b[w])throw H("Module: '"+a+"' not found!");"undefined"!=typeof b[1]&&(f=b[0],c.packages=c.packages||[],c.packages[m](b[1]))}var f=a;c=c||{};if(a instanceof Array||a&&"object"==typeof a&&"function"==typeof a[B]&&"function"==typeof a.reverse)for(var k=0;k<a[w];k++)e(a[k]);else e(a);if(a=M[":"+f]){c&&(!c.language&&c.locale)&&(c.language=c.locale);c&&"string"==typeof c.callback&&(k=c.callback,k.match(/^[[\]A-Za-z0-9._]+$/)&&(k=g.eval(k),c.callback=
k));if((k=c&&null!=c.callback)&&!a.s(b))throw H("Module: '"+f+"' must be loaded before DOM onLoad!");k?a.m(b,c)?g[y](c.callback,0):a.load(b,c):a.m(b,c)||a.load(b,c)}else throw H("Module: '"+f+"' not found!");});K("google.load",google.load);
google.T=function(a,b){b?(0==O[w]&&(P(g,"load",Q),!D("msie")&&!D("safari")&&!D("konqueror")&&D("mozilla")||g.opera?g.addEventListener("DOMContentLoaded",Q,!1):D("msie")?h.write("<script defer onreadystatechange='google.loader.domReady()' src=//:>\x3c/script>"):(D("safari")||D("konqueror"))&&g[y](S,10)),O[m](a)):P(g,"load",a)};K("google.setOnLoadCallback",google.T);
function P(a,b,c){if(a.addEventListener)a.addEventListener(b,c,!1);else if(a.attachEvent)a.attachEvent("on"+b,c);else{var e=a["on"+b];a["on"+b]=null!=e?aa([c,e]):c}}function aa(a){return function(){for(var b=0;b<a[w];b++)a[b]()}}var O=[];google[z].P=function(){var a=g.event.srcElement;"complete"==a.readyState&&(a.onreadystatechange=null,a.parentNode.removeChild(a),Q())};K("google.loader.domReady",google[z].P);var ba={loaded:!0,complete:!0};function S(){ba[h.readyState]?Q():0<O[w]&&g[y](S,10)}
function Q(){for(var a=0;a<O[w];a++)O[a]();O.length=0}google[z].d=function(a,b,c){if(c){var e;"script"==a?(e=h.createElement("script"),e.type="text/javascript",e.src=b):"css"==a&&(e=h.createElement("link"),e.type="text/css",e.href=b,e.rel="stylesheet");(a=h.getElementsByTagName("head")[0])||(a=h.body.parentNode.appendChild(h.createElement("head")));a.appendChild(e)}else"script"==a?h.write('<script src="'+b+'" type="text/javascript">\x3c/script>'):"css"==a&&h.write('<link href="'+b+'" type="text/css" rel="stylesheet"></link>')};
K("google.loader.writeLoadTag",google[z].d);google[z].Q=function(a){N=a};K("google.loader.rfm",google[z].Q);google[z].S=function(a){for(var b in a)"string"==typeof b&&(b&&":"==b[q](0)&&!M[b])&&(M[b]=new T(b[A](1),a[b]))};K("google.loader.rpl",google[z].S);google[z].R=function(a){if((a=a.specs)&&a[w])for(var b=0;b<a[w];++b){var c=a[b];"string"==typeof c?M[":"+c]=new U(c):(c=new V(c[u],c.baseSpec,c.customSpecs),M[":"+c[u]]=c)}};K("google.loader.rm",google[z].R);google[z].loaded=function(a){M[":"+a.module].l(a)};
K("google.loader.loaded",google[z].loaded);google[z].O=function(){return"qid="+((new Date)[v]().toString(16)+Math.floor(1E7*Math.random()).toString(16))};K("google.loader.createGuidArg_",google[z].O);I("google_exportSymbol",I);I("google_exportProperty",J);google[z].a={};K("google.loader.themes",google[z].a);google[z].a.I="//www.google.com/cse/style/look/bubblegum.css";L(google[z].a,"BUBBLEGUM",google[z].a.I);google[z].a.K="//www.google.com/cse/style/look/greensky.css";L(google[z].a,"GREENSKY",google[z].a.K);
google[z].a.J="//www.google.com/cse/style/look/espresso.css";L(google[z].a,"ESPRESSO",google[z].a.J);google[z].a.M="//www.google.com/cse/style/look/shiny.css";L(google[z].a,"SHINY",google[z].a.M);google[z].a.L="//www.google.com/cse/style/look/minimalist.css";L(google[z].a,"MINIMALIST",google[z].a.L);google[z].a.N="//www.google.com/cse/style/look/v2/default.css";L(google[z].a,"V2_DEFAULT",google[z].a.N);function U(a){this.b=a;this.o=[];this.n={};this.e={};this.f={};this.j=!0;this.c=-1}
U[x].g=function(a,b){var c="";void 0!=b&&(void 0!=b.language&&(c+="&hl="+d(b.language)),void 0!=b.nocss&&(c+="&output="+d("nocss="+b.nocss)),void 0!=b.nooldnames&&(c+="&nooldnames="+d(b.nooldnames)),void 0!=b.packages&&(c+="&packages="+d(b.packages)),null!=b.callback&&(c+="&async=2"),void 0!=b.style&&(c+="&style="+d(b.style)),void 0!=b.noexp&&(c+="&noexp=true"),void 0!=b.other_params&&(c+="&"+b.other_params));if(!this.j){google[this.b]&&google[this.b].JSHash&&(c+="&sig="+d(google[this.b].JSHash));
var e=[],f;for(f in this.n)":"==f[q](0)&&e[m](f[A](1));for(f in this.e)":"==f[q](0)&&this.e[f]&&e[m](f[A](1));c+="&have="+d(e[B](","))}return google[z][t]+"/?file="+this.b+"&v="+a+google[z].AdditionalParams+c};U[x].t=function(a){var b=null;a&&(b=a.packages);var c=null;if(b)if("string"==typeof b)c=[a.packages];else if(b[w])for(c=[],a=0;a<b[w];a++)"string"==typeof b[a]&&c[m](b[a][n](/^\s*|\s*$/,"")[C]());c||(c=["default"]);b=[];for(a=0;a<c[w];a++)this.n[":"+c[a]]||b[m](c[a]);return b};
l(U[x],function(a,b){var c=this.t(b),e=b&&null!=b.callback;if(e)var f=new W(b.callback);for(var k=[],p=c[w]-1;0<=p;p--){var s=c[p];e&&f.B(s);if(this.e[":"+s])c.splice(p,1),e&&this.f[":"+s][m](f);else k[m](s)}if(c[w]){b&&b.packages&&(b.packages=c.sort()[B](","));for(p=0;p<k[w];p++)s=k[p],this.f[":"+s]=[],e&&this.f[":"+s][m](f);if(b||null==N[":"+this.b]||null==N[":"+this.b].versions[":"+a]||google[z].AdditionalParams||!this.j)b&&b.autoloaded||google[z].d("script",this.g(a,b),e);else{c=N[":"+this.b];
google[this.b]=google[this.b]||{};for(var R in c.properties)R&&":"==R[q](0)&&(google[this.b][R[A](1)]=c.properties[R]);google[z].d("script",google[z][t]+c.path+c.js,e);c.css&&google[z].d("css",google[z][t]+c.path+c.css,e)}this.j&&(this.j=!1,this.c=(new Date)[v](),1!=this.c%100&&(this.c=-1));for(p=0;p<k[w];p++)s=k[p],this.e[":"+s]=!0}});
U[x].l=function(a){-1!=this.c&&(X("al_"+this.b,"jl."+((new Date)[v]()-this.c),!0),this.c=-1);this.o=this.o.concat(a.components);google[z][this.b]||(google[z][this.b]={});google[z][this.b].packages=this.o.slice(0);for(var b=0;b<a.components[w];b++){this.n[":"+a.components[b]]=!0;this.e[":"+a.components[b]]=!1;var c=this.f[":"+a.components[b]];if(c){for(var e=0;e<c[w];e++)c[e].C(a.components[b]);delete this.f[":"+a.components[b]]}}};U[x].m=function(a,b){return 0==this.t(b)[w]};U[x].s=function(){return!0};
function W(a){this.F=a;this.q={};this.r=0}W[x].B=function(a){this.r++;this.q[":"+a]=!0};W[x].C=function(a){this.q[":"+a]&&(this.q[":"+a]=!1,this.r--,0==this.r&&g[y](this.F,0))};function V(a,b,c){this.name=a;this.D=b;this.p=c;this.u=this.h=!1;this.k=[];google[z].v[this[u]]=G(this.l,this)}F(V,U);l(V[x],function(a,b){var c=b&&null!=b.callback;c?(this.k[m](b.callback),b.callback="google.loader.callbacks."+this[u]):this.h=!0;b&&b.autoloaded||google[z].d("script",this.g(a,b),c)});V[x].m=function(a,b){return b&&null!=b.callback?this.u:this.h};V[x].l=function(){this.u=!0;for(var a=0;a<this.k[w];a++)g[y](this.k[a],0);this.k=[]};
var Y=function(a,b){return a.string?d(a.string)+"="+d(b):a.regex?b[n](/(^.*$)/,a.regex):""};V[x].g=function(a,b){return this.G(this.w(a),a,b)};
V[x].G=function(a,b,c){var e="";a.key&&(e+="&"+Y(a.key,google[z].ApiKey));a.version&&(e+="&"+Y(a.version,b));b=google[z].Secure&&a.ssl?a.ssl:a.uri;if(null!=c)for(var f in c)a.params[f]?e+="&"+Y(a.params[f],c[f]):"other_params"==f?e+="&"+c[f]:"base_domain"==f&&(b="http://"+c[f]+a.uri[A](a.uri[r]("/",7)));google[this[u]]={};-1==b[r]("?")&&e&&(e="?"+e[A](1));return b+e};V[x].s=function(a){return this.w(a).deferred};V[x].w=function(a){if(this.p)for(var b=0;b<this.p[w];++b){var c=this.p[b];if(RegExp(c.pattern).test(a))return c}return this.D};function T(a,b){this.b=a;this.i=b;this.h=!1}F(T,U);l(T[x],function(a,b){this.h=!0;google[z].d("script",this.g(a,b),!1)});T[x].m=function(){return this.h};T[x].l=function(){};T[x].g=function(a,b){if(!this.i.versions[":"+a]){if(this.i.aliases){var c=this.i.aliases[":"+a];c&&(a=c)}if(!this.i.versions[":"+a])throw H("Module: '"+this.b+"' with version '"+a+"' not found!");}return google[z].GoogleApisBase+"/libs/"+this.b+"/"+a+"/"+this.i.versions[":"+a][b&&b.uncompressed?"uncompressed":"compressed"]};
T[x].s=function(){return!1};var ca=!1,Z=[],da=(new Date)[v](),fa=function(){ca||(P(g,"unload",ea),ca=!0)},ga=function(a,b){fa();if(!(google[z].Secure||google[z].Options&&!1!==google[z].Options.csi)){for(var c=0;c<a[w];c++)a[c]=d(a[c][C]()[n](/[^a-z0-9_.]+/g,"_"));for(c=0;c<b[w];c++)b[c]=d(b[c][C]()[n](/[^a-z0-9_.]+/g,"_"));g[y](G($,null,"//gg.google.com/csi?s=uds&v=2&action="+a[B](",")+"&it="+b[B](",")),1E4)}},X=function(a,b,c){c?ga([a],[b]):(fa(),Z[m]("r"+Z[w]+"="+d(a+(b?"|"+b:""))),g[y](ea,5<Z[w]?0:15E3))},ea=function(){if(Z[w]){var a=
google[z][t];0==a[r]("http:")&&(a=a[n](/^http:/,"https:"));$(a+"/stats?"+Z[B]("&")+"&nc="+(new Date)[v]()+"_"+((new Date)[v]()-da));Z.length=0}},$=function(a){var b=new Image,c=$.H++;$.A[c]=b;b.onload=b.onerror=function(){delete $.A[c]};b.src=a;b=null};$.A={};$.H=0;I("google.loader.recordCsiStat",ga);I("google.loader.recordStat",X);I("google.loader.createImageForLogging",$);

}) ();google.loader.rm({"specs":["feeds","spreadsheets","gdata","visualization",{"name":"sharing","baseSpec":{"uri":"http://www.google.com/s2/sharing/js","ssl":null,"key":{"string":"key"},"version":{"string":"v"},"deferred":false,"params":{"language":{"string":"hl"}}}},"search","orkut","ads","elements",{"name":"books","baseSpec":{"uri":"http://books.google.com/books/api.js","ssl":"https://encrypted.google.com/books/api.js","key":{"string":"key"},"version":{"string":"v"},"deferred":true,"params":{"callback":{"string":"callback"},"language":{"string":"hl"}}}},{"name":"friendconnect","baseSpec":{"uri":"http://www.google.com/friendconnect/script/friendconnect.js","ssl":null,"key":{"string":"key"},"version":{"string":"v"},"deferred":false,"params":{}}},"identitytoolkit","ima",{"name":"maps","baseSpec":{"uri":"http://maps.google.com/maps?file\u003dgoogleapi","ssl":"https://maps-api-ssl.google.com/maps?file\u003dgoogleapi","key":{"string":"key"},"version":{"string":"v"},"deferred":true,"params":{"callback":{"regex":"callback\u003d$1\u0026async\u003d2"},"language":{"string":"hl"}}},"customSpecs":[{"uri":"http://maps.googleapis.com/maps/api/js","ssl":"https://maps.googleapis.com/maps/api/js","version":{"string":"v"},"deferred":true,"params":{"callback":{"string":"callback"},"language":{"string":"hl"}},"pattern":"^(3|3..*)$"}]},"payments","wave","annotations_v2","earth","language",{"name":"annotations","baseSpec":{"uri":"http://www.google.com/reviews/scripts/annotations_bootstrap.js","ssl":null,"key":{"string":"key"},"version":{"string":"v"},"deferred":true,"params":{"callback":{"string":"callback"},"language":{"string":"hl"},"country":{"string":"gl"}}}},"picker"]});
google.loader.rfm({":search":{"versions":{":1":"1",":1.0":"1"},"path":"/api/search/1.0/351077565dad05b6847b1f7d41e36949/","js":"default+en.I.js","css":"default+en.css","properties":{":JSHash":"351077565dad05b6847b1f7d41e36949",":NoOldNames":false,":Version":"1.0"}},":language":{"versions":{":1":"1",":1.0":"1"},"path":"/api/language/1.0/72dfd738bc1b18a14ab936bb2690a4f0/","js":"default+en.I.js","properties":{":JSHash":"72dfd738bc1b18a14ab936bb2690a4f0",":Version":"1.0"}},":feeds":{"versions":{":1":"1",":1.0":"1"},"path":"/api/feeds/1.0/e658fb253c8b588196cf534cc43ab319/","js":"default+en.I.js","css":"default+en.css","properties":{":JSHash":"e658fb253c8b588196cf534cc43ab319",":Version":"1.0"}},":spreadsheets":{"versions":{":0":"1",":0.4":"1"},"path":"/api/spreadsheets/0.4/87ff7219e9f8a8164006cbf28d5e911a/","js":"default.I.js","properties":{":JSHash":"87ff7219e9f8a8164006cbf28d5e911a",":Version":"0.4"}},":ima":{"versions":{":3":"1",":3.0":"1"},"path":"/api/ima/3.0/28a914332232c9a8ac0ae8da68b1006e/","js":"default.I.js","properties":{":JSHash":"28a914332232c9a8ac0ae8da68b1006e",":Version":"3.0"}},":wave":{"versions":{":1":"1",":1.0":"1"},"path":"/api/wave/1.0/3b6f7573ff78da6602dda5e09c9025bf/","js":"default.I.js","properties":{":JSHash":"3b6f7573ff78da6602dda5e09c9025bf",":Version":"1.0"}},":earth":{"versions":{":1":"1",":1.0":"1"},"path":"/api/earth/1.0/109c7b2bae7fe6cc34ea875176165d81/","js":"default.I.js","properties":{":JSHash":"109c7b2bae7fe6cc34ea875176165d81",":Version":"1.0"}},":annotations":{"versions":{":1":"1",":1.0":"1"},"path":"/api/annotations/1.0/bacce7b6155a1bbadda3c05d65391b22/","js":"default+en.I.js","properties":{":JSHash":"bacce7b6155a1bbadda3c05d65391b22",":Version":"1.0"}},":picker":{"versions":{":1":"1",":1.0":"1"},"path":"/api/picker/1.0/27b625d21ca34b09c89dcd3d22f65143/","js":"default.I.js","css":"default.css","properties":{":JSHash":"27b625d21ca34b09c89dcd3d22f65143",":Version":"1.0"}}});
google.loader.rpl({":scriptaculous":{"versions":{":1.8.3":{"uncompressed":"scriptaculous.js","compressed":"scriptaculous.js"},":1.9.0":{"uncompressed":"scriptaculous.js","compressed":"scriptaculous.js"},":1.8.2":{"uncompressed":"scriptaculous.js","compressed":"scriptaculous.js"},":1.8.1":{"uncompressed":"scriptaculous.js","compressed":"scriptaculous.js"}},"aliases":{":1.8":"1.8.3",":1":"1.9.0",":1.9":"1.9.0"}},":yui":{"versions":{":2.6.0":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":2.9.0":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":2.7.0":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":2.8.0r4":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":2.8.2r1":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":2.8.1":{"uncompressed":"build/yuiloader/yuiloader.js","compressed":"build/yuiloader/yuiloader-min.js"},":3.3.0":{"uncompressed":"build/yui/yui.js","compressed":"build/yui/yui-min.js"}},"aliases":{":3":"3.3.0",":2":"2.9.0",":2.7":"2.7.0",":2.8.2":"2.8.2r1",":2.6":"2.6.0",":2.9":"2.9.0",":2.8":"2.8.2r1",":2.8.0":"2.8.0r4",":3.3":"3.3.0"}},":swfobject":{"versions":{":2.1":{"uncompressed":"swfobject_src.js","compressed":"swfobject.js"},":2.2":{"uncompressed":"swfobject_src.js","compressed":"swfobject.js"}},"aliases":{":2":"2.2"}},":webfont":{"versions":{":1.0.28":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.27":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.29":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.12":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.13":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.14":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.15":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.10":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.11":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.2":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.1":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.0":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.6":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.19":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.5":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.18":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.4":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.17":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.3":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.16":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.9":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.21":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.22":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.25":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.26":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.23":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"},":1.0.24":{"uncompressed":"webfont_debug.js","compressed":"webfont.js"}},"aliases":{":1":"1.0.29",":1.0":"1.0.29"}},":ext-core":{"versions":{":3.1.0":{"uncompressed":"ext-core-debug.js","compressed":"ext-core.js"},":3.0.0":{"uncompressed":"ext-core-debug.js","compressed":"ext-core.js"}},"aliases":{":3":"3.1.0",":3.0":"3.0.0",":3.1":"3.1.0"}},":mootools":{"versions":{":1.3.1":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.1.1":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.3.0":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.3.2":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.1.2":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.2.3":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.2.4":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.2.1":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.2.2":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.2.5":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.4.0":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.4.1":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"},":1.4.2":{"uncompressed":"mootools.js","compressed":"mootools-yui-compressed.js"}},"aliases":{":1":"1.1.2",":1.11":"1.1.1",":1.4":"1.4.2",":1.3":"1.3.2",":1.2":"1.2.5",":1.1":"1.1.2"}},":jqueryui":{"versions":{":1.8.0":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.2":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.1":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.15":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.14":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.13":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.12":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.11":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.10":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.17":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.16":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.6.0":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.9":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.7":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.8":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.7.2":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.5":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.7.3":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.6":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.7.0":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.7.1":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.8.4":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.5.3":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"},":1.5.2":{"uncompressed":"jquery-ui.js","compressed":"jquery-ui.min.js"}},"aliases":{":1.8":"1.8.17",":1.7":"1.7.3",":1.6":"1.6.0",":1":"1.8.17",":1.5":"1.5.3",":1.8.3":"1.8.4"}},":chrome-frame":{"versions":{":1.0.2":{"uncompressed":"CFInstall.js","compressed":"CFInstall.min.js"},":1.0.1":{"uncompressed":"CFInstall.js","compressed":"CFInstall.min.js"},":1.0.0":{"uncompressed":"CFInstall.js","compressed":"CFInstall.min.js"}},"aliases":{":1":"1.0.2",":1.0":"1.0.2"}},":dojo":{"versions":{":1.3.1":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.3.0":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.6.1":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.1.1":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.3.2":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.6.0":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.2.3":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.7.2":{"uncompressed":"dojo/dojo.js.uncompressed.js","compressed":"dojo/dojo.js"},":1.7.0":{"uncompressed":"dojo/dojo.js.uncompressed.js","compressed":"dojo/dojo.js"},":1.7.1":{"uncompressed":"dojo/dojo.js.uncompressed.js","compressed":"dojo/dojo.js"},":1.4.3":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.5.1":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.5.0":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.2.0":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.4.0":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"},":1.4.1":{"uncompressed":"dojo/dojo.xd.js.uncompressed.js","compressed":"dojo/dojo.xd.js"}},"aliases":{":1.7":"1.7.2",":1":"1.6.1",":1.6":"1.6.1",":1.5":"1.5.1",":1.4":"1.4.3",":1.3":"1.3.2",":1.2":"1.2.3",":1.1":"1.1.1"}},":prototype":{"versions":{":1.7.0.0":{"uncompressed":"prototype.js","compressed":"prototype.js"},":1.6.0.2":{"uncompressed":"prototype.js","compressed":"prototype.js"},":1.6.1.0":{"uncompressed":"prototype.js","compressed":"prototype.js"},":1.6.0.3":{"uncompressed":"prototype.js","compressed":"prototype.js"}},"aliases":{":1.7":"1.7.0.0",":1.6.1":"1.6.1.0",":1":"1.7.0.0",":1.6":"1.6.1.0",":1.7.0":"1.7.0.0",":1.6.0":"1.6.0.3"}},":jquery":{"versions":{":1.6.2":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.3.1":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.6.1":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.3.0":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.6.4":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.6.3":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.3.2":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.6.0":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.2.3":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.7.0":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.7.1":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.2.6":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.4.3":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.4.4":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.5.1":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.5.0":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.4.0":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.5.2":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.4.1":{"uncompressed":"jquery.js","compressed":"jquery.min.js"},":1.4.2":{"uncompressed":"jquery.js","compressed":"jquery.min.js"}},"aliases":{":1.7":"1.7.1",":1.6":"1.6.4",":1":"1.7.1",":1.5":"1.5.2",":1.4":"1.4.4",":1.3":"1.3.2",":1.2":"1.2.6"}}});
}
;
/*!
 * jQuery Box Lid Plugin v0.1
 * https://github.com/jimjh/box-lid
 *
 * Copyright 2013 Jiunn Haur Lim
 * Released under the MIT License
 *
 * Usage:
 *    $('.box-lid-menu').boxLid();
 */

function box_lid(){
!function(n){"use strict";function t(t){t=n.extend({container:"body",flag:"box-lid-open"},t);var e=n(t.container);this.open=function(){e.data("box-lid-timer",setTimeout(function(){e.addClass(t.flag)},100))},this.close=function(){clearTimeout(e.data("box-lid-timer")),e.removeClass(t.flag)}}n.fn.boxLid=function(e){var o=new t(e);return this.each(function(){n(this).hover(o.open,o.close)})}}(jQuery);
}
;
/***
* Author: Erwin Yusrizal
* UX by: Tai Nguyen
* Created On: 27/02/2013
* Version: 1.1.0
* Issue, Feature & Bug Support: erwin.yusrizal@gmail.com
***/

function jqwalk(){
;(function ($, window, document, undefined) {

	/**
    * GLOBAR VAR
    */
    var _globalWalkthrough = {},
         _elements = [],
         _activeWalkthrough,
         _activeId,
         _counter = 0,
         _isCookieLoad,
         _firstTimeLoad = true,
         _onLoad = true,
         _index = 0,
         _isWalkthroughActive = true,
         $jpwOverlay = $('<div id="jpwOverlay"></div>'),
         $jpWalkthrough = $('<div id="jpWalkthrough"></div>'),
         $jpwTooltip = $('<div id="jpwTooltip"></div>');

    /**
    * PUBLIC METHOD
    */

    var methods = {

        isPageWalkthroughActive: function () {
            if (_isWalkthroughActive) {
                return true;
            }
            return false;

        },

        currIndex: function () {
            return _index;
        },

        //init method
        init: function (options) {

            var options = $.extend({}, $.fn.pagewalkthrough.options, options);

            return this.each(function () {
                var $this = $(this),
                    elementId = $this.attr('id');                    

                options = options || {};
                options.elementID = elementId;

                _globalWalkthrough[elementId] = options;
                _elements.push(elementId);

                //check if onLoad and this is first time load
                if (options.onLoad) {
                    _counter++;
                }

                //get first onload = true
                if (_counter == 1 && _onLoad) {
                    _activeId = elementId;
                    _activeWalkthrough = _globalWalkthrough[_activeId];      
                    _onLoad = false;              
                } 

                // when user scroll the page, scroll it back to keep walkthought on user view
                $(window).scroll(function () {
                    if (_isWalkthroughActive && _activeWalkthrough.steps[_index].stayFocus) {
                        clearTimeout($.data(this, 'scrollTimer'));
                        $.data(this, 'scrollTimer', setTimeout(function () {
                            scrollToTarget(_activeWalkthrough);
                        }, 250));
                    }

                    return false;

                });

            });

        },

        renderOverlay: function () {

            //if each walkthrough has onLoad = true, throw warning message to the console
            if (_counter > 1) {
                debug('Warning: Only first walkthrough will be shown onLoad as default');
            }          

            //get cookie load
            _isCookieLoad = getCookie('_walkthrough-' + _activeId);

            //check if first time walkthrough
            if (_isCookieLoad == undefined) {
                _isWalkthroughActive = true;
                buildWalkthrough();
                showCloseButton();

                scrollToTarget();
                
                setTimeout(function () {
                    //call onAfterShow callback
                    if (_index == 0 && _firstTimeLoad) {
                        if (!onAfterShow()) return;
                    }
                }, 100);            
            } else {//check when user used to close the walkthrough to call the onCookieLoad callback
                onCookieLoad(_globalWalkthrough);
            }
        },

        restart: function (e) {
            if (_index == 0) return;

            _index = 0;
            if(!(onRestart(e)))return;
            if(!(onEnter(e)))return;
            buildWalkthrough();

            scrollToTarget();
            
        },

        close: function (target) {

            _index = 0;
            _firstTimeLoad = true;

            _isWalkthroughActive = false;

            if (target) {
                //set cookie to false
                setCookie('_walkthrough-' + target, 0, 365);
                _isCookieLoad = getCookie('_walkthrough-' + target);
            } else {
                //set cookie to false
                setCookie('_walkthrough-' + _activeId, 0, 365);
                _isCookieLoad = getCookie('_walkthrough-' + _activeId);
            }

            if ($('#jpwOverlay').length) {
                $jpwOverlay.fadeOut('slow', function () {
                    $(this).remove();
                });
            }

            if ($('#jpWalkthrough').length) {
                $jpWalkthrough.fadeOut('slow', function () {
                    $(this).html('').remove();
                });
            }

            if ($('#jpwClose').length) {
                $('#jpwClose').fadeOut('slow', function () {
                    $(this).html('').remove();
                });
            }

        },

        show: function (target) {
            _isWalkthroughActive = true;
            _firstTimeLoad = true;
            _activeId = target;
            _activeWalkthrough = _globalWalkthrough[target];

            buildWalkthrough();
            showCloseButton();

            scrollToTarget();

            //call onAfterShow callback
            if (_index == 0 && _firstTimeLoad) {
                if (!onAfterShow()) return;
            }

        },

        next: function (e) {
            _firstTimeLoad = false;
            if (_index == (_activeWalkthrough.steps.length - 1)) return;

            if(!onLeave(e))return;
            _index = parseInt(_index) + 1;
            if(!onEnter(e))return;
            buildWalkthrough();

            scrollToTarget();
            
        },

        prev: function (e) {
            if (_index == 0) return;

            if(!onLeave(e))return;
            _index = parseInt(_index) - 1;
            if(!onEnter(e))return;
            buildWalkthrough();

            scrollToTarget();
        },

        getOptions: function (activeWalkthrough) {
            var _wtObj;

            //get only current active walkthrough
            if (activeWalkthrough) {
                _wtObj = {};
                _wtObj = _activeWalkthrough;
                //get all walkthrough
            } else {
                _wtObj = [];
                for (var wt in _globalWalkthrough) {
                    _wtObj.push(_globalWalkthrough[wt]);
                }
            }

            return _wtObj;
        }


    };//end public method



    /*
    * BUILD OVERLAY
    */
    function buildWalkthrough() {

        var opt = _activeWalkthrough;

        //call onBeforeShow callback
        if (_index == 0 && _firstTimeLoad) {
            if (!onBeforeShow()) return;
        }

        if (opt.steps[_index].popup.type != 'modal' && opt.steps[_index].popup.type != 'nohighlight') {

            $jpWalkthrough.html('');

            //check if wrapper is not empty or undefined
            if (opt.steps[_index].wrapper == '' || opt.steps[_index].wrapper == undefined) {
                alert('Your walkthrough position is: "' + opt.steps[_index].popup.type + '" but wrapper is empty or undefined. Please check your "' + _activeId + '" wrapper parameter.');
                return;
            }            

            var topOffset = cleanValue($(opt.steps[_index].wrapper).offset().top);
            var leftOffset = cleanValue($(opt.steps[_index].wrapper).offset().left);
            var transparentWidth = cleanValue($(opt.steps[_index].wrapper).innerWidth()) || cleanValue($(opt.steps[_index].wrapper).width());
            var transparentHeight = cleanValue($(opt.steps[_index].wrapper).innerHeight()) || cleanValue($(opt.steps[_index].wrapper).height());

            //get all margin and make it gorgeous with the 'px', if it has no px, IE will get angry !!
            var marginTop = cssSyntax(opt.steps[_index].margin, 'top'),
                marginRight = cssSyntax(opt.steps[_index].margin, 'right'),
                marginBottom = cssSyntax(opt.steps[_index].margin, 'bottom'),
                marginLeft = cssSyntax(opt.steps[_index].margin, 'left'),
                roundedCorner = 30,
                overlayClass = '',
                killOverlay = '';

            var overlayTopStyle = {
                'height': cleanValue(parseInt(topOffset) - (parseInt(marginTop) + (roundedCorner)))
            }

            var overlayLeftStyle = {
                'top': overlayTopStyle.height,
                'width': cleanValue(parseInt(leftOffset) - (parseInt(marginLeft) + roundedCorner)),
                'height': cleanValue(parseInt(transparentHeight) + (roundedCorner * 2) + parseInt(marginTop) + parseInt(marginBottom))
            }


            //check if use overlay      
            if (opt.steps[_index].overlay == undefined || opt.steps[_index].overlay) {
                overlayClass = 'overlay';
            } else {
                overlayClass = 'noOverlay';
                killOverlay = 'killOverlay';
            }

            var overlayTop = $('<div id="overlayTop" class="' + overlayClass + '"></div>').css(overlayTopStyle).appendTo($jpWalkthrough);
            var overlayLeft = $('<div id="overlayLeft" class="' + overlayClass + '"></div>').css(overlayLeftStyle).appendTo($jpWalkthrough);

            if (!opt.steps[_index].accessable) {

                var highlightedAreaStyle = {
                    'top': overlayTopStyle.height,
                    'left': overlayLeftStyle.width,
                    'topCenter': {
                        'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight))
                    },
                    'middleLeft': {
                        'height': cleanValue(parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom))
                    },
                    'middleCenter': {
                        'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight)),
                        'height': cleanValue(parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom))
                    },
                    'middleRight': {
                        'height': cleanValue(parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom))
                    },
                    'bottomCenter': {
                        'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight))
                    }
                }

                var highlightedArea = $('<div id="highlightedArea"></div>').css(highlightedAreaStyle).appendTo($jpWalkthrough);

                highlightedArea.html('<div>' +
                                        '<div id="topLeft" class="' + killOverlay + '"></div>' +
                                        '<div id="topCenter" class="' + killOverlay + '" style="width:' + highlightedAreaStyle.topCenter.width + ';"></div>' +
                                        '<div id="topRight" class="' + killOverlay + '"></div>' +
                                    '</div>' +

                                    '<div style="clear: left;">' +
                                        '<div id="middleLeft" class="' + killOverlay + '" style="height:' + highlightedAreaStyle.middleLeft.height + ';"></div>' +
                                        '<div id="middleCenter" class="' + killOverlay + '" style="width:' + highlightedAreaStyle.middleCenter.width + ';height:' + highlightedAreaStyle.middleCenter.height + '">&nbsp;</div>' +
                                        '<div id="middleRight" class="' + killOverlay + '" style="height:' + highlightedAreaStyle.middleRight.height + ';"></div>' +
                                    '</div>' +

                                    '<div style="clear: left;">' +
                                        '<div id="bottomLeft" class="' + killOverlay + '"></div>' +
                                        '<div id="bottomCenter" class="' + killOverlay + '" style="width:' + highlightedAreaStyle.bottomCenter.width + ';"></div>' +
                                        '<div id="bottomRight" class="' + killOverlay + '"></div>' +
                                    '</div>');
            } else {

                //if accessable
                var highlightedAreaStyle = {
                    'top': overlayTopStyle.height,
                    'left': overlayLeftStyle.width,
                    'topCenter': {
                        'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight))
                    }
                }

                var accessableStyle = {

                    'topAccessable': {
                        'position': 'absolute',
                        'top': overlayTopStyle.height,
                        'left': overlayLeftStyle.width,
                        'topCenter': {
                            'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight))
                        }
                    },
                    'middleAccessable': {
                        'position': 'absolute',
                        'top': cleanValue(parseInt(overlayTopStyle.height) + roundedCorner),
                        'left': overlayLeftStyle.width,
                        'middleLeft': {
                            'height': cleanValue(parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom))
                        },
                        'middleRight': {
                            'height': cleanValue(parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom)),
                            'right': cleanValue(parseInt(transparentWidth) + roundedCorner + parseInt(marginRight) + parseInt(marginLeft))
                        }
                    },
                    'bottomAccessable': {
                        'left': overlayLeftStyle.width,
                        'top': cleanValue(parseInt(overlayTopStyle.height) + roundedCorner + parseInt(transparentHeight) + parseInt(marginTop) + parseInt(marginBottom)),
                        'bottomCenter': {
                            'width': cleanValue(parseInt(transparentWidth) + parseInt(marginLeft) + parseInt(marginRight))
                        }
                    }
                }

                var highlightedArea = $('<div id="topAccessable" style="position:' + accessableStyle.topAccessable.position + '; top:' + accessableStyle.topAccessable.top + ';left:' + accessableStyle.topAccessable.left + '">' +
                                        '<div id="topLeft" class="' + killOverlay + '"></div>' +
                                        '<div id="topCenter" class="' + killOverlay + '" style="width:' + accessableStyle.topAccessable.topCenter.width + '"></div>' +
                                        '<div id="topRight" class="' + killOverlay + '"></div>' +
                                    '</div>' +

                                    '<div id="middleAccessable" class="' + killOverlay + '" style="clear: left;position:' + accessableStyle.middleAccessable.position + '; top:' + accessableStyle.middleAccessable.top + ';left:' + accessableStyle.middleAccessable.left + ';">' +
                                        '<div id="middleLeft" class="' + killOverlay + '" style="height:' + accessableStyle.middleAccessable.middleLeft.height + ';"></div>' +
                                        '<div id="middleRight" class="' + killOverlay + '" style="position:absolute;right:-' + accessableStyle.middleAccessable.middleRight.right + ';height:' + accessableStyle.middleAccessable.middleRight.height + ';"></div>' +
                                    '</div>' +

                                    '<div id="bottomAccessable" style="clear: left;position:absolute;left:' + accessableStyle.bottomAccessable.left + ';top:' + accessableStyle.bottomAccessable.top + ';">' +
                                        '<div id="bottomLeft" class="' + killOverlay + '"></div>' +
                                        '<div id="bottomCenter" class="' + killOverlay + '" style="width:' + accessableStyle.bottomAccessable.bottomCenter.width + ';"></div>' +
                                        '<div id="bottomRight" class="' + killOverlay + '"></div>' +
                                    '</div>').appendTo($jpWalkthrough);

            } //end checking accessable

            var highlightedAreaWidth = (opt.steps[_index].accessable) ? parseInt(accessableStyle.topAccessable.topCenter.width) + (roundedCorner * 2) : (parseInt(highlightedAreaStyle.topCenter.width) + (roundedCorner * 2));


            var overlayRightStyle = {
                'left': cleanValue(parseInt(overlayLeftStyle.width) + highlightedAreaWidth),
                'height': overlayLeftStyle.height,
                'top': overlayLeftStyle.top,
                'width': cleanValue(windowWidth() - (parseInt(overlayLeftStyle.width) + highlightedAreaWidth))
            }

            var overlayRight = $('<div id="overlayRight" class="' + overlayClass + '"></div>').css(overlayRightStyle).appendTo($jpWalkthrough);

            var overlayBottomStyle = {
                'height': cleanValue($(document).height() - (parseInt(overlayTopStyle.height) + parseInt(overlayLeftStyle.height))),
                'top': cleanValue(parseInt(overlayTopStyle.height) + parseInt(overlayLeftStyle.height))
            }

            var overlayBottom = $('<div id="overlayBottom" class="' + overlayClass + '"></div>').css(overlayBottomStyle).appendTo($jpWalkthrough);



            if ($('#jpWalkthrough').length) {
                $('#jpWalkthrough').remove();
            }

            $jpWalkthrough.appendTo('body').show();

            if (opt.steps[_index].accessable) {
                showTooltip(true);
            } else {
                showTooltip(false);
            }


        } else if(opt.steps[_index].popup.type == 'modal'){

            if ($('#jpWalkthrough').length) {
                $('#jpWalkthrough').remove();
            }

            if (opt.steps[_index].overlay == undefined || opt.steps[_index].overlay) {
                showModal(true);
            } else {
                showModal(false);
            }

        }else{
            if ($('#jpWalkthrough').length) {
                $('#jpWalkthrough').remove();
            }


            if (opt.steps[_index].overlay == undefined || opt.steps[_index].overlay) {
                noHighlight(true);
            } else {
                noHighlight(false);
            }
        }
    }

    /*
    * SHOW MODAL
    */
    function showModal(isOverlay) {
        var opt = _activeWalkthrough, overlayClass = '';

        if (isOverlay) {
            $jpwOverlay.appendTo('body').show();
        } else {
            if ($('#jpwOverlay').length) {
                $('#jpwOverlay').remove();
            }
        }

        var textRotation =  setRotation(parseInt(opt.steps[_index].popup.contentRotation));

        $jpwTooltip.css({ 'position': 'absolute', 'left': '50%', 'top': '50%', 'margin-left': -(parseInt(opt.steps[_index].popup.width) + 60) / 2 + 'px','z-index':'9999'});

        var tooltipSlide = $('<div id="tooltipTop">' +
                                '<div id="topLeft"></div>' +
                                '<div id="topRight"></div>' +
                            '</div>' +

                            '<div id="tooltipInner">' +
                            '</div>' +

                            '<div id="tooltipBottom">' +
                                '<div id="bottomLeft"></div>' +
                                '<div id="bottomRight"></div>' +
                            '</div>');       

        $jpWalkthrough.html('');
        $jpwTooltip.html('').append(tooltipSlide)
                            .wrapInner('<div id="tooltipWrapper" style="width:'+cleanValue(parseInt(opt.steps[_index].popup.width) + 30)+'"></div>')
                            .append('<div id="bottom-scratch"></div>')
                            .appendTo($jpWalkthrough);
        
        $jpWalkthrough.appendTo('body');

        $('#tooltipWrapper').css(textRotation);

        $(opt.steps[_index].popup.content).clone().appendTo('#tooltipInner').show();

        $jpwTooltip.css('margin-top', -(($jpwTooltip.height()) / 2)+ 'px');
        $jpWalkthrough.show();


    }


    /*
    * SHOW TOOLTIP
    */
    function showTooltip(isAccessable) {

        var opt = _activeWalkthrough;

        var tooltipWidth = (opt.steps[_index].popup.width == '') ? 300 : opt.steps[_index].popup.width,
            top, left, arrowTop, arrowLeft,
            roundedCorner = 30,
            overlayHoleWidth = (isAccessable) ? ($('#topAccessable').innerWidth() + (roundedCorner * 2)) || ($('#topAccessable').width() + (roundedCorner * 2)) : $('#highlightedArea').innerWidth() || $('#highlightedArea').width(),
            overlayHoleHeight = (isAccessable) ? $('#middleAccessable').innerHeight() + (roundedCorner * 2) || $('#middleAccessable').height() + (roundedCorner * 2) : $('#highlightedArea').innerHeight() || $('#highlightedArea').height(),
            overlayHoleTop = (isAccessable) ? $('#topAccessable').offset().top : $('#highlightedArea').offset().top,
            overlayHoleLeft = (isAccessable) ? $('#topAccessable').offset().left : $('#highlightedArea').offset().left,
            arrow = 30,
            draggable = '';  

        var textRotation = (opt.steps[_index].popup.contentRotation == undefined || parseInt(opt.steps[_index].popup.contentRotation) == 0) ? clearRotation() : setRotation(parseInt(opt.steps[_index].popup.contentRotation));


        //delete jwOverlay if any
        if ($('#jpwOverlay').length) {
            $('#jpwOverlay').remove();
        }

        var tooltipSlide = $('<div id="tooltipTop">' +
                                '<div id="topLeft"></div>' +
                                '<div id="topRight"></div>' +
                            '</div>' +

                            '<div id="tooltipInner">' +
                            '</div>' +

                            '<div id="tooltipBottom">' +
                                '<div id="bottomLeft"></div>' +
                                '<div id="bottomRight"></div>' +
                            '</div>');

        $jpwTooltip.html('').css({ 'marginLeft': '0', 'margin-top': '0', 'position': 'absolute','z-index':'9999'})
                           .append(tooltipSlide)
                           .wrapInner('<div id="tooltipWrapper" style="width:'+cleanValue(parseInt(opt.steps[_index].popup.width) + 30)+'"></div>')
                           .appendTo($jpWalkthrough);

        if (opt.steps[_index].popup.draggable) {
            $jpwTooltip.append('<div id="drag-area" class="draggable-area"></div>');
        }        

        $jpWalkthrough.appendTo('body').show();

        $('#tooltipWrapper').css(textRotation);

        $(opt.steps[_index].popup.content).clone().appendTo('#tooltipInner').show();

        $jpwTooltip.append('<span class="' + opt.steps[_index].popup.position + '">&nbsp;</span>');

        switch (opt.steps[_index].popup.position) {

            case 'top':
                top = overlayHoleTop - ($jpwTooltip.height() + (arrow / 2)) + parseInt(opt.steps[_index].popup.offsetVertical) - 86;
                if (isAccessable) {
                    left = (overlayHoleLeft + (overlayHoleWidth / 2)) - ($jpwTooltip.width() / 2) - 40 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                } else {
                    left = (overlayHoleLeft + (overlayHoleWidth / 2)) - ($jpwTooltip.width() / 2) - 5 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                }
                arrowLeft = ($jpwTooltip.width() / 2) - arrow;
                arrowTop = '';
                break;
            case 'right':
                top = overlayHoleTop - (arrow / 2) + parseInt(opt.steps[_index].popup.offsetVertical);
                left = overlayHoleLeft + overlayHoleWidth + (arrow / 2) + parseInt(opt.steps[_index].popup.offsetHorizontal) + 105;
                arrowTop = arrow;
                arrowLeft = '';
                break;
            case 'bottom':

                if (isAccessable) {
                    top = (overlayHoleTop + overlayHoleHeight) + parseInt(opt.steps[_index].popup.offsetVertical) + 86;
                    left = (overlayHoleLeft + (overlayHoleWidth / 2)) - ($jpwTooltip.width() / 2) - 40 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                } else {
                    top = overlayHoleTop + overlayHoleHeight + parseInt(opt.steps[_index].popup.offsetVertical) + 86;
                    left = (overlayHoleLeft + (overlayHoleWidth / 2)) - ($jpwTooltip.width() / 2) - 5 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                }

                arrowLeft = ($jpwTooltip.width() / 2) - arrow;
                arrowTop = '';
                break;
            case 'left':
                top = overlayHoleTop - (arrow / 2) + parseInt(opt.steps[_index].popup.offsetVertical);
                left = overlayHoleLeft - $jpwTooltip.width() - (arrow) + parseInt(opt.steps[_index].popup.offsetHorizontal) - 105;
                arrowTop = arrow;
                arrowLeft = '';
                break;
        }

        $('#jpwTooltip span.' + opt.steps[_index].popup.position).css({ 'left': cleanValue(arrowLeft) });

        $jpwTooltip.css({ 'top': cleanValue(top), 'left': cleanValue(left) });
        $jpWalkthrough.show();
    }

    /**
     * POPUP NO HIGHLIGHT
     */

     function noHighlight(isOverlay){
        var opt = _activeWalkthrough, overlayClass = '';

        var wrapperTop = $(opt.steps[_index].wrapper).offset().top,
            wrapperLeft = $(opt.steps[_index].wrapper).offset().left,
            wrapperWidth = $(opt.steps[_index].wrapper).width(),
            wrapperHeight = $(opt.steps[_index].wrapper).height(),
            arrow = 30,
            draggable = '',
            top, left, arrowTop, arrowLeft; 

        if (isOverlay) {
            $jpwOverlay.appendTo('body').show();
        } else {
            if ($('#jpwOverlay').length) {
                $('#jpwOverlay').remove();
            }
        }

        $jpwTooltip.css(clearRotation());

        var textRotation = (opt.steps[_index].popup.contentRotation == 'undefined' || opt.steps[_index].popup.contentRotation == 0) ? '' : setRotation(parseInt(opt.steps[_index].popup.contentRotation));

        $jpwTooltip.css({ 'position': 'absolute','margin-left': '0px','margin-top':'0px','z-index':'9999'});

        var tooltipSlide = $('<div id="tooltipTop">' +
                                '<div id="topLeft"></div>' +
                                '<div id="topRight"></div>' +
                            '</div>' +

                            '<div id="tooltipInner">' +
                            '</div>' +

                            '<div id="tooltipBottom">' +
                                '<div id="bottomLeft"></div>' +
                                '<div id="bottomRight"></div>' +
                            '</div>');            

        $jpWalkthrough.html('');
        $jpwTooltip.html('').append(tooltipSlide)
                            .wrapInner('<div id="tooltipWrapper" style="width:'+cleanValue(parseInt(opt.steps[_index].popup.width) + 30)+'"></div>')
                            .appendTo($jpWalkthrough);

        if (opt.steps[_index].popup.draggable) {
            $jpwTooltip.append('<div id="drag-area" class="draggable-area"></div>');
        }
        
        $jpWalkthrough.appendTo('body');

        $('#tooltipWrapper').css(textRotation);

        $(opt.steps[_index].popup.content).clone().appendTo('#tooltipInner').show();

        $jpwTooltip.append('<span class="' + opt.steps[_index].popup.position + '">&nbsp;</span>');

        switch (opt.steps[_index].popup.position) {

            case 'top':
                top = wrapperTop - ($jpwTooltip.height() + (arrow / 2)) + parseInt(opt.steps[_index].popup.offsetVertical) - 86;
                left = (wrapperLeft + (wrapperWidth / 2)) - ($jpwTooltip.width() / 2) - 5 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                arrowLeft = ($jpwTooltip.width() / 2) - arrow;
                arrowTop = '';
                break;
            case 'right':
                top = wrapperTop - (arrow / 2) + parseInt(opt.steps[_index].popup.offsetVertical);
                left = wrapperLeft + wrapperWidth + (arrow / 2) + parseInt(opt.steps[_index].popup.offsetHorizontal) + 105;
                arrowTop = arrow;
                arrowLeft = '';
                break;
            case 'bottom':
                top = wrapperTop + wrapperHeight + parseInt(opt.steps[_index].popup.offsetVertical) + 86;
                left = (wrapperLeft + (wrapperWidth / 2)) - ($jpwTooltip.width() / 2) - 5 + parseInt(opt.steps[_index].popup.offsetHorizontal);
                arrowLeft = ($jpwTooltip.width() / 2) - arrow;
                arrowTop = '';
                break;
            case 'left':
                top = wrapperTop - (arrow / 2) + parseInt(opt.steps[_index].popup.offsetVertical);
                left = wrapperLeft - $jpwTooltip.width() - (arrow) + parseInt(opt.steps[_index].popup.offsetHorizontal) - 105;
                arrowTop = arrow;
                arrowLeft = '';
                break;
        }

        $('#jpwTooltip span.' + opt.steps[_index].popup.position).css({ 'left': cleanValue(arrowLeft) });

        $jpwTooltip.css({ 'top': cleanValue(top), 'left': cleanValue(left) });
        $jpWalkthrough.show();


     }

     /*
    * SCROLL TO TARGET
    */
    function scrollToTarget() {

        var options = _activeWalkthrough;

        if (options.steps[_index].autoScroll ||  options.steps[_index].autoScroll == undefined) {
            if (options.steps[_index].popup.position != 'modal') {

                var windowHeight = $(window).height() || $(window).innerHeight(),
                    targetOffsetTop = $jpwTooltip.offset().top,
                    targetHeight = $jpwTooltip.height() ||  $jpwTooltip.innerHeight(),
                    overlayTop = $('#overlayTop').height();

                $('html,body').animate({scrollTop: (targetOffsetTop + (targetHeight/2) - (windowHeight/2))}, options.steps[_index].scrollSpeed);    
                
            } else {
                $('html,body').animate({ scrollTop: 0 }, options.steps[_index].scrollSpeed);
            }

        }
    }


    /**
     * SHOW CLOSE BUTTON
     */
     function showCloseButton(){
        if(!$('jpwClose').length){
            $('body').append('<div id="jpwClose"><a href="javascript:;" title="Click here to close"><span></span><br>Click Here to Close</a></div>');
        }
     }



    /**
    /* CALLBACK
    /*/

    //callback for onLoadHidden cookie
    function onCookieLoad(options) {

        for (i = 0; i < _elements.length; i++) {
            if (typeof (options[_elements[i]].onCookieLoad) === "function") {
                options[_elements[i]].onCookieLoad.call(this);
            }
        }

        return false;
    }

    function onLeave(e) {
        var options = _activeWalkthrough;

        if (typeof options.steps[_index].onLeave === "function") {
            if (!options.steps[_index].onLeave.call(this, e, _index)) {
                return false;
            }
        }

        return true;

    }

    //callback for onEnter step
    function onEnter(e) {

        var options = _activeWalkthrough;

        if (typeof options.steps[_index].onEnter === "function") {
            if (!options.steps[_index].onEnter.call(this, e, _index)) {
                return false;
            }
        }

        return true;
    }

    //callback for onClose help
    function onClose() {
        var options = _activeWalkthrough;

        if (typeof options.onClose === "function") {
            if (!options.onClose.call(this)) {
                return false;
            }
        }

        //set help mode to false
        //_isWalkthroughActive = false;
        methods.close();

        return true;
    }

    //callback for onRestart help
    function onRestart(e) {
        var options = _activeWalkthrough;
        //set help mode to true
        _isWalkthroughActive = true;
        methods.restart(e);

        //auto scroll to target
        scrollToTarget();

        if (typeof options.onRestart === "function") {
            if (!options.onRestart.call(this)) {
                return false;
            }
        }

        return true;
    }

    //callback for before all first walkthrough element loaded
    function onBeforeShow() {
        var options = _activeWalkthrough;
        _index = 0;

        if (typeof (options.onBeforeShow) === "function") {
            if (!options.onBeforeShow.call(this)) {
                return false;
            }
        }

        return true;
    }

    //callback for after all first walkthrough element loaded
    function onAfterShow() {
        var options = _activeWalkthrough;
        _index = 0;

        if (typeof (options.onAfterShow) === "function") {
            if (!options.onAfterShow.call(this)) {
                return false;
            }
        }

        return true;
    }



	/**
    * HELPERS
    */

    function windowWidth() {
        return $(window).innerWidth() || $(window).width();
    }

    function debug(message) {
        if (window.console && window.console.log)
            window.console.log(message);
    }

    function clearRotation(){
        var rotationStyle = {
            '-webkit-transform': 'none', //safari
            '-moz-transform':'none', //firefox
            '-ms-transform': 'none', //IE9+
            '-o-transform': 'none', //opera
            'filter':'none', //IE7
            '-ms-transform' : 'none' //IE8
        }

        return rotationStyle;
    }

    function setRotation(angle){

        //for IE7 & IE8
        var M11, M12, M21, M22, deg2rad, rad;

        //degree to radian
        deg2rad = Math.PI * 2 / 360;
        rad = angle * deg2rad;

        M11 = Math.cos(rad);
        M12 = Math.sin(rad);
        M21 = Math.sin(rad);
        M22 = Math.cos(rad);

        var rotationStyle = {
            '-webkit-transform': 'rotate('+parseInt(angle)+'deg)', //safari
            '-moz-transform':'rotate('+parseInt(angle)+'deg)', //firefox
            '-ms-transform': 'rotate('+parseInt(angle)+'deg)', //IE9+
            '-o-transform': 'rotate('+parseInt(angle)+'deg)', //opera
            'filter':'progid:DXImageTransform.Microsoft.Matrix(M11 = '+M11+',M12 = -'+M12+',M21 = '+M21+',M22 = '+M22+',sizingMethod = "auto expand");', //IE7
            '-ms-transform' : 'progid:DXImageTransform.Microsoft.Matrix(M11 = '+M11+',M12 = -'+M12+',M21 = '+M21+',M22 = '+M22+',SizingMethod = "auto expand");' //IE8
        }

        return rotationStyle;

    }

    function cleanValue(value) {
        if (typeof value === "string") {
            if (value.toLowerCase().indexOf('px') == -1) {
                return value + 'px';
            } else {
                return value;
            }
        } else {
            return value + 'px';
        }
    }

    function cleanSyntax(val) {

        if (val.indexOf('px') != -1) {
            return true;
        } else if(parseInt(val) == 0){
            return true;
        }
        return false;
    }

    function cssSyntax(val, position) {
        var value = val,
            arrVal = value.split(' '),
            counter = 0,
            top, right, bottom, left, returnVal;

        for (i = 0; i < arrVal.length; i++) {
            //check if syntax is clean with value and 'px'
            if (cleanSyntax(arrVal[i])) {
                counter++;
            }
        }

        //all syntax are clean
        if (counter == arrVal.length) {

            for (i = 0; i < arrVal.length; i++) {

                switch (i) {
                    case 0:
                        top = arrVal[i];
                        break;
                    case 1:
                        right = arrVal[i];
                        break;
                    case 2:
                        bottom = arrVal[i];
                        break;
                    case 3:
                        left = arrVal[i];
                        break;
                }

            }

            switch (arrVal.length) {
                case 1:
                    right = bottom = left = top;
                    break;
                case 2:
                    bottom = top;
                    left = right;
                    break;
                case 3:
                    left = right;
                    break;
            }

            if (position == 'undefined' || position == '' || position == null) {
                console.log('Please define margin position (top, right, bottom, left)');
                return false;
            } else {

                switch (position) {
                    case 'top':
                        returnVal = top;
                        break;
                    case 'right':
                        returnVal = right;
                        break;
                    case 'bottom':
                        returnVal = bottom;
                        break;
                    case 'left':
                        returnVal = left;
                        break;
                }

            }

            return returnVal;

        } else {
            console.log('Please check your margin syntax..');
            return false;
        }
    }

    function setCookie(c_name, value, exdays) {
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var c_value = escape(value) + ((exdays == null) ? "" : "; expires=" + exdate.toUTCString());
        document.cookie = c_name + "=" + c_value;
    }

    function getCookie(c_name) {
        var i, x, y, ARRcookies = document.cookie.split(";");
        for (i = 0; i < ARRcookies.length; i++) {
            x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
            y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
            x = x.replace(/^\s+|\s+$/g, "");
            if (x == c_name) {
                return unescape(y);
            }
        }
    }

    /**
     * BUTTON CLOSE CLICK
     */

     $('#jpwClose a').live('click', onClose);


    /**
     * DRAG & DROP
     */

    $('#jpwTooltip #drag-area').live('mousedown', function (e) {

        if (!$(this).hasClass('draggable-area')) {
            return;
        }
        if (!$(this).hasClass('draggable')) {
            $(this).addClass('draggable').css('cursor','move');
        }

        var z_idx = $(this).css('z-index'),
            drg_h = $(this).outerHeight(),
            drg_w = $(this).outerWidth(),
            pos_y = $(this).offset().top + (drg_h*2) - e.pageY -10,
            pos_x = (e.pageX - $(this).offset().left + drg_w) - ($(this).parent().outerWidth() + drg_w) +20;

        $(document).on("mousemove", function (e) {

            $('.draggable').parent().offset({
                top: e.pageY + pos_y - drg_h,
                left: e.pageX + pos_x - drg_w 
            }).on("mouseup", function () {
                $(this).children('#tooltipWrapper').removeClass('draggable').css({'z-index':z_idx,'cursor':'default'});
            });
        });
        e.preventDefault(); // disable selection
    }).live("mouseup", function () {
        $(this).removeClass('draggable').css('cursor','default');
    });



	/**
    * MAIN PLUGIN
    */
    $.pagewalkthrough = $.fn.pagewalkthrough = function (method) {

        if (methods[method]) {

            return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));

        } else if (typeof method === 'object' || !method) {

            methods.init.apply(this, arguments);

        } else {

            $.error('Method ' + method + ' does not exist on jQuery.pagewalkthrough');

        }

    }

    setTimeout(function () {
        methods.renderOverlay();
    }, 500);

	$.fn.pagewalkthrough.options = {

		steps: [

			{
               wrapper: '', //an ID of page element HTML that you want to highlight
               margin: 0, //margin for highlighted area, may use CSS syntax i,e: '10px 20px 5px 30px'
               popup:
               {
					content: '', //ID content of the walkthrough
					type: 'modal', //tooltip, modal, nohighlight
                    position:'top',//position for tooltip and nohighlight type only: top, right, bottom, left
					offsetHorizontal: 0, //horizontal offset for the walkthrough
					offsetVertical: 0, //vertical offset for the walkthrough
					width: '320', //default width for each step,
					draggable: false, // set true to set walkthrough draggable,
					contentRotation: 0 //content rotation : i.e: 0, 90, 180, 270 or whatever value you add. minus sign (-) will be CCW direction
               },
               overlay:true,             
               accessable: false, //if true - you can access html element such as form input field, button etc
               autoScroll: true, //is true - this will autoscroll to the arror/content every step 
               scrollSpeed: 1000, //scroll speed
               stayFocus: false, //if true - when user scroll down/up to the page, it will scroll back the position it belongs
               onLeave: null, // callback when leaving the step
               onEnter: null // callback when entering the step
           }

		],
        name: '',
		onLoad: true, //load the walkthrough at first time page loaded
		onBeforeShow: null, //callback before page walkthrough loaded
		onAfterShow: null, // callback after page walkthrough loaded
		onRestart: null, //callback for onRestart walkthrough
		onClose: null, //callback page walkthrough closed
		onCookieLoad: null //when walkthrough closed, it will set cookie and use callback if you want to create link to trigger to reopen the walkthrough
	};

} (jQuery, window, document));
}
;
(function() {


}).call(this);
function weightMeasure(cname, name, object, unit, weight){
  var canvas = $('#'+cname)[0];
  var context = canvas.getContext('2d');
  var wts=[];
  var leftwt = weight;
  var rightwt = 0;
  var wtstr=weight.toString();
  wtstr=wtstr.split("").reverse().join("");
  for(i=0; i < wtstr.length; i++){
    wts[i]=parseInt(wtstr[i]);
  }
  var mg = 20;
  var fht = 50;
  var lth = 300;
  var iangle = Math.acos(fht/lth);
  var angle=iangle;
  function fillTri(x1, y1, x2, y2, x3, y3){
    context.beginPath();
    context.moveTo(x1, y1);
    context.lineTo(x2, y2);
    context.lineTo(x3, y3);
    context.lineTo(x1, y1);
    context.closePath();
    context.fillStyle="blue";
    context.fill();
  } 
  function drawFulcrum(){
    fillTri(context.width/2-20, context.height-mg, context.width/2+20, context.height-mg, context.width/2, context.height-20-fht);
  }
  function setAngle(){
    angle=2*Math.PI*rightwt/leftwt;
    if(angle < iangle) {angle=iangle;}
    if(angle > Math.PI-iangle) {angle=Math.PI-iangle;}
  }
  function drawLever(){
    context.save();
    context.translate(context.width/2, context.height-fht-20-10);
    context.rotate(angle);
    context.fillStyle="gray";
    context.fillRect(-5, -lth/2, 10, lth);
  }
  drawFulcrum();
  setAngle();
  drawLever();
}
;
function mob_comp(){
	if((/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent))){
		not_comp=['Draw Triangle', 'Draw Quadrilateral', 'DefVertices', 
		'DefAdjacentSides', 'DefAdjacentVertices', 'AddNumberLine', 
		'SubNumberLine', 'CreateBar', 'CreateTally', 'BisectLine'];
		$('.list_box').each(function(){
			for (i=0; i < not_comp.length; i++){
				if($(this).children('p').text().indexOf(not_comp[i])!= -1){
					$(this).children('a').text('Not Compatible');
					$(this).children('a')[0].href='';
					$(this).children('a').css('background-color','#ccc');
					$(this).children('a').css('height','34px');
					$(this).children('a').css('margin-top','-15px');
				}
			}
		});
	}
}

;
function setNavLineWidths() {
  $('.nav-line').css("width", $(".container").css("width"));
  $('.nav-line').each(function () {
    var $elt = $(this)
      , $target = $('#' + $elt.attr('data-target'))
      , target_off = $target.offset()
      , target_w = $target.outerWidth()
      , target_h = $target.outerHeight()
      , target_y = parseInt($target.css("margin-top"))
      , $blue = $elt.children(':first-child')
      , $green = $elt.children(':last-child')
      , $both = $elt.children();

    var blue_w  = target_off.left
      , blue_y  = parseInt($blue.css('height')) // don't want borders
      , green_x = blue_w + target_w/2
      , green_w = Math.max($('.container').width() - green_x, 940 - green_x)
      , both_y  = 25 // (target_h / 2) - blue_y  + target_y
                               //  green should have same height

    // console.log($.param(target_off) + ': target_off');
    // console.log(target_w + ': target_w');
    // console.log(target_h + ': target_h');
    // console.log(target_y + ': target_y');
    // console.log(blue_w  + ': blue_w ');
    // console.log(blue_y  + ': blue_y ');
    // console.log(green_x + ': green_x');
    // console.log(green_w + ': green_w');
    // console.log(both_y  + ': both_y ');

    $blue.css("width", blue_w);
    $green.css("left", $(".container").css("margin-left"));

    $green.css("width", "100%");

    $both.css("top", both_y)
  });
}
function dbord(pname){
  if($(".container").width() <= 722){
    $(".dotted-border").css("width", ($(".container").width()-22)+"px");
    $(".dotted-border").css("height","auto");
    $('#bbor').css('margin-left', '0px');
  }
  else{
    $(".dotted-border").css("width", "252px");
    $('#bbor').css('margin-left', '43px');
  }
  if(pname=="pset"){shelf_color();}
  else{shelf_color_in(pname[0], pname[1], pname[2]);}
  $(window).resize(function(){
  if($(".container").width() <= 722){
    $(".dotted-border").css("width", ($(".container").width()-22)+"px");
    $(".dotted-border").css("height","auto");
    $('#bbor').css('margin-left', '0px');
  }
  else{
    $(".dotted-border").css("width", "252px");
    $('#bbor').css('margin-left', '43px');
  }
  if(pname=="pset"){shelf_color();}
  else{shelf_color_in(pname[0], pname[1], pname[2]);}
});
}


$(function() {
  setNavLineWidths();
  $(window).resize(setNavLineWidths);
  
  
});
function logoutb(){
  $(".switch-to a").hover(function(){
    $(this).text("Are you sure?");},
    function(){$(this).text("Log out");}
  );
}
function shelf_do(){
  if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)){
    $("body").css("width", "457px");
    $("body").css("zoom", ""+($(window).width()/457));
  }
  wdt=$(".container").width();
lis="";
  lisarr=[]
  lis+="<li class=shelf_li id=account>"+$(".shelf .shelf_ul .shelf_li").eq(0).html()+"</li>";
  lisarr[0]="<li class=shelf_li id=account>"+$(".shelf .shelf_ul .shelf_li").eq(0).html()+"</li>";
  for(i=1; i < $(".shelf .shelf_ul .shelf_li").length; i++){
    lis+="<li class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
    lisarr[i]="<li class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
  }
  $(".shelf").remove();
  for(i=0; i < lisarr.length; i++){
    n = parseInt(($(".container").width()-200)/86);
    te=(lisarr.slice(i, (i+n))).join("\n");
    $("#bigshelf").append("<div class=shelf><ul class=shelf_ul>"+te+"</ul></div>");
    i=i+n-1;
  }
  liwt=parseInt($(".shelf .shelf_ul .shelf_li").css("width"))+2*parseInt($(".shelf .shelf_ul .shelf_li").css("padding"));
  wdt=$(".container").width();
$(window).resize(function(){
  if(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)){
    $("body").css("width", "457px");
    $("body").css("zoom", ""+($(window).width()/457));
  }
  lisob=$(".shelf ul li");

  if(Math.abs($(".container").width()-wdt) > 10 ){
  lis="";
  lisarr=[]
  for(i=0; i < $(".shelf .shelf_ul .shelf_li").length; i++){
    lis+="<li  class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
    lisarr[i]="<li  class=shelf_li>"+$(".shelf .shelf_ul .shelf_li").eq(i).html()+"</li>";
  }
  $(".shelf").remove();
  for(i=0; i < lisarr.length; i++){
    n = parseInt(($(".container").width()-200)/liwt);
    te=(lisarr.slice(i, (i+n))).join("\n");
    $("#bigshelf").append("<div class=shelf><ul class=shelf_ul>"+te+"</ul></div>");
    i=i+n-1;
  }
  wdt=$(".container").width();
}
badges_look();
});
}
;

function notepad_new() {
  // global drawing variables
  var canvas = $('#notepad')[0];
  var context = canvas.getContext('2d');
  $("#npcolorpicker").val("#E85858");
  $("#sv_opform").hide();
  answer=false;
  var ytem = undefined;
  var pane=$("#note").jScrollPane().data("jsp");
  var mousex;
  var downx;
  var mousey;
  var downy;
  var mousedown=false;
  var lheight=20;
  var mode="wr";
  try { ytem = JSON.parse($("#npstr").attr("value")); } catch(err) {}
  var notes = []; 
  var draw=[];
  if(ytem != "" && ytem != undefined) {
    answer=true;
    draw=ytem[1];
    for(p=0; p<ytem[0].length; p++){
      addline(ytem[0][p]);
    }
  }
  function addline(ln, lsp){
    lsp = typeof lsp !== 'undefined' ? lsp : 0;
    //alert("<p style=\"position:absolute; text-indent:"+(lsp*8)+"px; left:2px; top:"+(2+notes.length*lheight)+"px; width:"+canvas.width+"px\">"+ln+"</p>");
    $("#npPane").append("<p style=\"position:absolute; text-indent:"+(lsp*8)+"px; left:2px; top:"+(2+notes.length*lheight)+"px; width:"+canvas.width+"px\">"+ln+"</p>");
    notes[notes.length]=ln;
    $('#notes').attr("value", "");
    $('#notes').css("top", ""+(notes.length*lheight+13)+"px");
    canvas.height=Math.max(parseInt($("#notes").css("top"))+15, canvas.height);
    context.lineWidth=3;
    ct=0;
    for(j=0; j<draw.length; j++){
      if(draw[j].length>1){
        context.strokeStyle=draw[j][0][2];
        context.lineWidth=2;
        for(k=1; k<draw[j].length; k++){
          drawLine(draw[j][k-1][0], draw[j][k-1][1], draw[j][k][0], draw[j][k][1]);
        }
      }
      context.lineWidth=1;
    }
    pane.reinitialise();
    pane.scrollToPercentY(100, true);
    if(!answer){
      $("#npstr").attr("value", JSON.stringify([notes, draw]));

    }
  }
  $("#drawnp").click(function(e){
    if(mode!="dr"){
      $("#drawnp").css("background-color", "gray");
      mode="dr";
      $("#npPane").hide();
      $("#notes").hide();
      for(i=0; i<notes.length; i++){
        context.fillStyle="rgb(85, 102, 119)"; 
        context.font="10pt Courier";
        context.fillText(notes[i], 2, i*lheight+12); 
      }
    }
    else{
      mode="wr";
      $("#drawnp").css("background-color", "white");
      $("#npPane").show();
      $("#notes").show();
      $("#notes").focus();
    }
  });
  $("#notepad").mousedown(function(e){
    mousedown=true;
    if(mode=="wr"){
      pane.scrollToPercentY(100, true);
      $("#notes").focus();
    }
    if(mode=="dr"){
      context.lineWidth=3;
      context.strokeStyle=$("#npcolorpicker").val();
      downx = mousex;
      downy = mousey;
      draw.push([])
    draw[draw.length-1].push([downx, downy, $("#npcolorpicker").val()]);
    }
  });
  $("#notepad").mouseup(function(e){
    context.lineWidth=1;
    mousedown=false;
    $("#npstr").attr("value", JSON.stringify([notes, draw]));
  });
  $('#notepad').mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    var offset = $('#notepad').offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);

    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
    if(mousedown && mode=="dr"){
      drawLine(draw[draw.length-1][draw[draw.length-1].length-1][0], draw[draw.length-1][draw[draw.length-1].length-1][1], mousex, mousey);
      draw[draw.length-1].push([mousex, mousey]);
    }
  });
  $('#notes').keypress(function(e){
    pane.scrollToPercentY(100);
    if(e.keyCode==13) {
      addline($('#notes').attr("value"));
    }
  });
  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }

  var adding = true
    , subtracting = false
    , multiplying = false;
  $("#np_add").css("background-color","gray");

  var disable_old_form = function() {
    adding=false;
    subtracting=false;
    multiplying=false;
    $(".tbicons").css("background-color", "white");
    $("#calc-form").removeClass();
  }

  $("#np_add").click(function(e){
    if(!adding){
      disable_old_form();
      adding=true;
      $(this).css("background-color", "gray");
      $("#calc-form").addClass("addition");
    }
  });

  $("#np_sub").click(function(e){
    if(!subtracting){
      disable_old_form();
      subtracting=true;
      $(this).css("background-color", "gray");
      $("#calc-form").addClass("subtraction");
    }
  });

  $("#np_mult").click(function(e){
    if(!multiplying){
      disable_old_form();
      multiplying=true;
      $(this).css("background-color", "gray");
      $("#calc-form").addClass("multiplication");
    }
  });

  $("#cr_opform").click(function(e){
    createform_np();
  });
  function createform_np(){
    $("#calc").hide();
    $("#sv_opform").show();
    if(adding){
      adding_np($("#np_num1").attr("value"), $("#np_num2").attr("value"), "+");
    }
    if(subtracting){
      adding_np($("#np_num1").attr("value"), $("#np_num2").attr("value"), "-");
    }
    if(multiplying){
      mult_np($("#np_num1").attr("value"), $("#np_num2").attr("value"));
    }

  }
  $("#np_num2").keypress(function(e){
    if(e.keyCode==13){
      createform_np()
    }
  });
  function adding_np(n1, n2, sign){
    lt=1+Math.max(n1.length, n2.length);
    var ht="<table id=laddtable border=0>\n";
    ht+="<tr>\n";
    for(i=0; i<lt-n1.length; i++){
      ht+="<td> </td>\n";
    }
    for(i=0; i<n1.length; i++){
      ht+="<td>"+n1[i]+"</td>\n";
    }
    ht+="</tr>\n";
    ht+="<tr>\n";
    for(i=0; i<lt-n2.length; i++){
      if(i==0){	
        ht+="<td>"+sign+"</td>\n";
      }
      else {ht+="<td> </td>\n";}
    }
    for(i=0; i<n2.length; i++){
      ht+="<td>"+n2[i]+"</td>\n";
    }
    ht+="</tr>\n";
    ht+="<tr>\n";
    for(i=0; i<lt; i++){
      ht+="<td><input type=text class='digit linps' id=lin"+i+" maxlength=1></td>\n";
    }
    ht+="</tr>\n";
    ht+="</table>";
    $('#ops_form').append(ht);
    $('#laddtable').css("font", "10pt Courier");
    $('#laddtable').css("text-align", "center");
    $('#laddtable').css("margin-left", "-50%");
    $("#lin"+(lt-1)).select();
    $(".linps").keypress(function(e){
      String.fromCharCode(e.keyCode)
      if(e.keyCode > 47 && e.keyCode < 58) {
        $(this).attr("value", String.fromCharCode(e.keyCode));
      }
    var tot="";
    if (e.keyCode==13){
      for(var i=0; i<lt; i++){
        tot+=$("#lin"+i).attr("value");
      }
      addline(n1+" "+sign+" "+n2+" = "+tot);
      context.strokeStyle="black";
      $('#laddtable').remove();
      $('#calc').show();
      $("#sv_opform").hide();
      $("#np_num1").attr("value", tot);
      $("#np_num2").attr("value", "");

    }
    });
    $("#sv_opform").click(function(e){
      var com="";

      for(var i=0; i<lt; i++){
        k=$("#lin"+i).attr("value");
        k = typeof k !== 'undefined' ? k : "";
        com+=k;
      }
      addline(n1+" "+sign+" "+n2+" = "+com);
      context.strokeStyle="black";
      $('#laddtable').remove();
      $('#calc').show();
      $("#sv_opform").hide();
      $("#sv_opform").unbind();
      $("#np_num1").attr("value", com);
      $("#np_num2").attr("value", "");
    });
    for (var j=1; j<lt; j++)
    {
      $("#lin"+j).keypress({j:j}, function(e){
        $("#lin"+(e.data.j-1)).select();
      });
    }
  }
  function mult_np(n1, n2){
    lt=1+n1.length+n2.length;
    var ht="<table id=addtable border=0>\n";
    ht+="<tr>\n";
    for(i=0; i<lt-n1.length; i++){
      ht+="<td> </td>\n";
    }
    for(i=0; i<n1.length; i++){
      ht+="<td>"+n1[i]+"</td>\n";
    }
    ht+="</tr>\n";
    ht+="<tr>\n";
    for(i=0; i<lt-n2.length; i++){
      if(i==0){	
        ht+="<td>x</td>\n";
      }
      else {ht+="<td> </td>\n";}
    }
    for(i=0; i<n2.length; i++){
      ht+="<td>"+n2[i]+"</td>\n";
    }
    ht+="</tr>\n";
    for (j=0; j<n2.length; j++){
      ht+="<tr>\n";
      for(i=0; i<lt-(n1.length+j+1); i++){
        if(i==0 && j!=0){	
          ht+="<td>+</td>\n";
        }
        else {ht+="<td> </td>\n";}
      }
      for(i=0; i<(n1.length+j+1); i++){
        ht+="<td><input type=text class='digit inps"+j+"' id=in_"+j+"_"+i+" maxlength=1></td>\n";
      }
      ht+="</tr>\n";
    }
    if(n2.length>1){
      for(i=0; i<lt; i++){
        ht+="<td><input type=text class='digit inps' id=in"+i+" maxlength=1></td>\n";
      }
    }
    ht+="</tr>\n";
    ht+="</table>";
    //alert(ht);
    $('#ops_form').append(ht);
    $('#addtable').css("font", "10pt Courier");
    $('#addtable').css("text-align", "center");
    $('#addtable').css("margin-left", "-50%");
    $("#in_0_"+(n1.length)).select();
    for(j=0; j<n2.length; j++){
      if(j==n2.length-1){
        $(".inps"+j).keypress(function(e){
          if (e.keyCode==13){
            $("#in"+(lt-1)).select();
          }
        });
      }
      else{
        $(".inps"+j).keypress({j:j}, function(e){
          if (e.keyCode==13){

            $("#in_"+(e.data.j+1)+"_"+(n1.length)).select();
            for(i=0; i<j; i++){
              $("#in_"+(e.data.j+1)+"_"+(n1.length+1+i)).attr("value","0");
            }
          }
        });
      }
    }
    if(n2.length==1){
      $(".inps0").keypress(function(e){
        var tot="";
        if (e.keyCode==13){
          for(var i=0; i<lt-1; i++){
            tot+=$("#in_0_"+i).attr("value");
          }
          addline(n1+" x "+n2+" = "+tot);
          $('#addtable').remove();
          $('#calc').show();
          $('#notes').focus();
          $("#sv_opform").hide();
      $("#np_num1").attr("value", tot);
      $("#np_num2").attr("value", "");
        }

      });
      $("#sv_opform").click(function(e){
        var com="";
        for(var i=0; i<lt-1; i++){
          com+=$("#in_0_"+i).attr("value");
        }
        addline(n1+" x "+n2+" = "+com);
        $('#addtable').remove();
        $('#calc').show();
        $('#notes').focus();
        $("#sv_opform").hide();
        $("#sv_opform").unbind();
      $("#np_num1").attr("value", com);
      $("#np_num2").attr("value", "");

      });
    }
    else {
      $(".inps").keypress(function(e){
        var tot="";
        if (e.keyCode==13){
          for(var i=0; i<lt; i++){
            tot+=$("#in"+i).attr("value");
          }
          addline(n1+" x "+n2+" = "+tot);
          $('#addtable').remove();
          $('#calc').show();
          $('#notes').focus();
          $("#sv_opform").hide();

        }
      });
      $("#sv_opform").click(function(e){
        var com="";
        for(var i=0; i<lt; i++){
          com+=$("#in"+i).attr("value");
        }
        addline(n1+" x "+n2+" = "+com);
        $('#addtable').remove();
        $('#calc').show();
        $('#notes').focus();
        $("#sv_opform").hide();
        $("#sv_opform").unbind();
      });
    }
    for (var j=1; j<lt; j++){
      $("#in"+j).keypress({j:j}, function(e){
        if (e.keyCode!=13){
          e.preventDefault();
          $("#in"+(e.data.j)).attr("value", String.fromCharCode(e.keyCode));
          $("#in"+(e.data.j-1)).select();
        }
      });
    }
    for(var j=0; j<n2.length; j++){
      for(var i=1; i<n1.length+j+1; i++){
        $("#in_"+j+"_"+i).keypress({j:j, i:i}, function(e){
          if (e.keyCode!=13){
            e.preventDefault();
            $("#in_"+(e.data.j)+"_"+(e.data.i)).attr("value", String.fromCharCode(e.keyCode));
            $("#in_"+(e.data.j)+"_"+(e.data.i-1)).select();
          }
        });
      }
    }

  }
}
;
function startShow() {
  var slides = $('div.slide');
  slides.mouseenter(function() {
    clearInterval( parseInt($('#intervalID').text()) );
  });
  slides.mouseleave(function() {
    $('#intervalID').text( setInterval("decSlideTimer()", 1000) );
  });

  $('#nextslide').click(function() {
    setSlide((slideNo() + 1) % numSlides());
  });
  $('#prevslide').click(function() {
    setSlide((slideNo() + numSlides() - 1) % numSlides());
  });

  $('#intervalID').text( setInterval("decSlideTimer()", 1000) );
}

function slideNo() {
  return parseInt($('#slideNo').text());
}

function numSlides() {
  return $('div.slide').length;
}

function resetTimer(time) {
  if(time === undefined) { 
    var time = 6;
  }
  $('#slideTimer').text(time + '');
}

function decSlideTimer() {
  var numsecs = parseInt($('#slideTimer').text());
  if(numsecs > 0) {
    resetTimer(numsecs - 1);
    return;
  }

  setSlide((slideNo() + 1) % numSlides());
}

function setSlide(num) {
  var oldslide = $('div.slide.selected');
  var newslide = $('div.slide:eq(' + num + ')');

  oldslide.fadeOut();
  newslide.fadeIn();
  oldslide.removeClass("selected")
  newslide.addClass("selected");

  $('#slideNo').text(num);
  resetTimer();
}

function setPageFunc(name, height) {
  return function() { 
    $('.staticpage').hide();
    $('#'+name).show();
    //$('#container').attr('style', 'height:'+height+'px;');
    $('.navbar-fixed-top li').removeClass("active");
    $('#'+name+'link').parent().addClass("active");
  };
}

function hideProblem() {
  $('#dimmer').unbind('click');

  $('#problem_overlay').hide();
  // $('#dimmer').hide();
  $('#dimmer').remove();
  return false;
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length > 0) {
    dimmer.remove();
  }
  $('body').prepend("<div id=dimmer onclick='hideProblem();'></div>");
  $('#dimmer').show();
  // $('#dimmer').click(hideProblem);
}

function initProblemOverlay() {
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('body').prepend("<div id=problem_overlay class=problem_overlay></div>");
   $p = $('#problem_overlay');
  }

  var dimmer = $('#dimmer');
  if(dimmer.length == 0) {
    $('body').prepend("<div id=dimmer></div>");
    dimmer = $('#dimmer');
  }

  $p.show();
  closeWithDimmer();
  return $p;
}

var goHome = setPageFunc('home', 510);
var goFeatures = setPageFunc('features', 900);
var goAbout = setPageFunc('about', 525);
var goSignin = setPageFunc('signin', 510);

var homeOnLoad = function(pagename) {
  startShow();
  if(pagename === "features") {
    goFeatures();
  }
  else if(pagename === "about") {
    goAbout();
  }
  else if(pagename === "signin") {
    goSignin();
  }
  else {
    goHome();
  }
}

$(document).ready(function() {
  $('.features').collapse();

  $('#homelink').click(goHome);
  $('#featureslink').click(goFeatures);
  $('#aboutlink').click(goAbout);
  $('#signinlink').click(goSignin);
});

function browsers(){
  if($.browser.webkit){
    $('body').append("<div class=\'modal in\' id=\"browserss\"><p>For the best SmarterGrades experience, use:</p><a href=\"https://www.google.com/intl/en/chrome/browser/\" target=\"#\"><img src=\"/assets/chrome_i.png\"></img></a>");
  }
}
;
function hideProblem() {
  /*$('#dimmer').unbind('click');

  $('#problem_overlay').hide();
  $("body").css("overflow", "scroll");
  // $('#dimmer').hide();
  $('#dimmer').remove();
    $("body").css("overflow", "scroll");*/
  $('#pr_dim').hide();
  $("body").css("overflow", "scroll");
  return false;
}

function closeWithDimmer(overlay) {
  var dimmer = $("#dimmer");
  if(dimmer.length > 0) {
    dimmer.hide();
  }
  //$('body').prepend("<div id=dimmer onclick='hideProblem();'></div>");
  $('#dimmer').show();
  // $('#dimmer').click(hideProblem);
}

function initProblemOverlay() {
  var dimmer = $('#dimmer');
  if($('#pr_dim').length == 0){
    $('body').prepend("<div id=pr_dim></div>");
  }
  if(dimmer.length == 0) {
    
    $('#pr_dim').prepend("<div id=dimmer onclick='hideProblem();'></div>");
    dimmer = $('#dimmer');
  }
  var $p = $('#problem_overlay');
  // console.log("found " + $p);
  if($p.length == 0){
   $('#pr_dim').append("<div id=problem_overlay class=problem_overlay></div>");
   $p = $('#problem_overlay');
  }
  $("body").css("overflow", "hidden");
  $('#pr_dim').show();
  dimmer.show();
  $p.show();
  //closeWithDimmer();
  return $p;
}
function bclr_pset(){
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  $(".pset_list_box").hover(function(){
    $(this).css("background-color",COLOR[Math.round(Math.random()*(COLOR.length-1))]);
  });
}
function bclr_problem(){
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  $(".problem_list_box").hover(function(){
    $(this).css("background-color",COLOR[Math.round(Math.random()*(COLOR.length-1))]);
  });
}

function awesome(){
  AWESOME=['Awesome!! Try Another!', 'Fantastic! You\'re almost done with this Problem Type! Try Another!', 'You\'re making everyone else look bad! Keep at it! Try Another']
  $("#problem_overlay").append("<div class=awesome id=awesome><p>"+AWESOME[Math.round(Math.random()*(AWESOME.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>");
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}
function shit(){
  SHIT=['Try Another!', 'Keep on Working at it!!', 'You will get there! Try another!'];
  t="<div class=awesome id=shit><p>"+SHIT[Math.round(Math.random()*(SHIT.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>";
  $("#problem_overlay").append(t);
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}
function done_pr(){
  DONEP=['Try Another Problem Type! This one is already Blue!', 'There are other Problem Types Available!! Don\'t hoard this one!!', 'The other Problem Types are feeling lonely!!! Try one of them!'];
  $("#problem_overlay").append("<div class=awesome id=donep><p>"+DONEP[Math.round(Math.random()*(DONEP.length-1))]+"</p><i class=\'x_awesome icon-remove-circle icon-white\'></i></div>");
  $('.x_awesome').click(function(){
    $('.awesome').hide();
  });
}
;
function hide_custom_problem_form() {
  $('#dimmer').unbind('click');

  $('#custom_problem_form').hide();
  $('#custom_problem_form').find('.input-field,textarea').attr('value', '');
  $('#dimmer').hide();
}
;
(function() {


}).call(this);
$(document).ready(function(){ 
  format_select_arrow();
});

function format_select_arrow() {
  if (!$.browser.opera) {

    $('select.select').each(function(){
      var title = $(this).attr('title')
        , width = $(this).width()
        , height = $(this).height()
        , position = $(this).position();

      if( $('option:selected', this).length > 0 ) {
        title = $('option:selected', this).text();
      }

      $(this)
      .css({'z-index':10,
            'opacity':0,
            '-khtml-appearance':'none' })
      .after('<span class="select" style="height:' + height + 
                                       'px;width:' + width + 
                                       'px;left:' + position.left + 
                                       'px;top:' + position.top + 
                                       'px;">' + title + '</span>')
      .change(function(){
        val = $('option:selected',this).text();
        $(this).next().text(val);
      })
    });

  };
}
;
function shelf_color(){
  var redarr=[];
  var greenarr=[];
  var bluearr=[];
  var i=0;
  var sumblue=0;
  var sumred=0;
  var sumgreen=0;
  var widpset=0;
  $('#bbor').children('.pset_pbar').each(function(){
        redarr[i]= $(this).children('.pset_bar').children('.bar-danger').width();
        widpset+=$(this).width();
        bluearr[i]= $(this).children('.pset_bar').children('.bar-info').width();
        sumblue=bluearr[i]+sumblue;
        sumred=redarr[i] + sumred;
        greenarr[i]= $(this).children('.pset_bar').children('.bar-success').width();
        sumgreen=greenarr[i] + sumgreen; 
        i++;

    });

var shelfwid=$("#bigshelf .shelf").width();
//$('#bigshelf .shelf ul').css("background-color","#ff0040");
//alert(shelfwid);
var green_per=(sumgreen/widpset)*100;
var green_val_shelf=(green_per/100)*shelfwid;
var blue_per = (sumblue/widpset)*100;
var blue_val_shelf= (blue_per/100)*shelfwid;
var red_per=  green_per + blue_per;

//$('#bigshelf .shelf ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue_per+"%,#ff0040 "+blue_per+"%)"); 
if(green_per!=0){
$('#bigshelf .shelf .shelf_ul').css("background","-webkit-gradient(linear,"+blue_per+"% 0%,"+red_per+"% 0%, from(#0087bd), to(#ff0040), color-stop(.005,#60b349),color-stop(.995,#60b349))");
}
else {
  $('#bigshelf .shelf .shelf_ul').css("background","-webkit-linear-gradient(left,#0087bd "+blue_per+"%,#ff0040 "+blue_per+"%)"); 
}
$('#bigshelf .shelf .shelf_ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+blue_per+"%,#60b349 0%,#60b349 "+(red_per)+"%,#ff0040 0%)");

}
function shelf_color_in(blue, green, red){
  if(green != "0"){
$('#bigshelf .shelf_ul').css("background","-webkit-gradient(linear,"+parseInt(blue)+"% 0%,"+(parseInt(blue)+parseInt(green))+ "% 0%, from(#0087bd), to(#ff0040), color-stop(.005,#60b349),color-stop(.995,#60b349))")
}
else{
  if(blue!="0"){
    if(parseInt(blue)==100){
      $('#bigshelf .shelf_ul').css("background","#0087bd"); 
    }
    else{
      $('#bigshelf .shelf_ul').css("background","-webkit-linear-gradient(left, #0087bd "+parseInt(blue)+"%, #ff0040 "+parseInt(blue)+"%)"); 
    }
  }
  else{
    $('#bigshelf .shelf_ul').css("background","red"); 
  }
}
$('#bigshelf .shelf_ul').css("background","-moz-linear-gradient(0% 0% 0deg,#0087bd, #1414C9, #0087bd "+parseInt(blue)+"%,#60b349 0%,#60b349 "+(parseInt(blue)+parseInt(green))+"%,#ff0040 0%)");
}
;
function set_stat_widths(elt, total) {
  console.log(stats.find('li:eq(2)').first().attr('data-original-title')); 
  if(total == undefined) { total = false; }

  elt.children('ul').each( function() {
    var scores = $(this).children('li:gt(0)')
      , width = (940 - 400) / scores.length;
    
    scores.each( function() { 
      var percent = parseInt( $(this).attr('data-width') )
        , kid = $(this).children('div').first()

      //console.log(percent + '');

      if(total) {
        $(this).width(width * percent / 100.0);
        kid.width('100%');
      } else {
        $(this).width(width);
        kid.width(percent + '%');
      }
    });
  });
}
;
INIT_PROBLEM = {};
DESTROY_PROBLEM = {};

function initProblem() { 
  //console.log('initProblem');
  for(a in INIT_PROBLEM) {
    //console.log("INIT: " + a);
    INIT_PROBLEM[a].call()
  }
  console.log('Problem JS initialized');
}

function destroyProblem() {
  for(a in DESTROY_PROBLEM) {
    DESTROY_PROBLEM[a].call();
  }
}
;

function setUpDataGr(cname, tname) {
  COLOR=["#049cdb", "#46a546", "#9d261d", "#f89406", "#c3325f", "#7a43b6", "#ffc40d"];
  var canvas = $("#"+cname)[0];
  var table = tname;
  if(canvas == undefined) { return undefined; }
  var ht = canvas.height;
  var wt = canvas.width; 
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started
  var mousedown=false;

  var grph={
    mg : 50,
    type : "basicbar",
    scale : 30,
    color : ["red", "green", "blue", "orange", "yellow", "gray"],
    edit : false,
    divs : 10,
    dir : 'x',
    head : "",
    start : 0,
    table : new Array(),
    tally : [],
    divsedit : false,
    setEditable : function(edit){
              this.edit=edit;
    },
    setDivsEditable : function(divsedit){
              this.divsedit=divsedit;
    },
    setType : function(type){
               this.type=type;
            },
    setDivs : function(divs){
                this.divs=divs;
            },
    setScale : function(scale){
               this.scale=scale;
             },
    setDir : function(dir){
               this.dir=dir;
             },
    setHead : function(head){
                this.head=head;
              },
    setStart : function(start){
                 this.start=start;
               },
    drawBones : function(){
                  context.fillStyle="black";
                  drawLine(this.mg, ht-this.mg, this.mg, 0);
                  drawLine(wt, ht-this.mg, this.mg, ht-this.mg);
                  for (i = 0; i <= ((ht-this.mg) / this.scale) ; i++) {
                    drawLine(this.mg, ht-this.mg-i*this.scale,this.mg+5, ht-this.mg-i*this.scale);
                    context.textAlign="right";
                    context.fillText(this.divs*i, this.mg-1, ht-this.mg-i*this.scale+8); 
                  }
                },
    fromTable : function(){
                  $("#"+table+" tr").each(function() {
                    var arrayOfThisRow = [];
                    var tableData = $(this).find('input');
                    if (tableData.length > 0) {
                      tableData.each(function() { arrayOfThisRow.push($(this).attr("value")); });
                      grph.table.push(arrayOfThisRow);
                    }
                  });
                },
    drawInitialPictogram : function(imurl){
                      this.image=imurl;
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      mu=20;
                      html="";
                      for(i=0; i<this.table.length; i++){
                        for(j=0; j<parseInt(this.table[i][1]); j++){
                          if(parseInt(this.table[i][1])-this.divs >= this.divs){
                            if((j+1)%this.divs==0){
                              html+="<i class=\"pict "+imurl+"\" id=pict_"+i+"_"+((j+1)/this.divs)+" style=\"position:absolute; top:"+(y+i*2*y)+"px; left:"+(x+mu*(j+1)/this.divs)+"px;\"></i>\n";
                            }
                          }
                          else { html+="<i class=\"half_pict "+imurl+"\" id=pict_"+i+"_"+Math.ceil((j+1)/this.divs)+" style=\"position:absolute; top:"+(y+i*2*y)+"px; left:"+(x+mu*Math.ceil((j+1)/this.divs))+"px;\"></i>\n";}
                        }
                      }
                      $("#pict").append(html);
                    }, 
    addPictogram : function(index){
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      html="<i class=\"pict "+this.image+"\" id=pict_"+index+"_"+(1+parseInt(this.table[index][1])/this.divs)+" style=\"position:absolute; top:"+(y+index*2*y)+"px; "+(x+mu*(1+Math.ceil(parseInt(this.table[index][1])/this.divs)))+"px;\"></i>\n";
                      this.table[index][1]=""+(parseInt(this.table[index][1])+this.divs);
                      cor=true;
                      for(i=0; i<Math.ceil(parseInt(this.table[index][i])/this.divs)-1; i++){
                        if($("#pict_"+index+"_"+(i+1)).attr("class")=="half_pict "+this.image){
                          cor=false;
                          break;
                        }
                      }
                      if (!cor) {
                        this.table[index][1]="n/a";
                      }
                   },
    addHalfPictogram : function(index){
                      x=10+wt/4;
                      y=(ht/this.table.length)/2;
                      html="<i class=\"half_pict "+this.image+"\" id=pict_"+index+"_"+(parseInt(this.table[index][1])/this.divs)+" style=\"position:absolute; top:"+(y+index*2*y)+"px; "+(x+mu*Math.ceil(parseInt(this.table[index][1])/this.divs))+"px;\"></i>\n";
                      this.table[index][1]=""+(parseInt(this.table[index][1])+this.divs/2)
                      cor=true;
                      for(i=0; i<Math.ceil(parseInt(this.table[index][i])/this.divs)-1; i++){
                        if($("#pict_"+index+"_"+(i+1)).attr("class")=="half_pict "+this.image){
                          cor=false;
                          break;
                        }
                      }
                      if (!cor) {
                        this.table[index][1]="n/a";
                      }
                   },
    removePictogram : function(index){
                        if($("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).attr("class")=="half_pict "+this.image) {this.table[index][i]=""+parseInt(this.table[index][i])-this.divs/2;}
                        if($("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).attr("class")=="pict "+this.image) {this.table[index][i]=""+parseInt(this.table[index][i])-this.divs/2;}
                        $("#pict_"+index+"_"+(Math.ceil(parseInt(this.table[index][1])/this.divs))).remove();
                      },

    preInitialTally : function(){
                        for(i=0; i<this.table.length; i++){
                          this.tally[i]=new Array();
                          for(k=0; k < parseInt(this.table[i][1]); k++){
                            if((k+1) % 5!=0){
                              this.tally[i].push('|');
                            }
                            else{ this.tally[i].push('/'); }
                          }
                        }
                        
                      },
    drawTallyMarks : function(){
                       drawLine(wt/4, 0, wt/4, ht);
                       if(this.edit){
                        drawLine(3*wt/4, 0, 3*wt/4, ht);
                       }
                       x=10+wt/4;
                       y=(ht/this.table.length)/2;
                       mu=7;
                       su=10;
                       for(i=0; i<this.table.length; i++){
                         drawLine(0, (i+1)*(ht/this.table.length), wt, (i+1)*(ht/this.table.length));
                         context.textAlign="center";
                         context.fillStyle=COLOR[i % COLOR.length];
                         context.font="12pt Calibri";
                         context.fillText(this.table[i][0], wt/8, y+i*(ht/this.table.length)+3);
                         context.strokeStyle="black";
                         context.textAlign="left";
                         ct=0;
                         for(j=0; j < this.tally[i].length; j++){
                           context.strokeStyle=COLOR[i % COLOR.length];
                           if(this.tally[i][j]=='|'){
                             drawLine(x+j*mu, y+i*(ht/this.table.length)-su, x+j*mu, y+i*(ht/this.table.length)+su);
                             ct+=1;
                           }
                           else{
                             drawLine(x+(j)*mu, y+i*(ht/this.table.length)-su, x+(j-ct-1)*mu, y+i*(ht/this.table.length)+su);
                             ct=0;
                           }
                           context.strokeStyle="black";
                         }    
                       }

                     },

    addLine : function(index){
                this.tally[index].push('|');
                ret=parseInt(this.table[index][1])+1;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  }
                }
                this.table[index][1]=ret;
              },
    addSlash : function(index){
                this.tally[index].push('/');
                ret=parseInt(this.table[index][1])+1;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  }
                }
                this.table[index][1]=ret;
              },
    remLast : function(index){
                this.tally[index].pop();
                ret=0;
                for(i=0; i<this.tally[index].length; i++){
                  if((i+1) % 5!=0){
                   if(this.tally[index][i]!='|'){
                    ret="n/a";
                    break;
                   }
                   else { ret+=1; }
                  }
                  else{ if(this.tally[index][i]!='/'){
                    ret="n/a";
                    break;
                  }
                  else{ret+=1;}
                  }
                }
                this.table[index][1]=""+ret;
              },
                  
    placeTallyButtons : function(){
                       x=5*wt/6;
                       y1=(ht/this.table.length)/2-10;
                       html="";
                       for(i=0; i<this.table.length; i++){
                         html+="<button type=button class=line id=line_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x-20)+"px;\"> | </button>\n";
                         html+="<button type=button class=slash id=slash_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x)+"px;\"> / </button>\n";
                         html+="<button type=button class=undo id=undo_"+i+" style=\"position:absolute; top:"+(y1+i*(ht/this.table.length))+"px; left:"+(x+20)+"px;\"> < </button>\n";
                         $("#tally").append(html);
                       }
                        },


    drawBasicBar : function(){
                  this.sp=(wt-this.mg)/this.table.length;
                  for(i = 0; i < this.table.length; i++){
                    context.save();
                    context.translate(this.mg+this.sp/2+i*this.sp, ht-this.mg/2);
                    if (this.table[i][0].length > 3){
                    context.rotate(-Math.PI/3);
                    }
                    context.textAlign="center";
                    context.fillText(this.table[i][0], 0, 0);
                    context.restore();
                  }
                  for(i = 0; i < this.table.length; i++){
                    he=(parseInt(this.table[i][1])/this.divs)*this.scale;
                    context.fillStyle=COLOR[i % COLOR.length];
                    context.fillRect(this.mg+i*this.sp+this.sp/4, ht-this.mg-he, this.sp/2, he);
                  }
                   },
    redraw : function(){
               this.chHTable();
               
               context.clearRect(0,0,wt, ht);
               if(this.type=="basicbar"){
                 this.drawBones();
                 this.drawBasicBar();
               }
               if(this.type=="tally"){
                 this.drawTallyMarks();
               }
             },
    editingBB : function(tr, wh){
                  if(tr > 0){
                    if(parseInt(this.table[wh][1]) > 0){
                      st=((parseInt(this.table[wh][1])-Math.floor(tr/this.scale)*this.divs));
                      if (st >= 0) {this.table[wh][1]=""+st;}
                    }
                  }
                  else{
                    st=((parseInt(this.table[wh][1])-Math.ceil(tr/this.scale)*this.divs));
                    if (st >= 0) {this.table[wh][1]=""+st;}
                  }
                  this.redraw();
                },
    chHTable : function(){
                 for(i=0; i<this.table.length; i++){
                   for(j=0; j < this.table[i].length; j++){
                     $("#"+table+" tr:eq("+i+")").find("input:eq("+j+")").attr("value", this.table[i][j]); 
                   }
                 }
               } 
                       
  };
  if($("#edit").attr("value")=="edit"){
    grph.setEditable(true);
  }
  grph.setType($("#type").attr("value"));
  if(grph.type=="tally"){
    grph.fromTable();
    if(grph.edit){
      grph.placeTallyButtons();
    }
    grph.preInitialTally();
    grph.drawTallyMarks();
  }
  else{
    if($("#editdivs").attr("value")=="true"){
      grph.setDivsEditable(true);
    }
    grph.setDivs($("#divs").attr("value"));
    grph.drawBones();
    grph.fromTable();
    grph.drawBasicBar();
  }



  function drawLine(x1,y1, x2, y2) {
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }
  $('.line').click(function(e){
    grph.addLine(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });
  $('.slash').click(function(e){
    grph.addSlash(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });
  $('.undo').click(function(e){
    grph.remLast(parseInt($(this).attr("id").substr($(this).attr("id").indexOf("_")+1, 10)));
    grph.redraw();
  });




  $('#'+cname).mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    initdowny=mousey;
    mousedown=true;
  });
  $('#'+cname).mouseup(function (e) { 
    mousedown=false;
  });
  $('#'+cname).mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    var offset = $('#'+cname).offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);
    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
    // global scope.
    if(mousedown){
      if(grph.edit){
        if(grph.type=="basicbar"){

          for(i =0; i<grph.table.length; i++){
            if(downx > grph.mg+grph.sp*i+grph.sp/4 && downx < grph.mg+grph.sp*i+3*grph.sp/4) {
              if(downy < ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale + 45 && downy > ht-grph.mg-(parseInt(grph.table[i][1])/grph.divs)*grph.scale -45){
                if(Math.abs(mousey-downy) >= grph.scale){
                  grph.editingBB(mousey-downy, i);
                  downy=mousey;
                }
              }
            }
          }
        }
      }
    }

  });


}

//INIT_PROBLEM['datagr'] = function() {
//    setUpDataGr("datacanvas", "table");
//}
;
// Drawtools.js
// @author Thomas Ramfjord
// This is a fairly complicated javascript app, so I've written down the basic format.  Basically there is an array of shapes (a 
// shape is basically an interface.  See an example for the functions you need to implement).  The function "redraw" draws all the shapes
// the canvas.  The mouse functions on the canvas element are determined by the "state" variable, which is an index of the STATES array.  
// Each "state" in the array is an object with functions for all the mouse callbacks.  At the intersection of shapes and at the end of lines
// and such are Points Of Interest (POIs), which the mouse will jump to when close enough.
//
//  section 1:
//      global variables and constants.  Constants should be all caps.
//    shapes: the variable which contains all the shapes
//
//  section 2:
//      drawing/utility functions.  Here you will find functions to write output like messages, and various utility functions used
//      elsewhere in the code.  Odds and ends can go here.
//    redraw: I redraw all the shapes and write messages and stuff.
//    updatePOIs: goes through each pair of shapes, and adds points of interest where they intersect
//      -poiBlahBlah functions are for finding intersections between a pair of shapes and adding POI's for them
//
//  section 3:
//      -shape utility functions
//      -generic shape definitons (eg. circle, line)
//      -specific shape definitions (eg. protractor)
//
//  section 4:
//      -state definitions (eg. compState, rulerState, etc)
//
//  section 5:
//      -essentially the main method type code - If you want to draw things on load do it here.

function setUpGeo(cname) {
  // global drawing variables
  cname2=cname;
  if(cname==null){
    cname='geocanvas';
    cname2='';
  }
  var canvas = $('#'+cname)[0];
  if(canvas == undefined) { return undefined; }

  var shapesDisp = $('#'+cname2+'shapes');
  var messageDisp = $('#message');
  var context = canvas.getContext('2d');
  var mousex;         // global mouse position x coord
  var mousey;         // global mouse position y coord
  var downx;          // x coord where the click started
  var downy;          // y coord where the click started

  var nextLineNo = 1;   // lines and circles will be given names like l1, l2 - these indicat the number
  var nextCircleNo = 1;
  var startLineNo = 1;  // starting number - set by getStartShapes
  var startCircleNo = 1;
  var COLORS = ["green", "blue", "purple", "red", "orange", "yellow"]

  // state information
  var PROTRACTOR = 0;
  var COMPASS    = 1;
  var RULER      = 2;
  var LINE       = 3;
  var SELECT     = 4;
  var ERASOR     = 5;
  var BLANK      = 6;
  var state;          // determines mousedown/up/move effects of canvas - currently represents either
  //  protractor, compass, ruler, or line drawing

  var startShapes = []; // will contain the starting shapes that are not to be deleated on clear()
  var shapes = [];      // will hold the current list of shapes - reset to startShapes on clear()

  // array of POI objects, set with the function updatePOIs()
  var pointsOfInterest = [];
  var activePOI_i = -1; // index of the active POI, -1 indicates none active

  //
  // Drawing/Utility Functions
  //
  function redraw(){
    context.clearRect(0,0,canvas.width, canvas.height);
    getActivePOIs();

    if(activePOI_i >= 0) { 
      pointsOfInterest[activePOI_i].draw(); 
    }
    //for (var i = 0; i < pointsOfInterest.length; i++) {
    //  pointsOfInterest[i].draw();
    //}

    for (var i = 0; i < shapes.length; i++) {
      shapes[i].draw();
    }

    //writeMessage(message);
    //writeShapes();
  }

  function setMouseXY(e) {
    var offset = $('#'+cname).offset();
    var offsetx = Math.round(offset.left);
    var offsety = Math.round(offset.top);
      
    mousex = e.pageX - offsetx; // - offset.left;
    mousey = e.pageY - offsety; // - offset.top;
  }
  function writeMessage(message){
    context.clearRect(0,0,canvas.width,30);
    context.font = "12pt Calibri";
    context.fillStyle = "black";
    context.fillText(message, 10, 25);
  }

  function writeShapeHTML() {
    console.log(shapes);
    var s = "";
    var hidden_s = "";
    var color_i = 0;
    for(var i = 0; i < shapes.length; i++) {
      if(!shapes[i].hidden) {
        //if(i == startShapes.length) { s += "<hl>" }
        s += "<div class=shape style=\"background-color:"+COLORS[i]+";\" id=s_" + i + " >" 
                + shapes[i] + 
             "</div>\n";
        hidden_s += ","+shapes[i].encode();
      }
    }
    //for(var i = 0; i < pointsOfInterest.length; i++) {
    //  s += "<p>" + pointsOfInterest[i] + "</p>\n";
    //}
    shapesDisp.html(s);
    $('#'+cname2+'qbans_geometry').attr('value', hidden_s.substr(1));
  }

  function addShapeCallbacks() {
    for(var i = 0; i < shapes.length; i++) {
      if(!shapes[i].hidden) {
        $('#s_'+i).mouseenter({i:i, color:COLORS[i]}, function(e) {
          shapes[e.data.i].highlight(e.data.color);
          redraw();
        });
        $('#s_'+i).mouseleave({i:i}, function(e) {
          shapes[e.data.i].unhilight();
          redraw();
        });

        if(shapes[i] instanceof Circle) {
          // add click to set radius when in compass mode
          $('#s_'+i).click({i:i}, function(e) {
            if(state == compState) {
              $('#circlesize').attr("value", ''+shapes[e.data.i].r);
            }
          });
        }
      }
    }
  }

  // this gets changed when we're in select state... probably bad practice
  var writeShapes = function(){
    writeShapeHTML();
    addShapeCallbacks();
  }

  // ugh...
  function getStartState() {
    tool = $('#'+cname2+'starttool').attr('value');
    if(tool == "select") {
      setState(SELECT);
    } else if(tool == "compass") {
      setState(COMPASS);
    } else if(tool == "line") {
      setState(LINE);
    } else if(tool == "protractor") {
      setState(PROTRACTOR);
    } else {
      setState(BLANK);
    }
  }

  function getStartShapes(){
    startShapes = [];

    // clear and setting start/next Nos is necessary for this to be called multiple times
    clear();
    nextLineNo = 1;   // lines and circles will be given names like l1, l2 - these indicat the number
    nextCircleNo = 1;
    startLineNo = 1;  // starting number - set by getStartShapes
    startCircleNo = 1;

    var s = $('#'+cname2+'startshapes').attr('value');
    if(s != "") {
      var a = s.split(',');
      for(var i = 0; i < a.length; i++) {
        addShape(decodeShape(a[i]));
      }
    }

    startLineNo = nextLineNo;
    startCircleNo = nextCircleNo;
    startShapes = shapes.slice(0);
    clear();
  }

  function getSelectedShapes() {
    var selectedShapes = [];

    var s = $('#'+cname2+'qbans_selected').attr('value');
    if(s==null){
      s='';
    }
    var a = s.split(',');
    for(var i = 0; i < a.length; i++) {
      var shape = decodeShape(a[i]);

      if(shape == undefined) {
        continue;
      }

      j = findShape(shape);
      if(j > 0) {
        shapes[j].highlight();
      } 
      else {
        shape.highlight();
        addShape(shape);
      }
    }
  }

  function getActivePOIs() {
    // NOTE I do not redraw - you must call redraw afterwards if you want my effects to be visible
    // if there is an active POI, check if we're still within range
    if(activePOI_i >= 0) {
      if(pointsOfInterest[activePOI_i].mouseDist() > 10) {
        activePOI_i = -1;
        if(state == protState) {
          protractor.toOffset();
        }
      }
    }

    // otherwise activate any POI within range
    else {
      for (var i = 0; i < pointsOfInterest.length; i++) {
        if(pointsOfInterest[i].mouseDist() < 7) {
          activePOI_i = i;
        }
      }
    }
  }
  function updatePOIs() {
    pointsOfInterest = [];

    // individual shape POIs
    for(var i = 0; i < shapes.length; i++) {
      if(shapes[i].hidden) { continue; }

      if(shapes[i] instanceof Line) {
        addPOI(shapes[i].x1, shapes[i].y1);
        addPOI(shapes[i].x2, shapes[i].y2);
      }

      if(shapes[i] instanceof Circle) {
        addPOI(shapes[i].x, shapes[i].y);
      }
    }

    // shape intersection POIs
    for(var i = 0; i < (shapes.length -1); i++) {
      for(var j = i+1; j < shapes.length; j++) {
        if(shapes[i].hidden || shapes[j].hidden) { continue; }

        if(shapes[i] instanceof Circle) {
          if(shapes[j] instanceof Circle) {
            poiCircleCircle(shapes[i], shapes[j]);
          }
          else if(shapes[j] instanceof Line) {
            poiLineCircle(shapes[j], shapes[i]);
          }
        }
        else if(shapes[i] instanceof Line) {
          if(shapes[j] instanceof Circle) {
            poiLineCircle(shapes[i], shapes[j]);
          }
          else if(shapes[j] instanceof Line) {
            poiLineLine(shapes[i], shapes[j]);
          }
        }
      }
    }
  }
  function poiLineLine(l1, l2) {
    var denom = (l1.x1 - l1.x2)*(l2.y1 - l2.y2) - (l1.y1 - l1.y2)*(l2.x1 - l2.x2);
    if(denom == 0) { // lines are parallel
      return 0;
    }
    
    // get the intersection of the lines using a formula given by wikipedia: http://en.wikipedia.org/wiki/Line-line_intersection
    var x = Math.floor(((l1.x1 * l1.y2 - l1.y1 * l1.x2) * (l2.x1 - l2.x2) - (l1.x1 - l1.x2)*(l2.x1 * l2.y2 - l2.y1 * l2.x2)) / denom);
    var y = Math.floor(((l1.x1 * l1.y2 - l1.y1 * l1.x2) * (l2.y1 - l2.y2) - (l1.y1 - l1.y2)*(l2.x1 * l2.y2 - l2.y1 * l2.x2)) / denom);

    // ensure that the intersection is on both line segments
    var maxX = Math.min(Math.max(l1.x1, l1.x2), Math.max(l2.x1, l2.x2));
    var maxY = Math.min(Math.max(l1.y1, l1.y2), Math.max(l2.y1, l2.y2));
    var minX = Math.max(Math.min(l1.x1, l1.x2), Math.min(l2.x1, l2.x2));
    var minY = Math.max(Math.min(l1.y1, l1.y2), Math.min(l2.y1, l2.y2));
    if(minX <= x && x <= maxX && minY <= y && y <= maxY) {
      addPOI(x,y)
    }
  }
  // note that I currently don't return the number of POIs like my friends, or indeed anything useful
  function poiLineCircle(l, c) {
    // flip x and y when the slope is close to vertical - this leads to more precise calculations
    // and avoids failure on the vertical case
    var flipped = Math.abs(l.x2 - l.x1) < Math.abs(l.y2 - l.y1);
    var x1 = flipped ? l.y1 : l.x1;
    var y1 = flipped ? l.x1 : l.y1;
    var x2 = flipped ? l.y2 : l.x2;
    var y2 = flipped ? l.x2 : l.y2;
    var xc = flipped ? c.y : c.x;
    var yc = flipped ? c.x : c.y;

    var m = (y2 - y1)/(x2 - x1);
    var b = y1 - m*x1;
    // (x-xc)^2 + (y-yc)^2 = c.r^2                                     CIRCLE
    // y = m(x - x1) + y1                                              LINE
    // (x-xc)^2 + (m(x - x1) + y1 - yc)^2 = c.r^2                      SUB Y
    var tmp = y1 - yc - m*x1; 
    // (x-xc)^2 + (mx + tmp)^2 = c.r^2                                 SUB tmp
    // x^2 - 2x*xc + xc^2 + (mx)^2 + 2*tmp*mx + tmp^2 = c.r^2          EXPAND
    // (m^2+1) x^2 + (2*tmp*m - 2*xc) x + (tmp^2 + xc^2 - c.r^2) = 0   REARRANGE
    var a = m*m + 1;
    var b = 2*tmp*m - 2*xc;
    var c = tmp*tmp + xc*xc - c.r*c.r;

    var discriminant = b*b - 4*a*c;
    //alert("discriminant = " + discriminant);
    //alert("se:  a = " + a + ", b = " + b + ", c = " + c + ", disc = " + discriminant + "\n" +
    //      "m = " + (y2 - y1) + "/" + (x2 - x1) + " = " + m + (flipped ? ", flipped" : ""));
    if(discriminant < 0) { // indicates no intersection even on infinite line
      return 0;
    }
    var maxX = Math.max(x1, x2);
    var maxY = Math.max(y1, y2);
    var minX = Math.min(x1, x2);
    var minY = Math.min(y1, y2);

    discriminant = Math.sqrt(discriminant);
    var x_poi = Math.floor((discriminant - b)/(2 * a));
    var y_poi = Math.floor(m*(x_poi - x1) + y1);
    if(minX <= x_poi && x_poi <= maxX && minY <= y_poi && y_poi <= maxY){
      if(flipped){ addPOI(y_poi, x_poi); } else { addPOI(x_poi, y_poi); }
    }
    if(discriminant == 0) { return 1; }

    x_poi = Math.floor((0 - b - discriminant)/(2 * a));
    y_poi = Math.floor(m*(x_poi - x1) + y1);
    if(minX <= x_poi && x_poi <= maxX && minY <= y_poi && y_poi <= maxY){
      if(flipped){ addPOI(y_poi, x_poi); } else { addPOI(x_poi, y_poi); }
    }
    return 2;
  }
  function poiCircleCircle(c1, c2) {
    var dist = distance(c1.x, c1.y, c2.x, c2.y);
    var overlap = (c1.r + c2.r) - dist;
    if(overlap < 0 || dist == 0) { return 0; } // if no intersections OR circles are same, we don't want POIS
    if(overlap == 0) { 
      var x = (c2.x - c1.x)*(c1.r/(c1.r + c2.r)) + c1.x;
      var y = (c2.y - c1.y)*(c1.r/(c1.r + c2.r)) + c1.y;
      addPOI(x,y);
      return 1;
    }
    
    // we can now assume that there are 2 points of intersection
    // equations taken from http://paulbourke.net/geometry/2circle/
    var a = (c1.r * c1.r - c2.r * c2.r + dist * dist) / (2 * dist); // a =~ distance from c1 to the midpoint between the two circles
    var h = Math.sqrt(c1.r * c1.r - a * a); // 
    // (x,y) is P2 on the url above, which is the main point between the two circles
    var x = (c2.x - c1.x)*(a/dist) + c1.x;
    var y = (c2.y - c1.y)*(a/dist) + c1.y;

    var x1 = x - (h/dist)*(c2.y - c1.y);
    var x2 = x + (h/dist)*(c2.y - c1.y);
    var y1 = y + (h/dist)*(c2.x - c1.x);
    var y2 = y - (h/dist)*(c2.x - c1.x);
    addPOI(x1,y1);
    addPOI(x2,y2);
    return 2;
  }

  function clearMessage(){
    writeMessage("");
  }

  function drawCircle(x, y, r, color, width) {
    if(color != undefined) { context.strokeStyle = color }
    if(width != undefined) { context.lineWidth = width }
    else { context.lineWidth = 1; }

    context.beginPath();
    context.arc(x, y, r, 0, (2.0 * Math.PI), false);
    context.closePath();
    context.stroke();
  }

  function drawSolidCircle(x, y, r, color) {
    if(color == undefined) { color = "black" }
    context.beginPath();
    context.arc(x, y, r, 0, (2.0 * Math.PI), false);
    context.closePath();
    context.fillStyle = color
    context.fill();
  }

  function drawLine(x1,y1, x2, y2, color, width) {
    if(color != undefined) { context.strokeStyle = color; }
    if(width != undefined) { context.lineWidth = width }
    else { context.lineWidth = 1; }
    context.beginPath();
    context.moveTo(x1,y1);
    context.lineTo(x2, y2);
    context.stroke();
    context.closePath();
  }

  //
  // Shape Utility Functions
  //
  function distance(x1, y1, x2, y2) {
    xdiff = x1 - x2;
    ydiff = y1 - y2;
    return Math.sqrt(xdiff * xdiff + ydiff * ydiff);
  }
  function insideCircle(x, y, r) {
    return (distance(x,y, mousex, mousey) <= r)
  }

  //
  // Specific Shape functions/definitions
  //
  function Shape(hidden) {
    hidden = typeof hidden !== 'undefined' ? hidden : false;
    this.hidden = hidden;
    this.color = "black";
    this.thickness = 1;

    this.highlight = function(color) {
      this.color = color;
      this.thickness = 3;
    }

    this.unhilight = function() {
      this.color = "black";
      this.thickness = 1;
    }
  }
  function decodeShape(s) {
    var a = s.split(":");

    if(a.length < 2) { return undefined; }

    var type = a.shift();
    if(type == "line"){
      for(var i = 0; i < a.length; i++) { a[i] = parseInt(a[i]); }
      return new Line(a[0], a[1], a[2], a[3]);
    }

    else if(type == "circle"){
      return new Circle(parseInt(a[0]), parseInt(a[1]), parseFloat(a[2]));
    }

    else if(type == "point"){
      return new Point(parseInt(a[0]), parseInt(a[1]), a[2], parseFloat(a[3]));
    }

    else if(type == "infline"){
      for(var i = 0; i < a.length; i++) { a[i] = parseInt(a[i]); }
      return new Line(a[0], a[1], a[2], a[3]);
    }

    else if(type == "ray"){
      for(var i = 0; i < a.length; i++) { a[i] = parseInt(a[i]); }
      return new Line(a[0], a[1], a[2], a[3]);
    }
  }

  function updateShapePeriphery() {
    writeShapes();
    updatePOIs();
    redraw();
  }

  function findShape(shape) {
    for(var i = 0; i < shapes.length; i++) {
      if(shapes[i].to_s == shape.to_s) { return i; }
    }
    return -1;
  }

  function addShape(shape) {
    if(shape instanceof Line){
      nextLineNo++;
    }
    else if(shape instanceof Circle){
      nextCircleNo++;
    }
    else if(shape == undefined) {
      return -1;
    }

    shapes.push(shape);
    updateShapePeriphery();
    return shapes.length - 1; // index of shape
  }
  function delShape(shape_i) {
    shapes.splice(shape_i,1);
    updateShapePeriphery();
  }
  function clear() {
    nextLineNo = startLineNo;
    nextCircleNo = startCircleNo;

    shapes = startShapes.slice(0);
    updateShapePeriphery();
  }

  function Line(x1, y1, x2, y2) {
    if(x1 > x2) { return new Line(x2, y2, x1, y1); }

    Shape.call(this);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.num = nextLineNo;

    this.draw = function() {
      drawLine(this.x1, this.y1, this.x2, this.y2, this.color, this.thickness);
    }

    // TODO remove this - it is kind of a hack to make tracingLine work
    this.set_p2 = function(x, y){
      this.x2 = x;
      this.y2 = y;
      this.draw = function() {
        drawLine(this.x1, this.y1, x, y, "black");
      }
    }

    this.underMouse = function(px_dist) { 
      if(px_dist == undefined) { px_dist = 5; }
     
      var l1 = this.toSlopeInt();
      var l2 = this.toRevSlopeInt(); // give vertical lines a fighting chance for selection

      // Remember! x1 and x2 are guaranteed to be in sorted order.  Not so with y1 and y2!!!
      return (Math.abs(mousex * l1.m + l1.b - mousey) < px_dist && this.x1 < mousex && mousex < this.x2)
          || (Math.abs(mousey * l2.m + l2.b - mousex) < px_dist && Math.abs((this.y1 + this.y2)/2 - mousey < px_dist))
    }

    this.toString = function() {
      //return "(Line from " + x1 + ", " + y1 + " to " + x2 + ", " + y2 + ")";
      return "l<sub>" + this.num + "</sub>"
    }

    this.encode = function() {
      return "line:"+this.x1+":"+this.y1+":"+this.x2+":"+this.y2;
    }

    this.toSlopeInt = function() {
      var m = (this.y2 - this.y1) / (this.x2 - this.x1);
      var b = this.y1 - (m * this.x1);
      return {
        m : m,
        b : b,
      }
    }

    this.toRevSlopeInt = function() {
      var m = (this.x2 - this.x1) / (this.y2 - this.y1);
      var b = this.x1 - (m * this.y1);
      return {
        m : m,
        b : b,
      }
    }
  }

  function addLine(x1,y1,x2,y2) {
    var tmp = new Line(x1,y1,x2,y2);
    return addShape(tmp);
  }

  function Circle(x,y,r) {
    Shape.call(this);
    this.x = x;
    this.y = y;
    this.r = r;
    this.num = nextCircleNo;

    this.draw = function() {
      drawCircle(this.x, this.y, this.r, this.color, this.thickness);
    }

    this.underMouse = function(px_dist) { 
      if(px_dist == undefined) { px_dist = 3; }
      return insideCircle(this.x, this.y, (this.r + px_dist)) && !insideCircle(this.x, this.y, this.r - px_dist);
    }

    this.toString = function() {
      //return "(Circle " + x + ", " + y + ", " + r.toFixed(3) + ")"; //round of radius to 3 digs
      return "c<sub>"+this.num+"</sub>";
    }

    this.encode = function() {
      return "circle:"+this.x+":"+this.y+":"+this.r;
    }
  }

  // creates a new circle, adds it to shapes, returns new index
  function addCircle(x,y,r) {
    var tmp = new Circle(x,y,r);
    return addShape(tmp);
  }


  // name should be a single capital letter according to CBSE convention
  function Point(x,y,name, angle) {
    Shape.call(this, true);
    this.x = x;
    this.y = y;
    this.name = name;
    this.angle = (angle == undefined) ? 45.0 : angle;
    this.color = "black";
    this.r = 2;

    this.draw = function() {
      var dist = 17.0 - Math.abs(this.angle - 2.2) * 3.7; // yeah I just got these values from playing around
      var tx = this.x + (dist * Math.cos(this.angle));
      var ty = this.y + (dist * Math.sin(this.angle));
      context.fillText(this.name, tx, ty);
      drawSolidCircle(this.x, this.y, this.r, this.col);
    }

    this.highlight = function(color) {
      if(color == undefined) { color = "green"; }
      this.color = color;
      this.r = 7;
    }
    this.unhilight = function() {
      this.color = "black";
      this.r = 2;
    }

    this.toString = function() { return name; }

    this.encode = function() {
      return "point:"+this.x+":"+this.y+":"+this.name;
    },
    this.underMouse = function() { return false }
  }

  function addPoint(x,y,name) {
    var tmp = new Point(x,y,name);
    return addShape(tmp);
  }

  // Interest Point stuff
  function POI(x, y) {
    this.x = x;
    this.y = y;
    this.active = false;

    this.mouseDist = function() {
      if(state == protState){
        // if we're not moving the protractor
        if(!(state.mouse_is_down && state.on_protractor)) {
          return 1024; // hopefully a bigger distance than we'll ever be testing for
        }
        return distance(this.x, this.y, mousex - protractor.offx, mousey - protractor.offy);
      }
      else {
        return distance(this.x,this.y,mousex,mousey);
      }
    }

    this.toString = function() {
      //TODO remove mousedist
      return "(POI " + this.x+", " + this.y + ")";
    }

    this.draw = function() { 
      drawSolidCircle(this.x, this.y, 10, "green");
    }

    this.encode = function() {
      return "point:"+this.x+":"+this.y + ":";
    }
  }
  function addPOI(x, y) {
    pointsOfInterest.push(new POI(x,y));
  }

  // unique shapes
  var protractor = {
    x : canvas.width / 2,
    y : canvas.height / 2,
    offx : 0,
    offy : 0,
    theta : 0.0,
    shapes_i : -1,

    lastx : -1,
    lasty : -1,
    lasttheta : 0.0,

    addToShapes : function() {
      if(this.shapes_i >= 0){
        return this.shapes_i;
      }
      else {
        this.shapes_i = shapes.push(this) - 1;
        redraw();
        return this.shapes_i;
      }
    },
    delFromShapes : function() {
      if(this.shapes_i >= 0) {
        shapes.splice(this.shapes_i, 1);
        redraw();
        this.shapes_i = -1;
      }
    },
    toString : function() { 
      return "(Protractor at " + this.x + ", " + this.y + ")";
    },
    move : function() {
      this.x -= this.lastx - mousex;
      this.y -= this.lasty - mousey;
      this.lastx = mousex;
      this.lasty = mousey;
    },
    rotate : function() {
      var mousetheta = Math.atan2((mousex - this.x), (mousey - this.y));
      this.theta -= mousetheta - this.lasttheta;
      this.lasttheta = mousetheta;
      // T?DO? ensure theta is between 0 and PI/2 
    },
    // sets this.lasttheta to the mouse coordinate theta
    setLasttheta : function() {
      this.lasttheta = Math.atan2((mousex - this.x), (mousey - this.y));
    },

    draw : function() {
      context.strokeStyle = "black";
      context.lineWidth = 1;

      var innerRadius = 50;
      var outerRadius = 100;
      var x = this.x;
      var y = this.y;

      // the weird begin/closePath stuff here is to fix a bug with the closing path with lines thing
      context.beginPath();
      // minicircle in the center
      context.arc(this.x, this.y, 5, 0, 2*Math.PI, true);
      context.closePath();
      context.stroke();
      // outer D
      context.beginPath();
      context.arc(this.x, this.y, outerRadius, Math.PI + this.theta, 2*Math.PI + this.theta, false);
      //inner semicircle
      context.arc(this.x, this.y, innerRadius, Math.PI + this.theta, 2*Math.PI + this.theta, false);

      var total = 1;
      var divisors = [2,9,2];
      for (var n = 0; n < divisors.length; n++) {
        total *= divisors[n];
        theta_i = Math.PI / total; // not that theta is the current rotation of the compass
        myInnerRadius = (outerRadius - innerRadius) * n / divisors.length + innerRadius;
        for(var i = 1; i < total; i++) {
          var angle = i * theta_i + this.theta;
          var sine = 0.0 - Math.sin(angle);
          var cosine = 0.0 - Math.cos(angle);
          var x1 = cosine * myInnerRadius + this.x;
          var y1 = sine * myInnerRadius + this.y;
          var x2 = cosine * outerRadius + this.x;
          var y2 = sine * outerRadius + this.y;

          context.moveTo(x1,y1);
          context.lineTo(x2,y2);
        }
      }
      var x1 = Math.cos(this.theta) * outerRadius + this.x;
      var y1 = Math.sin(this.theta) * outerRadius + this.y;
      var x2 = Math.cos(this.theta + Math.PI) * outerRadius + this.x;
      var y2 = Math.sin(this.theta + Math.PI) * outerRadius + this.y;
      context.moveTo(x1,y1);
      context.lineTo(x2,y2);
      //context.closePath();
      context.stroke();
    },
    underMouse : function() {
      // TODO calculate for real
      return insideCircle(this.x, this.y, 100);
    },
    setOffset : function () {
      this.offx = mousex - this.x;
      this.offy = mousey - this.y;
    },
    toOffset : function () {
      this.x = mousex - this.offx;
      this.y = mousey - this.offy;
    }
  }

  //
  // App State/Tool definitions
  //
  function setState(newstate) {
    if(state == STATES[newstate]) { return; }
    $('.tools div').removeClass("selected");
    $(STATEIDS[newstate]).addClass("selected");
    if(!(typeof state === "undefined")){
      state.deactivate();
    }

    if(typeof STATES[newstate] === "undefined"){
      alert("undefined newstate: "+ newstate + ", " + a_to_s(STATES));
      state = protState;
    } 
    else {
      state = STATES[newstate];
    }
    state.activate();
  }

  // when we're in protState, we're using the protractor to measure angles
  var protState = {
    tool : "protractor",  
    // variables we need to determine behaviour
    on_protractor : false,
    mouse_is_down : false,

    // methods
    activate : function() {
      protractor.addToShapes();
      $(canvas).css('cursor', 'move');
    },
    deactivate : function() {
      protractor.delFromShapes();
      $(canvas).css('cursor', 'default');
    },

    // mouse actions
    mousedown : function() {
      this.mouse_is_down = true;
      protractor.lastx = downx;
      protractor.lasty = downy;
      this.on_protractor = protractor.underMouse();
      if(!this.on_protractor) {
        protractor.setLasttheta();
      }
      else {
        protractor.setOffset();
      }
    },
    mouseup : function() {
      this.mouse_is_down = false;
    },
    mousemove : function() {
      if(this.mouse_is_down){
        if(this.on_protractor){
          protractor.move();
        }
        else {
          protractor.rotate()
        }
      }
    }
  }

  var nullfunc = function() { return null; }

  // when we are in compState, we are using the compass to draw circles
  var compState = {
    tool : "compass",
    mouse_is_down : false,
    usingsetradius : false,
    minicircle_i : -1,

    useWrittenSize : function() {
      $("#compass span").attr("style","");
      $('#compass span').text("Compass R = " + Math.round(parseFloat($("#circlesize").attr("value")),2));
      $('#circlesize').attr("disabled", true);
    },
    useMakeSize : function() {
      $("#compass span").attr("style","border-right:2px solid black;");
      $('#compass span').text("Compass");
      $('#circlesize').attr("disabled", false);
    },

    activate : function() {
      $('#circlesize').show();
      $('#usecirclesize').show();
      this.useMakeSize();
      $(canvas).css('cursor', 'crosshair');
    },
    deactivate : function() {
      $(STATEIDS[COMPASS]+" span").attr("style","");
      $("#compass span").text("Compass");
      $('#circlesize').hide();
      $('#usecirclesize').hide();
      $(canvas).css('cursor', 'default');
    },
    mousedown : function() {
      if(!this.usingSetRadius()) {
        this.mouse_is_down = true;
        tracingLine.start();
        var miniCircle = new Circle(mousex, mousey, 5);
        miniCircle.hidden = true;
        this.minicircle_i = shapes.push(miniCircle);
      }
    },
    mouseup : function() {
      // TODO rm
      if(this.usingsetradius){
        var radius = parseFloat($('#circlesize').attr("value"));
        if(isNaN(radius) || radius < 0.0 || 1000 < radius) {
          alert('"' + $('#circlesize').attr("value") + '" is an invalid circle radius - it has to be a number between 0 and 1000');
          return;
        }
      }
      else {
        shapes.pop(); // minicircle
        var radius = tracingLine.clear();
      }
      if(radius > 4) {
        addCircle(downx, downy, radius);
        redraw();
      }
      this.mouse_is_down = false;
      $('#circlesize').attr("value", ''+radius);
    },
    mousemove : function() {
      if(this.mouse_is_down && (!this.usingsetradius)) {
        var radius = distance(mousex, mousey, downx, downy);
        tracingLine.follow();
      }
    },
    usingSetRadius : function() {
      this.usingsetradius = $('#usecirclesize:checked').length == 1;
      return this.usingsetradius;
    }
  } 

  // state for using a ruler
  var rulerState = {
    mouse_is_down : false,
    x : 0,
    y : 0,
    last_dist : "n/a",

    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : function() {
      this.mouse_is_down = true;
      this.x = mousex;
      this.y = mousey;
      tracingLine.start();
      //addCircle(mousex, mousey, 5);
    },
    mousemove : function() { 
      var message;
      if(this.mouse_is_down) {
        message =  "distance from ("+this.x+", "+this.y+") to (";
        message += mousex+", "+mousey+") = " + distance(this.x,this.y,mousex,mousey);
        tracingLine.follow();
      }
      else {
        message = "(" + mousex + ", " + mousey + "), just measured: " + this.last_dist;
      }
    },
    mouseup : function() {
      this.mouse_is_down = false;
      //shapes.pop();
      var dist = tracingLine.clear();
      this.last_dist = dist;
      // TODO print out distance in a better way
    }

  }

  // the state for drawing a line / using a straightedge
  var lineState = {
    x1 : mousex,
    y1 : mousey,
    mouse_is_down : false,

    activate : function() {
      $(canvas).css('cursor', 'crosshair');
    },
    deactivate : function() {
      $(canvas).css('cursor', 'default');
    },
    mousedown : function() {
      this.mouse_is_down = true;
      this.x1 = mousex;
      this.y1 = mousey;
      tracingLine.start();
    },
    mouseup : function() {
      this.mouse_is_down = false;
      tracingLine.clear();
      if(distance(this.x1, this.y1, mousex, mousey) > 5) {
        addLine(this.x1, this.y1, mousex, mousey);
        redraw();
      }
    },
    mousemove : function() {
      if(this.mouse_is_down) {
        tracingLine.follow();
      }
    }
  }

  var eraseState = {
    s_i : -1,

    activate : function() {
      pointsOfInterest = [] // kind of hackish - don't want to be able to see POIs in this state
      $(canvas).css('cursor', 'pointer');
    },
    deactivate : function() {
      updateShapePeriphery();
      $(canvas).css('cursor', 'default');
    },

    mousedown : nullfunc,    

    mouseup : function() {
      if(this.s_i >= 0) { 
        shapes.splice(this.s_i, 1);
        this.s_i = -1;
      }
    },

    mousemove : function() {
      if(this.s_i >= 0) { // on shape
        var s = shapes[this.s_i];

        if(s.underMouse()) return;

        s.unhilight(); 
        this.s_i = -1;
      }

     // locate nearby shapes/pois
      this.s_i = selectState.onWhichShape(); // too lazy to move this somewhere more general

      // if we're not on a shape (s_i is already -1) or on a startShape
      // note that shapes always places the startShapes before the user drawn shapes
      if(this.s_i < startShapes.length) {
        this.s_i = -1;
      }
      else { 
        shapes[this.s_i].highlight(); 
      }
    }
  }

  var selectState = {
    s_i : -1,
    n_points_added : 0,
    selShapes : {},
    old_writeShapes : undefined, 

    activate : function() {
      // I <3 JAVASCRIPT
      this.old_writeShapes = writeShapes;
      writeShapes = function() { writeShapeHTML(); }
      writeShapes();
      $(canvas).css('cursor', 'pointer');
    },
    deactivate : function() {
      writeShapes = this.old_writeShapes();
      writeShapes();
      $(canvas).css('cursor', 'default');
    },

    mousedown : function() {
      if(activePOI_i >= 0) { // we're on a point
        var poi = pointsOfInterest[activePOI_i];
        var p_e = poi.encode();
        if(!this.selShapes[p_e]) {
          // highlight a new point and add it to this.selShapes
          var p_i = addPoint(poi.x, poi.y, "");
          shapes[p_i].highlight();
          this.selShapes[p_e] = shapes[p_i]; // this should never be 0 unless the canvas was empty, 
                                        // which is impossible because there'd be no POIs
        }
        else {
          // remove the point we added from shapes and this.selShapes
          // TODO improve delShape and use that
          var i = shapes.lastIndexOf(this.selShapes[p_e]);
          shapes.splice(i, 1);
          this.selShapes[p_e] = undefined;
        }
      }
      else if(this.s_i >= 0) { // we're on a shape
        var s = shapes[this.s_i];
        var s_e = s.encode();
        if(!this.selShapes[s_e]) {
          // highlight shape and add it to this.selShapes
          s.highlight();
          this.selShapes[s_e] = true;
        }
        else {
          s.unhilight();
          this.selShapes[s_e] = undefined;
        }
      }
      this.writeSelection();
    },

    mousemove : function() {
      if(this.s_i >= 0) { // on shape
        var s = shapes[this.s_i];
        var s_e = s.encode();
        if(!s.underMouse() || activePOI_i >= 0) { // leaving shape
          // unhilight it unless the user has clicked on/selected it
          if(!this.selShapes[s_e]) { 
            s.unhilight(); 
          }
          this.s_i = -1;
        }
      }
      else { // locate nearby shapes/pois
        if(activePOI_i < 0) { //no active pois, check for shapes
          this.s_i = this.onWhichShape();
          if(this.s_i >= 0) { shapes[this.s_i].highlight(); }
        }
      }
    },

    mouseup : nullfunc,

    onWhichShape : function() {
      for(var i = 0; i < shapes.length; i++) {
        if(shapes[i].underMouse()) { 
          return i
        }
      }
      return -1;
    },

    writeSelection : function() {
      var s = "";
      for(i in this.selShapes) { if(this.selShapes[i]) { s = s+i + "," } }
      $('#'+cname2+'qbans_selected').attr("value", s.replace(/,$/, ""));
    }
  }

  // state we start in
  var blankState = {
    activate : nullfunc,
    deactivate : nullfunc,
    mousedown : nullfunc,
    mouseup : nullfunc,
    mousemove : nullfunc
  }

  // array of state objects - each has at least 5 methods: activate, deactivate, mouseup, mousedown, mousemove 
  var STATES = [protState, compState, rulerState, lineState, selectState, eraseState, blankState];
  var STATEIDS = ["#protractor", "#compass", "#ruler", "#line", "#selectState", "#eraseState", "#blank"];

  // a helper state for those which want a tracing line on mouse pushdown
  var tracingLine = {
    shape_i : -1,
    start : function() {
      if(this.shape_i < 0) {
        var line = new Line(mousex, mousey, mousex+1, mousey+1);
        line.hidden = true;
        this.shape_i = shapes.push(line) - 1;
      }
    },
    follow : function() {
      shapes[this.shape_i].set_p2(mousex, mousey);
      //context.fillText(shapes[i].toString(), (canvas.width-200), 500);
      redraw();
    },
    clear : function() {
      line = shapes[this.shape_i];
      var dist = distance(line.x1, line.y1,line.x2, line.y2);
      shapes.splice(this.shape_i,1);
      this.shape_i = -1
        redraw();
      return dist;
    }
  }

  //
  // Callbacks for mouse gestures
  //
  $('#'+cname).mousedown(function (e) { 
    // downx and y have many uses
    downx = mousex;
    downy = mousey;
    state.mousedown();
  });

  $('#'+cname).mouseup(function (e) { 
    state.mouseup();
    activePOI_i = -1;
    redraw();
  });

  $('#'+cname).mousemove(function (e) { 
    // mousex and mousey are used for many things, and therefore need to be in the
    // global scope.
    setMouseXY(e);

    // activate interest points if we are close to them
    getActivePOIs();
    if(activePOI_i >= 0) {
      if(state == protState) {
        protractor.x = pointsOfInterest[activePOI_i].x;
        protractor.y = pointsOfInterest[activePOI_i].y;
      }
      else {
        mousex = pointsOfInterest[activePOI_i].x;
        mousey = pointsOfInterest[activePOI_i].y;
      }
    }
    state.mousemove();
    redraw();
  });

  $('#compass').click(function(){
    setState(COMPASS);
  });

  function validateCircleSize() {
    var radius = parseFloat($('#circlesize').attr("value"));
    if(isNaN(radius) || 0 >= radius) {
      alert("The radius on the right needs to be a positive number!");
      $('#usecirclesize').prop("checked", false);
      return false;
    }
    if(radius > 500) {
      alert("Hey, that's a pretty big radius.  I don't think it will fit on the screen");
      $('#usecirclesize').prop("checked", false);
      return false;
    }
    return true;
  }
  $('#usecirclesize').click(function() {
    if($('#usecirclesize').prop("checked")){
      if(validateCircleSize()){
        compState.useWrittenSize();
      }
    } else {
      compState.useMakeSize();
    }
  });

  $('#protractor').click(function(){
    setState(PROTRACTOR);
  });

  $('#ruler').click(function(){
    setState(RULER);
  });

  $('#line').click(function(){
    setState(LINE);
  });

  $('#clear').click(function(){
    getStartShapes();
    setState(BLANK);
  });

  $('#erase').click(function(){
    setState(ERASOR);
  });

  function a_to_s(arr) {
    s = "";
    for(var i = 0; i < arr.length; i++) {
      s += arr[i] + "\n";
    }
    return s;
  }

  //
  // general/main part
  //
  //addLine(600, 0, 600, canvas.height);
  //alert(STATES[0].tool + ", " + STATES[1].tool);
  getStartShapes();
  getStartState();
  getSelectedShapes();
  //setState(SELECT);
}

//INIT_PROBLEM['geometry'] = setUpGeo;
function centerFractionInts() {
  $('.fraction .int').each(function() {
    var $i = $(this)
      , $total_height = $i.parent().height();

    $i.css('top', $total_height / 2)
    $i.css('margin-top', (0-$i.outerHeight())/ 2)
  });
}

INIT_PROBLEM['fraction'] = centerFractionInts;
function rel_mt_fields(btn) {
  return btn.siblings("div").children("input");
}

function set_mt_field_ids(fields) {
  blank_field = fields.first().attr("id").replace(/[0-9]*$/, "");
  for(var i = 0; i < fields.length; i++) {
    fields[i].id = blank_field + i;
    fields[i].name = blank_field + i;
  }
}

function bind_mt_buttons() {
  $('.add_mt_field').unbind('click');
  $('.add_mt_field').bind('click', function() {
    var fields = rel_mt_fields($(this));

    var new_field = fields.first().clone()
    new_field.attr("value", "");

    fields.last().after(new_field);
    fields = rel_mt_fields($(this));

    set_mt_field_ids(fields);
    bind_mt_fields();
    fields.last().select();

  });

  $('.del_mt_field').unbind('click');
  $('.del_mt_field').bind('click', function() {
    var fields = rel_mt_fields($(this));
    var num = fields.length;

    if(num > 1) {
      fields.last().remove();
    }
    rel_mt_fields($(this)).last().select()
  });

  bind_mt_fields();
}

function bind_mt_fields() {
  $('.multifield div input').unbind('keydown');
  $('.multifield div input').keydown(function (e) {
    //alert("keycode = " + e.keyCode );
    // shift-space, shift-enter, ctrl-space, ctrl-enter
    if((e.keyCode == 32 || e.keyCode == 13) && (e.shiftKey || e.ctrlKey)) {
      $(this).parent().siblings(".add_mt_field").click();
      e.preventDefault();
    }
    // backspace
    else if(e.keyCode == 8) {
      if($(this).attr("value") == "") {
        var mom = $(this).parent();
        if(mom.children().length > 1) {
          $(this).remove();

          set_mt_field_ids(mom.children());
          var emptykids = mom.children('input[value=""]');
          if(emptykids.length > 0) {
            emptykids.last().select();
          }
          else {
            mom.children().last().select();
          }
        }

        e.preventDefault();
      }
    }
  });
}

INIT_PROBLEM['multi_text_field'] = bind_mt_buttons;
function o_to_s(obj) {
  ret = []
  for(var a in obj) {
    ret.push("" + a + ": " + obj[a]);
  }
  return "{ " + ret.join(", ") + " }"
}
function initNumberLine() {
  // global drawing variables
  $('.numberline').each(function() {
    var jcanvas = $(this);
    var canname = jcanvas.attr('id')
      , name = jcanvas.attr('data-name')
      , editable = (jcanvas.attr('data-editable') == 'true')
      , movable = (jcanvas.attr('data-movable') == 'true')
      , which = jcanvas.attr('data-which')
      , canvas = jcanvas[0];

    console.log("WOO HOO");
    console.log(canname);
    console.log(name);
    console.log(editable);
    console.log(movable);
    console.log(which);

    var context = canvas.getContext('2d');
    context.clearRect(0,0,canvas.width, canvas.height);
    var mousex;         // global mouse position x coord
    var mousey;         // global mouse position y coord
    var downx;          // x coord where the click started
    var downy;          // y coord where the click started
    var mousedown=false;
    var off=25;         // offset from edges
    var state;
    var zoompos = 180;
    var malNumLine={  
      num : 10,
    center : (canvas.width)/2, 
    snum : 10,
    mid : 0,
    diff : 10,
    bdivs : 1000,
    zbarc : zoompos,
    initz : zoompos,
    poi : [],
    inp : null,
    points : [],
    lines : [],
    zoomin : [1, 0.5, 0.25, 0.2, 0.1, 0.05],
    zoominf : [1, 2, 4, 5, 10, 20],          
    zoomout : [1, 2, 5, 10, 50, 100],
    ewid : Math.floor((canvas.width-2*off)/100),
    lower : 40,
    movable : movable,
    upper : 320,
    ldiv : 20,
    edit : editable,
    curnum : 0,
    curpos : 0,
    initpos : 0,
    fdiff : 1,
    movemid : function() {
      var mmov=mousex-downx;
      downx=mousex
        this.center+=mmov;
    },
    zoom : function() {

    },
    addsub : function(){
      num=parseInt($("#"+canname+"_"+name).attr("value"));
      this.curnum=num;
      leftpos=0;
      if(num >= this.mid && num <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2+ct*this.ewid;
            break;
          }
          add+=((this.diff/10));
          ct+=1;
        }
      }
      if(num < this.mid && num >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2-ct*this.ewid;
            break;
          }
          add-=this.diff/10;
          ct+=1;
        }
      }
      if(leftpos!=0){
        this.curpos=leftpos;
        fwth=16;
        this.drawPointer(leftpos);
        context.save();
        context.fillStyle="white";
        context.textAlign="center";
        context.fillText(""+num, leftpos, canvas.height-off+17); 
        context.restore();
      }
    },
    drawPointer : function(pos){
      fwth=16;
      this.curpos=pos;
      drawLine(pos, canvas.height-off, pos-fwth/2, canvas.height-off+7);
      drawLine(pos, canvas.height-off, pos+fwth/2, canvas.height-off+7);
      context.save();
      context.fillStyle="black";
      context.fillRect(pos-fwth/2, canvas.height-off+7, fwth, 15);
      context.fillStyle="white";
      context.strokeStyle="red";
      if(this.initpos!=0){
        drawLine(pos, canvas.height-off, this.initpos, canvas.height-off); 
      }
      context.restore();
    },

    label: function(num, clr){
      leftpos=0;
      if(num > this.mid && num <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2+ct*this.ewid;
            break;
          }
          add+=((this.diff/10));
          ct+=1;
        }
      }
      if(num < this.mid && num >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2-ct*this.ewid;
            break;
          }
          add-=this.diff/10;
          ct+=1;
        }
      }
      if(leftpos!=0){
        fwth=(""+num).length*8;
        drawLine(leftpos, canvas.height-off, leftpos-fwth/2, canvas.height-off+15);
        drawLine(leftpos, canvas.height-off, leftpos+fwth/2, canvas.height-off+15);
        context.fillStyle=clr;
        context.fillRect(leftpos-fwth/2, canvas.height-off+15, fwth, 15)
        context.fillStyle="white";
        context.fillText(""+num, leftpos-fwth/2+2, canvas.height-off+24)
        context.fillStyle="black";


      }
    },
    lines : function(nums){
      num=nums[0];
      leftpos=0;
      if(num > this.mid && num <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2+ct*this.ewid;
            break;
          }
          add+=((this.diff/10));
          ct+=1;
        }
      }
      if(num < this.mid && num >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2-ct*this.ewid;
            break;
          }
          add-=this.diff/10;
          ct+=1;
        }
      }
      lnum1=leftpos;
      num=nums[1];
      leftpos=0;
      if(num > this.mid && num <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2+ct*this.ewid;
            break;
          }
          add+=((this.diff/10));
          ct+=1;
        }
      }
      if(num < this.mid && num >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2-ct*this.ewid;
            break;
          }
          add-=this.diff/10;
          ct+=1;
        }
      }
      lnum2=leftpos;
      context.strokeStyle="red";
      drawLine(lnum1, canvas.height-off, lnum2, canvas.height-off);
      context.strokeStyle="black";
    },
    inputfield : function(num){
      leftpos=0;
      if(num > this.mid && num <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add <= this.mid+this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2+ct*this.ewid;
            break;
          }
          add+=((this.diff/10));
          ct+=1;
        }
      }
      if(num < this.mid && num >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
        var add=this.mid;
        ct=0;
        while (add >= this.mid-this.diff*(canvas.width-2*off)/(2*this.ewid*this.snum)){
          if(add==num){
            leftpos=(canvas.width)/2-ct*this.ewid;
            break;
          }
          add-=this.diff/10;
          ct+=1;
        }
      }
      if(leftpos!=0){
        fwth=(""+num).length*8;
        drawLine(leftpos, canvas.height-off, leftpos-fwth/2, canvas.height-off+15);
        drawLine(leftpos, canvas.height-off, leftpos+fwth/2, canvas.height-off+15);

        html="<input type=text id="+name+" name="+name+" maxlength="+((""+num).length)+" style=\"width:"+fwth+"px; padding:0px; position:absolute; top:"+(canvas.height-off+15)+"px; margin-right:0px; margin-left:7px; left:"+(leftpos-fwth/2-1)+"px;\">";
        $("#nline").append(html);
      }
    },
    moveZBar : function() {
      var mmov=mousey-downy;
      downy=mousey;
      if (mmov+this.zbarc <= this.upper-this.ldiv-1 && mmov+this.zbarc >= this.lower+this.ldiv+1) {
        this.zbarc+=mmov;

        zoompos=this.zbarc;
        if (this.zbarc < this.initz) {
          this.diff=this.zoomout[Math.floor((this.initz-this.zbarc)/this.ldiv)];
        }
        else {
          this.diff=this.zoomin[Math.floor((this.zbarc-this.initz)/this.ldiv)];
          this.fdiff=this.zoominf[Math.floor((this.zbarc-this.initz)/this.ldiv)];
        }
      }
    },
    drawZBar : function() {
      drawLine(5,this.lower,5,this.upper);
      drawLine(5,this.upper,15,this.upper);
      drawLine(15,this.upper,15,this.lower);
      drawLine(15,this.lower,5,this.lower);
      drawLine(5,this.zbarc-this.ldiv,5,this.zbarc+this.ldiv);
      drawLine(5,this.zbarc+this.ldiv,15,this.zbarc+this.ldiv);
      drawLine(15,this.zbarc+this.ldiv,15,this.zbarc-this.ldiv);
      drawLine(15,this.zbarc-this.ldiv,5,this.zbarc-this.ldiv);
      writeMessage("The small divs are " +this.diff/10+" and the big divs are "+this.diff);
    },
    draw : function(type) {
      var first=canvas.width-off;
      var last=off;
      var ct=0;
      for (i=this.center; i >= off; i-=this.ewid){
        if (i <= canvas.width-off) { 
          drawLine(i, canvas.height-off, i, canvas.height-off-10);
          if (ct==0) {last=i;}
          ct+=1;
        } 
        first=i;
      }
      ct=0;
      for (i=this.center; i <=canvas.width-off; i+=this.ewid){
        if (i >= off){
          drawLine(i, canvas.height-off, i, canvas.height-off-10);
          if (ct==0 && first > i) {first=i;}
          if(last < i) {last=i;}
          ct+=1;
        }  
      }
      t=this.mid;
      var ct=this.mid;
      for (i=this.center; i >= off; i-=this.ewid*this.snum){
        if (i <= canvas.width-off) { 
          drawLine(i, canvas.height-off, i, canvas.height-off-20);
          this.poi.push(i);
          if (i !=this.center) {
            if (type == "dec" || this.diff >= 1){
              context.font = "9pt Calibri";
              if ((Math.round(t*1000)/1000).toString().length < 2) {
                context.fillText(Math.round(t*1000)/1000, i-3, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 3) {
                context.fillText(Math.round(t*1000)/1000, i-6, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 4) {
                context.fillText(Math.round(t*1000)/1000, i-9, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 5) {
                context.fillText(Math.round(t*1000)/1000, i-12, canvas.height-10);
              }
              else{
                context.fillText(Math.round(t*1000)/1000, i-15, canvas.height-10);
              }
            }
            else {
              var num=-ct;
              var den=this.fdiff;
              var hcf=gcd(num, den);
              num=Math.round(num/hcf);
              den=Math.round(den/hcf);
              context.font = "9pt Calibri";
              if(den !=1){
                context.fillText(-num, i-9, canvas.height-15);
                context.fillText("__", i-9, canvas.height-15);
                context.fillText(den, i-9, canvas.height-4)
              }
              else { context.fillText(-num, i-9, canvas.height-10); }
            }
          } 
        }
        t-=this.diff;
        ct-=1;
      }
      ct=0;
      t=this.mid
        for (i=this.center; i <=canvas.width-off; i+=this.ewid*this.snum){
          if (i >= off){
            drawLine(i, canvas.height-off, i, canvas.height-off-20);
            this.poi.push(i);
            if (type == "dec" || this.diff >= 1){
              context.font = "9pt Calibri";
              if ((Math.round(t*1000)/1000).toString().length < 2) {
                context.fillText(Math.round(t*1000)/1000, i-3, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 3) {
                context.fillText(Math.round(t*1000)/1000, i-6, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 4) {
                context.fillText(Math.round(t*1000)/1000, i-9, canvas.height-10);
              }
              else if ((Math.round(t*1000)/1000).toString().length < 5) {
                context.fillText(Math.round(t*1000)/1000, i-12, canvas.height-10);
              }
              else{
                context.fillText(Math.round(t*1000)/1000, i-15, canvas.height-10);
              }
            }
            else {
              var num=ct;
              var den=this.fdiff;
              var hcf=gcd(num, den);
              num=Math.round(num/hcf);
              den=Math.round(den/hcf);
              context.font = "9pt Calibri";
              if(den !=1){
                context.fillText(num, i-9, canvas.height-15);
                context.fillText("__", i-9, canvas.height-15);
                context.fillText(den, i-9, canvas.height-4)
              }
              else { context.fillText(-num, i-9, canvas.height-10); }
            }
          }
          t+=this.diff;
          ct+=1;
        }
      drawLine(first, canvas.height-off, last, canvas.height-off);
    }
    }
    malNumLine.draw("frac");
    malNumLine.diff=parseInt($("#"+canname+"_bigdiv").attr("value"));
    if(which=="inpval"){
      malNumLine.inputfield(parseInt($("#"+canname+"_inp").attr("value")));
    }
    if(which=="movinp"){
      malNumLine.addsub();
      malNumLine.initpos=malNumLine.curpos;
    }
    if(which=="label"){
      labs=$("#"+canname+"_label").attr("value").split(",");
      for(p=0; p<labs.length; p++){
        if(p==0){
        malNumLine.label(labs[p],"black");
        }
        else{
          malNumLine.label(labs[p],"green");
        }
      }
      lines=$("#"+canname+"_lines").attr("value").split(";");
      for(p=0; p<lines.length; p++){
        malNumLine.lines(lines[p].split(","));
      }

    }
    if( malNumLine.edit ){
      malNumLine.drawZBar();
    }
    $('#'+canname).mousedown(function (e) { 
      // downx and y have many uses
      initdownx=mousex;
      downx = mousex;
      downy = mousey;
      mousedown=true;
    });

    $('#'+canname).mouseup(function (e) { 
      if(which=="movinp"){
        if(malNumLine.initpos > mousex){
          $("#"+canname+"_"+name).attr("value", malNumLine.curnum+Math.round((downx-initdownx)/malNumLine.ewid));
          $("#"+name).attr("value", malNumLine.curnum+Math.round((downx-initdownx)/malNumLine.ewid));
        }
        else{
          $("#"+canname+"_"+name).attr("value", malNumLine.curnum+Math.round((downx-initdownx)/malNumLine.ewid));
          $("#"+name).attr("value", malNumLine.curnum+Math.round((downx-initdownx)/malNumLine.ewid));
        }
    context.clearRect(0,0,canvas.width, canvas.height);
    malNumLine.draw("dec");

    malNumLine.addsub();
      }
      mousedown=false;
    });

    function setMouseXY(e) {
      var offset = $('#'+canname).offset();
      var offsetx = Math.round(offset.left);
      var offsety = Math.round(offset.top);

      mousex = e.pageX - offsetx; // - offset.left;
      mousey = e.pageY - offsety; // - offset.top;
    }
    $('#'+canname).mousemove(function (e) { 
      // mousex and mousey are used for many things, and therefore need to be in the
      // global scope.
      setMouseXY(e);
      if(which=="movinp"){
        if(mousedown && downx < malNumLine.curpos+8 && downx > malNumLine.curpos-8 && downy > canvas.height-off+7 && mousex > off+2 && mousex < canvas.width-off-2){
          context.clearRect(0,0,canvas.width, canvas.height);
          malNumLine.draw("dec");
          malNumLine.drawPointer(mousex);
          downx=mousex;
        }
      }
      if(mousedown && malNumLine.movable){
        if (downy > canvas.height-75){
          malNumLine.movemid();
          context.clearRect(0,0,canvas.width, canvas.height);
          malNumLine.draw("frac");
          if(malNumLine.edit){
            malNumLine.drawZBar();
          }
        }
        if (downx > 5 && downx < 20 && downy > zoompos-25 && downy < zoompos+25){
          malNumLine.moveZBar();
          context.clearRect(0, 0, canvas.width, canvas.height);
          malNumLine.drawZBar();
          malNumLine.draw("frac");
        }
      }
      // activate interest points if we are close to them
    });
    function writeMessage(message){
      context.clearRect(0,0,canvas.width,30);
      context.font = "12pt Calibri";
      context.fillStyle = "black";
      context.fillText(message, 10, 25);
    }
    function gcd(num1,num2){
      if (num2==0) {return num1;}
      if (num1 < num2) {return gcd(num2, num1);}
      return gcd(num1-num2, num2);
    }
    function drawNumLine(num, snum, diff, mid){
      var ewid=Math.floor((canvas.width-2*off)/(num*snum));
      var first;
      for (i=center; i >= off; i-=ewid){
        drawLine(i, canvas.height-off, i, canvas.height-off-10);
        first=i;
      }
      var last;
      for (i=center; i <=canvas.width-off; i+=ewid){
        drawLine(i, canvas.height-off, i, canvas.height-off-10);
        last=i;  
      }
      t=mid
        for (i=center; i >= off; i-=ewid*snum){
          drawLine(i, canvas.height-off, i, canvas.height-off-20);
          context.fillText(t, i-5, canvas.height-10)
            t-=diff
        }
      t=0
        for (i=center; i <=canvas.width-off; i+=ewid*snum){
          drawLine(i, canvas.height-off, i, canvas.height-off-20);
          context.fillText(t, i-5, canvas.height-10)
            t+=diff;
        }
      drawLine(first, canvas.height-off, last, canvas.height-off)
    }


    function writeNums(num, x, y){
      context.clearRect(x-5,y,x+5,y+10);
      context.font = "12pt Calibri";
      context.fillStyle = "black";
      context.fillText(num, x-7, y+15);
    }


    function drawCircle(x, y, r) {
      context.beginPath();
      context.arc(x, y, r, 0, (2.0 * Math.PI), false);
      context.closePath();
      context.stroke();
    }

    function drawLine(x1,y1, x2, y2) {
      context.beginPath();
      context.moveTo(x1,y1);
      context.lineTo(x2, y2);
      context.stroke();
      context.closePath();
    }

    function Line(x1, y1, x2, y2) {
      Shape.call(this);
      this.x1 = x1;
      this.y1 = y1;
      this.x2 = x2;
      this.y2 = y2;
      this.draw = function() {
        drawLine(x1, y1, x2, y2);
      }
      // TODO remove this - it is kind of a hack to make tracingLine work
      this.set_p2 = function(x, y){
        this.x2 = x;
        this.y2 = y;
        this.draw = function() {
          drawLine(this.x1, this.y1, x, y);
        }
      }
      this.underMouse = function() { 
        return false; 
      }
      this.toString = function() {
        return "(Line from " + x1 + ", " + y1 + " to " + x2 + ", " + y2 + ")";
      }
    }

    function addLine(x1,y1,x2,y2) {
      var tmp = new Line(x1,y1,x2,y2);
      return addShape(tmp);
    }
    //
    // Shape Utility Functions
    //
    function distance(x1, y1, x2, y2) {
      xdiff = x1 - x2;
      ydiff = y1 - y2;
      return Math.sqrt(xdiff * xdiff + ydiff * ydiff);
    }
  });
}

INIT_PROBLEM['numberline'] = initNumberLine;
(function ($) {
  "user strict";

  /* PERMUTATIONDRAG CLASS DEFINITION
   * ================================ */

  var PermutationDrag = function(element) {
    this.$element = $(element);
    //this.padding = parseInt(this.$element.css('padding-right').replace(/px/, ''));
    this.gap = 10;
    this.box = undefined;
    this.read_elts();

    $(element).css('height', this.height);
    $(element).css('width', this.width);
    var offset   = this.$element.offset();
    this.offsetx = Math.round(offset.left);
  }

  PermutationDrag.prototype = {
    read_elts : function() {
      this.elts = [];
      var max_height = 0
        , l_off = 0
        , p = this
        , l = 0; // length of elts


      this.$element.children('div').each( function(i) {
        l = p.elts.push( new PermBox( $(this), i, l_off) );
        max_height = Math.max(max_height, $(this).outerHeight());

        l_off += p.elts[l-1].width + p.gap
        console.log(l_off + " " +p.elts[l-1]);
      });

      this.height = max_height;
      this.width = this.box_x(this.elts[l-1]) + this.elts[l-1].width;
    }

    , write_order : function() {
      this.$element.children('input').attr('value', this.elts.join(","));
    }

    // theoretical x position of elts[i] - linear search. Since elts is generally small you shouldn't
    // usually bother to save the result of this function
    // and if we did want to we should just memoize here and update on swap_elts()
    , box_x : function(box) {
      len = 0;
      for(var i = 0; i < box.i; i++) {
        len += this.elts[i].width + this.gap;
      }
      return len;
    }

    , next_movable_elt : function(box, inc) {
      for(var i = (box.i + inc); 0 <= i && i < this.elts.length; i += inc) {
        if(!this.elts[i].fixed) { return this.elts[i] }
      }
      return undefined;
    }

    // Switches boxes i and j
    // - slides j to i's previous position
    // - nothing is done to the position of i, because i is assumed to be in the mouse
    , swap_elts : function(b_i, b_j) {
      var i = b_i.i
        , j = b_j.i

      b_j.set_i(i);
      b_i.set_i(j);

      this.elts[j] = b_i
      this.elts[i] = b_j 

      b_j.slide_to(this.box_x(b_j))

      // slide elts in between j and i to their new places
      // only necessary for fixed elements
      var inc = (j > i) ? +1 : -1
      for(var i = (i + inc); i != j; i += inc) {
        this.elts[i].slide_to(this.box_x(this.elts[i]))
      }

      this.write_order();
    }

    , mouse_is_down : function() {
      return this.box != undefined;
    }

    , mousedown : function(e) {
      var mousex = e.pageX - this.offsetx;

      // get the box we clicked on unless it's fixed
      for(var i = this.elts.length - 1; i >= 0; i--) {
        // console.log(this.box_x(this.elts[i]));
        if(mousex > this.box_x(this.elts[i])) {
          if(this.elts[i].fixed){
            return 0;
          }

          this.box = this.elts[i];
          this.mouse_off = mousex - this.box_x(this.box)
          break;
        }
      }

      // increase the z-index of this box so it's above the others
      this.box.inc_z();
    }

    , mouseup : function(e) {
      if(this.box == undefined) return;

      this.box.slide_to(this.box_x(this.box));
      this.box.dec_z();
      console.log('z-index: ' + this.box.$element.css('z-index'));
      this.box = undefined;
    }

    , mousemove : function (e) {
      if(this.mouse_is_down()) {
        var l_off  = e.pageX - this.offsetx - this.mouse_off
          , box    = this.box
          , next_b = this.next_movable_elt(box, +1)
          , prev_b = this.next_movable_elt(box, -1);

        // if we're off the edges, stay at the edge and return
        if( (next_b == undefined && l_off > this.box_x(box)) || (prev_b == undefined && l_off < 0) ) {
          box.set_l_off(this.box_x(box));
          return 1;
        } 

        else {
          box.set_l_off(l_off);
        }

        // now we swap with the next elt if the overlap in our current state is bigger
        // than the overlap in the best alternative state
        var overlap = l_off - this.box_x(box);

        if(overlap > 0) {
          // next_b must be defined, or we're at the edge and would have returned
          var overlap_n = (this.box_x(next_b) - box.width + next_b.width) - l_off;
          if(overlap > overlap_n) { this.swap_elts(box, next_b); }
        }
        else if(overlap < 0) {
          var overlap_n = l_off - this.box_x(prev_b);
          if(-overlap > overlap_n) { this.swap_elts(box, prev_b); }
        }
        return 1;
      }
    }
  }

  /* PERMBOX CLASS DEFINITION
   * ======================== */
  var PermBox = function(element, i, l_off) {
    this.$element = element;
    this.i = i;
    this.set_l_off(l_off);
    this.width = element.outerWidth();
    this.fixed = this.$element.hasClass('fixed');
  }

  PermBox.prototype = {
    set_l_off : function(l_off) {
      this.l_off = l_off;
      this.$element.css('left', l_off);
    }

    , middle : function() {
      return this.l_off + Math.floor(this.width / 2)
    }

    , slide_to : function(l_off) {
      this.$element.animate({ left : (l_off + "px") });
      this.l_off = l_off;
    }

    , set_i : function(i) {
      this.i = i;
    }

    , toString : function() {
      return this.$element.text();
    }

    , inc_z : function() {
      var z = parseInt(this.$element.css('z-index'));
      this.$element.css('z-index', z+1);
    }

    , dec_z : function() {
      var z = parseInt(this.$element.css('z-index'));
      this.$element.css('z-index', z-1);
    }
  }

  /* PERMUTATIONDRAG PLUGIN DEFINITION
   * ================================= */
  $.fn.permutationDrag = function() {
    // this.each so you can call $('.permutationDrag').permutationDrag();, and it will apply to all elts
    return this.each( function() {
      var $this = $(this),
          data = $this.data('permutationDrag');

      if(!data) $this.data('permutationDrag', (data = new PermutationDrag(this)))
      $this.mousemove(function(e) { data.mousemove(e) });
      $this.mousedown(function(e) { data.mousedown(e) });
      $this.mouseup(function(e) { data.mouseup(e) });
      $this.mouseleave(function(e) { data.mouseup(e) });
    });
  };
} ) ( jQuery );

INIT_PROBLEM['permutationDrag'] = function() {
  $('.permutationDrag').permutationDrag();
};
function drawimage2(a,n,m,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  // alert("canvaswidth is"+canvaswidth+"blah"+a);
  var ycord = y;
  var xcord = x;
for (var i = 0; i < n+(m/2)-(m%2); i++) 
{
  // alert(""+i);
  if (xcord+distance+width<canvaswidth) 
  {
  ctx.drawImage(image1,xcord,ycord,width,height);
   xcord = xcord+(distance+width);
  }
  else
  {
    xcord = x;
    ycord = ycord+distance+height;
  ctx.drawImage(image1,xcord,ycord,width,height);
   xcord = xcord+(distance+width);
  }
}

for(var i =0; i<m%2; i++)
{

  if (xcord+distance+(width/2)<canvaswidth)
  { 
  ctx.drawImage(image2,xcord,ycord,width/2,height);
  xcord = xcord+(distance+(width/2));
  }
  else
  {
    xcord = x;
    ycord = ycord+distance+height;
    ctx.drawImage(image2,xcord,ycord,width/2,height);
    xcord = xcord+(distance+(width/2));
  }
}
}
function drawimage3(a,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  // alert("canvaswidth is"+canvaswidth);

  // alert("blah"+x+y+width+height+distance+"fck"+xcordinate[a]);
  if ((no1[a]==0)&&(no2[a]==0)) 
  {
     xcordinate[a] = x;
     ycordinate[a] = y;
  // alert("blah"+x+y+width+height+distance+"fck"+xcordinate[a]);

     ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a] +(width+distance); 
  }
  else
  {
  // alert("blahh"+x+y+width+height+distance+"fck"+xcordinate[a]);

    if (xcordinate[a]+distance+width<canvaswidth)
    { 
      ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a] +(width+distance);
    }
    else
    {
      xcordinate[a] = x;
      ycordinate[a] = ycordinate[a]+distance+height;
      ctx.drawImage(image1,xcordinate[a],ycordinate[a],width,height);
      xcordinate[a] = xcordinate[a]+(distance+width);
    }

  }
  no1[a]=no1[a]+1;
  no[a]=no[a]+1;
  putvalue2(a,no[a]);
}
function drawimage4(a,x,y,width,height,distance)
{
  // alert("blah");
  var canvas = $("#myCanvas_"+a);
var ctx = canvas[0].getContext("2d");
var canvaswidth = canvas[0].width;
var canvasheight = canvas[0].height;
  if ((no1[a]==0)&&(no2[a]==0))  
  {
     xcordinate[a] = x;
     ycordinate[a] = y;
     ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a] +(width/2+distance); 
  }
  else
  {
    if (xcordinate[a]+distance+width<canvaswidth)
    { 
      ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a] +(width/2+distance);
    }
    else
    {
      xcordinate[a] = x;
      ycordinate[a] = ycordinate[a]+distance+height;
      ctx.drawImage(image2,xcordinate[a],ycordinate[a],width/2,height);
      xcordinate[a] = xcordinate[a]+(distance+width/2);
    }

  }
  no2[a]=no2[a]+1;
  no[a]=no[a]+0.5; 
  putvalue2(a,no[a]);
}


function putvalue2(a,sliceno)
{
  var a  =a;                
  // alert("slice number is " + sliceno+"a= "+a);
  var sliceno=sliceno;
  $("#pictogram_table"+" tr:eq("+a+")").find("input").attr("value", sliceno); 
}                
;
function input1(num,exp)
{	
	

	var maxexp = exp;
	var maxvariable = num;
	// alert("blah")
	var table=document.getElementById("table");
   var r = table.insertRow(0);
   for(var i=0;i<num;i++)
        {
        	var name = variablearray[i];
        	for(var j=0;j<exp;j++)
        	{
        
        		var cellname = name +name+ j;
        		var cell = r.insertCell(j);
           		var k = j+1;
           		cell.id = cellname;
          
		   		cell.style.width="100px";
		  		
		  		var buttonname = name+k;
		   		var btn=document.createElement("BUTTON");
		  
		    	var spanSuper = "<sup>"+k+"</sup>";    
		   		btn.setAttribute("type","button");
		   		btn.innerHTML = name+spanSuper;
		   		btn.id = buttonname;
		   		btn.class = "new";
 		   		btn.onclick = function(){myfunc(this.id);};
		   		var b=document.getElementById(cellname);
		   		// $("#"+cellname).appendChild(btn);
		   		b.appendChild(btn);
			}
        }
}

function myfunc(char,num,exp)
        {	

			var maxexp = exp;
			var maxvariable = num;
            
            var text = document.getElementById("textfield"); 
        	
            var val = text.innerHTML;
			var ch = char;
            switch(ch)
            {
                case "BackSpace":
                // alert("BackSpace");
                if(val.charAt(val.length-1) ==" ")
                {text.innerHTML = val.substr(0, val.length - 1);}
                else if(val.charAt(val.length-1) =="+")
                {	
                	text.innerHTML = val.substr(0, val.length - 1);
                	var val = text.innerHTML;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{sign=1;
                	// alert("sign is"+sign)
                	}
                	else{
                	sign=0;
                	// alert("sign is"+sign);
                	}
                	deleted =1;
                	// alert("deleted is "+deleted);
                	
                }
                else if(val.charAt(val.length-1) =="-")
                {
                	text.innerHTML = val.substr(0, val.length - 1);
                	var val = text.innerHTML;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{sign=1;
                	// alert("sign is"+sign)
                	}
                	else{
                	sign=0;
                	// alert("sign is"+sign);
                	}
                	deleted=1;
                	
                }
                else if(val.charAt(val.length-1) ==">")
                {
                  // alert("yes");
                var d=0;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{
                		d=1;
                		// alert("sign is"+sign)
                	}
                	else
                	{
                		d=0;
                		// alert("sign is"+sign);
                	}
                	var check = 0;
                	for(var i=0;i<6;i++)
					         {check +=arrayexp[i]; }
					
					
					
					         if(check==0)
                	 {
                		var len=0;
                		var a = n+1;
                		var b ="";
                		var c =val.charAt(a);
                		while((c==0)||(c==1)||(c==2)||(c==3)||(c==4)||(c==5)||(c==6)||(c==7)||(c==8)||(c==9))
  						        { 
  							         b=b+c;
  							         a++;
  							         c=val.charAt(a);
  							         len++;
  							         // alert("length of coeff is "+len); 
  						        }
  						      if(b=="")
                		  {b=1;}
                		// alert("coeef is"+b);
						        var c1 = parseInt(b);
						      // alert("coeef is"+c1);
                		if(d==0)
                		{}
                		else
                		{c1 = (-1)*(c1)};
                		// alert("coeef is"+c1);
  						var a1 = val.charAt(a,a);
  						// alert("variable is "+a1);
                		var b1 = val.charAt(a+6, a+6);
//                 		alert("expo is"+b1);
// 			alert("a is "+a);
// 			alert("length is" +val.length);
// 			a= a+13;
                		while(a<val.length)
                 		{
// 			                 alert("blah");
		                	var c2 = parseInt(b1);
// 		                	alert("c2 is "+c2)
        		        	// var spanSuper = "<sup>"+a+"</sup>";               
//                				text.innerHTML += b+spanSuper;  
               				for(var i=0;i<6;i++)
               				{
               					if(a1==variablearray[i])
               					{arrayexp[i] +=c2;
				               		// alert("Value of arrayexp outside the function " + arrayexp[i]);
               					};
               				}
               				a = a+13;
               				// alert("a is "+a);
               				var a1 = val.charAt(a,a);
//                				alert("variable is "+a1);
                			var b1 = val.charAt(a+6, a+6);
               			}	
               			var ind = getindex(6,maxexp);
               			// alert("index is "+ind);
               			// alert("array coefficient is"+	arraycoeff[ind]);
               			arraycoeff[ind]= arraycoeff[ind]-c1;
               			// alert("array coefficient is"+	arraycoeff[ind]);
                    chHTable(index);
               			for(var i=0;i<6;i++)
						{arrayexp[i] =0;}
               		}
               	 else
               		{
               			for(var i=0;i<6;i++)
						{arrayexp[i] =0;}
						coefficient ="";
               		}
                text.innerHTML = val.substr(0, n);
                }
               else
               {
//                alert("deleted is "+deleted);
               if(deleted==1)
               {
               	var d=0;
                	var n =val.lastIndexOf(" ");
                	if(val.charAt(n-1) =="-")
                	{
                		d=1;
//                  		alert("sign is"+sign)
                	}
                	else
                	{
                		d=0;
//                 		alert("sign is"+sign);
                	}
                	
                	var len=0;
                		var a = n+1;
                		var b ="";
                		// var c =val.charAt(a);
//                 		while((c==0)||(c==1)||(c==2)||(c==3)||(c==4)||(c==5)||(c==6)||(c==7)||(c==8)||(c==9))
//   						{
//   							b=b+c;
//   							a++;
//   							c=val.charAt(a);
//   							alert("character is"+c);
//   							len++;
//    							alert("length of coeff is "+len); 
//   						}
						var b = val.substr(a, val.length)
  						if(b=="")
                		{b=1;}
//                 		alert("coeef is"+b);
						var c1 = parseInt(b);
// 						alert("coeef is"+c1);
                		if(d==0)
                		{}
                		else
                		{c1 = (-1)*(c1)};
//                 		alert("constant is"+	arraycoeff[0]);
                		arraycoeff[0]= arraycoeff[0]-c1;
                    chHTable(index);
//                 		alert("constant is"+	arraycoeff[0]);
                		text.innerHTML = val.substr(0, a);
                		coefficient="";
                		
                	
               }
               else
               {
                text.innerHTML = val.substr(0, val.length - 1);
                coefficient=coefficient.substr(0,coefficient.length-1);
                // alert("coeff is"+coefficient);
                }
                }
                break;
	
                
                
                case "Enter":
                    // alert("Enter");
                   text.innerHTML += "<br>";
                   intcoefficient = parseInt(coefficient);
                   if(coefficient=="")
                    {intcoefficient =1;}
                	 
                   index = getindex(6,maxexp);
                   if(sign==0){}
	        		       else{intcoefficient = -1*intcoefficient;}
        		      // alert("Value of index outside the function " + index);
					       if(coefficient!="")
					       {
					       if(arraycoeff[index]===undefined)
	        		   {arraycoeff[index]= intcoefficient;}
	        		   else{arraycoeff[index]+= intcoefficient;}

	        		     // alert("Value at index  " + arraycoeff[index]);
	        	 // $("#table2"+" tr:eq("+index+")").find("input:eq("+index+")").attr("value", arraycoeff[index]); 
               // $(document).ready(function(){
               // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
               //  });
              // $("#"+table2+" tr:eq("+index+")").innerHTML(arraycoeff[index]); 
                   
                   chHTable(index);
                   for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
                   }
                   coefficient = "";
                    break;

	        	case "+ ":
	        		 // alert("+");
	        		text.innerHTML += ch;
	        		intcoefficient = parseInt(coefficient);
	        		if(coefficient=="")
	        		{intcoefficient =1;}
	        		index=getindex(6,maxexp);
	        		if(sign==0){}
	        		else{intcoefficient = -1*intcoefficient;}
        		// alert("Value of index outside the function " + index);
					
					if(arraycoeff[index]===undefined)
	        		{arraycoeff[index]= intcoefficient;}
	        		else{arraycoeff[index]+= intcoefficient;}
  	        		// alert("Value at index  " + arraycoeff[index]);
 	        		 chHTable(index);
 	        		for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
					
					
					sign=0;
					coefficient = "";
	        	break; 
	        	
	        	case "- ":
	        		// alert("-");
	        		text.innerHTML += ch;
	        		intcoefficient = parseInt(coefficient);
	        		if(coefficient=="")
	        		{intcoefficient =1;}
	        		index=getindex(6,maxexp);
	        		if(sign==0){}
	        		else{intcoefficient = -1*intcoefficient;}
        		// alert("Value of index outside the function " + index);
	        		
	        		if(arraycoeff[index]===undefined)
	        		{arraycoeff[index]= intcoefficient;}
	        		else{arraycoeff[index]+= intcoefficient;}
	        		// alert("Value at index  " + arraycoeff[index]);
	        		chHTable(index);
	        		for(var i=0;i<6;i++)
					{arrayexp[i] =0;}
					
					
					sign=1;
					coefficient = "";
	        	break;   
               
               default:
               	if(ch.length==1)
                  { text.innerHTML += ch;
                  	coefficient +=ch;
                  	// alert(coefficient);
                  }
                else
                { 
                var a = ch.substr(ch.length-1,ch.length);
                var b = ch.substr(ch.length-2, ch.length - 1);
//                 if(coefficient==0){coefficient=1;};
//                 alert("blah"+a);
                var c = parseInt(a);
                var spanSuper = "<sup>"+a+"</sup>";               
               	text.innerHTML += b+spanSuper;  
               	for(var i=0;i<6;i++)
               	{
               		if(b==variablearray[i])
               		{arrayexp[i] +=c;
               		// alert("Value of arrayexp outside the function " + arrayexp[i]);
               		// alert("variable is "+variablearray[i])
               		};
               	}
                	
                }
                   
            }
        }

function getindex(num,exp)
{	var a= 0;

	var maxexp = exp;
	
	for(var i=0;i<num;i++)
	{
		a+= arrayexp[i]*(Math.pow(maxexp,i));
		// alert("calculating index..location"+i+"value=="+arrayexp[i]);
	}
	// alert("index is "+a);
	return a;
}

  function chHTable(index){
                
                      var index=index;
                      $("#table2"+" tr:eq("+index+")").find("input:eq("+index+")").attr("value", arraycoeff[index]); 
                      // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
                   
                 
               } 









;
function createshape(a,par4,par5,par6,par7)
{
	// alert("shape is" +a);
	if(a=='circle')
	{	
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 	}
 	else if(a=='rectangle1')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else if(a=='rectangle2')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else if(a=='rectangle3')
 	{
 		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
	ctx.beginPath();
	ctx.rect(startx,starty,length,breadth);
	ctx.strokeStyle = "red";
	ctx.stroke();
	ctx.fillStyle = "white";
	ctx.fill();
	}
	else
	{
		alert("futre vu");
	}
}


function slice(par1,par2,par3,par4,par5,par6,par7,arr,choose)
{	
	if(par1=='circle')
	{	
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		var angle = par2;
		var b = 360.0/angle;
		var a = (angle/180.0)*Math.PI;
		var c = a;
		// alert("no of slices " + b);
		for(var i =0;i<b;i++)
		{
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,0,c);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			c  = c+a;
			colored[i]=0;
		}
		c = a;
		for(var i =0;i<b;i++)
		{
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,0,c);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "black";
			ctx.closePath();
			ctx.stroke();
			c  = c+a;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
           	var d= (sliceno-1)*a;
           	var e = d+a;
           	ctx.beginPath();
			ctx.arc(centrex,centrey,radius,d,e);
			ctx.lineTo(centrex,centrey);
			ctx.stroke();
			ctx.fillStyle = "red";
			ctx.fill();
			ctx.beginPath();
			ctx.arc(centrex,centrey,radius,d,e);
			ctx.lineTo(centrex,centrey);
			ctx.strokeStyle = "black";
			ctx.closePath();
			ctx.stroke();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle1')
	{	
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len  = par2;
		var a = length/len;
		// alert("no of slices " + a);
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		var e = startx;
		for(var i =0; i<a; i++)
		{
			ctx.beginPath();
			ctx.moveTo(e,starty);
			ctx.lineTo(e+len,starty);
			ctx.lineTo(e+len,starty+breadth);
			ctx.lineTo(e,starty+breadth);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			e = e+len;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			var d= (sliceno-1)*len;
           	var e = startx+d;
           	ctx.beginPath();
           	ctx.moveTo(e,starty);
			ctx.lineTo(e+len,starty);
			ctx.lineTo(e+len,starty+breadth);
			ctx.lineTo(e,starty+breadth);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle2')
	{
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len = par2;
		var a = breadth/len;
		// alert("no of slices " + a);
		ctx.beginPath();
		ctx.rect(startx,starty,length,length);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		var e = starty;
		for(var i =0; i<a; i++)
		{
			ctx.beginPath();
			ctx.moveTo(startx,e);
			ctx.lineTo(startx,e+len);
			ctx.lineTo(startx+length,e+len);
			ctx.lineTo(startx+length,e);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			e = e+len;
			colored[i]=0;
		}
		alert("alert");
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			var d= (sliceno-1)*len;
			var e = starty+d;
            ctx.beginPath();
           	ctx.moveTo(startx,e);
			ctx.lineTo(startx,e+len);
			ctx.lineTo(startx+length,e+len);
			ctx.lineTo(startx+length,e);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "green";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}

		}
	}
	else if(par1=='rectangle3')
	{
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
		var len = par2;
		var bre = par3;
		var a = length/len;
		var b = breadth/bre;
		// alert("no of slices " + a*b);
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "red";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill;
		var x = startx;
		var y =starty;
		for(var i =0; i<a; i++)
		{
		 	y =starty;
			for(var j=0;j<b;j++)
			{
			// alert("blah");
				ctx.beginPath();
				ctx.moveTo(x,y);
				ctx.lineTo(x,y+bre);
				ctx.lineTo(x+len,y+bre);
				ctx.lineTo(x+len,y);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				y = y+bre;
			}
			x = x+len;
		}
		for(var i =0;i<arr.length;i++)
		{
			var sliceno = arr[i];
			alert("slice number is " + sliceno);
			// sliceno = (len*(slicex-1))+slicey;
			var slicey = sliceno%len;
			var slicex = ((sliceno-slicey)/len)+1;
			var locx= (slicex-1)*len+startx;
            var locy = (slicey-1)*bre+starty;
       		ctx.beginPath();
			ctx.moveTo(locx,locy);
			ctx.lineTo(locx,locy+bre);
			ctx.lineTo(locx+len,locy+bre);
			ctx.lineTo(locx+len,locy);
			ctx.strokeStyle = "red";
			ctx.closePath();
			ctx.stroke();
			ctx.fillStyle = "black";
			ctx.fill();
			colored[sliceno-1]=1;
			if (choose==1) {putvalue(sliceno);}
		}
	}
}

function update(event,par1,par2,par3,par4,par5,par6,par7) 
{	if(par1=='circle')
	{
		 // alert("circle");
		var centrex = par4;
		var centrey =par5;
		var radius = par6;
		var angle = par2;
		// alert("angle="+angle);
		// var rect = c.getBoundingClientRect();
		var b = 360.0/angle;
		var a = (angle/180.0)*Math.PI;
		var sliceno = 1;
		var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-centrex;	
        var pageY=event.pageY-offsety-centrey;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
        
         // alert("coordinates are  "+ pageX +"and"+pageY);
        var tanangle = pageY/pageX;
        var angle2 = Math.atan(pageY/pageX);
             // alert("angle is " + angle2);
        var angle3 = (angle2*180)/Math.PI;
            // alert("angle in degrees is " + angle3);
        if (((pageX*pageX)+(pageY*pageY))<(radius*radius))
            {
           		if (pageY>0)
           			if (angle3>0) 
           			{
           				sliceno += Math.floor(angle3/angle);
           			}
           			else
           			{
           				sliceno += Math.floor((angle3+90)/angle) + Math.floor(90/angle);
           			}
           		else
           			if (angle3>0) 
           			{
           				sliceno += Math.floor((angle3)/angle) + Math.floor(180/angle);
           			}
           			else
           			{
           				sliceno += Math.floor((angle3+90)/angle) + Math.floor(270/angle);
           			}
           			alert("slice number is " + sliceno);
           			var d= (sliceno-1)*a;
           			var e = d+a;
           			if (colored[sliceno-1]==1) 
           			{
           				ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.stroke();
						ctx.fillStyle = "green";
						ctx.fill();
						ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.strokeStyle = "black";
						ctx.closePath();
						ctx.stroke();
						colored[sliceno-1]=0;
						putvalue(sliceno);
					}
					else
					{
           				ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.stroke();
						ctx.fillStyle = "red";
						ctx.fill();
						ctx.beginPath();
						ctx.arc(centrex,centrey,radius,d,e);
						ctx.lineTo(centrex,centrey);
						ctx.strokeStyle = "black";
						ctx.closePath();
						ctx.stroke();
						colored[sliceno-1]=1;
						putvalue(sliceno);
					}

       		}
       		else
       		{
       			alert("outside the circle");
       		}
    }
    else if (par1=='rectangle1')
    {	
    	// alert("rectangle1");
    	var len = par2;
		var sliceno = 1;
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
            // alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	sliceno += Math.floor(pageX/len);
            	alert("sliceno is " +sliceno);
            	var d= (sliceno-1)*len;
           		var e = startx+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
           		ctx.moveTo(e,starty);
				ctx.lineTo(e+len,starty);
				ctx.lineTo(e+len,starty+breadth);
				ctx.lineTo(e,starty+breadth);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
           		ctx.moveTo(e,starty);
				ctx.lineTo(e+len,starty);
				ctx.lineTo(e+len,starty+breadth);
				ctx.lineTo(e,starty+breadth);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);
				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
	else if(par1=='rectangle2')
	{
		// alert("rectangle2");
		var len = par2;
		var sliceno = 1;
		var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
             alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	sliceno += Math.floor(pageY/len);
            	alert("sliceno is " +sliceno);
            	var d= (sliceno-1)*len;
           		var e = starty+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
           		ctx.moveTo(startx,e);
				ctx.lineTo(startx,e+len);
				ctx.lineTo(startx+length,e+len);
				ctx.lineTo(startx+length,e);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
           		ctx.moveTo(startx,e);
				ctx.lineTo(startx,e+len);
				ctx.lineTo(startx+length,e+len);
				ctx.lineTo(startx+length,e);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);

				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
	else if(par1=='rectangle3')
	{
		// alert("rectangle3");
		var len = par2;
		var bre = par3;
	    var sliceno = 1;
		var slicex = 1;
		var slicey =1;
        var startx = par4;
 		var starty = par5;
 		var length = par6;
 		var breadth =par7;
        var canvas=$("#myCanvas");
		var offset = canvas.offset();
    	var offsetx = Math.round(offset.left);
    	var offsety = Math.round(offset.top);
        var pageX=event.pageX-offsetx-startx;	
        var pageY=event.pageY-offsety-starty;
		coordinate[0] = pageX;
		coordinate[1] = pageY;
            // alert("coordinates are  "+ pageX +"and"+pageY);
            if ((pageX>=0)&&(pageX<=length)&&(pageY>=0)&&(pageY<=breadth)) 
            {
            	slicey += Math.floor(pageY/bre);
            	slicex += Math.floor(pageX/len);
            	sliceno = (len*(slicex-1))+slicey;
            	alert("sliceno is " +sliceno);
            	var locx= (slicex-1)*len+startx;
            	var locy = (slicey-1)*bre+starty;
    //         	var d= (sliceno-1)*len;
    //        		var e = 150+d;
            	if (colored[sliceno-1]==1) 
           		{
           		ctx.beginPath();
				ctx.moveTo(locx,locy);
				ctx.lineTo(locx,locy+bre);
				ctx.lineTo(locx+len,locy+bre);
				ctx.lineTo(locx+len,locy);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "green";
				ctx.fill();
				colored[sliceno-1]=0;
				putvalue(sliceno);
				}
				else
				{
           		ctx.beginPath();
				ctx.moveTo(locx,locy);
				ctx.lineTo(locx,locy+bre);
				ctx.lineTo(locx+len,locy+bre);
				ctx.lineTo(locx+len,locy);
				ctx.strokeStyle = "red";
				ctx.closePath();
				ctx.stroke();
				ctx.fillStyle = "black";
				ctx.fill();
				colored[sliceno-1]=1;
				putvalue(sliceno);
				}
            }
            else
            {
            	alert("outside the rectangle");
            }
	}
}


function putvalue(sliceno)
{
                	// alert("#shapetable"+" tr:eq("+sliceno+")");
                	// alert("slice number is " + sliceno);
                      var sliceno=sliceno-1;
                      $("#shapetable"+" tr:eq("+sliceno+")").find("input").attr("value", colored[sliceno]); 
                      // $("#qbans_ans_"+index).attr("value", arraycoeff[index]); 
} 
;
function createshape1(a,par1,par2,par3,par4,par5,unit)
{
	// alert("shape is" +a);
	if(a=='circle')
	{	
		var centrex = par2*5;
		var centrey =par3*5;
		var radius = par1*5;
		var choice= par4;
		var unit = unit;
		
		// ctx.rotate(40*Math.PI/180);
		if (choice==0)
		{
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(centrex+radius,centrey);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		// alert("radius is " +unit);
  		// ctx.fillText("radius = "+radius/5+""+unit, centrex+5, centrey-5);
  		}
  		else
  		{
  			ctx.beginPath();
		ctx.arc(centrex,centrey,radius,0,2*Math.PI);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(centrex+radius,centrey);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
 		ctx.fill();
 		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		// alert("radius is " +unit);
  		ctx.fillText("radius = "+radius/5+""+unit, centrex+5, centrey-5);
  		}
 	}
 	else if (a=='arc_1') 
 	{
 		// alert("arc_1");
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var startangle = par4;
		var finishangle = unit;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		
 	}
 	else if (a=='arc_2') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var startangle = par4;
		var finishangle = unit;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,false);
		ctx.stroke();
		
 	}
 	else if (a=='arc_3') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5+radius;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();

		
 	}
 	else if(a=='rectangle')
 	{
 		var startx = par3*10;
 		var starty = par5*10;
 		var length = par1*10;
 		var breadth =par2*10;
 		var unit = unit;
 		var choice=par4;
 		if (choice==0) 
 		{
		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		// ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		// ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else if (choice==1) 
  		{
  		ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		// ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else if (choice==2)
  		{
  			ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		// ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
  		else
  		{
  			ctx.beginPath();
		ctx.rect(startx,starty,length,breadth);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText(""+breadth/10+""+unit,startx-40,starty+breadth/2)
  		}
	}
	else if(a=='eqtriangle')
 	{
 		var choice = par4;
 		if (choice==0) 
 		{
 		var startx = par3;
 		var starty = par5;
 		var length = par1*10;
 		var unit = unit;
 		var height = (length/2)*Math.tan(Math.PI/3);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length,starty);
		ctx.lineTo(startx+length/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
  		sctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.textAlign="center";
  		ctx.fillText("Equilateral Triangle", 150,295);
  		}
  		else 
  		{
  		var startx = par3;
 		var starty = par5;
 		var length = par1*10;
 		var unit = unit;
 		var height = (length/2)*Math.tan(Math.PI/3);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length,starty);
		ctx.lineTo(startx+length/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		// ctx.fillStyle = "white";
		// ctx.fill();
		ctx.beginPath();
		ctx.moveTo(startx+length/2,starty-height);
		ctx.lineTo(startx+length/2,starty);
		ctx.stroke();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
  		ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  		ctx.fillText("height = "+(height/10).toFixed(2),startx+length/2,((starty)+(starty-height))/2);
  		ctx.textAlign="center";
  		ctx.fillText("Equilateral Triangle", 150,295);
  		}
	}
	else if(a=='isotriangle')
 	{	
 		var choice = par4;
 		if (choice==0) 
 		{
 		var startx = par3;
 		var starty = par5;
 		var length1 = par1*10;
 		var length2 = par2*10;
 		var unit = unit;
 		var angle = Math.acos(length2/(2*length1));
 		// alert("angle="+angle*180/Math.PI);
 		var height = (length2/2)*(Math.tan(angle));
 		// alert("height="+height);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length2,starty);
		ctx.lineTo(startx+length2/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		
  		ctx.fillText(" "+length2/10+""+unit, startx+length2/4, starty-5);
  		ctx.fillText(""+length1/10+""+unit,startx,starty-height/2);
  		ctx.textAlign="center";
  		ctx.fillText("Isoceles Triangle", 150,295);
  		}
  		else
  		{
  		// alert("white");
  		var startx = par3;
 		var starty = par5;
 		var length1 = par1*10;
 		var length2 = par2*10;
 		var unit = unit;
 		var angle = Math.acos(length2/(2*length1));
 		// alert("angle="+angle*180/Math.PI);
 		var height = (length2/2)*(Math.tan(angle));
 		// alert("height="+height);
		ctx.beginPath();
		ctx.moveTo(startx,starty);
		ctx.lineTo(startx+length2,starty);
		ctx.lineTo(startx+length2/2,starty-height);
		ctx.lineTo(startx,starty);
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.fillStyle = "white";
		ctx.fill();
		ctx.beginPath();
		ctx.moveTo(startx+length2/2,starty-height);
		ctx.lineTo(startx+length2/2,starty);
		ctx.stroke();
  		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.fillText("height = "+(height/10).toFixed(2),startx+length2/2,((starty)+(starty-height))/2);
  		ctx.fillText(" "+length2/10+""+unit, startx+length2/4, starty-5);
  		ctx.fillText(""+length1/10+""+unit,startx,starty-height/2);
  		ctx.textAlign="center";
  		ctx.fillText("Isoceles Triangle", 150,295);
  		}
	}
	else if (a=='scalene') 
	{
		
		var choice = par4;
		var a = par1*10;
		var b = par2*10;
		var c = par3*10;
		if(((a+b)>c)&&((b+c)>a)&&((c+a)>b))
		{
			if (choice!=0)
			{
				// alert("black");
			var cosA = (b*b+c*c-a*a)/(2*b*c);
			var angleA = Math.acos(cosA);
			var sinA = Math.sin(angleA);
			var radius = a/(2*Math.sin(angleA));
			var cosB = (a*a+c*c-b*b)/(2*a*c);
			var angleB = Math.acos(cosB);
			var a1 = radius*sinA;
			var a2 = radius*cosA;
			var b1 = radius*Math.cos(0.5*Math.PI-(angleA+2*angleB));
			var b2 = radius*Math.sin(0.5*Math.PI-(angleA+2*angleB));
			var centrex = 150;
			var centrey =150;
			var height = Math.abs(b2-a2);
			ctx.beginPath();
			ctx.moveTo(centrex-a1,centrey+a2);
			ctx.lineTo(centrex+a1,centrey+a2);
			ctx.lineTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex-a1,centrey+a2)
			ctx.stroke();
			ctx.beginPath();
			ctx.moveTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex+b1,centrey+a2);
			ctx.stroke();
			ctx.fillStyle = "blue";
 			ctx.font = " 12px Arial";
			// ctx.fillText("height = "+height.toFixed(2),centrex+b1,((centrey+a2)+(centrey+b2))/2);
			ctx.fillText("height = "+(height/10).toFixed(2),130,282);

  			ctx.textAlign="center";
 			ctx.fillText(""+a/10+""+unit,centrex,centrey+a2+10);
 			ctx.fillText(""+b/10+""+unit,((centrex+a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
 			ctx.fillText(""+c/10+""+unit,((centrex-a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
  			ctx.fillText("Triangle", 150,295);
  			}
  			else
  			{
  			// alert("white");
  			var cosA = (b*b+c*c-a*a)/(2*b*c);
			var angleA = Math.acos(cosA);
			var sinA = Math.sin(angleA);
			var radius = a/(2*Math.sin(angleA));
			var cosB = (a*a+c*c-b*b)/(2*a*c);
			var angleB = Math.acos(cosB);
			var a1 = radius*sinA;
			var a2 = radius*cosA;
			var b1 = radius*Math.cos(0.5*Math.PI-(angleA+2*angleB));
			var b2 = radius*Math.sin(0.5*Math.PI-(angleA+2*angleB));
			var centrex = 150;
			var centrey =150;
			
			ctx.beginPath();
			ctx.moveTo(centrex-a1,centrey+a2);
			ctx.lineTo(centrex+a1,centrey+a2);
			ctx.lineTo(centrex+b1,centrey+b2);
			ctx.lineTo(centrex-a1,centrey+a2)
			ctx.stroke();
			ctx.fillText(" "+length/10+""+unit, startx+length/4, starty-5);
  			ctx.textAlign="center";
  			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.fillText(""+a/10+""+unit,centrex,centrey+a2+10);
 			ctx.fillText(""+b/10+""+unit,((centrex+a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
 			ctx.fillText(""+c/10+""+unit,((centrex-a1)+(centrex+b1))/2,((centrey+a2)+(centrey+b2))/2);
  			ctx.fillText("Triangle", 150,295);
  			}
		}
		else
		{
			alert("A triangle cannot be constructed with these side lengths.")
		}
	}
	else if (a=='regularpolygon') 
	{
		var choice = par4;
		var numsides=par1;
		var length = par2;
		var startx = 250;
 		var starty = 250;
 		var canvasy= par3;
 		var unit = unit;
		var side = length;
		var numsides = numsides;
		var angle = 180/numsides;
		var radius = side/(2*(Math.sin(angle)));
		if (choice==0)
		{
		for (var i = 0; i <numsides; i++) 
		{
			regularpoly_x[i]=(radius*Math.cos(2*Math.PI*i/numsides));
			regularpoly_y[i]=(radius*Math.sin(2*Math.PI*i/numsides));
			original2[3*i]=regularpoly_x[i];
			original2[3*i+1]= regularpoly_y[i];
			original2[3*i+2]=10;
		}
		createshape2(original2,unit,150,150,0);
		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.textAlign="center"; 
		// ctx.fillText("side length = "+length+""+unit,150, 280);
		ctx.fillText("Regular Polygon", 150,canvasy-5);
		}
		else
		{
		for (var i = 0; i <numsides; i++) 
		{
			regularpoly_x[i]=(radius*Math.cos(2*Math.PI*i/numsides));
			regularpoly_y[i]=(radius*Math.sin(2*Math.PI*i/numsides));
			original2[3*i]=regularpoly_x[i];
			original2[3*i+1]= regularpoly_y[i];
			original2[3*i+2]=10;
		}
		createshape2(original2,unit,250,250,0);
		ctx.fillStyle = "blue";
 		ctx.font = " 14px Arial";
 		ctx.textAlign="center"; 
		ctx.fillText("side length = "+length+""+unit,150,canvasy-20);
		ctx.fillText("Regular Polygon", 150,canvasy-5);
		}
	}
	else if(a=='cube')
	{
		var x = par1*10;
		var y = par2*10;
		var l = par3*10;
		var unit = unit;
		if (par4==0)
		{
		var angle = Math.PI/6;
  		var b = l*Math.sin(angle)*Math.sin(Math.PI/4);
  		var a = l*Math.cos(angle)*Math.sin(Math.PI/4);
  		ctx.beginPath();
  		ctx.moveTo(x,y);
  		ctx.lineTo(x,y+l);
  		ctx.lineTo(x+l,y+l);
  		ctx.lineTo(x+l,y);
  		ctx.lineTo(x,y);
  		ctx.lineTo(x+a,y-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.lineTo(x+l,y);
  		ctx.moveTo(x+l,y+l);
  		ctx.lineTo(x+a+l,y+l-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.stroke();
  		}
  		else
  		{
			var angle = Math.PI/6;
  			var b = l*Math.sin(angle)*Math.sin(Math.PI/4);
  			var a = l*Math.cos(angle)*Math.sin(Math.PI/4);
  			ctx.beginPath();
  			ctx.moveTo(x,y);
  			ctx.lineTo(x,y+l);
  			ctx.lineTo(x+l,y+l);
  			ctx.lineTo(x+l,y);
  			ctx.lineTo(x,y);
  			ctx.lineTo(x+a,y-b);
  			ctx.lineTo(x+a+l,y-b);
  			ctx.lineTo(x+l,y);
  			ctx.moveTo(x+l,y+l);
  			ctx.lineTo(x+a+l,y+l-b);
  			ctx.lineTo(x+a+l,y-b);
  			ctx.stroke();
  			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
			ctx.fillText("length = "+l/10+""+unit,x+l/2,y);
  		}
	}
	else if(a=='cuboid_1')
	{
		var x = par1*10;
		var y = par2*10;
		var l = par3*10;
		var br = par4*10;
		var h = par5*10;
		var angle = Math.PI/6;
  		var b = br*Math.sin(angle)*Math.sin(Math.PI/4);
  		var a = br*Math.cos(angle)*Math.sin(Math.PI/4);
  		ctx.beginPath();
  		ctx.moveTo(x,y);
  		ctx.lineTo(x,y+h);
  		ctx.lineTo(x+l,y+h);
  		ctx.lineTo(x+l,y);
  		ctx.lineTo(x,y);
  		ctx.lineTo(x+a,y-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.lineTo(x+l,y);
  		ctx.moveTo(x+l,y+h);
  		ctx.lineTo(x+a+l,y+h-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.stroke();
	}
	else if(a=='cuboid_2')
	{
		var x = par1*10;
		var y = par2*10;
		var l = par3*10;
		var br = par4*10;
		var h = par5*10;
		var unit = unit;
		var angle = Math.PI/6;
  		var b = br*Math.sin(angle)*Math.sin(Math.PI/4);
  		var a = br*Math.cos(angle)*Math.sin(Math.PI/4);
  		ctx.beginPath();
  		ctx.moveTo(x,y);
  		ctx.lineTo(x,y+h);
  		ctx.lineTo(x+l,y+h);
  		ctx.lineTo(x+l,y);
  		ctx.lineTo(x,y);
  		ctx.lineTo(x+a,y-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.lineTo(x+l,y);
  		ctx.moveTo(x+l,y+h);
  		ctx.lineTo(x+a+l,y+h-b);
  		ctx.lineTo(x+a+l,y-b);
  		ctx.stroke();
  		ctx.font = " 14px Arial";
 		ctx.textAlign="center"; 
		ctx.fillText("length="+l/10+""+unit,x+l/2,y);
		ctx.fillText("height="+h/10+""+unit,x+l,y+h/2);
		ctx.fillText("breadth="+br/10+""+unit,x+l+a,y-b/2);

	}
	else if(a=='cylinder')
	{
		var x = par1*10;
		var y = par2*10;
		var w = par3*5;
		var h = par4*5;
		var unit= unit;
		if(par5==0)
		{
		ctx.beginPath(); //to draw the top circle
  		for (var i = 0 * Math.PI; i < 2 * Math.PI; i += 0.001) 
  		{
   			xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
			yPos = (y + h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    		if (i == 0) 
    		{
      			ctx.moveTo(xPos, yPos);
      		} 
    		else
    		{
      			ctx.lineTo(xPos, yPos);
    		}
  		}

  		ctx.moveTo(x, y + h / 8);
  		ctx.lineTo(x, y + h - h / 8);

  		for (var i = 0 * Math.PI; i < Math.PI; i += 0.001) 
  		{
    		xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
    		yPos = (y + h - h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    		if (i == 0) 
    		{
      			ctx.moveTo(xPos, yPos);
      		} 
    		else 
    		{
      			ctx.lineTo(xPos, yPos);
    		}
  		}
  		ctx.moveTo(x + w, y + h / 8);
  		ctx.lineTo(x + w, y + h - h / 8);            
  		ctx.stroke();
  		}
  		else
  		{
			ctx.beginPath(); //to draw the top circle
  			for (var i = 0 * Math.PI; i < 2 * Math.PI; i += 0.001) 
  			{
   				xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
				yPos = (y + h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    			if (i == 0) 
    			{
      				ctx.moveTo(xPos, yPos);
      			} 
    			else
    			{	
      				ctx.lineTo(xPos, yPos);
    			}
  			}

  			ctx.moveTo(x, y + h / 8);
  			ctx.lineTo(x, y + h - h / 8);
  			ctx.moveTo(x +w/2 , y + h / 8);
  			ctx.lineTo(x+w, y + h / 8);


  			for (var i = 0 * Math.PI; i < Math.PI; i += 0.001) 
  			{
    			xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
    			yPos = (y + h - h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    			if (i == 0) 
    			{
      				ctx.moveTo(xPos, yPos);
      			} 
    			else 
    			{
      				ctx.lineTo(xPos, yPos);
    			}
  			}
  			ctx.moveTo(x + w, y + h / 8);
  			ctx.lineTo(x + w, y + h - h / 8);            
  			ctx.stroke();
  			ctx.fillStyle = "blue";
  			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
			ctx.fillText("radius="+w/5+""+unit,x+3*w/4,y+h/8-3);
			ctx.fillText("height="+h/5+""+unit,x+w,y+h/2);
  		}
	}
	else if (a=='cone')
	{
		var x = par1*10;
		var y = par2*10;
		var w = par3*10;
		var h = par4*10;
		var unit= unit;
		if (par5==0)
		{
			ctx.beginPath(); //to draw the top circle
  			for (var i = 0 * Math.PI; i < 2 * Math.PI; i += 0.001) 
  			{
				xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
				yPos = (y + h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    			if (i == 0) 
    			{
      				ctx.moveTo(xPos, yPos);
      			} 
    			else
    			{
      				ctx.lineTo(xPos, yPos);
    			}
  			}
  			ctx.moveTo(x, y + h / 8);
  			ctx.lineTo(x+w/2, y - h + h / 8);
  			ctx.lineTo(x+w, y + h / 8);    
  			ctx.stroke();
  		}
  		else
  		{
			ctx.beginPath(); //to draw the top circle
  			for (var i = 0 * Math.PI; i < 2 * Math.PI; i += 0.001) 
  			{
				xPos = (x + w / 2) - (w / 2 * Math.sin(i)) * Math.sin(0 * Math.PI) + (w / 2 * Math.cos(i)) * Math.cos(0 * Math.PI);
				yPos = (y + h / 8) + (h / 8 * Math.cos(i)) * Math.sin(0 * Math.PI) + (h / 8 * Math.sin(i)) * Math.cos(0 * Math.PI);

    			if (i == 0) 
    			{
      				ctx.moveTo(xPos, yPos);
      			} 
    			else
    			{
      				ctx.lineTo(xPos, yPos);
    			}
  			}
  			ctx.moveTo(x, y + h / 8);
  			ctx.lineTo(x+w/2, y - h + h / 8);
  			ctx.lineTo(x+w, y + h / 8);
  			ctx.moveTo(x +w/2 , y + h / 8);
  			ctx.lineTo(x+w, y + h / 8);
  			ctx.moveTo(x +w/2 , y + h / 8);
  			ctx.lineTo(x+w/2, y - h + h / 8);   
  			ctx.stroke();
  			ctx.fillStyle = "blue";
  			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
			ctx.fillText("radius="+w/10+""+unit,x+3*w/4,y+h/8-3);
			ctx.fillText("height="+h/10+""+unit,x+w/2,y-h/2);
  		}

	}
	else
	{
		alert("Shape not created.");
	}
}



function createshape2(arr,unit,par1,par2,par3)
{
	var choice = par3;
	var startx = par1;
 	var starty = par2;
 	var currx = startx+arr[0]*10;
 	var curry = starty+arr[1]*10;
 	var unit = unit;
 	if (choice==0)
 	{
 	ctx.beginPath();
	ctx.moveTo(currx,curry);
	// alert("initial  "+Math.floor(currx)+","+Math.floor(curry));
	for(var i =3;i<arr.length;i=i+3)
		{
			var lengthx = arr[i]*10;
			var lengthy = arr[i+1]*10;
			var length5 = arr[i-1];
			ctx.lineTo(startx+lengthx,starty+lengthy);
			// alert("new  "+Math.floor(startx+lengthx)+","+Math.floor(starty+lengthy));
			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
 			if (i!=0)
 			{ 
			// ctx.fillText(""+length5+""+unit, currx+((startx+lengthx)-(currx))/2, curry+((starty+lengthy)-(curry))/2);
			}
			else
			{
				// ctx.fillText(""+length5+""+unit, startx+(currx-startx)/2, curry+((starty+lengthy)-(curry))/2);
			}
			currx = startx+lengthx;
			curry = starty+lengthy;
		}
		var length5 = arr[arr.length-1];
		// ctx.fillText(""+length5+""+unit, (currx+startx+arr[0]*10)/2, (curry+starty+arr[1]*10)/2);
	ctx.closePath();
	ctx.strokeStyle = "black";
	ctx.stroke();
	}
	else
	{
		ctx.beginPath();
	ctx.moveTo(currx,curry);
	// alert("initial  "+Math.floor(currx)+","+Math.floor(curry));
	for(var i =3;i<arr.length;i=i+3)
		{
			var lengthx = arr[i]*10;
			var lengthy = arr[i+1]*10;
			var length5 = arr[i-1];
			// alert("length="+length5);
			ctx.lineTo(startx+lengthx,starty+lengthy);
			// alert("new  "+Math.floor(startx+lengthx)+","+Math.floor(starty+lengthy));
			ctx.fillStyle = "blue";
 			ctx.font = " 14px Arial";
 			ctx.textAlign="center"; 
 			if (i!=0)
 			{ 
			if (length5!=0)
				{
			ctx.fillText(""+length5+""+unit, currx+((startx+lengthx)-(currx))/2, curry+((starty+lengthy)-(curry))/2);
			}
			}
			else
			{
				if (length5!=0)
				{
				ctx.fillText(""+length5+""+unit, startx+(currx-startx)/2, curry+((starty+lengthy)-(curry))/2);
				}
			}
			currx = startx+lengthx;
			curry = starty+lengthy;
		}
		var length5 = arr[arr.length-1];
		if (length5!=0)
				{
		ctx.fillText(""+length5+""+unit, (currx+startx+arr[0]*10)/2, (curry+starty+arr[1]*10)/2);
	}
	ctx.closePath();
	ctx.strokeStyle = "black";
	ctx.stroke();	
	}

}

function createshape3(a,par1,par2,par3,par4,par5,unit,par6,par7,par8)
{
	if (a=='arc_3') 
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5+radius;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		var text1 = par6;
		var text2 = par7;
		var text3 = par8;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,true);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();
		ctx.fillStyle = "blue";
 		ctx.font = " 18px Tahoma";
  		ctx.fillText(""+text1+"", centrex, centrey+12);
  		ctx.fillText(""+text2+"", x1, y1-5);
  		ctx.fillText(""+text3+"", x2+5, y2+5);
 	}
 	else if (a=='arc_4')
 	{
 		var centrex = par1;
		var centrey =par2;
		var radius = par3*5;
		var length = par5;
		var startangle = par4;
		var finishangle = unit;
		var x1= centrex+length*Math.cos(startangle);
		var y1= centrey+length*Math.sin(startangle);
		var x2= centrex+length*Math.cos(finishangle);
		var y2= centrey+length*Math.sin(finishangle);
		var text1 = par6;
		var text2 = par7;
		var text3 = par8;
		// alert("finishangle is "+finishangle);
		// ctx.rotate(40*Math.PI/180);
		ctx.beginPath();
		ctx.arc(centrex,centrey,radius,startangle,finishangle,false);
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x1,y1);
		ctx.stroke();
		ctx.strokeStyle = "black";
		ctx.stroke();
		ctx.beginPath();
		ctx.moveTo(centrex,centrey);
		ctx.lineTo(x2,y2);
		ctx.stroke();
		ctx.fillStyle = "blue";
 		ctx.font = " 18px Tahoma";
  		ctx.fillText(""+text1+"", centrex, centrey+12);
  		ctx.fillText(""+text2+"", x1, y1-5);
  		ctx.fillText(""+text3+"", x2+5, y2+5);
 	}
}
;
(function() {


}).call(this);
function registerAs(id) {
  initProblemOverlay();
  $('#dimmer').attr('onclick', '');
  $('#dimmer').click(function() {
    $('#new_'+id).appendTo('#hidden_registration_forms');
    hideProblem();
  });

  $('#problem_overlay').html('');
  $('#new_'+id).appendTo('#problem_overlay');
}

function registerStudent() {
  registerAs('student');
}

function registerTeacher() {
  registerAs('teacher');
}

function registerCoach() {
  registerAs('coach');
}
;
function walkthrough_pset(){
	not_mobile= !(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));
	$('#walkthrough').pagewalkthrough({
		steps: [
		{
			wrapper: '',
			margin: 0,
			popup:{
				content: '#intro_walk',
				type: 'modal',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}        
		},
		{
			wrapper: '#bigshelf',
			margin: '0',
			popup:
			{
				content: '#shelf_walk',
				type: 'tooltip',
				position: 'bottom',
				offsetHorizontal: 0,
				offsetVertical: -100,
				width: '500',
				draggable: true,
			}     
		},
		{
			wrapper: '.dotted-border',
			margin: '0',
			popup:
			{
				content: '#history_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.problem_list_box',
			margin: '0',
			popup:
			{
				content: '#bbor_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.label-info.correct_hist',
			margin: '0',
			popup:
			{
				content: '#correct_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.label-info.incorrect_hist',
			margin: '0',
			popup:
			{
				content: '#incorrect_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#open-walkthrough',
			margin: '0',
			popup:
			{
				content: '#open_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '',
			margin: '0',
			popup:
			{
				content: '#done_walk',
				type: 'modal',
				position: '',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}             
		},
		],
		name: 'Walkthrough',
		onLoad: not_mobile,
	});
$('.prev-step').live('click', function(e){
	$.pagewalkthrough('prev',e);
});

$('.next-step').live('click', function(e){
	$.pagewalkthrough('next',e);
});
$('#open-walkthrough').live('click', function(){
	var id = $(this).attr('id').split('-');

	if(id == 'parameters') return;

	$.pagewalkthrough('show', id[1]); 
});
$('.close-step').live('click', function(e){
      $.pagewalkthrough('close');
  });
  $('#jpwClose').live('click', function(e){
      $.pagewalkthrough('close');
  });
}
;
function walkthrough_student(){
	not_mobile= !(/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));
	$('#walkthrough').pagewalkthrough({
		steps: [
		{
			wrapper: '',
			margin: 0,
			popup:{
				content: '#intro_walk',
				type: 'modal',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}        
		},
		{
			wrapper: '#bigshelf',
			margin: '0',
			popup:
			{
				content: '#shelf_walk',
				type: 'tooltip',
				position: 'bottom',
				offsetHorizontal: 0,
				offsetVertical: -100,
				width: '500',
				draggable: true,
			}     
		},
		{
			wrapper: '#account',
			margin: '0',
			popup:
			{
				content: '#account_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#points',
			margin: '0',
			popup:
			{
				content: '#points_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#notifications',
			margin: '0',
			popup:
			{
				content: '#notif_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_1',
			margin: '0',
			popup:
			{
				content: '#shape_1_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_2',
			margin: '0',
			popup:
			{
				content: '#shape_2_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_3',
			margin: '0',
			popup:
			{
				content: '#shape_3_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_4',
			margin: '0',
			popup:
			{
				content: '#shape_4_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#get_badge_5',
			margin: '0',
			popup:
			{
				content: '#shape_5_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.dotted-border',
			margin: '0',
			popup:
			{
				content: '#history_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.pset_list_box',
			margin: '0',
			popup:
			{
				content: '#bbor_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '.progress',
			margin: '0',
			popup:
			{
				content: '#pbar_walk',
				type: 'tooltip',
				position: 'right',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '#open-walkthrough',
			margin: '0',
			popup:
			{
				content: '#open_walk',
				type: 'tooltip',
				position: 'left',
				offsetHorizontal: 0,
				offsetVertical: 0,
				draggable: true,
				width: '500'
			}     
		},
		{
			wrapper: '',
			margin: '0',
			popup:
			{
				content: '#done_walk',
				type: 'modal',
				position: '',
				offsetHorizontal: 0,
				offsetVertical: 0,
				width: '400'
			}             
		},
		],
		name: 'Walkthrough',
		onLoad: not_mobile,
	});
$('.prev-step').live('click', function(e){
	$.pagewalkthrough('prev',e);
});

$('.next-step').live('click', function(e){
	$.pagewalkthrough('next',e);
});
$('#open-walkthrough').live('click', function(){
	var id = $(this).attr('id').split('-');

	if(id == 'parameters') return;

	$.pagewalkthrough('show', id[1]); 
});
$('.close-step').live('click', function(e){
      $.pagewalkthrough('close');
  });
}
;
/*! Copyright (c) 2011 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.6
 * 
 * Requires: 1.2.2+
 */


(function($) {

var types = ['DOMMouseScroll', 'mousewheel'];

if ($.event.fixHooks) {
    for ( var i=types.length; i; ) {
        $.event.fixHooks[ types[--i] ] = $.event.mouseHooks;
    }
}

$.event.special.mousewheel = {
    setup: function() {
        if ( this.addEventListener ) {
            for ( var i=types.length; i; ) {
                this.addEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = handler;
        }
    },
    
    teardown: function() {
        if ( this.removeEventListener ) {
            for ( var i=types.length; i; ) {
                this.removeEventListener( types[--i], handler, false );
            }
        } else {
            this.onmousewheel = null;
        }
    }
};

$.fn.extend({
    mousewheel: function(fn) {
        return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel");
    },
    
    unmousewheel: function(fn) {
        return this.unbind("mousewheel", fn);
    }
});


function handler(event) {
    var orgEvent = event || window.event, args = [].slice.call( arguments, 1 ), delta = 0, returnValue = true, deltaX = 0, deltaY = 0;
    event = $.event.fix(orgEvent);
    event.type = "mousewheel";
    
    // Old school scrollwheel delta
    if ( orgEvent.wheelDelta ) { delta = orgEvent.wheelDelta/120; }
    if ( orgEvent.detail     ) { delta = -orgEvent.detail/3; }
    
    // New school multidimensional scroll (touchpads) deltas
    deltaY = delta;
    
    // Gecko
    if ( orgEvent.axis !== undefined && orgEvent.axis === orgEvent.HORIZONTAL_AXIS ) {
        deltaY = 0;
        deltaX = -1*delta;
    }
    
    // Webkit
    if ( orgEvent.wheelDeltaY !== undefined ) { deltaY = orgEvent.wheelDeltaY/120; }
    if ( orgEvent.wheelDeltaX !== undefined ) { deltaX = -1*orgEvent.wheelDeltaX/120; }
    
    // Add event and delta to the front of the arguments
    args.unshift(event, delta, deltaX, deltaY);
    
    return ($.event.dispatch || $.event.handle).apply(this, args);
}

})(jQuery);
/*
 * jScrollPane - v2.0.0beta12 - 2012-09-27
 * http://jscrollpane.kelvinluck.com/
 *
 * Copyright (c) 2010 Kelvin Luck
 * Dual licensed under the MIT or GPL licenses.
 */

(function(b,a,c){b.fn.jScrollPane=function(e){function d(D,O){var ay,Q=this,Y,aj,v,al,T,Z,y,q,az,aE,au,i,I,h,j,aa,U,ap,X,t,A,aq,af,am,G,l,at,ax,x,av,aH,f,L,ai=true,P=true,aG=false,k=false,ao=D.clone(false,false).empty(),ac=b.fn.mwheelIntent?"mwheelIntent.jsp":"mousewheel.jsp";aH=D.css("paddingTop")+" "+D.css("paddingRight")+" "+D.css("paddingBottom")+" "+D.css("paddingLeft");f=(parseInt(D.css("paddingLeft"),10)||0)+(parseInt(D.css("paddingRight"),10)||0);function ar(aQ){var aL,aN,aM,aJ,aI,aP,aO=false,aK=false;ay=aQ;if(Y===c){aI=D.scrollTop();aP=D.scrollLeft();D.css({overflow:"hidden",padding:0});aj=D.innerWidth()+f;v=D.innerHeight();D.width(aj);Y=b('<div class="jspPane" />').css("padding",aH).append(D.children());al=b('<div class="jspContainer" />').css({width:aj+"px",height:v+"px"}).append(Y).appendTo(D)}else{D.css("width","");aO=ay.stickToBottom&&K();aK=ay.stickToRight&&B();aJ=D.innerWidth()+f!=aj||D.outerHeight()!=v;if(aJ){aj=D.innerWidth()+f;v=D.innerHeight();al.css({width:aj+"px",height:v+"px"})}if(!aJ&&L==T&&Y.outerHeight()==Z){D.width(aj);return}L=T;Y.css("width","");D.width(aj);al.find(">.jspVerticalBar,>.jspHorizontalBar").remove().end()}Y.css("overflow","auto");if(aQ.contentWidth){T=aQ.contentWidth}else{T=Y[0].scrollWidth}Z=Y[0].scrollHeight;Y.css("overflow","");y=T/aj;q=Z/v;az=q>1;aE=y>1;if(!(aE||az)){D.removeClass("jspScrollable");Y.css({top:0,width:al.width()-f});n();E();R();w()}else{D.addClass("jspScrollable");aL=ay.maintainPosition&&(I||aa);if(aL){aN=aC();aM=aA()}aF();z();F();if(aL){N(aK?(T-aj):aN,false);M(aO?(Z-v):aM,false)}J();ag();an();if(ay.enableKeyboardNavigation){S()}if(ay.clickOnTrack){p()}C();if(ay.hijackInternalLinks){m()}}if(ay.autoReinitialise&&!av){av=setInterval(function(){ar(ay)},ay.autoReinitialiseDelay)}else{if(!ay.autoReinitialise&&av){clearInterval(av)}}aI&&D.scrollTop(0)&&M(aI,false);aP&&D.scrollLeft(0)&&N(aP,false);D.trigger("jsp-initialised",[aE||az])}function aF(){if(az){al.append(b('<div class="jspVerticalBar" />').append(b('<div class="jspCap jspCapTop" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragTop" />'),b('<div class="jspDragBottom" />'))),b('<div class="jspCap jspCapBottom" />')));U=al.find(">.jspVerticalBar");ap=U.find(">.jspTrack");au=ap.find(">.jspDrag");if(ay.showArrows){aq=b('<a class="jspArrow jspArrowUp" />').bind("mousedown.jsp",aD(0,-1)).bind("click.jsp",aB);af=b('<a class="jspArrow jspArrowDown" />').bind("mousedown.jsp",aD(0,1)).bind("click.jsp",aB);if(ay.arrowScrollOnHover){aq.bind("mouseover.jsp",aD(0,-1,aq));af.bind("mouseover.jsp",aD(0,1,af))}ak(ap,ay.verticalArrowPositions,aq,af)}t=v;al.find(">.jspVerticalBar>.jspCap:visible,>.jspVerticalBar>.jspArrow").each(function(){t-=b(this).outerHeight()});au.hover(function(){au.addClass("jspHover")},function(){au.removeClass("jspHover")}).bind("mousedown.jsp",function(aI){b("html").bind("dragstart.jsp selectstart.jsp",aB);au.addClass("jspActive");var s=aI.pageY-au.position().top;b("html").bind("mousemove.jsp",function(aJ){V(aJ.pageY-s,false)}).bind("mouseup.jsp mouseleave.jsp",aw);return false});o()}}function o(){ap.height(t+"px");I=0;X=ay.verticalGutter+ap.outerWidth();Y.width(aj-X-f);try{if(U.position().left===0){Y.css("margin-left",X+"px")}}catch(s){}}function z(){if(aE){al.append(b('<div class="jspHorizontalBar" />').append(b('<div class="jspCap jspCapLeft" />'),b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragLeft" />'),b('<div class="jspDragRight" />'))),b('<div class="jspCap jspCapRight" />')));am=al.find(">.jspHorizontalBar");G=am.find(">.jspTrack");h=G.find(">.jspDrag");if(ay.showArrows){ax=b('<a class="jspArrow jspArrowLeft" />').bind("mousedown.jsp",aD(-1,0)).bind("click.jsp",aB);x=b('<a class="jspArrow jspArrowRight" />').bind("mousedown.jsp",aD(1,0)).bind("click.jsp",aB);
if(ay.arrowScrollOnHover){ax.bind("mouseover.jsp",aD(-1,0,ax));x.bind("mouseover.jsp",aD(1,0,x))}ak(G,ay.horizontalArrowPositions,ax,x)}h.hover(function(){h.addClass("jspHover")},function(){h.removeClass("jspHover")}).bind("mousedown.jsp",function(aI){b("html").bind("dragstart.jsp selectstart.jsp",aB);h.addClass("jspActive");var s=aI.pageX-h.position().left;b("html").bind("mousemove.jsp",function(aJ){W(aJ.pageX-s,false)}).bind("mouseup.jsp mouseleave.jsp",aw);return false});l=al.innerWidth();ah()}}function ah(){al.find(">.jspHorizontalBar>.jspCap:visible,>.jspHorizontalBar>.jspArrow").each(function(){l-=b(this).outerWidth()});G.width(l+"px");aa=0}function F(){if(aE&&az){var aI=G.outerHeight(),s=ap.outerWidth();t-=aI;b(am).find(">.jspCap:visible,>.jspArrow").each(function(){l+=b(this).outerWidth()});l-=s;v-=s;aj-=aI;G.parent().append(b('<div class="jspCorner" />').css("width",aI+"px"));o();ah()}if(aE){Y.width((al.outerWidth()-f)+"px")}Z=Y.outerHeight();q=Z/v;if(aE){at=Math.ceil(1/y*l);if(at>ay.horizontalDragMaxWidth){at=ay.horizontalDragMaxWidth}else{if(at<ay.horizontalDragMinWidth){at=ay.horizontalDragMinWidth}}h.width(at+"px");j=l-at;ae(aa)}if(az){A=Math.ceil(1/q*t);if(A>ay.verticalDragMaxHeight){A=ay.verticalDragMaxHeight}else{if(A<ay.verticalDragMinHeight){A=ay.verticalDragMinHeight}}au.height(A+"px");i=t-A;ad(I)}}function ak(aJ,aL,aI,s){var aN="before",aK="after",aM;if(aL=="os"){aL=/Mac/.test(navigator.platform)?"after":"split"}if(aL==aN){aK=aL}else{if(aL==aK){aN=aL;aM=aI;aI=s;s=aM}}aJ[aN](aI)[aK](s)}function aD(aI,s,aJ){return function(){H(aI,s,this,aJ);this.blur();return false}}function H(aL,aK,aO,aN){aO=b(aO).addClass("jspActive");var aM,aJ,aI=true,s=function(){if(aL!==0){Q.scrollByX(aL*ay.arrowButtonSpeed)}if(aK!==0){Q.scrollByY(aK*ay.arrowButtonSpeed)}aJ=setTimeout(s,aI?ay.initialDelay:ay.arrowRepeatFreq);aI=false};s();aM=aN?"mouseout.jsp":"mouseup.jsp";aN=aN||b("html");aN.bind(aM,function(){aO.removeClass("jspActive");aJ&&clearTimeout(aJ);aJ=null;aN.unbind(aM)})}function p(){w();if(az){ap.bind("mousedown.jsp",function(aN){if(aN.originalTarget===c||aN.originalTarget==aN.currentTarget){var aL=b(this),aO=aL.offset(),aM=aN.pageY-aO.top-I,aJ,aI=true,s=function(){var aR=aL.offset(),aS=aN.pageY-aR.top-A/2,aP=v*ay.scrollPagePercent,aQ=i*aP/(Z-v);if(aM<0){if(I-aQ>aS){Q.scrollByY(-aP)}else{V(aS)}}else{if(aM>0){if(I+aQ<aS){Q.scrollByY(aP)}else{V(aS)}}else{aK();return}}aJ=setTimeout(s,aI?ay.initialDelay:ay.trackClickRepeatFreq);aI=false},aK=function(){aJ&&clearTimeout(aJ);aJ=null;b(document).unbind("mouseup.jsp",aK)};s();b(document).bind("mouseup.jsp",aK);return false}})}if(aE){G.bind("mousedown.jsp",function(aN){if(aN.originalTarget===c||aN.originalTarget==aN.currentTarget){var aL=b(this),aO=aL.offset(),aM=aN.pageX-aO.left-aa,aJ,aI=true,s=function(){var aR=aL.offset(),aS=aN.pageX-aR.left-at/2,aP=aj*ay.scrollPagePercent,aQ=j*aP/(T-aj);if(aM<0){if(aa-aQ>aS){Q.scrollByX(-aP)}else{W(aS)}}else{if(aM>0){if(aa+aQ<aS){Q.scrollByX(aP)}else{W(aS)}}else{aK();return}}aJ=setTimeout(s,aI?ay.initialDelay:ay.trackClickRepeatFreq);aI=false},aK=function(){aJ&&clearTimeout(aJ);aJ=null;b(document).unbind("mouseup.jsp",aK)};s();b(document).bind("mouseup.jsp",aK);return false}})}}function w(){if(G){G.unbind("mousedown.jsp")}if(ap){ap.unbind("mousedown.jsp")}}function aw(){b("html").unbind("dragstart.jsp selectstart.jsp mousemove.jsp mouseup.jsp mouseleave.jsp");if(au){au.removeClass("jspActive")}if(h){h.removeClass("jspActive")}}function V(s,aI){if(!az){return}if(s<0){s=0}else{if(s>i){s=i}}if(aI===c){aI=ay.animateScroll}if(aI){Q.animate(au,"top",s,ad)}else{au.css("top",s);ad(s)}}function ad(aI){if(aI===c){aI=au.position().top}al.scrollTop(0);I=aI;var aL=I===0,aJ=I==i,aK=aI/i,s=-aK*(Z-v);if(ai!=aL||aG!=aJ){ai=aL;aG=aJ;D.trigger("jsp-arrow-change",[ai,aG,P,k])}u(aL,aJ);Y.css("top",s);D.trigger("jsp-scroll-y",[-s,aL,aJ]).trigger("scroll")}function W(aI,s){if(!aE){return}if(aI<0){aI=0}else{if(aI>j){aI=j}}if(s===c){s=ay.animateScroll}if(s){Q.animate(h,"left",aI,ae)
}else{h.css("left",aI);ae(aI)}}function ae(aI){if(aI===c){aI=h.position().left}al.scrollTop(0);aa=aI;var aL=aa===0,aK=aa==j,aJ=aI/j,s=-aJ*(T-aj);if(P!=aL||k!=aK){P=aL;k=aK;D.trigger("jsp-arrow-change",[ai,aG,P,k])}r(aL,aK);Y.css("left",s);D.trigger("jsp-scroll-x",[-s,aL,aK]).trigger("scroll")}function u(aI,s){if(ay.showArrows){aq[aI?"addClass":"removeClass"]("jspDisabled");af[s?"addClass":"removeClass"]("jspDisabled")}}function r(aI,s){if(ay.showArrows){ax[aI?"addClass":"removeClass"]("jspDisabled");x[s?"addClass":"removeClass"]("jspDisabled")}}function M(s,aI){var aJ=s/(Z-v);V(aJ*i,aI)}function N(aI,s){var aJ=aI/(T-aj);W(aJ*j,s)}function ab(aV,aQ,aJ){var aN,aK,aL,s=0,aU=0,aI,aP,aO,aS,aR,aT;try{aN=b(aV)}catch(aM){return}aK=aN.outerHeight();aL=aN.outerWidth();al.scrollTop(0);al.scrollLeft(0);while(!aN.is(".jspPane")){s+=aN.position().top;aU+=aN.position().left;aN=aN.offsetParent();if(/^body|html$/i.test(aN[0].nodeName)){return}}aI=aA();aO=aI+v;if(s<aI||aQ){aR=s-ay.verticalGutter}else{if(s+aK>aO){aR=s-v+aK+ay.verticalGutter}}if(aR){M(aR,aJ)}aP=aC();aS=aP+aj;if(aU<aP||aQ){aT=aU-ay.horizontalGutter}else{if(aU+aL>aS){aT=aU-aj+aL+ay.horizontalGutter}}if(aT){N(aT,aJ)}}function aC(){return -Y.position().left}function aA(){return -Y.position().top}function K(){var s=Z-v;return(s>20)&&(s-aA()<10)}function B(){var s=T-aj;return(s>20)&&(s-aC()<10)}function ag(){al.unbind(ac).bind(ac,function(aL,aM,aK,aI){var aJ=aa,s=I;Q.scrollBy(aK*ay.mouseWheelSpeed,-aI*ay.mouseWheelSpeed,false);return aJ==aa&&s==I})}function n(){al.unbind(ac)}function aB(){return false}function J(){Y.find(":input,a").unbind("focus.jsp").bind("focus.jsp",function(s){ab(s.target,false)})}function E(){Y.find(":input,a").unbind("focus.jsp")}function S(){var s,aI,aK=[];aE&&aK.push(am[0]);az&&aK.push(U[0]);Y.focus(function(){D.focus()});D.attr("tabindex",0).unbind("keydown.jsp keypress.jsp").bind("keydown.jsp",function(aN){if(aN.target!==this&&!(aK.length&&b(aN.target).closest(aK).length)){return}var aM=aa,aL=I;switch(aN.keyCode){case 40:case 38:case 34:case 32:case 33:case 39:case 37:s=aN.keyCode;aJ();break;case 35:M(Z-v);s=null;break;case 36:M(0);s=null;break}aI=aN.keyCode==s&&aM!=aa||aL!=I;return !aI}).bind("keypress.jsp",function(aL){if(aL.keyCode==s){aJ()}return !aI});if(ay.hideFocus){D.css("outline","none");if("hideFocus" in al[0]){D.attr("hideFocus",true)}}else{D.css("outline","");if("hideFocus" in al[0]){D.attr("hideFocus",false)}}function aJ(){var aM=aa,aL=I;switch(s){case 40:Q.scrollByY(ay.keyboardSpeed,false);break;case 38:Q.scrollByY(-ay.keyboardSpeed,false);break;case 34:case 32:Q.scrollByY(v*ay.scrollPagePercent,false);break;case 33:Q.scrollByY(-v*ay.scrollPagePercent,false);break;case 39:Q.scrollByX(ay.keyboardSpeed,false);break;case 37:Q.scrollByX(-ay.keyboardSpeed,false);break}aI=aM!=aa||aL!=I;return aI}}function R(){D.attr("tabindex","-1").removeAttr("tabindex").unbind("keydown.jsp keypress.jsp")}function C(){if(location.hash&&location.hash.length>1){var aK,aI,aJ=escape(location.hash.substr(1));try{aK=b("#"+aJ+', a[name="'+aJ+'"]')}catch(s){return}if(aK.length&&Y.find(aJ)){if(al.scrollTop()===0){aI=setInterval(function(){if(al.scrollTop()>0){ab(aK,true);b(document).scrollTop(al.position().top);clearInterval(aI)}},50)}else{ab(aK,true);b(document).scrollTop(al.position().top)}}}}function m(){if(b(document.body).data("jspHijack")){return}b(document.body).data("jspHijack",true);b(document.body).delegate("a[href*=#]","click",function(s){var aI=this.href.substr(0,this.href.indexOf("#")),aK=location.href,aO,aP,aJ,aM,aL,aN;if(location.href.indexOf("#")!==-1){aK=location.href.substr(0,location.href.indexOf("#"))}if(aI!==aK){return}aO=escape(this.href.substr(this.href.indexOf("#")+1));aP;try{aP=b("#"+aO+', a[name="'+aO+'"]')}catch(aQ){return}if(!aP.length){return}aJ=aP.closest(".jspScrollable");aM=aJ.data("jsp");aM.scrollToElement(aP,true);if(aJ[0].scrollIntoView){aL=b(a).scrollTop();aN=aP.offset().top;if(aN<aL||aN>aL+b(a).height()){aJ[0].scrollIntoView()}}s.preventDefault()
})}function an(){var aJ,aI,aL,aK,aM,s=false;al.unbind("touchstart.jsp touchmove.jsp touchend.jsp click.jsp-touchclick").bind("touchstart.jsp",function(aN){var aO=aN.originalEvent.touches[0];aJ=aC();aI=aA();aL=aO.pageX;aK=aO.pageY;aM=false;s=true}).bind("touchmove.jsp",function(aQ){if(!s){return}var aP=aQ.originalEvent.touches[0],aO=aa,aN=I;Q.scrollTo(aJ+aL-aP.pageX,aI+aK-aP.pageY);aM=aM||Math.abs(aL-aP.pageX)>5||Math.abs(aK-aP.pageY)>5;return aO==aa&&aN==I}).bind("touchend.jsp",function(aN){s=false}).bind("click.jsp-touchclick",function(aN){if(aM){aM=false;return false}})}function g(){var s=aA(),aI=aC();D.removeClass("jspScrollable").unbind(".jsp");D.replaceWith(ao.append(Y.children()));ao.scrollTop(s);ao.scrollLeft(aI);if(av){clearInterval(av)}}b.extend(Q,{reinitialise:function(aI){aI=b.extend({},ay,aI);ar(aI)},scrollToElement:function(aJ,aI,s){ab(aJ,aI,s)},scrollTo:function(aJ,s,aI){N(aJ,aI);M(s,aI)},scrollToX:function(aI,s){N(aI,s)},scrollToY:function(s,aI){M(s,aI)},scrollToPercentX:function(aI,s){N(aI*(T-aj),s)},scrollToPercentY:function(aI,s){M(aI*(Z-v),s)},scrollBy:function(aI,s,aJ){Q.scrollByX(aI,aJ);Q.scrollByY(s,aJ)},scrollByX:function(s,aJ){var aI=aC()+Math[s<0?"floor":"ceil"](s),aK=aI/(T-aj);W(aK*j,aJ)},scrollByY:function(s,aJ){var aI=aA()+Math[s<0?"floor":"ceil"](s),aK=aI/(Z-v);V(aK*i,aJ)},positionDragX:function(s,aI){W(s,aI)},positionDragY:function(aI,s){V(aI,s)},animate:function(aI,aL,s,aK){var aJ={};aJ[aL]=s;aI.animate(aJ,{duration:ay.animateDuration,easing:ay.animateEase,queue:false,step:aK})},getContentPositionX:function(){return aC()},getContentPositionY:function(){return aA()},getContentWidth:function(){return T},getContentHeight:function(){return Z},getPercentScrolledX:function(){return aC()/(T-aj)},getPercentScrolledY:function(){return aA()/(Z-v)},getIsScrollableH:function(){return aE},getIsScrollableV:function(){return az},getContentPane:function(){return Y},scrollToBottom:function(s){V(i,s)},hijackInternalLinks:b.noop,destroy:function(){g()}});ar(O)}e=b.extend({},b.fn.jScrollPane.defaults,e);b.each(["mouseWheelSpeed","arrowButtonSpeed","trackClickSpeed","keyboardSpeed"],function(){e[this]=e[this]||e.speed});return this.each(function(){var f=b(this),g=f.data("jsp");if(g){g.reinitialise(e)}else{b("script",f).filter('[type="text/javascript"],:not([type])').remove();g=new d(f,e);f.data("jsp",g)}})};b.fn.jScrollPane.defaults={showArrows:false,maintainPosition:true,stickToBottom:false,stickToRight:false,clickOnTrack:true,autoReinitialise:false,autoReinitialiseDelay:500,verticalDragMinHeight:0,verticalDragMaxHeight:99999,horizontalDragMinWidth:0,horizontalDragMaxWidth:99999,contentWidth:c,animateScroll:false,animateDuration:300,animateEase:"linear",hijackInternalLinks:false,verticalGutter:4,horizontalGutter:4,mouseWheelSpeed:0,arrowButtonSpeed:0,arrowRepeatFreq:50,arrowScrollOnHover:false,trackClickSpeed:0,trackClickRepeatFreq:70,verticalArrowPositions:"split",horizontalArrowPositions:"split",enableKeyboardNavigation:true,hideFocus:false,keyboardSpeed:0,initialDelay:300,speed:30,scrollPagePercent:0.8}})(jQuery,this);
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//









$(function() {
  $('.with_tooltip').tooltip();
});
