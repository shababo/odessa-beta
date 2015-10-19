function data = io(s, output)

s.queueOutputData(output);
data = s.startForeground();