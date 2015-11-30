% go to position (x,y,z)
function gotopos(s,x,y,z)
    
    % convert target position in um to step moter microstep
    x=(x*16);
    y=(y*16);
    z=(z*16);
    i=1;
    xc=uint8([0 0 0 0]);% microstep represented by bytes
    while (x>0)
        xc(i)=uint8(mod(x,16^2));
        x=floor(x/(16^2));
        i=i+1;
    end
    yc=uint8([0 0 0 0]);% microstep represented by bytes
    i=1;
    while (y>0)
        yc(i)=uint8(mod(y,16^2));
        y=floor(y/(16^2));
        i=i+1;
    end
    zc=uint8([0 0 0 0]);% microstep represented by bytes
    i=1;
    while (z>0)
        zc(i)=uint8(mod(z,16^2));
        z=floor(z/(16^2));
        i=i+1;
    end

    fwrite(s, uint8(['M' xc(1) xc(2) xc(3) xc(4) yc(1) yc(2) yc(3) yc(4) zc(1) zc(2) zc(3) zc(4)]))% fast move command    
end