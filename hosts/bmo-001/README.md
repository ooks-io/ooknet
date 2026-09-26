# bmo-001

Raspberry Pi 5 server, boots NixOS off an nvme.

## Hardware

Stacked top to bottom: nvme -> m.2 hat -> pi -> ups (the ups sits under the pi).

| part                                         | notes                                                                                  |
| -------------------------------------------- | -------------------------------------------------------------------------------------- |
| HUADISK 128GB NVMe, M.2 2242, PCIe gen3, TLC | shows up as `HYVD128_2242_`, realtek RTS5765DL controller, DRAM-less                   |
| Waveshare PoE M.2 HAT+ (B), sku 29320        | pcie ffc to m.2 (2230-2280), PoE powered, stackable 40 pin header                      |
| Raspberry Pi 5, 8GB                          | official active cooler (heatsink + fan) under the m.2 hat, kernel controlled `pwm-fan` |
| 52Pi / GeeekPi UPS Gen 6, sku EP-0245        | 18650 packs (2S, up to 4 in parallel), feeds the pi from underneath via pogo pins      |

### Waveshare PoE M.2 HAT+ (B)

- pcie gen2 by default, gen3 opt in with `dtparam=pciex1_gen=3`. no stability
  caveats documented
- no HAT+ id eeprom (nothing under `/proc/device-tree/hat`). waveshare tells you
  to set `dtparam=pciex1` in config.txt, bmo-001 sets it via configTxt. the nvme
  showed up without it too (even booted off sd), the firmware turns the port on
  by itself, so this is belt and braces
- PoE: 802.3af/at, 37-57V in, isolated. outputs 5V 4.5A max **through the gpio
  5V pins** plus a 2 pin 12V 2A header, 25W total
- if the pi complains about the supply: `usb_max_current_enable=1`
- which gpio pins it uses beyond 5V/gnd: not documented
- docs: [product](https://www.waveshare.com/poe-m.2-hat-plus-b.htm),
  [wiki](https://www.waveshare.com/wiki/PoE_M.2_HAT+_(B))

### UPS Gen 6

- usb-c in, 5-12V, PD/QC/FCP. 80W on mains, 40W on battery, 5V current rating
  not documented
- powers the pi through pogo pins onto **both gpio 5V pins** (per a pi forum
  user, not the official docs)
- aluminium heatsink + usb fan cool the UPS board itself, the UPS runs that fan,
  not the pi. expect it idle while the UPS is unpowered
- monitoring: stm32 mcu on `/dev/i2c-1` addr `0x17` (`0x18` in bootloader/ota
  mode), reg `0x00` always reads `0xA6`. little endian words, mV/mA:

  | reg             | what                                                                                                                               |
  | --------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
  | `0x0E` / `0x10` | output / input voltage                                                                                                             |
  | `0x12`          | battery voltage (2S, 8.4V full)                                                                                                    |
  | `0x16` / `0x18` | output / input current                                                                                                             |
  | `0x1A`          | battery current, signed, negative = discharging                                                                                    |
  | `0x1C`          | temperature, int8 °C                                                                                                               |
  | `0x1D`          | CR1, bit0 = auto power on when mains returns (default on)                                                                          |
  | `0x1F`          | SR1: b0 5V out on, b1 fast charging, b2 discharging, b3 input low, b4 output low, b5 battery low, b6 adc mismatch, b7 battery fail |
  | `0x20`          | SR2                                                                                                                                |
  | `0x21` / `0x25` | protection / auto start voltage                                                                                                    |
  | `0x23`          | shutdown countdown, write seconds and it cuts power after                                                                          |
  | `0x2B`          | runtime, u64 ms                                                                                                                    |

- no battery % register, estimate it from voltage
- no gpio shutdown line, the pi has to poll. official `battery_monitor.py` polls
  every 120s and powers off below 7400 mV. clean pattern: write a countdown to
  `0x23`, then `poweroff`
- only config.txt advice is enabling i2c (`dtparam=i2c_arm=on`)
- officially only tested on pi os bookworm
- docs: [wiki](https://wiki.52pi.com/index.php?title=EP-0245),
  [scripts + register map](https://github.com/geeekpi/upsv6_pub)
  (`script/tools/read_device.c`, `script/tools/python_demo/`)

## Power, read this first

Both boards drive the same gpio 5V rail, PoE from above and the UPS from below.
Neither vendor documents running them together. If PoE and the UPS are both
live, two supplies share one rail. Pick one real source (probably usb-c into the
UPS so battery backup works, with PoE unplugged or the PoE hat only doing pcie),
or confirm with the vendors before running both. Undervoltage shows up in
`dmesg | grep -i voltage`.

Current state (2026-09-26): powered from the pi's own usb-c. no 18650s in the
UPS yet, and it wont turn on without them (auto start needs external power
**and** battery above the auto start voltage). once batteries are in, move power
to the UPS usb-c and unplug the pis, otherwise its two sources again.

## What we found on the running system

- supply (pi usb-c, 2026-09-26): usb-pd negotiated 5V 5A, pdos match the
  official 27W psu (5V 5A, 9V 3A, 12V 2.25A, 15V 1.8A). `max_current=5000`,
  undervoltage alarm 0, no overcurrent flags. read from
  `/proc/device-tree/chosen/power/*` and hwmon `rpi_volt`, no vcgencmd needed
- idle temps: cpu 42C, nvme 40C, rp1 48C. `pwm-fan` is the active cooler, idle
  at state 0/4 (pi5 curve starts ~50C)
- nvme links at pcie gen2 x1 (5 GT/s), matches waveshares default
- DRAM-less drive, it borrows 32MB of host memory (HMB) for its mapping table
- smart baseline 2026-09-26: PASSED, 0% used, 5.7GB written, 0 media errors, 2
  unsafe shutdowns (power pulls). DRAM-less drives take power loss worse,
  `sudo poweroff` before unplugging until the UPS has batteries. check again
  with `sudo nix run nixpkgs#smartmontools -- -H -A /dev/nvme0`
- no undervoltage or throttling in dmesg since boot

## Bootloader eeprom

Set from raspberry pi os on 2026-09-26, cant be changed from nixos (the eeprom
tools need `vcgencmd`, which only exists on raspberry pi os):

```
BOOT_UART=1
BOOT_ORDER=0xf461   # sd, nvme, usb, retry
NET_INSTALL_AT_POWER_ON=1
PCIE_PROBE=1
```

bootloader release: 2026-05-26. To change it again, boot a raspberry pi os sd
card and use `rpi-eeprom-config`.

## Boot

See `modules/nixos/hardware/rpi5.nix`. The eeprom firmware loads the kernel
straight off the nvme firmware partition, no u-boot, one generation only.
Rolling back means redeploying the old config, theres no boot menu.

A sd card in the slot wins over the nvme (boot order), handy for recovery with
the `ookspi` installer image.

## Official raspberry pi docs

Anchors checked 2026-09-26 against wayback copies (raspberrypi.com blocks
scripted fetches).

- config.txt:
  [reference](https://www.raspberrypi.com/documentation/computers/config_txt.html),
  [`kernel`](https://www.raspberrypi.com/documentation/computers/config_txt.html#kernel),
  [`initramfs`](https://www.raspberrypi.com/documentation/computers/config_txt.html#initramfs),
  [`arm_64bit`](https://www.raspberrypi.com/documentation/computers/config_txt.html#arm_64bit),
  [filters](https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters)
  ([`[pi5]`](https://www.raspberrypi.com/documentation/computers/config_txt.html#model-filters),
  [`[all]`](https://www.raspberrypi.com/documentation/computers/config_txt.html#the-all-filter)),
  [`enable_uart`](https://www.raspberrypi.com/documentation/computers/config_txt.html#enable_uart),
  [`dtparam`](https://www.raspberrypi.com/documentation/computers/config_txt.html#dtparam),
  [`dtoverlay`](https://www.raspberrypi.com/documentation/computers/config_txt.html#dtoverlay)
- bootloader eeprom:
  [overview](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#raspberry-pi-boot-eeprom),
  [`BOOT_ORDER`](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#BOOT_ORDER),
  [`PCIE_PROBE`](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#PCIE_PROBE),
  [editing the config](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#editing-the-current-bootloader-configuration),
  [`rpi-eeprom-update`](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#rpi-eeprom-update)
- pcie / nvme:
  [enable pcie (`pciex1`)](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#enable-pcie),
  [gen 3](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0),
  [nvme boot](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#nvme-ssd-boot)
- device tree:
  [overlays and parameters](https://www.raspberrypi.com/documentation/computers/configuration.html#device-trees-overlays-and-parameters)
- power:
  [powering the pi 5](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#powering-raspberry-pi-5),
  [`PSU_MAX_CURRENT`](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#PSU_MAX_CURRENT)
- cooling:
  [pi 5 fans](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#raspberry-pi-5-fans),
  [thermal control](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#frequency-management-and-thermal-control),
  [fan connector pinout](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#raspberry-pi-5-fan-connector-pinout),
  [active cooler brief (pdf)](https://pip.raspberrypi.com/documents/RP-008188-DS-active-cooler-product-brief.pdf)
- gpio / i2c:
  [gpio](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#gpio),
  [pinout](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#view-a-gpio-pinout-for-your-raspberry-pi),
  [i2c](https://www.raspberrypi.com/documentation/computers/configuration.html#i2c)
- debug uart:
  [uart types](https://www.raspberrypi.com/documentation/computers/configuration.html#uart-types)
  (UART10 is the pi 5 debug connector)
- datasheets:
  [pi 5 product brief](https://pip.raspberrypi.com/documents/RP-008348-DS-raspberry-pi-5-product-brief.pdf),
  [rp1 peripherals](https://pip.raspberrypi.com/documents/RP-008370-DS-1-rp1-peripherals.pdf)
  (the rp1 does gpio, ethernet, usb)
- source:
  [kernel `rpi-6.12.y`](https://github.com/raspberrypi/linux/tree/rpi-6.12.y)
  ([`bcm2712_defconfig`](https://github.com/raspberrypi/linux/blob/rpi-6.12.y/arch/arm64/configs/bcm2712_defconfig),
  bmo-001 runs 6.12.75 from nixpkgs `linux-rpi.nix`),
  [firmware](https://github.com/raspberrypi/firmware),
  [eeprom releases](https://github.com/raspberrypi/rpi-eeprom/releases)

## Todo

- UPS monitor service: `dtparam=i2c_arm=on`, poll `0x17`, shut down cleanly on
  low battery using the `0x23` countdown
- gpio input, plain gpio reads need no config.txt changes, just access to
  `/dev/gpiochip*`. check the UPS pogo pins dont claim the pins you want
- sort out the power source question above
