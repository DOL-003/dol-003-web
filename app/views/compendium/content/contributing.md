---
title: Contributing guidelines
label: Contributing
subtitle: Want to contribute to the Compendium? Great! We ask everyone to read these guidelines before getting started.
---

Note that pull requests that do not follow these guidelines will not be accepted.

## Process

The code for DOL-003.info, including Compendium content, lives in [GitHub](https://github.com/jmarquis/controllers){:target="\_blank"}. Simply fork the repo, push up your changes to your fork, and open a pull request.

Pull requests are accepted on a case-by-case basis entirely at the DOL-003.info team's discretion. We welcome everyone's contributions, but take responsibility for curating Compendium content to keep it consistent and helpful.

Here are some general guidelines for pull requests:

- Keep scope small. Several small pull requests are preferable to one large one, unless all the changes are closely related.
- Write a good PR description explaining why you're making the change, and linking any supporting documentation for the topic you're writing about.
- Feel free to share your PR in [Discord](https://discord.gg/HwtPU7tkCT){:target="\_blank"} for discussion!

## Content guidelines

- Do not use first person language.
- Use an objective tone and characterize the basis of all subjective recommendations.
  - For instance, "Many community members recommend..." or "The general consensus of most modders..."
- Speak in present tense unless describing specific historical or upcoming events. The Compendium is meant to represent the current state of GCC modding.
- Do not use hyperbolic language.
- Use American English standards for spelling and grammar by default.

### Organization

With specific exceptions, each top-level page should be a **component page** describing a component or group of components of a GameCube controller.

A component page may describe subcomponents within the page, or split subcomponent information out into subpages if the amount of detail warrants it. For instance, the [buttons](/compendium/buttons) page describes all buttons inline since there isn't much to say about them, but the [analog sticks](/compendium/sticks) page has subpages for each different part of the analog stick assembly since each subcomponent has a large amount of related information.

Each mod should be covered by its own **mod page** nested under a **Mods** page under the relevant component.

### Pages

Every page should be explanatory in tone, and generally go from more general to more detailed information.

Component pages should cover, in roughly this order:

- Introductory information (i.e. what is this thing?)
- High-level breakdown (e.g. what variants of this thing exist? what components does it consist of?)
- What are the common issues with this component, and how can you fix them? (title: **Common issues & repairs**)
- Where can you source replacements of this component? (title: **Replacements**)
- What are some common mods related to this component? (title: **Modifications**)

Mod pages should cover, in roughly this order:

- What does this mod accomplish?
- What are some variations of this mod? (if any)
- What parts are needed/available? (title: **Parts**)
- How do you do the mod? (title: **Process**)
- What are some guides for this mod? (title: **Guides**)

Incomplete pages that do not follow this structure should be marked as stubs.

Captioned photos are encouraged for all pages and subsections, especially to illustrate examples of different components and mods.

When in doubt, try to make your contributions consistent with the other content in the Compendium. And don't be afraid to discuss your changes in [Discord](https://discord.gg/HwtPU7tkCT){:target="\_blank"}!
