# **nut-taal**
> An auxiliary constructed language that is parsable by both computer and human. Inspired by [mini language](https://minilanguage.com)

### A taste of the language:
## [Try it out](https://mikeskoe.github.io/nut-taal/)
nut-taal | English 
-- | --
my <u>lief</u> dit <u>doen</u> | I <u>like</u> to <u>do</u> this
dit a kat e *my klein mooi* | This is my *small beutiful* cat
e *dit-dag* a sy <u>wil</u> i <u>speel</u> **met** jy | *Today*, he <u>wants</u> to <u>play</u> **with** you

### [More Examples](https://mikeskoe.github.io/nut-taal/#examples)
### [Dictionary](https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv)
### [Conjunctions](https://github.com/MikeSkoe/nut-taal/blob/main/public/Conjunctions.csv)
### [Discord](https://discord.gg/yVzvgJKH)

---
## Grammar
<img src="https://github.com/MikeSkoe/nut-taal/blob/main/public/diagram.svg" alt= “diagram” width="25%" height="25%">

### Low level
The language have three low-level language units:
- [Root](#Root) - a building block of the language
- [Mark](#Mark) - explains if the root a noun, verb or an ad (a modifier, like an adjective or adverb)
- [Conjunction](#Conjunction) - introduces a [phrase](#Phrase) (clause), to make sentences richer

#### **Root**
Can be collapsed to make a compound word, using a `*-*-*` pattern.
It keeps vocabulary richer and the dictionary shorter.

It can have three states, depending on position in a sentence:
- noun - a thing
- <u>verb</u> - an action
- *ad* - a modification, like adjective or adverb

#### **Mark**
Placed before a root
- `a` - introduces a noun
- `i` - introduces a verb
- `e` - introduces a modificator

There are some [patterns](#patterns), where the marks should be dropped.

#### **Conjunction**
Placed before a [phrase](#Phrase).
Examples of Conjunctions could be words like:
- **want** - because
- **in** - in
- **vir** - to, for
---

### Middle level
Words are middle level units.
They consist of roots and marks and can have three states: **noun**, **verb** and **ad**

#### Patterns
Noun | Verb | Ad
-- | -- | --- 
`a *` | `i *` | `e *`
`[BEGINING OF THE SENTENCE] *` | `[NOUN] *` | `[AD] *`
`[Conjunction] *` ||
`[VERB] *` ||

---
### High level
#### Phrase
The phrase (or clause) is a cluster of non-conjunction words.

#### Subject
The first noun in a phrase

#### Infinitive
The second verb in a phrase

#### Object
The second noun in a phrase

---
## Tenses
If a tense, quantity or conditionals are clear from a context, no additional marker needed.
But if explicitness is required, here are some useful words:
- voor - before. A past tense indicator
- sal - shall. A future tense indicator
- al - already, yet. A perfect tense indicator
- sou - would, could. A conditionals indicator

| nut-taal | English
| - | -
| e *voor* a my <u>eet</u> oranje | I ate an orange
| e *sal* a my <u>eet</u> oranje | I will eat an orange
| e *al* a my <u>eet</u> oranje | I have eaten an orange
| e *voor* a my <u>al-eet</u> oranje | I had eaten an orange
| e *sal* a my <u>al-eet</u> oranje | I will have eaten an orange
| e *sou* a my <u>eet</u> oranje | I would eat an orange

---
## Vocabulary
Ideally, every root should have a meaning, be it a noun, verb, or adjective, as long as it is clear and makes sense.
Therefore, related words could be collapsed into a single root.
For example, a root "vra" could mean "question" as a noun, "to ask" as a verb, and "curious/curiously" as an adjective.

At the same time, to prevent ambiguity, a single root should not cover too wide range of meanings or unrelated ideas.
The dictionary should be optimised, not limited.
Additionally there should not be a root, like English **like**, that could mean **alike** and **to love**, since these are two completely different meanings

At the moment the dictionary is not perfect.
Some compound words should be replaced with more implicit compounds.
Some words could be replaced with synonyms.
Some words could be added.
I hope the dictionary will be better and better as the comunity grows.

### Why Afrikaans?
> The dictionary is not tightly coupled with the language.
It is rather a dependency.

At the moment all roots come from Afrikaans.
I did it for few reasons:
- Having only one source language allows to use a translator! Which means you can fallback to a root from the translator and voice a sentence, since pronunciation follows Afrikaans rules
- It is one of the simples natural languages
- It is much simpler to read and pronounce than English, since spelling is regular
- It sounds great (let's be honest, some event popular conlangs sound artificial)
- There will always be someone who does not know the majority a vocabulary anyways
- It is a Germanic language, located in Africa, so it has a lot of common words with English, Dutch, German and Khoisan languages of Southern Africa

### How to contribute
> [Discord server](https://discord.gg/3AsNmZVJ)

Even though you can already use the language for a communication, it is far from being perfect.
If you want to mature the language, you can suggest dictionary modification using issue template.
Go to "Issues" -> "New Issue" -> choose a template and press "Get started" or press "Open a blank issue"

💜

