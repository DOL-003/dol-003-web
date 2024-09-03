---
title: PODE
subtitle: All about Potentiometer Oddity Degradation Effect.
notice: imagery
---

**Potentiometer Oddity Degradation Effect** (**PODE**) is a phenomenon where a worn [stickbox potentiometer](/analogs-stick/stick-components/stickbox-potentiometers) exhibits inaccurate position readings. This typically manifests as sluggish and/or sporadic unexpected input values when moving the stick.

**Trigger PODE** is a related condition where a [trigger potentiometer](/triggers#trigger-pode) has a non-zero neutral value after the trigger released.

## Diagnosis

PODE is best diagnosed using an input viewer with an oscilloscope, such as [SmashScope](https://goomwave.com/2020/06/28/smashscope-guide/). When flicking the stick, the oscilloscope waveform will show a delay in the input curve when returning to neutral, often featuring an uneven slope with sudden spikes or dips.

Trigger PODE is even easier to detect with an input viewer. After pulling the trigger a few times and releasing it, the trigger's analog value remains at a non-zero value.

## Impact

PODE subtly changes the timing and movement needed for various Melee tech that involve quickly moving the analog stick, such as smash turns, dashback and pivots. Since PODE usually develops gradually, it tends to make a controller perform less consistently over time, forcing the player to constantly adjust to the level of PODE.

Historically, PODE was not well-understood and many players even considered it beneficial as it has the side effect of reducing [snapback](/analog-sticks/stick-components/thumbsticks#snapback), as well as making certain vanilla Melee tech easier to perform, such as dashbacks. With the advent of [snapback modules](/analog-sticks/stick-mods/snapback-module) and more recently [heartbeat modules](/analog-sticks/stick-mods/heartbeat-module), PODE is now considered mostly detrimental, since it's possible to have an almost 100% consistent controller without it.

Sufficiently severe trigger PODE causes lingering trigger analog input, which typically manifests as unintentionally holding shield in a Smash game.

## Repair

The two primary options to fix PODE are replacing the potentiometer with a less-worn one, or installing a [heartbeat module](/analog-sticks/stick-mods/heartbeat-module).

## Theory

PODE has been thoroughly researched, most notably by the [PODE Collective](https://x.com/podecollective), a group of modding pioneers with significant electrical experience.

The leading theory of what causes PODE's exact behavior is that a combination of scratches on the carbon surface of the potentiometer and microcells of capacitance caused by oxidation of the wiper creates a cascading discharge that sends current through the potentiometer at a variable rate. Giving this current somewhere else to drain is the basis of how a [heartbeat module](/analog-sticks/stick-mods/heartbeat-module) works.

## Resources

- [Kadano](https://dol-003.info/modders/kadano) wrote a [deep dive into the mechanics of snapback and PODE](https://sites.google.com/view/kadanosnapback/home)
- Goomy also wrote a large amount of [PODE documentation](https://docs.google.com/document/d/1qM5PvM0SSHaUtSu8COg24nm2Vri9GsTB3xCtSvAHamU)
