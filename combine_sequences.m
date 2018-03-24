function full_seq = combine_sequences(sequences,rand_order)

%!!!!! NOTE: THIS FUNCTION ASSUMES THAT THE ITI **ACROSS** SEQUENCE IS CONSTANT

full_seq = sequences{1};
[full_seq.group] = deal(1);
iti = diff([full_seq(1:2).start]) - full_seq(1).duration;
start = full_seq(1).start;

% itis(1) = diff([full_seq(1:2).start]) - full_seq(1).duration;

for i = 2:length(sequences)
    [sequences{2}.group] = deal(i);
    full_seq = [full_seq sequences{2}];
%     itis(i) = diff([sequences{2}(1:2).start]) - sequences{2}(1).duration;
end

if rand_order
    
    new_order = randperm(length(full_seq));
    full_seq = full_seq(new_order);
    
end

% redo starts...
full_seq(1).start = start;
for i = 2:length(full_seq)
    full_seq(i).start = full_seq(i-1).start + iti + full_seq(i-1).duration;
end