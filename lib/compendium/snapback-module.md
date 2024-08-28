---
title: Snapback module
subtitle: Install capacitors to prevent analog misinputs due to snapback.
tags:
  - stick-mod
  - mod
---

Most analog sticks naturally have [snapback](/analog-sticks/stickboxes#snapback), and an **anti-snapback module** (commonly shortened to **snapback module**) is the de facto standard way to prevent it from causing misinputs.

## History

Originally, snapback was suppressed by soldering capacitors directly to the potentiometer leads until snapback was sufficiently suppressed. However, this is not an easily adjustable or user-serviceable mod, which is important because as stickboxes and potentiometers wear, the snapback profile changes and suppression needs to be adjusted. Additionally, the controller had to be reset (X + Y + Start) after initializing, because the capacitance interfered with the initial calibration.

Eventually, the idea of a snapback "module" came about, which integrates several capacitors of varying size into a small circuit board with switches to easily enable or bypass each one, allowing overall snapback capacitance on each axes to be changed as needed. [Kadano](https://dol-003.info/modders/kadano) also came up with a way to avoid needing to reset after plugging in via a small additional circuit in the module — these are now commonly known as "no-reset" modules.

## Parts

A variety of companies and modders sell snapback modules of their own designs. Note that availability may vary.

- [esca no-reset module](https://www.etsy.com/listing/1063578642/esca-gamecube-controller-snapback)
- [FIRES no-reset module](https://www.etsy.com/listing/1060466170/fires-no-reset-antisnapback-module-for)
- [Hand Held Legend flex PCB module](https://handheldlegend.com/products/no-reset-snapback-mod-for-the-gamecube-controller-hand-held-legend?variant=39711300354182)
- Kadano sells various revisions of his module designs on [his shop](https://kadano.biz)

## Process

A traditional module includes several small wires that must be soldered to the potentiometer leads, and a separate mechanism to attach the module itself to the board. More recently, people have created flexible PCB modules that fit over the leads and can be soldered directly onto the board. Most modules include installation instructions pertaining to their specific design.

## Resources

[Kadano](https://dol-003.info/modders/kadano), who pioneered snapback modules, maintains a [detailed reference about his past module designs](https://kadano.net/SSBM/GCC/S2.html).
