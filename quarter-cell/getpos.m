% go to position (x,y,z)
function [x,y,z]=getpos(s)

    fprintf(s,'%c','C');
    pause(0.1);
    if (s.BytesAvailable > 1)
        out= fread(s,s.BytesAvailable,'uint8');
        pause(0.1);
    end  
    [r,c]=size(out);
    x=(out(r-12)+out(r-11)*256+out(r-10)*256^2+out(r-9)*256^3)/16;
    y=(out(r-8)+out(r-7)*256+out(r-6)*256^2+out(r-5)*256^3)/16;
    z=(out(r-4)+out(r-3)*256+out(r-2)*256^2+out(r-1)*256^3)/16;
    
end