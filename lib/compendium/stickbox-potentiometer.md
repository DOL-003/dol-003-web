---
title: Stickbox potentiometer
subtitle: The electrical component of the analog stick assembly.
---

A **stickbox potentiometer** is a rotational variable resistor moved by the pegs on a [stickbox](/analog-stick/stickbox). Two potentiometers are responsible for translating the position of each stickbox into values that the GCC processor can interpret as X and Y coordinates.

## Common issues & repairs

### PODE

As a potentiometer wears, it usually develops [Potentiometer Oddity Degradation Effect](/misc/pode) (PODE). PODE is when a potentiometer no longer accurately reports the position of the stick, particularly during movement, which often results in missed inputs.

Since PODE is caused by the carbon components within the potentiometer wearing out, it cannot feasibly be repaired. Generally, the potentiometers are replaced to fix PODE. Alternatively, a [heartbeat module](/analog-stick/stick-mods/heartbeat-module) can be installed to suppress the effects of PODE.

### Drift

Potentiometers can also develop drift, which is similar to PODE but manifests as incorrect non-zero values when the stick is at the center/neutral position. Similarly, drift generally cannot be fixed without replacing the affected potentiometers.

It is possible to [clean a potentiometer](https://www.youtube.com/watch?v=lPJ2ST9vTfQ) by unclipping it, removing the wiper, and gently applying isopropyl alcohol. However, this generally will not fix issues caused by wear.

## Replacements

The only place to get new OEM potentiometers is currently [Kadano](https://kadano.biz), who orders them in bulk from one of Nintendo's suppliers.

Used potentiometers can be harvested from other Nintendo controllers, but be wary of how worn they are:

- **Other GCCs**
- **Wii Classic Controllers** (and the Pro variant)
- **Wii Nunchucks**

Some modders sell extra potentiometers, usually on sites like Etsy.

Third-party potentiometers are not recommended.

## Modifications

[Snapback modules](/analog-stick/stick-mods/snapback-module) attach capacitors to the potentiometer leads to filter out unintentional inputs caused by snapback.
