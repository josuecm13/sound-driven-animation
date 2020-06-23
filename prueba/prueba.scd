SynthDef(\pulse,{
	var sig, chain, onsets;
	sig = SinOsc.ar(Rand(220.0,440.0))
	*EnvGen.ar(Env.perc(releaseTime:0.5),Dust.ar(0.5))*0.7;
	Out.ar(0,sig !2);
	//
	chain = FFT({LocalBuf(512, 1)}, sig);
	onsets = Onsets.kr(chain,0.1,\power);
	SendTrig.kr(onsets);
	SendPeakRMS.kr(sig, 20, 3, "/replyAddress");
}).add;
Synth(\pulse)

~host = NetAddr("localhost", 4859); // address de PROCESSING


o = OSCFunc({ arg msg, time;
	[time, msg].postln;
	~host.sendMsg("/trigger",42,12.34,"hello processing");
},'/tr', s.addr);

p = OSCFunc({ |msg|
	"peak: %, rms: %".format(msg[3], msg[4]).postln
}, '/replyAddress');