+++
title = "Name-value Pairs"
template = "notebook/note.html"
+++

## References:

- https://nix.dev/tutorials/nix-language

## Overview

In [[Nix]], [[key-value-pair|key-value-pairs]] go by _name-value-pairs_.

## Structure

- **Key**: The key in [[Nix]] doesn't have to be a string.
- **Separator**: Values are assigned to a value with an equal sign (`=`).
- **Value**: Values can be any [[primitive-data-types|primitive data types]],
  [[functions]], or [[attribute-sets|attribute sets]], or [[lists]].
- **Delimiter**: name-value-pairs in a set are delimited by a semicolon (`;`)

_example structure_

```nix
{name}{separator}{value}{delimier}

name = "value";
```

```nix
{
  a = "string";
  b = 20;
  c = true;
  d = ./path/to;
  e = ["list" 10 true];
  f = {
    name = "value";
    attribute = true;
  };
}
```

## Assigning names to values

Names can be assigned to values in a number of ways:

- [[attribute-sets|Attribute sets]] `{ ... }`
- [[let-bindings|Let bindings]] `let ... in`
- [[functions|Functions]] `:`

# [[primitive-data-types|Next: Primitive data types]]
