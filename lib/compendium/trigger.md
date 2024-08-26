---
title: Trigger
subtitle: The GameCube controller has a trigger button on each side of the controller.
---

<aside class="no-offset">
  <a href="/static/compendium/oem-triggers.jpg">
    <img src="/static/compendium/oem-triggers-thumb.jpg">
  </a>
  <p>A set of OEM triggers.</p>
</aside>

Each **trigger** is a shoulder button on either side of a GCC designed to be pulled with an index or middle finger. The triggers themselves are ABS plastic like the other buttons, but the underlying mechanism is more complex, allowing a larger range of motion and actuating both analog and digital inputs. The left trigger is referred to as the **L button**, while the right trigger is referred to as the **R button**.

The trigger assembly is one of the more complicated moving parts in a GameCube controller, consisting of several pieces including a graduated slider potentiometer that enables a range of analog inputs proportional to how far the trigger is pressed, as well as a silicone button pad and contact pad (on the corresponding trigger daughterboard) to activate a digital input when the trigger is fully pressed.

## Common issues & repairs

<aside>
  <a href="/static/compendium/trigger-pot.jpg">
    <img src="/static/compendium/trigger-pot-thumb.jpg">
  </a>
  <p>A trigger slider potentiometer.</p>
</aside>

In addition to the following common problems, there are various [trigger mods](/trigger/trigger-mods) that address more subjective issues with triggers.

### Trigger PODE

Perhaps the most common trigger issue caused by wear is trigger PODE (Potentiometer Oddity Degradation Effect), which is a name for when the slider potentiometer starts inputting inaccurate analog values. This most often exhibits as the analog value not correctly returning to 0 when releasing the trigger, which can result in unintentionally holding shield in Smash games. Since this issue is caused by wear, it can't be fixed and the slider must be replaced (see below for replacement info).

### Getting stuck on shell

If a trigger seems to be catching on the shell on its way back up, it can help to trim a tiny bit of plastic off the shell next to the wing of the trigger that grips the slider. [Trigger stabilization](/trigger/trigger-mods/trigger-stabilization) is another good remedy for this.

### No digital press

When there's no "click" feeling when fully pressing the trigger, this usually indicates the silicone trigger button pad is either missing, not seated correctly, worn, or damaged. See below for replacement information.

If the click feeling is there but the expected input doesn't happen, this can indicate a dirty button pad or a problem with the daughterboard or wires that connect it to the motherboard. Try cleaning or replacing the pad, and then check for continuity at various points from the contact pad on the daughterboard to the corresponding pins of the main chip. If the controller is a [PhobGCC](/motherboard#phobgcc), make sure the trigger mode is one that allows the digital press.

## Replacements

Like most stock parts, OEM triggers can only be found on original GameCube controllers. However, various third-party options exist:

- [Resin triggers](/trigger/trigger-mods/resin-casting) are available in many different colors, textures and shapes.
- eXtremeRate includes triggers, and even replacement trigger assemblies, in [their shell + buttons sets](https://extremerate.com/collections/nintendo-gamecube-shells).

Knockoff triggers from sites like AliExpress or Amazon are not recommended, as they are particularly prone to fit issues even compared to other knockoff buttons.

### Slider potentiometers

The only place to get new OEM potentiometers is currently [Kadano](https://kadano.biz), who orders them in bulk from one of Nintendo's suppliers.

Used slider potentiometers can be harvested from other GCCs or from Wii Classic Controllers (which interestingly don't actually use the sliders, but still have them for unknown reasons). Some modders sell extra potentiometers, usually on sites like Etsy.

### Silicone button pads

There is no known source for OEM button pads other than GCCs. Some third-party options exist, but are generally considered varying degrees of inferior to OEM pads.

- Battle Beaver sells [replacement pads](https://battlebeavercustoms.com/products/battle-beaver-gamecube-contact-pads), though some have found their longevity to be much lower than that of OEM pads.

- eXtremeRate includes silicone pads with [their GameCube shells](https://extremerate.com/collections/nintendo-gamecube-shells).
