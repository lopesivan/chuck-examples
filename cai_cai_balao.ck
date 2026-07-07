// Cai, Cai, Balão - Versão Otimizada com ADSR
// Instrumento: Oscilador Senoidal com Envelope de Amplitude (sem estalos)
SinOsc s => ADSR env => dac;

// Configuração do Envelope (Ataque, Decaimento, Sustentação, Relaxamento)
env.set(10::ms, 10::ms, 0.8, 50::ms);

// Matriz de notas (Escala de Dó Maior - MIDI)
[60, 62, 64, 65, 67, 69, 71, 72] @=> int notas[];

0 => int C;  // Do
1 => int D;  // Re
2 => int E;  // Mi
3 => int F;  // Fa
4 => int G;  // Sol
5 => int A;  // La
6 => int B;  // Si
7 => int C2; // Do agudo

// Função para tocar uma nota usando o envelope ADSR
fun void tecla(int nota, float dur)
{
    Std.mtof(notas[nota]) => s.freq;
    0.35 => s.gain;
    
    1 => env.keyOn;              // Ativa o som (suave)
    (dur - 0.04)::second => now; // Mantém a nota tocando
    
    1 => env.keyOff;             // Desativa o som (fade-out)
    0.04::second => now;         // Tempo para o som sumir naturalmente
}

// Tempo base de uma nota (semínima)
0.35 => float t;

// --- ESTRUTURA DA MÚSICA (Cai, Cai, Balão) ---

// Cai, cai, balão
tecla(G, t); tecla(A, t); tecla(G, t);
tecla(F, t); tecla(E, 2*t);

// Cai, cai, balão
tecla(G, t); tecla(A, t); tecla(G, t);
tecla(F, t); tecla(E, 2*t);

// Aqui na minha mão
tecla(G, t); tecla(G, t); tecla(F, t); tecla(E, t);
tecla(D, 2*t);

// Não cai não, não cai não, não cai não
tecla(D, t); tecla(E, t); tecla(F, t); tecla(D, t);
tecla(E, t); tecla(F, t); tecla(G, 2*t);

// Cai na rua do sabão
tecla(G, t); tecla(G, t); tecla(F, t); tecla(E, t);
tecla(D, t); tecla(E, t); tecla(C, 2*t);
