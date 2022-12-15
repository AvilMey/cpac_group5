~n1 = NetAddr.new("127.0.0.1", 12000);

MIDIClient.init;

MIDIIn.connectAll;


(

~notes = Array.newClear(128);
~notesA = Array2D.new(rows: 3, cols: 128);


MIDIdef.noteOn(\noteOnctrl, {
	arg vel, nn;
	[vel, nn].postln;
    //create and store synths for each note
	~notes[nn] = Synth.new( \tone, [ \freq, nn.midicps, \amp, vel.linexp(1,127,0.01,0.3), \gate, 1,]
	);
	~notesA[0,nn] = vel;
	~notesA[1,nn] = nn;
	~notesA[2,nn] = TempoClock.new;


});



MIDIdef.noteOff(\noteOffctrl, {
	/*in this function i will address the synth at the correct index corresponding to its notenumber and set the gate argument of that synth to 0. Then replace the synth with a nil value, like that synth was never there*/
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
	~notesA[2,nn] = ~notesA[2,nn].beats;
	~notesA[2,nn].stop;
	[~notesA[0,nn].linlin(0,127,0,255), ~notesA[1,nn], ~notesA[2,nn]].postln;

	//send message
	~n1.sendMsg(
		'/test', ~notesA[0,nn].linlin(0,127,0,255).asFloat, ~notesA[1,nn]%12, (~notesA[2,nn].asFloat)*100

);
});
)

(
SynthDef.new(\tone, {
	arg freq=440, amp=0.3, gate=0;
	var sig, env;
	sig = LFTri.ar(freq)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

o = Server.default.options;
o.inDevice_("Windows WASAPI : Microphone");
o.outDevice_("Windows WASAPI : Speakers");
Server.default.reboot;





