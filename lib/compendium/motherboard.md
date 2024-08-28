---
title: Motherboard
---

The **motherboard** is a PCB that serves as the base of a GCC's internals. It connects the various electrical components to the CNT-DOL processor, which is responsible for communicating with the connected console or adapter via the [cable](/cable). There are also three **daughterboards** connected to the motherboard: the C-stick board and two [trigger](/triggers) boards (also commonly called trigger paddles).

## OEM variants

There have been three major revisions of the motherboard that correspond with the three [stickbox variants](/analog-sticks/stickboxes#variants).

### T1

The earliest GCC motherboards. The oldest of these often have a green back, which makes them easy to recognize. T1 boards use a detachable connector for the C-stick board. The corresponding T1 stickboxes are soldered on.

### T2

The second-generation board eschews the detachable C-stick cable and adds a large blue oscillator that is the hallmark recognizable feature. The T2 stickboxes are also soldered on.

### T3

The most recent revision's most notable change is the swap to T3 stickboxes which are attached via screws instead of soldering. Some of the earliest T3 boards also have a detachable C-stick connector again for some reason.

## Aftermarket boards

In more recent years, several projects have created replacement motherboards for GCCs that feature programmability and various other features.

### Goomwave

The first well-known aftermarket motherboard was the Goomwave, which features hot-swappable [stickbox potentiometers](/analog-sticks/stickbox-potentiometers), [notch](/shell/shell-mods/notches) calibration, [PODE](/misc/pode) emulation, and various other customizable settings. At the project's peak, many top Melee players used a Goomwave, and demand far outstripped supply since the project was closed-source and only the maintainers could produce the boards. More recently, the Goomwave project has been more dormant in the wake of PhobGCC's growing popularity, and due to some macro-like functionality Goomwave controllers may not be tournament-legal in the near future.

### PhobGCC

<aside>
  <a href="/static/compendium/phobgcc-board.jpg">
    <img src="/static/compendium/phobgcc-board-thumb.jpg">
  </a>
  <p>A PhobGCC 2.0.2 board manufactured by Elecrow.</p>
</aside>

The PhobGCC project consists of an open-source PCB design paired with open-source firmware, designed to be fabricated, assembled and flashed by anyone. It replaces the OEM [stickbox potentiometers](/analog-sticks/stickbox-potentiometers) with magnets and Hall effect sensors, and supports many customizable settings like stick calibration, built-in [snapback](/analog-sticks/stickboxes#snapback) filtering, software [button swaps](/motherboard/board-mods/button-remapping), [digital trigger](/triggers/trigger-mods/digital-triggers) emulation, and much more.

Learn more at the [official PhobGCC docs](https://github.com/PhobGCC/PhobGCC-doc).

### Cardboard

The Cardboard is a custom PCB designed to use a transplanted CNT-DOL chip, the main chip on an OEM motherboard. It includes various popular mods as built-in features, such as a [heartbeat module](/analog-sticks/stick-mods/heartbeat-module), [digital triggers](/triggers/trigger-mods/digital-triggers), left Z, [mouse-click button](/buttons/button-mods/mouse-click-buttons) support, and more.

Cardboard is developed by Cardosi Customs, and files can be downloaded or boards can be purchased on [their website](https://cardosicustoms.com).

## Common issues & repairs

Motherboards tend to be very durable compared to other components since they have no moving parts, but they can exhibit some issues over time.

### Cracks

Boards can exhibit hairline cracks that break traces, causing electrical issues such as various components no longer working. This typically only happens as a result of serious impacts, such as controller spikes or drops. To find cracks, you can flex the board slightly to make them more visible.

Broken traces can theoretically be scraped up and bridged with solder, but generally a cracked board is considered beyond repair.

### Lifted pads

Through-hole soldering pads can sometimes be damaged or lifted from excessive or improper soldering. In these cases, the trace can be scraped up and connected to the pin with some solder and/or a wire, but given the loss of structural integrity, it is usually preferable to replace the board.

### Corroded button contacts

The copper button contacts can stop working, usually due to corrosion. For mild cases, this can sometimes be gently scrubbed off and cleaned with IPA. For X and Y, the corroded contacts can optionally be bridged to the other button to preserve jump functionality in Smash. In other cases, the board needs to be replaced.
