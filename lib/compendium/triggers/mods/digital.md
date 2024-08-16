---
title: Digital triggers
subtitle: Use the trigger's digital press to input an analog value.
---

The **digital trigger** mod rewires the digital press at the bottom of a trigger to instead (or in addition) input a static analog value. This mod is very popular for use with Smash Ultimate, primarily in combination with [trigger plugs](/compendium/triggers/mods/plugs), because it is the only way to get trigger plugs to work with Ultimate. Ultimate does not read the trigger's digital input on a GCC, but instead looks for an analog value of 79 or higher to consider the trigger as being pressed.

Note that aftermarket boards like the [PhobGCC](/compendium/boards#phobgcc) support this functionality in their software, so hardware modifications are not necessary.

## Parts

- Thin-gauge wire (30 AWG or thinner)
- Optional alternative: digital trigger flex PCB

## Process

1. Desolder the trigger board wires from both the trigger board and the motherboard.
2. Cut two thin-gauge wires to 2–3 times the length of the OEM trigger wires.
3. Solder the wires to the left and right upper pins of the trigger slider on the same side as the trigger.
4. Solder the other end of the wires to the trigger board just like the OEM wires were.
5. Wrap the wires around the upper edge of the board and along the outside edge of the board to avoid interference with the trigger assembly when the controller is reassembled.
6. Replace the trigger board in the rumble bracket and reassemble the controller.

To retain the digital input, some additional steps are needed. See the guide linked below for more details.

If you're using a digital trigger flex PCB, simply follow the included instructions and solder it on to the front of the motherboard.

## Resources

- Simple's [digital trigger guide](https://imgur.com/a/analog-press-on-digital-trigger-gcc-now-updated-with-transistor-mod-BNmDnVS){:target="\_blank"} consists of good photos of the process, as well as the optional transistor step that retains the digital input.
