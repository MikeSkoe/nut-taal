# **nut-taal**
> An auxiliary constructed language that is parsable by both computer and human. Inspired by [mini](https://minilanguage.com)

# [Try it out](https://mikeskoe.github.io/nut-taal/)
<img src="https://i.imgur.com/lW0KuI5.gif">

# A taste of the language:
Nut-taal | English 
-- | --
My <u>lief</u> dit <u>doen</u> | I <u>like</u> to <u>do</u> this
Dit <u>is</u> kat e *my klein mooi* | This is my *small beutiful* cat
E *gister* a sy <u>wil</u> i <u>speel</u> **met** jy | *Today*, he <u>wants</u> to <u>play</u> **with** you

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
- **a** - introduces a noun [word](#word)
- **i** - introduces a verb [word](#word)
- **e** - introduces a descriptor [word](#word)

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
`a` + `root`

Example:
- **Speel** - A game

#### **Verb** (An action)
`i` + `root`

Example: 
- **I Speel** - To play

#### **Ad** (A description)
Adjective: `Noun` + `e` + `root`

Example:
- **Kat e speel** - The playful cat

Adverb: `Verb` + `e` + `root`

Example:
- **I leer e speel** - To learn playfully

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
Formally there is no such thing as preposition in the language, but we have directional words, like:
- **aan** - to
- **in** - in
- **by** - near, by

That usually put in a context using the pattern: `e **preposition** **thing**`

Examples of usage:
- Jy <u>gee</u> bal e *aan my*? - Will you give the ball to me?
- My <u>sit</u> e *in huis* - I sit in the house
- Kat <u>sit</u> e *by my* - The cat sits near me

---
# Patterns
In order to make sentences more concise, there are some patterns
Pattern | Example | Translation
-- | -- | --
`[Noun] ...` | Kat | A cat
`i [Verb] ...` | I <u>dink</u> | To think
`e [Ad] ...` | E *oggend* | In the morning
`[Conjunction] [Noun] ...` | **Want** kat | Because of the cat
`... [Noun] a [Noun] ...` | Kat a dier | A cat is an animal
`... [Noun] a [Noun] ...` | Kat a dier | A cat is an animal
`... [Noun] [Verb] ...` | Kat <u>speel</u> | A cat plays
`... [Noun] e [Ad] ...` | Kat e *goed* | A good cat
`... [Verb] [Noun] ...` | I <u>lief</u> sy | To love her/him
`... [Verb] i [Verb] ...` | I <u>lief</u> i <u>speel</u> | To love to play 
`... [Verb] e [Ad] ...` | I <u>leef</u> e *geluk* | To live happily
`... [Ad] a [Noun] ...` | E *dit-dag* a my <u>werk</u> | Today I work
`... [Ad] i [Verb] ...` | E *dit-dag* i <u>werk</u> | To work today
`... [Ad] [Ad] ...` | E *dit-dag aand* | Today evening

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
