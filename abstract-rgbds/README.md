# abstract-rgbds

This is an [RGBDS](https://github.com/gbdev/rgbds) macro library which provides the ability to use different Interfaces within assembly source code.

Macro calls within each Interface may behave differently than they would outside of that Interface, or within a different Interface.

Interfaces can be nested, and if a macro is not defined within a certain Interface, it will traverse up the Interface stack until a definition is found.

This allows for the implementation of complicated functionality with simple syntax.  

This library currently comes with 4 pre-defined `Context`s, each with a multitude of Interfaces.  It also possible to define additional ones of each.

These Interfaces can then be used to create object-like Instances for a cleaner and more cohesive codebase


## Examples

It is somewhat difficult to explain the concepts here (and, it is currently incomplete).  For examples, take a look at how it is implemented in [Pokemon TRE2](https://github.com/Pokeglitch/poketre2/tree/master/macros/Pokemon)


## Warning
This library uses a lot of nested macro calls, which will lengthen build time a bit. It might also be necessary to increase the recursive depth limit if it keeps are catching false infinite-loop errors when building.  This is done be using the `-r` argument for `rgbasm`

# How to use

[RGBDS](https://github.com/gbdev/rgbds) version: **0.6.1**

Place this library in the base directory of the source code in a folder titled *abstract-rgbds* and import it at the start of the main .asm file:

```
include "abstract-rgbds/main.asm"
```

# Structure

To simplify what is explained above, this library has a particular heirarchy of definitions:
  * **Context**: used to build Interfaces
    * **Interface**: defines methods and properties for an Instance of this interface
      * **Instance** An Instance is created when an Interface is opened until it is closed
# Reference


## Base
This library comes with some base macro that are utilized elsewhere in the library.  However, some are generic enough that they can be used elsewhere in the source




## Context

A Context is used to build an Interface.

Its where the magic happens, by defining the abstraction between an Interface and the source code.  Every interaction with an Interface will be filtered through this Context to produce the intended behavior.

Defining a Context in its own is the lowest level of abstraction between this library's API and the underlying core of how this library operates.  It will be challenging to successfully create a new Context without knowing what is happening behind the scenes.

This section can be skipped if the goal it to simply utilize the pre-defined Interfaces

### **Definition**
A Context is defined as follows:
```
Context <ContextName>
    ...
    <parameters>
    ...
end
```

### **Parameters**
Each Context has 7 different macro which can be assigned to it.  Each one is optional

The macros are the following:
  * `new`
    * Executed at the very start of defining a new Interface of this Context
  * `finish`
    * Executed at the very end of the definition of a new Interface of this Context
  * `open`
    * Executed at the very start of opening an Interface instance of this Context
  * `method`
    * Handles the assignment of a method for an Interface instance of this Context
  * `property`
    * Handles the assignment of a property for an Interface instance of this Context
  * `handle`
    * Handles what arguments get relayed to a method call of an Interface instance of this Context
  * `close`
    * Executed at the very end of closing an Interface instance of this Context

To define these macros, simply place the name of the macro on the line, and then continue as as if a normal macro.  Do NOT prefix with `macro`
```
<name>
   ...
endm
```

Each of these macros receive various arguments.  Check the source code to identify them

## Interface
After defining a Context, an Interface can be defined utilizing that Context.  An Interface contains particular properties and methods which are accessible from within an Instance of that Interface.

Each time an Interface is opened, a unique Instance is created, and the properties and methods are linked to that particular Instance.

The exact manner how they are linked and accessed varies from Context to Context.

Interfaces can, optionally, inherit these properties and methods from another Interface.
### **Definition**
An Interface is defined as follows:
```
<ContextName> <InterfaceName>*(, <super-Interfacename>)*
    ...
    <parameters>
    ...
end
```

If a super Interface is provided, the Interface will inherit all properties and methods from that Interface

The new Interface can override these properties and methods.  When override a method, the method of the super Interface can be accessed by called `super`

`super` will always refer to the method within a super Interface of the same name as the method from which it was called

### **Parameters**

Each Interface has 4 different parameters which can be used to define attributes to an Instance of this Interface

These parameters are:
  * `property` - To attach a property to the Instance
  * `method` - To attach a method to the Instance
  * `from` - To assign a callback method for returning to Instance from a particular Interface
  * `forward` - To permit methods to be passed through to the next level of the Interface stack

Each Instance of an Interface is also automatically assigned the following properties:
  * `Name` - The name of the Instance
  * `Isolate` - Whether or not methods higher up the Interface stack are accessible
    * Default: `true`

The standard is to assign properties to an instance is with `#`, and to assign macros to an instance with `@`

While not mandatory, the standard for all pre-defined Contexts is to automatically adds the reference to the Instance self as the first argument to all method calls. (Same as how Python handles Classes).

Therefore, the following is an example of setting an Interface as Isolated from within an Interface method:
```
    def \1#Isolate = false
```

---
### **property**

The syntax to define a property is:
```
    property <InitializationMacro>, <PropertyName>(, <InitialValue(s)>+)
```

To define a `property`, a specific macro must exist which takes the name as the first argument, and any additional arguments that the macro accepts

When an Instance of this Interface is created, the property will be assigned to that 

While again, not mandatory, <InitializationMacro> usually will refer to a **Type** Interface.

---
### **method**
The typical syntax to define a method is:
```
    method <MethodName(s)>+
      args <ArgumentName(s)>*
        ...
    endm
```
The method `init` will be auto executed when a new Instance of this Interface is opened.  The method `exit` will be auto execture when the Instace closes

A `method` can have multiple names assigned to it, but at least 1 is required.  This is typically only necessary if it inherits from another Interface, or will be Inherited by another Interface to create unique `super` scenarios. 

Using `super` from a child Interface will call this method if the name of the method it was called from matches any of the names assigned to this method.

Likewise, calling `super` from within this method will refer to the super Interface method with whatever name this method was accessed by.

The `args` line is required, though the arguments names are optional. Each named argument will have its value assigned to the corresponding argument by index.  Empty argument names will be skipped.  For example:
```
    method myMethod
      args self, name, , age
        ...
    endm
```
In this example, self = `"\1"`, name = `"\2"`, and age = `"\4"`

If the argument is not provided, the name will not be defined

The number of named arguments can be accessed via `_nname`. This is useful to, for example, shift away named args and forward the remaining ones to another method.

In additional to the above syntax for methods, there is also the one line syntax to create a lambda method.

```
    method <MethodName(s)>+, "<StringExpression>"
```
A lambda method will be executed within the context is it called from, just as normal String Expression expansion is peformed.

That means it will not be able to access the instance it is attached to, nor will it be able to called `super`.

Attempting to do either will refer to the corresponding values of which this method is called (again, just as typical String Expressions do)

Try to avoid using `pushs` or `pops` from within a lambda, since that might interfere with the underlying expectations of this library.

---
### **from**

A `from` method is a callback which is executed when an Interface becomes the active interface due to the closing of the given Interface(s)

The syntax is essentially the same as methods
```
    from <InterfaceName(s)>+
      args <ArgumentName(s)>*
        ...
    endm
```

More than one Interface name can be provided.

The named arguments are optional, though only two arguments will be supplied to this method.  The first being this Instance, and the second being the Instance that just close which triggered this callback.

It can also be a lambda method:
```
    from <InterfaceName(s)>+, "<StringExpression>"
```

This is particularly useful to auto exit a given Interface when a specific Interface also exits:

```
    from childInterface, "end"
```

---
### **forward**

Forward is only neessary in Interfaces that are Isolated. This will permit the given methods to passthrough the isolation and get handled by an Interface higher up the stack.

The syntax is simply:
```
    forward <MethodName(s)>+
```

# Contexts

There are 4 different Contexts provided with this library:
  * `Type` - Defines various common data types with associated attributes for quantifying and manipulating it
  * `Struct` - Defines complex data types where attributes are assigned programatically
  * `Scope` - Defines a layer to manage specific scenarios within the code
  * `Class` - A combination of the above three
## Type

`Type` creates an object that represents common data types.  The pre-defined ones are:

  * `Bool`
  * `Number`
  * `String`
  * `List`
  * `Enum`
  * `Stack`

### **Usage**
Create a new Instance of a `Type` Interface via:
```
<TypeName> <InstanceName>(, <Arguments>*)
```
This will assign a new Instance of the given `Type` Interface to the given name.  Additional arguments can be included if the `Type` Interface accepts any. 

The Instance, and all of its members, can then be accessed through the given name.

Each `Type` has their own specific properties and methods.  For the time being, please consult the source code or examples to identify them.

**Note:** The `Type` Interface is only "open" temporarily while it assigns attributes to the Instance, and then "closes" automatically.  There is no need to call `end` to close it.


## Struct
`Stuct` created an object whose attributes are assigned programatically, making each Instance of a particular `Struct` Interface unique.  The current predefined Interfaces are:

  * `ByteStruct`

### **Usage**
Create new Instance of a `Struct` Interface via:
```
<StructName> <InstanceName>
    ...
    <parameters>
    ...
end
```
This will assign a new Instance of the given `Struct` Interface to the given name.  The Instance, and all of it's properties, can then be accessed via the given name.

Each `Struct` Interface has its own set of valid parameters.  For the time being, please consult the source code or examples to identify them.

## Scope
Unlike the above, a `Scope` will create a new object, but rather a layer of Context to handle specific scenarios.  This means it will not interrupt the source code behavior while the Interface is open. The current predefined Interfaces are:

  * `Overload` - Used in `Struct` to assign multiple properties to the same Struct position
  * `Return` - Used in `var` and `vars` to return a value from one macro to another

### **Usage**
Open a `Scope` Interface via:
```
<ScopeName> (<Arguments>,*)
```

This will 'open' the Interface context, but does not assign anything to a particular name.  While this Interface is open, the source code syntax does not change from what it was previously, except for whatever new methods are accessible via this new `Scope` Interface.

Each `Scope` Interface has its own set of methods that it introduces to the source code.  After the Interface is closed, those methods will no longer be accessible.

Close a `Scope` Interface with:
```
end
```

Each `Scope` has their own specific properties and methods.  For the time being, please consult the source code or examples to identify them.

## Class
A `Class` is basically an amalgamation of the above three `Context`s.  It will create a new Instance, whose members can be accessed via the name of that object.  Members can be defined programatically, while the `Class` Interface is open.  It also does not disrupt the behavior of the source code, except for introducing additional methods to the workspace.  These methods are the same as the ones assigned as members to the Instance name.

It is best used to simultaneously store a particular value to a variable and to store that same value to the ROM.

### **Usage**
Open a `Class` Interface via:
```
<ClassName> <InterfaceName>(, <Arguments>*)
```

This will assign a new Instance of the `Class` Interface to the given name. All properties and methods defined in this Interface are accessibe via that name.

It will also a new lexical layer and introduce those same methods to workspace (without need to access via the given name)

Close a `Class` Interface with:
```
end
```

Each `Class` has their own specific properties and methods.  For the time being, please consult the source code or examples to identify them.


# Future Work

## General
  * More explanation about predefined Interfaces

## Interfaces
  * Introduce properties to the workspace while an Interface is open, just as methods are

## Registers
  * 8 bit, 16 bit, RAM, etc
  * #RegisterSize = 8/16
  * @ld/load, etc

## Bit/Flag Register:
  * Attached to Registers via index [0-7/15]
  * Can be given names (i.e.: wEventX)
