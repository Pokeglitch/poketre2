# rgbds-contexts

This is an RGBDS macro library which provides the ability to use different Contexts within your code.

Macro calls within a certain Context behaves differently than they would outside of that Context, or within a different Context.

This allows you to implement complicated functionality with intuitive syntax.  

This library currently comes with 4 pre-defined Contexts, but you are also able to define your own.

You can then use these Contexts to create object-like instances for a cleaner and more cohesive codebase

**NOTE:**
This library uses a lot of nested macro calls.  This will increase build time a bit. You might also need to increase the recursive depth limit if you are catching false infinite-loop errors.

# How to use

Make sure you are using RGBDS version: **0.6.1**

Place this library in the base directory of your source code in a folder titled *rgbds-contexts* and import it at the start of your main .asm file by typing:

```
include "rgbds-contexts/main.asm"
```

# Reference

## Base
This library comes with some base macro that are utilized elsewhere in the library.  However, you can also use them as you see fit

## Context

The Context macro allows you to 