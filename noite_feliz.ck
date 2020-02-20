// connect sine oscillator to D/A convertor (sound card)
SinOsc s => dac;

// volume em 40%
.4 => s.gain;

// 0   1   2   3   4   5   6   7   8   9   10  11  12  13
[  60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83] @=> int notas[];
// Do  Re  Mi  Fa  Sol La  Si  Do  Re  Mi  Fa  Sol La  Si


fun void tecla(int i,  float t)
{
    // set frequencies
    Std.mtof(notas[i]) => s.freq;
    // allow 2 seconds to pass
    t::second => now;
}

repeat(2) {
    tecla(4, 1); // Sol
    tecla(5, .4); // Lá
    tecla(4, .4); // Sol
    tecla(2, 1);  // Mi
}

tecla(8, .8); // Ré
tecla(8, .7); // Ré
tecla(6, 1); // Si
tecla(7, .4); // Do
tecla(7, .4); // Do
tecla(4, 1); // Sol
