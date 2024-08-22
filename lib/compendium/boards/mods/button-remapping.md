---
title: Button remapping
subtitle: Swap button inputs to enable Z jump or trigger jump in Melee.
---

**Button remapping**, also known as a **button swap**, is a mod to change which input is triggered when pressing a button. Most commonly, the X or Y button input is swapped with the Z button input to allow Z to trigger a jump in Melee, in which case the mod is commonly known as **Z jump**.

## Tournament legality

Melee tournament rulesets generally allow this mod, as long as the controller has the same number of buttons/inputs as a stock controller and no button is mapped to multiple inputs or any kind of macro.

## Parts

Only basic soldering supplies and small-gauge wires are required. Additionally, Kadano sells a toggleable button remap module on [his shop](https://kadano.biz).

## Process

On an OEM controller, this mod is fairly challenging. The chip pins corresponding to the buttons being swapped need to be lifted from their traces, and thin wires need to be soldered to both the pins and the traces. Optionally, a small switch can be used to easily toggle the button swap on or off without soldering.

The [PhobGCC](/compendium/boards#phobgcc) firmware has built-in software support to swap either the Z, L or R inputs with either the X or Y inputs, without requiring any hardware modifications.

## Resources

- [Video guide](https://www.youtube.com/watch?v=pXkwwkJsQvo) by Mitch Cairns
