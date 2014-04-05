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
//x = Synth("Oscar", ["freq", 110]);
//y = Synth("Oscar", ["freq", 220]);
//z = Synth("Oscar", ["freq", 440]);
//x.free; y.free; z.free;

(
	var midi, dur, myNotes, myRhythm;
	midi = Pseq([36, 43, 36, 43], 4).asStream;
	dur = Pseq([0.5], 16).asStream;
    myNotes = Pshuf([48, 48, 50, 50, 51, 51, 53, 53, 55, 55, 57, 57, 58, 58, 51, 51], 1).asStream;
    myRhythm = Pshuf([0.5], 16).asStream;

    SynthDef.new("Oscar", { |freq = 440, sustain = 1, amp = 0.5|
		    var sig;
		    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
		    Out.ar(0, sig ! 2)
     }).add;

	SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
		    var sig;
		    sig = SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
		    Out.ar(0, sig ! 2)
	}).add;

	r = Task({
		    var delta, delta2;
		    while {
			        delta = dur.next;
			        delta.notNil
		    } {
			        Synth(\smooth, [freq: midi.next.midicps, sustain: delta]);
		             Synth("Oscar", [freq: myNotes.next.midicps, sustain: delta/2]);
			        delta.yield;
		    }
	}).play(quant: TempoClock.default.beats + 1.0);



)


s.quit; // "ctrl + enter" to execute this & shut down the "server"
