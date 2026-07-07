// terminator.ck (Mario Modern Remix Version)
// Baseado na lógica estrutural criada pelo usuário, atualizado para sonoridade moderna.

// ==========================================
// CADEIA DE ÁUDIO UPGRADED (SOM MODERNO)
// ==========================================

// Melodia Moderna (SuperSaw + Filtro + Eco)
SawOsc melody;
SawOsc melodyDetune; // Segundo oscilador para dar o efeito "gordo" de Synthwave
LPF melFilt => Delay melDelay => dac;
melody => melFilt;
melodyDetune => melFilt;

// Configuração do Eco da Melodia (Delay moderno)
0.2 => melDelay.gain;
250::ms => melDelay.delay;
melDelay => melDelay; // Feedback do eco

// Harmonia Moderna (SawOsc + Filtro)
SawOsc harmony;
SawOsc harmonyDetune;
LPF harFilt => dac;
harmony => harFilt;
harmonyDetune => harFilt;

// Filtros modernos (tiram o som "ardido" de videogame velho)
1200 => melFilt.freq;
1000 => harFilt.freq;

// Baixo Moderno (Sub-Bass limpo, profundo e encorpado)
SinOsc bass;
Gain bassGain => dac;
bass => bassGain;

// Bitcrusher original e bateria de ruído mantidos
class Bitcrusher extends Chugen
{
    fun float tick(float in)
    {
        return ((in * 8) $ int) / 8.0;
    }
}
Bitcrusher bits => bassGain;

LPF filt => Dyno crush => Gain g => dac;
Noise drums => filt;
int m;
int h;
int b;
int d;

// Sequência original de patterns da música do Mario
[7,0,1,0,1,2,3,2,4,2,3,2,4,5,6,5,7,0,1,0,1,8,9,8,10,8,9,8,10,5,6,5,7,8,9,8,10] @=> int seq[];

crush.compress();
0.001 => crush.thresh;
1.0 => crush.slopeBelow;
0.0 => crush.slopeAbove;
1::samp => crush.attackTime;
1::samp => crush.releaseTime;
37.5 => g.gain;

0 => int time1;
0 => int time2;
0 => int pattern;
0.12 => float gain; // Ganho ajustado para não saturar com osciladores duplos

1 => bass.gain;
0.0 => melody.gain;
0.0 => harmony.gain;
0.0 => bassGain.gain;
0.0 => drums.gain;

// ==========================================
// LOOP PRINCIPAL DO MOTOR DE ÁUDIO
// ==========================================
while (true)
{
    checkSqrNote(m , melody) => m;
    checkSqrNote(h , harmony) => h;
    checkTriNote();
    checkNoiNote();
    playPattern(seq[pattern]);
    735::samp => now;
    time1++;
    if (time1 / 3 > 47)
    {
        0 => time1;
        pattern++;
    }
    if (pattern == seq.size()) // Fim da música -> Loop recomeça no segundo padrão
    {
        1 => pattern;
    }
}

// ==========================================
// FUNÇÕES DE VERIFICAÇÃO E CONTROLE DE NOTAS (CORRIGIDA)
// ==========================================
fun int checkSqrNote(int amount, SawOsc osc) // Trocado de SqrOsc para SawOsc
{
    // Esta função controla os ganhos de forma suave
    if (amount == 7) { 0.5 * gain => osc.gain; }
    else if (amount == 6) { 0.4375 * gain => osc.gain; }
    else if (amount == 5) { 0.375 * gain => osc.gain; }
    else if (amount == 4) { 0.3125 * gain => osc.gain; }
    else if (amount == 2) { 0.25 * gain => osc.gain; }
    else if (amount != 3 && amount != 1) { 0.0 => osc.gain; }

    // Sincroniza o ganho do oscilador de detune para seguir o principal
    if (osc == melody) { osc.gain() => melodyDetune.gain; }
    if (osc == harmony) { osc.gain() => harmonyDetune.gain; }

    if (amount > 0) { 1 -=> amount; }
    return amount;
}
fun void checkTriNote()
{
    if (b == 8)
    {
        0.0 => bass.phase;
        gain => bassGain.gain;
    }
    else if (b < 1 || b > 8)
    {
        0.0 => bassGain.gain;
    }
    if (b > 0)
    {
        1 -=> b;
    }
}

fun void checkNoiNote()
{
    if (d > 0)
    {
        .75 * gain => drums.gain;
        1 -=> d;
    }
    else
    {
        0.0 => drums.gain;
    }
}

// ==========================================
// MAPEAMENTO E SELEÇÃO DOS PADRÕES (PATTERNS)
// ==========================================
fun void playPattern(int pat)
{
    if (pat == 0) { melody1a(); harmony1a(); bass1a(); drums1(); }
    else if (pat == 1) { melody1b(); harmony1b(); bass1b(); drums1(); }
    else if (pat == 2) { melody2a(); harmony2a(); bass2a(); drums1(); }
    else if (pat == 3) { melody2b(); harmony2b(); bass2b(); drums1(); }
    else if (pat == 4) { melody2c(); harmony2c(); bass2c(); drums1(); }
    else if (pat == 5) { melody3a(); harmony3a(); bass3a(); drums3(); }
    else if (pat == 6) { melody3b(); harmony3b(); bass3a(); drums3(); }
    else if (pat == 7) { melody3c(); harmony3c(); bass3b(); drums3(); }
    else if (pat == 8) { melody4a(); harmony4a(); bass4a(); drums4(); }
    else if (pat == 9) { melody4b(); harmony4b(); bass4b(); drums4(); }
    else if (pat == 10) { melody4c(); harmony4c(); bass4c(); drums4(); }
}

// ==========================================
// PADRÕES DE NOTAS DA MELODIA (MELODY)
// ==========================================
fun void melody1a() { melNote(0, 72); melNote(9, 67); melNote(18, 64); melNote(27, 69); melNote(33, 71); melNote(39, 70); melNote(42, 69); }
fun void melody1b() { melNote(0, 67); melNote(4, 76); melNote(8, 79); melNote(12, 81); melNote(18, 77); melNote(21, 79); melNote(27, 76); melNote(33, 72); melNote(36, 74); melNote(39, 71); }
fun void melody2a() { melNote(6, 79); melNote(9, 78); melNote(12, 77); melNote(15, 75); melNote(21, 76); melNote(27, 68); melNote(30, 69); melNote(33, 72); melNote(39, 69); melNote(42, 72); melNote(45, 74); }
fun void melody2b() { melNote(6, 79); melNote(9, 78); melNote(12, 77); melNote(15, 75); melNote(21, 76); melNote(27, 84); melNote(33, 84); melNote(36, 84); }
fun void melody2c() { melNote(6, 75); melNote(15, 74); melNote(24, 72); }
fun void melody3a() { melNote(0, 72); melNote(3, 72); melNote(9, 72); melNote(15, 72); melNote(18, 74); melNote(24, 76); melNote(27, 72); melNote(33, 69); melNote(36, 67); }
fun void melody3b() { melNote(0, 72); melNote(3, 72); melNote(9, 72); melNote(15, 72); melNote(18, 74); melNote(21, 76); }
fun void melody3c() { melNote(0, 76); melNote(3, 76); melNote(9, 76); melNote(15, 72); melNote(18, 76); melNote(24, 79); }
fun void melody4a() { melNote(0, 76); melNote(3, 72); melNote(9, 67); melNote(18, 68); melNote(24, 69); melNote(27, 77); melNote(33, 77); melNote(36, 69); }
fun void melody4b() { melNote(0, 71); melNote(4, 81); melNote(8, 81); melNote(12, 81); melNote(16, 79); melNote(20, 77); melNote(24, 76); melNote(27, 72); melNote(33, 69); melNote(36, 67); }
fun void melody4c() { melNote(0, 71); melNote(3, 77); melNote(9, 77); melNote(12, 77); melNote(16, 76); melNote(20, 74); melNote(24, 72); }

// ==========================================
// PADRÕES DE NOTAS DA HARMONIA (HARMONY)
// ==========================================
fun void harmony1a() { harNote(0, 64); harNote(9, 60); harNote(18, 55); harNote(27, 60); harNote(33, 62); harNote(39, 61); harNote(42, 60); }
fun void harmony1b() { harNote(0, 60); harNote(4, 67); harNote(8, 71); harNote(12, 72); harNote(18, 69); harNote(21, 71); harNote(27, 69); harNote(33, 64); harNote(36, 65); harNote(39, 62); }
fun void harmony2a() { harNote(6, 76); harNote(9, 75); harNote(12, 74); harNote(15, 71); harNote(21, 72); harNote(27, 64); harNote(30, 65); harNote(33, 67); harNote(39, 60); harNote(42, 64); harNote(45, 65); }
fun void harmony2b() { harNote(6, 76); harNote(9, 75); harNote(12, 74); harNote(15, 71); harNote(21, 72); harNote(27, 77); harNote(33, 77); harNote(36, 77); }
fun void harmony2c() { harNote(6, 68); harNote(15, 65); harNote(24, 64); }
fun void harmony3a() { harNote(0, 68); harNote(3, 68); harNote(9, 68); harNote(15, 68); harNote(18, 70); harNote(24, 67); harNote(27, 64); harNote(33, 64); harNote(36, 60); }
fun void harmony3b() { harNote(0, 68); harNote(3, 68); harNote(9, 68); harNote(15, 68); harNote(18, 70); harNote(21, 67); }
fun void harmony3c() { harNote(0, 66); harNote(3, 66); harNote(9, 66); harNote(15, 66); harNote(18, 66); harNote(24, 71); harNote(36, 67); }
fun void harmony4a() { harNote(0, 72); harNote(3, 69); harNote(9, 64); harNote(18, 64); harNote(24, 65); harNote(27, 72); harNote(33, 72); harNote(36, 65); }
fun void harmony4b() { harNote(0, 67); harNote(4, 77); harNote(8, 77); harNote(12, 77); harNote(16, 76); harNote(20, 74); harNote(24, 72); harNote(27, 69); harNote(33, 65); harNote(36, 64); }
fun void harmony4c() { harNote(0, 67); harNote(3, 74); harNote(9, 74); harNote(12, 74); harNote(16, 72); harNote(20, 71); harNote(24, 67); harNote(27, 64); harNote(33, 64); harNote(36, 60); }

// ==========================================
// PADRÕES DE NOTAS DO BAIXO (BASS)
// ==========================================
fun void bass1a() { basNote(0, 55); basNote(9, 52); basNote(18, 48); basNote(27, 53); basNote(33, 55); basNote(39, 54); basNote(42, 53); }
fun void bass1b() { basNote(0, 52); basNote(4, 60); basNote(8, 64); basNote(12, 65); basNote(18, 62); basNote(21, 64); basNote(27, 60); basNote(33, 57); basNote(36, 59); basNote(39, 55); }
fun void bass2a() { basNote(0, 48); basNote(9, 55); basNote(18, 60); basNote(24, 53); basNote(33, 60); basNote(36, 60); basNote(42, 53); }
fun void bass2b() { basNote(0, 48); basNote(9, 52); basNote(18, 55); basNote(21, 60); basNote(27, 79); basNote(33, 79); basNote(36, 79); basNote(42, 55); }
fun void bass2c() { basNote(0, 48); basNote(6, 56); basNote(15, 58); basNote(24, 60); basNote(33, 55); basNote(36, 55); basNote(42, 48); }
fun void bass3a() { basNote(0, 44); basNote(9, 51); basNote(18, 56); basNote(24, 55); basNote(33, 48); basNote(42, 43); }
fun void bass3b() { basNote(0, 50); basNote(3, 50); basNote(9, 50); basNote(15, 50); basNote(18, 50); basNote(24, 67); basNote(36, 55); }
fun void bass4a() { basNote(0, 48); basNote(9, 54); basNote(12, 55); basNote(18, 60); basNote(24, 53); basNote(30, 53); basNote(36, 60); basNote(39, 60); basNote(42, 53); }
fun void bass4b() { basNote(0, 50); basNote(9, 53); basNote(12, 55); basNote(18, 59); basNote(24, 55); basNote(30, 55); basNote(36, 60); basNote(39, 60); basNote(42, 55); }
fun void bass4c() { basNote(0, 55); basNote(9, 55); basNote(12, 55); basNote(16, 57); basNote(20, 59); basNote(24, 60); basNote(30, 55); basNote(36, 48); }

// ==========================================
// PADRÕES DE BATERIA (DRUMS)
// ==========================================
fun void drums1() { druNote(0, 0); druNote(6, 1); druNote(10, 1); druNote(12, 2); druNote(18, 1); druNote(22, 1); druNote(24, 0); druNote(30, 1); druNote(34, 1); druNote(36, 2); druNote(42, 1); druNote(46, 1); }
fun void drums3() { druNote(0, 2); druNote(6, 1); druNote(9, 2); druNote(15, 1); druNote(18, 2); druNote(24, 2); druNote(33, 2); druNote(39, 1); druNote(42, 1); druNote(45, 1); }
fun void drums4() { druNote(0, 1); druNote(9, 1); druNote(12, 2); druNote(18, 1); druNote(24, 1); druNote(33, 1); druNote(36, 2); druNote(42, 1); }

// ==========================================
// TRIGGERS INTERNOS DE SINALIZAÇÃO DE NOTAS
// ==========================================
fun void melNote(int t, int val)
{
    if (time1 == t * 3)
    {
        if (val >= 0 && val < 128)
        {
            Std.mtof(val) => melody.freq;
            Std.mtof(val) + 1.5 => melodyDetune.freq; // Desafinação analógica / Chorus moderno
            8 => m;
        }
    }
}

fun void harNote(int t, int val)
{
    if (time1 == t * 3)
    {
        if (val >= 0 && val < 128)
        {
            Std.mtof(val) => harmony.freq;
            Std.mtof(val) - 1.5 => harmonyDetune.freq; // Desafinação analógica / Chorus moderno
            8 => h;
        }
    }
}

fun void basNote(int t, int val)
{
    if (time1 == t * 3)
    {
        if (val >= 0 && val < 128)
        {
            Std.mtof(val) => bass.freq;
            8 => b;
        }
    }
}

fun void druNote(int t, int val)
{
    if (time1 == t * 3)
    {
        if (val == 0) { 1 => d; 900 => filt.freq; 3 => filt.Q; }
        else if (val == 1) { 1 => d; 20000 => filt.freq; 0.01 => filt.Q; }
        else if (val == 2) { 4 => d; 20000 => filt.freq; 0.01 => filt.Q; }
    }
}

