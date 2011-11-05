Prerequisites
=============

You need to install Pandoc, a Markdown to TeX/HTML/etc. processor.
                                           
On Debian / Ubuntu:

    $ apt-get install pandoc
    
On Mac OS X:

    $ brew install cabal-install
    $ cabal install pandoc

(you will probably need to fiddle with your PATH afterwards, in my case I'm adding `$HOME/.cabal/bin` to it in my `.profile`).

How to build
============

Type "make".

How to commit
=============

To make it easier to access the deliverables, the PDF are stored in Git.

So type "make ; make clean" before commit and that should do it.