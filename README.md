# **nut-taal**
> An auxiliary constructed language that is parsable by both computer and human. Inspired by [mini](https://minilanguage.com)

# [Try it out](https://mikeskoe.github.io/nut-taal/)

# A taste of the language:
Nut-taal | English 
-- | --
My <u>lief</u> dit <u>doen</u> | I <u>like</u> to <u>do</u> this
Dit <u>is</u> kat om *my klein mooi* | This is my *small beutiful* cat
Om *gister* an sy <u>wil</u> te <u>speel</u> **met** jy | *Today*, he <u>wants</u> to <u>play</u> **with** you

## [More Examples](https://mikeskoe.github.io/nut-taal/#examples)
## [Dictionary](https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv)
## [Conjunctions](https://github.com/MikeSkoe/nut-taal/blob/main/public/Conjunctions.csv)
## [Discord](https://discord.gg/gxWQ7uXqrz)

---

# Grammar
<img src="https://github.com/MikeSkoe/nut-taal/blob/main/public/diagram.svg" alt= “diagram” width="35%" height="35%">
<img src="https://github.com/MikeSkoe/nut-taal/blob/main/public/sentence-structure.svg" alt= “diagram” width="35%" height="35%">

---

## Low level
### **Root**
A term or stam defined if the [dictionary](https://github.com/MikeSkoe/nut-taal/blob/main/public/dictionary.csv).
Compound roots are achieved by composing other roots using `*-*-*` pattern.

Examples:
- **Speel** - game, play
- **My** - I, me, my
- **Na** - After, past

### **Mark**
An auxiliary unit that introduces either a noun, a verb or an ad (descriptor).
Placed before a root
- **an** - introduces a noun [word](#word)
- **te** - introduces a verb [word](#word)
- **om** - introduces a descriptor [word](#word)

### **Conjunction**
A language unit that introduces a [clause](#Clause), to make sentences richer.

Examples of conjunctions could be words like:
- **want** - because
- **maar** - but
- **vir** - to, for

---

## Middle level
### Word
See [patterns](#patterns) to learn when markers should be dropped
#### **Noun** (A thing)
`(an)` + `root`

Example:
- **Speel** - A game

#### **Verb** (An action)
`(te)` + `root`

Example: 
- **Te speel** - To play

#### **Ad** (A description)
Adjective: `Noun` + `om` + `root`

Example:
- **Kat om speel** - The playful cat

Adverb: `Verb` + `om` + `root`

Example:
- **Te leer om speel** - To learn playfully

---

## High level
### **Clause**
The clause is a group of non-conjunction words in a sentence.

### **Subject**
The noun before the first verb in a clause

### **Object**
The noun after a verb in a clause

### **Infinitive**
The second verb in a clause

## Tense
If a tense, quantity or conditionals are clear from a context, no additional marker needed.
But if explicitness is needed, here are some useful words:
- **was** - before. A past tense indicator
- **sal** - shall. A future tense indicator
- **al** - already, yet. A perfect tense indicator
- **sou** - would, could. A conditionals indicator

| nut-taal | English
| - | -
| my <u>was</u> oranje <u>eet</u> | I ate an orange
| my <u>sal</u> oranje <u>eet</u> | I will eat an orange
| my <u>al</u> oranje <u>eet</u> | I have eaten an orange
| my <u>was</u> oranje <u>al-eet</u> | I had eaten an orange
| my <u>sal</u> oranje <u>al-eet</u> | I will have eaten an orange
| my <u>sou</u> oranje <u>eet</u> | I would eat an orange

## Preposition
Formally there is no such thing as preposition in the language, but we have directional roots, like:
- **aan** - to
- **in** - in
- **by** - near, by
- ... etc.

That usually put in a context using the pattern: `om **preposition** **thing**`

Examples of usage:
- Jy <u>gee</u> bal om *aan my*? - Will you give the ball to me?
- My <u>sit</u> om *in huis* - I sit in the house
- Kat <u>sit</u> om *by my* - The cat sits near me

---
# Patterns
In order to make sentences more concise, there are some patterns
Pattern | Example | Translation
-- | -- | --
`[Noun] ...` | Kat | A cat
`te [Verb] ...` | Te <u>dink</u> | To think
`om [Ad] ...` | Om *oggend* | In the morning
`[Conjunction] [Noun] ...` | **Want** kat | Because of the cat
`... [Noun] an [Noun] ...` | Kat an dier | A cat is an animal
`... [Noun] an [Noun] ...` | Kat an dier | A cat is an animal
`... [Noun] [Verb] ...` | Kat <u>speel</u> | A cat plays
`... [Noun] om [Ad] ...` | Kat om *goed* | A good cat
`... [Verb] [Noun] ...` | Te <u>lief</u> sy | To love her/him
`... [Verb] te [Verb] ...` | Te <u>lief</u> te <u>speel</u> | To love to play 
`... [Verb] om [Ad] ...` | Te <u>leef</u> om *geluk* | To live happily
`... [Ad] an [Noun] ...` | Om *dit-dag* an my <u>werk</u> | Today I work
`... [Ad] te [Verb] ...` | Om *dit-dag* te <u>werk</u> | To work today
`... [Ad] [Ad] ...` | Om *dit-dag aand* | Today evening

---
# Vocabulary
Nut-taal is first of all a parsable grammar.
The dictionary is rather a dependency.

Having only one source language is preferable, because it allows us to use external dictionaries, in cases when the local dictionary is not exhaustive

At the moment Afrikaans is selected as a source of roots, because: 
- It is one of the simplest natural languages
- It is close to English, because it is also a Germanic language, but has much simpler vocabulary

---

# How to contribute
Even though you can already use the language for a communication, it is far from being perfect.
But the language is open source, so you can easily participate.

To issue a change in the language, go to "Issues" -> "New Issue" -> choose a template and press "Get started" or press "Open a blank issue"

💜
