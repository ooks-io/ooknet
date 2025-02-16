+++
title = "Syntax"
template = "notebook/chapter.html"
+++

## Resources

---

- [redhat documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/security_guide/chap-system_auditing)
- [arch-wiki](https://wiki.archlinux.org/title/Audit_framework)
- [linux-audit 101](https://linux-audit.com/linux-audit-framework-101-basic-rules-for-configuration/)
- [linux-audit configuration](https://linux-audit.com/configuring-and-auditing-linux-systems-with-audit-daemon)
- [man page](https://linux.die.net/man/7/audit.rules)

## Overview

---

The linux audit framework is a collection of tools used to log events the
administrator deems important; typically used to collect security-relevant
information. It is not a form of protection against attacks, but simply a means
of logging information to analyze after the fact.

Linux audit framework can be used in larger security pipelines, feeding
information to scripts and dashboards to catch any potential weaknesses in a
systems security.

It does this by listening to events reported by the kernel and logging them in a
file.

> [!tip]\
> The log file is typically found here: `/var/log/auditd.log`.

Linux audit framework is broken down into a few parts:

1. **Audit kernel module** - included in _most_ linux kernels (some custom
   kernels may require additional steps to include).
2. **Auditd** - A configurable daemon responsible for writing messages to the
   log file. Configuration is done in the `/etc/audit/auditd.conf` file.
3. **Command-line tools** - various command line tools to interface with the
   audit system. examples:
   - `auditctl`: Interacting with the daemons configuration on the fly.
   - `ausearch`: Searching for specific events.
   - `aureport`: Generating reports.
   - `autrace`: Tracing processes.
   - There are many more tools that can be used to interact with the audit
     system.
4. **Audit rules** - A collection of `auditctl` command that are run at system
   boot time. Configured in the file: `/etc/audit/audit.rules`.

## Installation

---

Although the kernel module is likely included with your distribution; you may
need to install the relevant packages to interface with it. For this example I
will be showing how to enable the linux audit system on NixOS.

`nixpkgs` includes a module that be used to enable the linux audit system:

```nix
# configuration.nix

{
  security.audit = {
    enable = true;
  };
}
```

You will also want to enable the audit daemon:

```nix
# configuration.nix

{
  security = {
    audit = {
      enable = true;
    };
    auditd.enable = true;
  };
}
```

Sources for these modules:

- [nixpkgs/audit.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/audit.nix)
- [nixpkgs/auditd.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/security/auditd.nix)

> [!info]\
> Use the kernel parameter `audit=1` to allow the audit system to audit
> processes that are run before the audit daemon starts.
>
> This is set by default if you enable the NixOS module.

## Configuration

---

The `auditctl` command can be used to set and retrieve configuration settings,
changes made this way are ephemeral and will removed when the system restarts.

For permanent changes, configuration is done in the `/etc/audit/auditd.conf`
file. Configuration options are structured as such:

`{conf}keyword=value`

Example configuration option:

```conf
# /etc/audit/auditd.conf

# set the log file location
log_file=/var/log/auditd.log
```

In most cases you can leave the default configuration.

For a list of all available configuration options, refer to the
[auditd.conf(5) man page](https://linux.die.net/man/5/auditd.conf).

## Rules

---

> [!warning]\
> The output from the audit system can be _very_ verbose; filling up the log
> file very quickly. Make sure to test all rules before deployment.

The `auditctl` command can also be used for setting rules; these rules are
definitions for what events we want to log & configuration for the kernel module
itself. Configuring the audit system with the `auditctl` command is typically
used for ad hoc changes, as these modifications are not automatically saved to a
permanent configuration file. Changes made with `auditctl` are only active for
the current session and will be lost upon system restart.\
For persistent rules, we use the `/etc/audit/audit.rules` file or files in the
`/etc/audit/rules.d/` directory.

Rules in auditd are broken up into 3 varieties:

- [Control](#control)
- [File System](#file-system)
- [System Calls](#system-calls)

### Control

---

These are commands that are used to configure the audit system (kernel module)
directly.

For a full list of control rules see
[auditctl(8) man page](https://linux.die.net/man/8/auditctl).

Some available _persistent_ options:

#### Failure mode

---

`-f`:\
This is used for defining what _action_ to take when the a _critical error
(failure mode)_ is detected. the available options are:

- `0` - silent.
- `1` - printk (print a failure message).
- `2` - panic (halt the system).\
  Example: `-f 1` print message when a critical error occurs.

#### Buffer Size

---

`-b`:\
Set the maximum number of audit system buffers in the kernel.\
Example: `-b 8192` Sets the maximum number of buffers to 8192, exceeding this
number will trigger a _critical error_.

#### Enable flag

---

`-e`:\
Set the enable flag. Available options:

- `0` - Disables auditing.
- `1` - Enables Auditing.
- `2` - Locks the configuration file preventing any further changes.\
  Example: `-e 2` Enables the auditing and locks the configuration file.

#### Rate

---

`-r`:\
Set the message/sec limit, if set to `0`, disable rate limiting. If the rate is
exceeded a _critical error_ will be triggered.\
Example: `-r 60` sets the rate limit to 60 messages/sec.

#### Delete

---

`-D`:\
Deletes all rules and watches.

### File System

---

Otherwise known as watches, the `-w` flag can be used to audit access to files
and directories.

Example: `-w path/to/file -p permissions -k keyname`

#### Paths

---

Paths can either be a file or a directory. If a directory is defined, then the
rule is used recursively down the directory tree excluding any directories that
may be mount points. Keep this in mind as auditing a large tree may be resource
intensive. Limiting the scope of your rules is key to optimizing performance.

#### Permissions

---

The `-p` option is for defining what permissions access type will trigger on.
Available permissions:

- `r` - read of the file
- `w` - write to the file
- `x` - execute the file
- `a` - change in the file's attribute

These options can be combined e.g: `-p rw` or `-p rwa`.

#### Key

---

The `-k` option is used to set a string as an identifier (key) for the rule.
This string is limited to 31 bytes long.

Typically used to group related rules to then be searched for with `ausearch`.

#### Example

---

```rules
# /etc/audit/auditd.rules

-w /etc/localtime -p wa -k system_changes

-w /etc/passwd -p x -k password_changes
-w /usr/bin/passwd -p x -k password_changes
```

In this example we set a few rules:

- `-w /etc/localtime -p wa -k system_changes` here we define a rule that tracks
  when the `localtime` file is either written to (`w`), or had an attribute
  changed (`a`). We then assign it the `system_changes` key as a unique
  identifier.
- `-w /etc/passwd -p x -k password_changes` &
  `-w /usr/bin/passwd -p x -k password_changes` here we are tracking when either
  of these files are executed (`x`), and assigning them both the
  `password_changes` key.

### System Calls

---

System call rules are for tracking kernel syscalls. It does this by loading
rules into a matching engine that checks every syscall that all programs make on
a system.

Example structure:

`-a action,list -S syscall -F field=value -k keyname`
