# About

Please notes that the following are intended as ‘checkpoints,’ they represent the minimal set of things we wish to say, however we’ll need to add our own linkages to make these things naturally flow together. This is the skeleton; when talking we’ll need to add the rest of the meat.

# Script

## Introduction

* Hello! Marco and I will be giving you an update of what’s been going on in the world of Scriptlets, along with some pretty exciting news
- Today we’ll be covering
    * what’s the problem?
    * what’s our solution?
    * what’s next?
- First up, let’s discuss the problem we’re trying to solve
- As it stands, config is not fun
    - It may be repetitive
    - Some parts may only apply in certain conditions
    - You essentially only have a drop-down list of pre-defined behaviours, if you want something else, pray there’s a nice extension system
- The common solution to help remedy this is to introduce programming concepts
    - We can now deal with repetition
    - We can now deal with conditional configuration
    - ... but we’re still stuck with the same drop-down list of behaviours, that hasn’t changed much
    - ... and what’s more, this is a complete mess!
- What went wrong is that programming concepts don’t really belong in declarative formats
- Let’s go back to square one---we want programming concepts, so let’s start with a programming language and work up from there
- Not just any programming language will do, what we want is _configuration,_ which is a subset of general purpose programming. In particular, we want the following properties:
    - Lightweight---reading a yaml file is pretty much instantaneous, so should running our config scripts
    - Domain-specific---we want to be closely tied to the system we’re configging, giving the user greater control
    - Deterministic---randomness would be a massive headache, so we don’t want that
    - Constrained---can’t use consume too many resources, that is, it is safe to run this
    - Advisory---not a script, output is a bunch of _requests,_ just like with regular config
- These are the properties, what have we made to implement these?
    - For the vast majority of cases, we will use an events+observers model which we expect to cover >95% of cases.  In some _very rare_ exceptions, a more script-like model may work, but let’s sit down for that one
    - (Step through the on-screen example)
- These scriptlets are written in Starlark, which is a minimalist Python dialect which allows only limited access to the host, essentially _we_ have tight control over what a scriptlet-writer has access to
- So that’s all good then...? Right? ...well not really... even if we restrict what can be accessed, if we were to use upstream Starlark, we’d have no way of making sure that one user’s script doesn’t use all our resources
- What’s worse is that it seems to be impossible...
- Before we continue, I just want to introduce another character in our cast... `alandonovan`
- `alandonovan` is the maintainer of upstream Starlark and author of The Go Programming Language
- `alandonovan` believes that it’s impossible to implement this kind of resource bounding
- `alandonovan` has said this on several occasions
- `alandonovan` _is_ very talented, and he’s not the only one who didn’t think this isn’t possible in Go
- But we did it anyway!
- ...well sort of, there are some constraints, but it’s faaaar better than nothing!
- We’ve implemented _best-effort safety-constraining_ for Starlark
    - It’s best effort in that we can’t provide guarantees alone, if juju exposes some functionality, it’s also up to juju to make this safe (although we have nice structures to help with this)
    - This is all best-effort, perfection is infeasible
    - As a result, we did _safety_ not _security,_ what we do here isn’t as tight as security we added constraints but writing your passwords in Starlark is _still_ a bad idea! We to not provide these extra-strong guarantees which security demands
    - We made _constraints_ that is, we’ll stop your programs running for ever and taking up too many resources
- So how did we do this? We identified a bunch of safety aspects, we say that a piece of functionality is
    - MemSafe---(took about 14 months) if it accounts for all memory it uses (if 10Mb are to be allocated for a list, first must check whether there’s room in the budget)
    - CPUSafe---(took about 6 months) if it accounts for the amount of work it does (if it iterates through 10K items in a list, it checks whether 10K steps can be performed within budget)
    - TimeSafe---(took 2 weeks) it doesn’t take too long, and if it does, it doesn’t take long to shut down when told to (can’t hang!)
    - IOSafe---(took 2 days) makes no access outside of the sandbox (e.g. can’t access the user’s home dir and start deleting files)
- This essentially creates a contract, we specify what safeties we care about, then all code has to declare that it abides by those safeties. This effectively means that we safety do ‘arbitrary code execution’
- By carefully abiding by these safeties
- If this sounds at all daunting, don’t worry---we’re here to help
    - We provide a test framework so your teams can check that their work is indeed safe, in our cooperative spirit. We make tools to make problems obvious, but it’s up to our own honesty not to merge obviously-problematic things!
    - We’ll be running recurring workshops starting in Madrid
    - We’re working on comprehensive documentation to detail what we’ve done as simply as possible
- These safetes are all now implemented for the entirety of the starlark standard library (excluding parts we’ll never use), now it’s just up to your coders to make use of these when introducing their own functionality
- But wait! Before you direct your teams to make use of this there’s one more thing we need to do first
    - The script we showed earlier isn’t just Starlark, it’s a particular _form_ of Starlark. To create script interfaces in this form, we’ve been working on a link library which your projects will use. The name of this library is `starform`
    - The previous work on Starlark took two years because it was hard, highly-technical, exploratory work
    - The work we need to do on `starform` is not difficult, it’s just designing and exposing a good, clean API
    - We’re already a good way into creating this library, having made a good start, we don’t expect this work to be more than a few months before it’s in a state ready for release
    - What that means---before the end of next cycle, you will be able to start implementing your own Scriptlet APIs, and will be able to finally unleash the true power of config! :D
- So now the question remains, how will you use this new-found power?
