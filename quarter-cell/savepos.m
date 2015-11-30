% save position (x,y,z)
function savepos(x,y,z)
    global defpos
    [r,c]=size(defpos);
    defpos(r+1,1)=x;
    defpos(r+1,2)=y;
    defpos(r+1,3)=z;
end