function voltage = get_voltage(lut,output)

voltage = lut(1,find(lut(2,:) <= output,1,'last'));