assignin_base({'isGetStageLocation'},{1})
pause(3)
currX = evalin('base','currentStageX');
currY = evalin('base','currentStageY');
currZ = evalin('base','currentStageZ');
move_dist = 25;
test_offsets = [0   0   0
                move_dist 0 0
                -move_dist 0 0
                0 move_dist 0
                0 -move_dist 0];
            
obj_locations = bsxfun(@plus,test_offsets,[currX currY currZ]);

order1 = randperm(size(obj_locations,1))
images = cell(size(obj_locations,1)+1,1);
for ii = 1:size(obj_locations,1)
    
%     i = order1(ii);
    i = ii;
    vars{1} = obj_locations(i,1);
    names{1} = 'theNewX';
    vars{2} = obj_locations(i,2);
    names{2} = 'theNewY';
    vars{3} = obj_locations(i,3);
    names{3} = 'theNewZ';
    %             vars{4} = 1;
    %             names{4} = 'isMoveStageAbsolute';
    assignin_base(names,vars);
    evalin('base','move_stage_absolute')
    pause(3)
    
    wrndlg = warndlg('Hole made?');
    pos = get(wrndlg,'position');
    set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
    waitfor(wrndlg)
    take_snap
    pause(1)
%     pause(2)
    images{i} = temp;
end
vars{1} = obj_locations(1,1);
names{1} = 'theNewX';
vars{2} = obj_locations(1,2);
names{2} = 'theNewY';
vars{3} = obj_locations(1,3);
names{3} = 'theNewZ';
%             vars{4} = 1;
%             names{4} = 'isMoveStageAbsolute';
assignin_base(names,vars);
evalin('base','move_stage_absolute')
pause(3)
take_snap
pause(1)
images{end+1} = temp;
%%
order2 = randperm(size(obj_locations,1))
for ii = 1:size(obj_locations,1)
    i = order2(ii)
    vars{1} = obj_locations(i,1);
    names{1} = 'theNewX';
    vars{2} = obj_locations(i,2);
    names{2} = 'theNewY';
    vars{3} = obj_locations(i,3);
    names{3} = 'theNewZ';
    %             vars{4} = 1;
    %             names{4} = 'isMoveStageAbsolute';
    assignin_base(names,vars);
    evalin('base','move_stage_absolute')
    pause(3)
    
    take_snap
    pause(2)
    images2{i} = temp;
end
figure
for i = 1:length(images1)
    subplot(length(images1),3,(i-1)*3+1)
    imagesc(images1{i})
    subplot(length(images1),3,(i-1)*3+2)
    imagesc(images2{i})
    subplot(length(images1),3,(i-1)*3+3)
    imagesc(abs(images1{i} - images2{i}))
end

%%
for i = 1:20
    vars{1} = obj_locations(2,1);
    names{1} = 'theNewX';
    vars{2} = obj_locations(2,2);
    names{2} = 'theNewY';
    vars{3} = obj_locations(2,3);
    names{3} = 'theNewZ';
    %             vars{4} = 1;
    %             names{4} = 'isMoveStageAbsolute';
    assignin_base(names,vars);
    evalin('base','move_stage_absolute')
    pause(3)
    
    take_snap
    pause(2)
    images{i,1} = temp;
    
    vars{1} = obj_locations(4,1);
    names{1} = 'theNewX';
    vars{2} = obj_locations(4,2);
    names{2} = 'theNewY';
    vars{3} = obj_locations(4,3);
    names{3} = 'theNewZ';
    %             vars{4} = 1;
    %             names{4} = 'isMoveStageAbsolute';
    assignin_base(names,vars);
    evalin('base','move_stage_absolute')
    pause(3)
    
    take_snap
    pause(2)
    images{i,2} = temp;
    
end

%%

% show hologram and mark it

% move objective over reference mark

% compute objective move

% recreate and test?

%%

loc_inds = [543   537   359   736   224    61];

for i = 1:length(loc_inds)
    
    
    wrndlg = warndlg('Hole under zero order?');
    pos = get(wrndlg,'position');
    set(wrndlg,'position',[0 1000 pos(3) pos(4)]);
    waitfor(wrndlg)
    
    isSnapImage = 1
    
    assignin_base({'isGetStageLocation'},{1})
    pause(3)
    obj_pos(i,:) = [evalin('base','currentStageX') evalin('base','currentStageY') evalin('base','currentStageZ')];

    pause(1)
    
end
