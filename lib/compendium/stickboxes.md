---
title: Stickboxes
subtitle: The mechanical component of the analog stick assembly.
tags:
  - stick-component
---

<aside>
  <a href="/static/compendium/t3-stickbox.jpg">
    <img src="/static/compendium/t3-stickbox-thumb.jpg">
  </a>
  <p>An OEM T3 stickbox.</p>
</aside>

The **stickbox** is the spring-loaded mechanism that lets you smoothly move an analog stick, and returns it to center when pressure is released.

## Variants

There are three iterations of stickboxes that correspond with the three [motherboard revisions](/motherboard#oem-variants), as well as stickboxes made by third parties.

### T1

Found on the earliest GCCs, these stickboxes are known to [wear](#looseness) very quickly, resulting in very loose analog sticks. T1s consist of plastic innards housed in a metal outer case, which is attached to the motherboard by four solder joints.

### T2

An improved version of the T1 that lasts much longer, but shares most aspects of the design.

### T3

A major all-plastic redesign that lasts much longer than the earlier variants. It attaches to the motherboard via 2 small screws. This design is also much easier to disassemble, which is another reason modders typically prefer them — it is much easier to clean them, lube them, and replace the springs in them.

### Third-party

No third-party stickboxes have been found which compare to T3s, and they are generally seen as inferior to OEM stickboxes and not worth buying or using.

## Common issues & repairs

### Looseness

The main problem encountered with stickboxes is wear, which impacts how well the stick returns to center. As a stickbox wears, a physical dead zone develops in the center where the stick feels loose, and in severe cases can cause misinputs. There is a common misconception that this wear is caused by weakened springs, but in reality it's caused by the breakdown of the plastic components inside the stickbox assembly.

Stickbox wear is unavoidable and unrepairable, and typically a stickbox is replaced once the looseness becomes noticeable.

### Snapback

Because stickboxes use springs to return the stick to center and thumbsticks add some weight to the end of the stick, inertia can cause an overshoot past center when releasing the stick. This results in a brief oscillation of the stick before it settles back at the center point, which can cause misinputs even on brand new stock GCCs. [Snapback capacitors/modules](/analog-sticks/stick-mods/snapback-module) are the standard solution to filtering out these inputs at the electrical level, and some aftermarket boards like [PhobGCC](/motherboard#phobgcc) have software-based snapback filtering built in.

## Replacements

There is no consistent source for OEM stickboxes other than other Nintendo controllers. Third-party stickboxes are not recommended.

- **Other Nintendo-made GameCube controllers** always have OEM stickboxes, but make sure the controller you're harvesting from is a compatible variant. See this [Stickbox Variant Guide](https://gccontrollerlibrary.com/guides/) (toward the bottom of the page) for which stamps on the back of the controller indicate which revision it contains.
- **Wii Classic Controllers** (both the normal and Pro variants) contain T3 stickboxes, and are often in good condition since these controllers are rarely used heavily compared to most GCCs.
- **Wii Nunchucks** contain a mix of T2 and T3 stickboxes. It is more common to find T3 Nunchucks in Europe, and T2 Nunchucks elsewhere.

There have been various community efforts over the years to produce a T3-like stickbox, generally via some kind of 3D printing, but due to the tiny tolerances and high durability needed, no community-made stickboxes have proven viable so far.

## Modifications

[Cleaning and lubing stickboxes](/analog-sticks/stick-mods/stickbox-lubing) is a common practice to make the stickbox movement smoother.

[Replacing the stickbox spring](/analog-sticks/stick-mods/aftermarket-stickbox-springs) is often done to change the feel of the resistance provided by the stickbox.
