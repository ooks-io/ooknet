{ lib, config, ... }:

let
  inherit (lib) optionals mkForce concatLists;
  inherit (builtins) elem;
  features = config.systemModules.host.hardware.features;
in

{
  security = {
    # Protects the kernel from being tampered with at runtime. prevents the ability to hibernate.
    protectKernelImage = true; 

    # page table isolation (PTI) is a kernel option designed to protect against
    # side-channel attacks, including Meltdown & Spectre vunerabilities.  
    forcePageTableIsolation = true;

    # locking kernel modules during runtime breaks certain services by stopping them from being
    # loaded at runtime. we use some of these services, so we disable this kernel option.
    lockKernelModules = false;

    # we enable simultaneous multithreading (SMT) because while it increases our attack surface
    # disabling it comes at a large perfomance loss.
    allowSimultaneousMultithreading = true;

    # slight increase in attack surface, but allows for sandboxing
    allowUserNamespaces = true;

    # we don't need unpivileged user namespaces unless we are messing with containers so we disable
    unprivilegedUsernsClone = false;
  };

  boot = {
    kernel = {
      sysctl = {
        # obfuscate kernel pointers to protect against attacks that rely on memory layout of the kernel
        "kernel.kptr_restrict" = 2;

        # we don't make use of sysrq so we disable it to protect ourselves against potential physical attacks
        "kernel.sysrq" = mkForce 0;

        # limits the exposer of the kernel memory address via dmesg
        "kernel.dmesg_restrict" = 1;
        
        # we are not a kernel developer so we disable this to prevent potential information leaks & attacks
        "kernel.ftrace_enabled" = false;

        # disables performance events for all non-root users, root can only acess events that are explicitly
        # enabled.
        "kernel.perf_event_paranoid" = 3;

        # disables the use of berkeley packet filter (BPF) to unpriviliged users.
        "kernel.unprivileged_bpf_disabled" = 1;

        # prevents potentially leaking sensitive information from the boot console kernel log.
        "kernel.printk" = "3 3 3 3";

        # just-in-time (JIT) compiler for the berkeley packet filter (BPF). disable this as we dont make use
        # of it and reduces potential security risks.
        "net.core.bpf_jit_enable" = false;

        # disables core dumps for SUID and SGID this reduces the risk of exposing sensitive information
        # that might reside in the memory at the time of a crash
        "fs.suid_dumpable" = 0;

        # enforces strict access to files only allows the user or root to write regular files
        "fs.protected_regular" = 2;
        "fs.protected_fifos" = 2;

        # disables the automatic loading of TTY line disciplines
        "dev.tty.ldisc_autoload" = "0";
      };
    };

    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    kernelParams = [
      # kernel errors can trigger something known as an "oops", by settings oops=panic we add a fail-safe
      # mechanism to ensure that in the advent of an oops the system reboots, preventing the system from running
      # in a potentially compromised state.
      "oops=panic"

      # enforces signature checking on all kernel modules before they are loaded.
      "module.sig_enforce=1"

      # enables memory page poisoning, increasing the difficulty for attackers to exploit
      # use-after-free vulnerabillities.
      "page_poison=on"

      # enables kernel adress space layout randomization (KASLR) which mitigates memory exploits
      # & increases system entropy.
      "page_alloc.shuffle=1"

      # randomizes the kernel stack offset, mitigating stack-based attacks.
      "randomize_kstack_offset=on"

      # lockdown aims to restrict certain kernel functionality that could be exploited by an attacker with
      # user space code.
      "lockdown=confidentiality"

      # disables a common interface that contains sensitive info on the kernel
      "debugfs=off"

      # prevent kernel from blanking plymouth out of the frame buffer console 
      "fbcon=nodefer"

      # enables auditing of integrity measurement events
      "integrity_audit=1"

      # increases memory safety by modifying the state of the memory objects more closely & helps detecting
      # & identifying bugs
      "slub_debug=FZP"

      # disables the legacy vyscall mechanism, reducing attack surface.
      "vsyscall=none"
      
      # reduce exposure to heap attacks by preventing different slab caches from being merged.
      "slab_nomerge"

      
      "rootflags=noatime"
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux"
    ];
    blacklistedKernelModules = concatLists [
      # Obscure network protocols
      [
        "dccp" # Datagram Congestion Control Protocol
        "sctp" # Stream Control Transmission Protocol
        "rds" # Reliable Datagram Sockets
        "tipc" # Transparent Inter-Process Communication
        "n-hdlc" # High-level Data Link Control
        "netrom" # NetRom
        "x25" # X.25
        "ax25" # Amatuer X.25
        "rose" # ROSE
        "decnet" # DECnet
        "econet" # Econet
        "af_802154" # IEEE 802.15.4
        "ipx" # Internetwork Packet Exchange
        "appletalk" # Appletalk
        "psnap" # SubnetworkAccess Protocol
        "p8022" # IEEE 802.3
        "p8023" # Novell raw IEEE 802.3
        "can" # Controller Area Network
        "atm" # ATM
      ]

      # Old or rare or insufficiently audited filesystems
      [
        "adfs" # Active Directory Federation Services
        "affs" # Amiga Fast File System
        "befs" # "Be File System"
        "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
        "cifs" # Common Internet File System
        "cramfs" # compressed ROM/RAM file system
        "efs" # Extent File System
        "erofs" # Enhanced Read-Only File System
        "exofs" # EXtended Object File System
        "freevxfs" # Veritas filesystem driver
        "f2fs" # Flash-Friendly File System
        "vivid" # Virtual Video Test Driver (unnecessary, and a historical cause of escalation issues)
        "gfs2" # Global File System 2
        "hpfs" # High Performance File System (used by OS/2)
        "hfs" # Hierarchical File System (Macintosh)
        "hfsplus" # " same as above, but with extended attributes
        "jffs2" # Journalling Flash File System (v2)
        "jfs" # Journaled File System - only useful for VMWare sessions
        "ksmbd" # SMB3 Kernel Server
        "minix" # minix fs - used by the minix OS
        "nfsv3" # " (v3)
        "nfsv4" # Network File System (v4)
        "nfs" # Network File System
        "nilfs2" # New Implementation of a Log-structured File System
        "omfs" # Optimized MPEG Filesystem
        "qnx4" # extent-based file system used by the QNX4 and QNX6 OSes
        "qnx6" # "
        "squashfs" # compressed read-only file system (used by live CDs)
        "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
        "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
      ]

      # Disable Thunderbolt and FireWire to prevent DMA attacks
      [
        "thunderbolt"
        "firewire-core"
      ]

      # if bluetooth is enabled, whitelist the module
      # necessary for bluetooth dongles to work
      (optionals (! (elem "bluetooth" features)) [
        "bluetooth" # let bluetooth work
        "btusb" # let bluetooth dongles work
      ])
    ];
  };
}
