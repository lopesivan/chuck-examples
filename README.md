==[[ChucK]] Record==

Here is a brief tutorial on writing to disk...

==recording your ChucK session to file is easy!==

example:  you want to record the following:

    > chuck foo.ck bar.ck

all you's got to do is ChucK a shred that writes to file:

    > chuck foo.ck bar.ck [http://chuck.cs.princeton.edu/doc/examples/basic/rec.ck rec.ck]

no changes to existing files are necessary.
an example rec.ck can be found in examples/, this
guy/gal writes to "foo.wav".  edit the file to change.
if you don't want to worry about overwriting the same
file everytime, you can:

    > chuck foo.ck bar.ck [http://chuck.cs.princeton.edu/doc/examples/basic/rec-auto.ck rec-auto.ck]

rec-auto.ck will generate a file name using the current
time.  You can change the prefix of the filename by

    "data/session" => w.autoPrefix;

w is the WvOut in the patch.

Oh yeah, you can of course chuck the rec.ck on-the-fly...

from terminal 1
    > chuck --loop

from terminal 2
    > chuck + rec.ck


==silent mode==

you can write directly to disk without having real-time audio
by using --silent or -s

    > chuck foo.ck bar.ck rec-auto.ck -s

this will not synchronize to the audio card, and will generate
samples as fast as it can.


==start and stop==

you can start and stop the writing to file by:

    1 => w.record;  // start
    0 => w.record;  // stop

as with all thing ChucKian, this can be done
sample-synchronously.


==another halting problem==

what if I have infinite time loop, and want to terminate
the VM, will my file be written out correctly?  the answer:

Ctrl-C works just fine.

ChucK STK module keeps track of open file handles and
closes them even upon abnormal termination, like Ctrl-C.
Actually for many, Ctrl-C is the natural way to end your
ChucK session.  At any rate, this is quite ghetto, but it works.
As for seg-faults and other catastrophic events, like computer
catching on fire from ChucK exploding, the file probably is
toast.

hmmmm, toast...


==the silent sample sucker strikes again==

as in rec.ck, one patch to write to file is:

    dac => gain g => WvOut w => blackhole;

the blackhole drives the WvOut, which in turns sucks
samples from gain and then the dac.  The WvOut
can also be placed before the dac:

    noise n => WvOut w => dac;

The WvOut writes to file, and also pass through the incoming samples.


==post your files online==

[[ChucK/Sounds]]
