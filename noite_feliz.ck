// connect sine oscillator to D/A convertor (sound card)
SinOsc s => dac;

// volume em 40%
.4 => s.gain;

//   0   1   2   3   4   5   6   7   8   9   10  11  12  13
//[  60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83] @=> int notas[];
//   Do  Re  Mi  Fa  Sol La  Si  Do  Re  Mi  Fa  Sol La  Si

[ 67,  69,  67,  64,  67,  69, 67, 64, 74] @=> int   n[];
[ 1.,  .4,  .4,  1.,  1.,  .4, .4, 1.,  1] @=> float f[];

for(0 => int i; i<n.cap();i++)
{
    Std.mtof(n[i]) => s.freq;
    f[i]::second => now;
}
