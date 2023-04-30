# taal
> A constructed language that is parsable by both computer and human

### A taste of the language:
## [Try it out](https://mikeskoe.github.io/code-ish-app/)
maklik-taal | English 
-- | --
my <u>lief</u> dit <u>doen</u> | I like to do this
dit a kat e *my klein mooi* | This is my small beutiful cat
e *dit-dag* a dit <u>wil</u> i <u>speel</u> **met** jy | Today, he wants to play with you

---
## Grammar
### Low level
The language have three low-level language units:
- [Root](#Root) - a building block of the language
- [Mark](#Mark) - explains if the root a noun, verb or an ad (a modificator)
- [Particle](#Particle) - introduces a [phrases](#Phrase), to make sentences richer

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

There are some cases, where the mark should be dropped.
See [patterns](#patterns)

#### **Particle**
Placed before a [phrase](#Phrase).
Examples of particles could be words like:
- **want** - because
- **in** - in
- **vir** - to/for

---
### Middle level
Words are middle level units.
They consist of roots and marks and can have three states: **noun**, **verb** and **ad**

#### Patterns
Noun | Verb | Ad
-- | -- | --- 
`a *` | `i *` | `e *`
`[BEGINING OF THE SENTENCE] *` | `[NOUN] *` | `[AD] *`
`[PARTICLE] *` ||
`[VERB] *` ||

---
### High level
#### Phrase
The phrase is a cluster of words.

#### Subject
The first noun in a phrase

#### Infinitive
The second verb in a phrase

#### Object
The second noun in a phrase

---
## Vocabulary
Ideally every root should meen something be it a noun, verb or ad, as long as it clear and makes sence.
Therefore related words could be collapsed to a single root.
For example a root `vraag` could mean **question** as a noun, **to ask** as a verb and **curious/curiously** as an ad.

At the same time, to prevent ambiguity, a single root should not cover too wide range or meanings.
The dictionary should be optimised, not limited.
Additionally there should not be a root, like English **like**, that could mean **alike** and **to love**, since these are two completely different meanings

The dictionary also includes some compound roots, whose meanings may be not clear, but they form commonly used words.

### Why Afrikaans?
> The dictionary is not tightly coupled with the language.
It is rather a dependency.

At the moment all roots come from Afrikaans.
I did it for few reasons:
- I think it is better to have only one source of roots.
It builds more predictable intuition about the dictionary.
Plus there will always be someone who does not know a single word in any possible conlang
- It one of the simples natural languages.
It is a simplified Dutch, which is a Germanic language (like German and English), located at Africa!
- It is much simpler to read and pronounce than English, since spelling is regular
