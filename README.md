# Boolean Language Compiler

## Build
The build phase is described in the `build.sh` file.

The result of the build is put int the `dist` folder.

### BoolLang Features

The compiler will make the lexical, syntactic and semantic analysis over an hypothetical programming language used for computing boolean operations.

The language supports the following features:

* Variables
* Scoping
* Operators' precendence (c-like)
* Comments
* Smart printing

### Examples

1. *Simple boolean operation.*
```typescript
    true&&false; // result is false
```

2. *More complex operation.*
```typescript
    (true&&!false)^(false||true); // result is false
```

3. *Variables*
```typescript
    let a = true;
    let b = true;
    let c = a&&b; 
    c; // result is true
```

4. *Scoping*
```typescript
    let a = true;
    let b = true;
    {
        let a = false;
        a&&b; // result is false;
    }
    a&&b; // result is true;
    
    /* Scoping can be nested */
    {
        {
            let night = true;
        }
        
        {
            let morning = false;
        }
    }
```

5. *Printing*
```typescript
    /* 
        First parameter is the color: red, blue or green.
        Second parameter is the message itself.
        Third parameter an operation.
    */

    yell( "I'm a simple yell." );
    yell( "blue", "I'm a colored yell." );
    yell( "I'm a yell with parameter.", false );
    yell( "green", "I'm a colored yell with parameter.", true&&false );
```

## Info
Project for the Formal Languages and Compilers exam / UNIBZ / 2016-2017


Name	| Github	| 
------------- | ------------------------- 
Kiani Mehtab	| <https://github.com/Mehtabk>
Micheloni Fabrizio	| <https://github.com/fmicheloni>	
Vettoretti Francesco	| <https://github.com/FraTheVet>
