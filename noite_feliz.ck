// connect sine oscillator to D/A convertor (sound card)
SinOsc s => dac;

// 0   1   2   3   4   5   6   7   8   9   10  11  12  13
[  60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81, 83] @=> int notas[];
// Do  Re  Mi  Fa  Sol La  Si  Do  Re  Mi  Fa  Sol La  Si


fun void tecla(int i,  float t)
{
    // set frequencies
    Std.mtof(notas[i]) => s.freq;
    // allow 2 seconds to pass
    .4 => s.gain;
    (t*500)::ms => now;
}

fun void pausa(float t)
{
    .0 => s.gain;
    t::ms => now;
}

1 => float t;
10 => float p;
repeat(2) {
    tecla(4, t+.5*t); // Sol
    tecla(5, .5*t);   // Lá
    tecla(4, t);      // Sol

    pausa(p*2);
    tecla(2, 3*t);    // Mi
}

    tecla(8, 2*t); // Ré
    pausa(p*1);
    tecla(8, t); // Ré

    pausa(p*2);
    tecla(6, 3*t); // Si

    tecla(7, 2*t); // Dó
    tecla(7, t); // Dó

    tecla(4, 3*t); // Sol

    repeat(2) {
        tecla(5, 2*t);  // Lá
        pausa(p*1);
        tecla(5, t);    // Lá

        tecla(7, t+.5*t);    // Do
        tecla(6, .5*t);   // Si
        tecla(5, t);   // Lá

        tecla(4, t+.5*t); // Sol
        tecla(5, .5*t);   // Lá
        tecla(4, t);      // Sol

        pausa(p*2);
        tecla(2, 3*t);    // Mi
    }

    tecla(8, 2*t); // Ré
    pausa(p*1);
    tecla(8, t); // Ré

    tecla(10, t+.5*t); // Fa
    tecla(8, .5*t);    // Ré
    tecla(6, t);       // Si

    tecla(7, 3*t);  // Do

    tecla(9, 3*t);  // Mi


    tecla(7, t+.5*t);  // Do
    tecla(4, .5*t);  // Sol
    tecla(2, t);  // Mi


    tecla(4, t+.5*t);  // Sol
    tecla(3, .5*t);  // Fa
    tecla(1, t);  // Re

    tecla(0, 3*t);  // Do



