// Click on any line and press ctrl-enter (the enter above right-shift) to execute that line.
s = Server.default.boot

s.boot; // Or press "ctrl + B" to start server

f = { "Function evaluated".postln; };

f;

(
"Call me,".postln;
"Ishmael.".postln;
)


//{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.1)] }.play;

SynthDef.new("Oscar", { arg freq = 440; Out.ar(0, SinOsc.ar(freq, 0, 0.2))}; ).add;
x = Synth("Oscar", ["freq", 110]);
y = Synth("Oscar", ["freq", 220]);
z = Synth("Oscar", ["freq", 440]);
x.free; y.free; z.free;

(
var midi, dur;
midi = Pseq([60, 72, 71, 67, 69, 71, 72, 60, 69, 67], 1).asStream;
dur = Pseq([2, 2, 1, 0.5, 0.5, 1, 1, 2, 2, 3], 1).asStream;

SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
    var sig;
    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
    Out.ar(0, sig ! 2)
}).add;

r = Task({
    var delta;
    while {
        delta = dur.next;
        delta.notNil
    } {
        Synth(\smooth, [freq: midi.next.midicps, sustain: delta]);
        delta.yield;
    }
}).play(quant: TempoClock.default.beats + 1.0);
)


s.quit; // "ctrl + enter" to execute this & shut down the "server"
