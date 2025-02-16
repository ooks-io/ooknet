+++
title = "Primitive Data Types"
template = "notebook/note.html"
+++

## References:

- https://nix.dev/manual/nix/2.18/language/values#list
- https://nix.dev/tutorials/nix-language

## Strings

[[strings|Single line strings]] are enclosed in quotes `" ... "`:

```nix
value = "string"
```

or multi-line with `'' ... ''`:

```nix
value = '' multi
line
string
''
```

## Numbers

**numbers|Integers**:

```nix
value = 1
```

**numbers|floating point numbers**:

```nix
value = 1.5
```

## Null

```nix
value = null
```

## Paths

**paths#Absolute paths|Absolute paths**:

```nix
value = /path/to
```

**paths#Relative Paths|Relative Paths**:

```nix
value = ./path
```

> [!warning] Paths in Nix cannot include trailing slashes `/`

```nix warn:1
value = ./path/
# result: error: path has a trailing slash
```

## Boolean

```nix
value = true # or false
```
