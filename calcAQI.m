function dataOut = calcAQI(dataIn)
    % Calculates the AQI value given a structure containing concentration
    % values for NO2, O3, SO2, and CO.
    NO2 = dataIn.NO2Mean;
    O3 = dataIn.O3Mean;
    SO2 = dataIn.SO2Mean;
    CO = dataIn.COMean;

    NO2Ranges = getRangeVals('NO2', NO2);
    O3Ranges = getRangeVals('O3', O3);
    SO2Ranges = getRangeVals('SO2', SO2);
    CORanges = getRangeVals('CO', CO);

    NO2AQI = calcIndivAQI(NO2Ranges(1), NO2Ranges(2), NO2Ranges(3), NO2Ranges(4), NO2);
    O3AQI = calcIndivAQI(O3Ranges(1), O3Ranges(2), O3Ranges(3), O3Ranges(4), O3);
    SO2AQI = calcIndivAQI(SO2Ranges(1), SO2Ranges(2), SO2Ranges(3), SO2Ranges(4), SO2);
    COAQI = calcIndivAQI(CORanges(1), CORanges(2), CORanges(3), CORanges(4), CO);

    dataOut = mean([NO2AQI, O3AQI, SO2AQI, COAQI]);
end


function AQI = calcIndivAQI(AQIHigh, AQILow, BPHigh, BPLow, conc)
    % Calculates the AQI value for an individual concentration value.
    if conc < 0
        conc = 0;
    end
    AQI = (((AQIHigh - AQILow) / (BPHigh - BPLow)) * (conc - BPLow)) + AQILow;
end

function ranges = getRangeVals(pollut, conc)
    % Returns an array of all range values required to calculate AQI.
    if isequal(pollut, 'NO2')
        conc = floor(conc);
        if conc <= 53
            BPHigh = 53;
            BPLow = 0;
            AQIHigh = 50;
            AQILow = 0;
        elseif conc >= 54 && conc <= 100
            BPHigh = 100;
            BPLow = 54;
            AQIHigh = 100;
            AQILow = 51;
        elseif conc >= 101 && conc <= 360
            BPHigh = 360;
            BPLow = 101;
            AQIHigh = 150;
            AQILow = 101;
        elseif conc >= 361 && conc <= 649
            BPHigh = 649;
            BPLow = 361;
            AQIHigh = 200;
            AQILow = 151;
        elseif conc >= 650 && conc <= 1249
            BPHigh = 1249;
            BPLow = 650;
            AQIHigh = 300;
            AQILow = 201;
        elseif conc >= 1250 && conc <= 1649
            BPHigh = 1649;
            BPLow = 1250;
            AQIHigh = 400;
            AQILow = 301;
        elseif conc >= 1650 && conc <= 2049
            BPHigh = 2049;
            BPLow = 1650;
            AQIHigh = 500;
            AQILow = 401;
        else
            error('NO2 concentration values cannot exceed the value of 2049.\n')
        end
    elseif isequal(pollut, 'O3')
        conc = floor(conc * 1000) / 1000;
        if conc <= 0.054
            BPHigh = 0.054;
            BPLow = 0;
            AQIHigh = 50;
            AQILow = 0;
        elseif conc >= 0.055 && conc <= 0.07
            BPHigh = 0.07;
            BPLow = 0.055;
            AQIHigh = 100;
            AQILow = 51;
        elseif conc >= 0.071 && conc <= 0.085
            BPHigh = 0.085;
            BPLow = 0.071;
            AQIHigh = 150;
            AQILow = 101;
        elseif conc >= 0.086 && conc <= 0.105
            BPHigh = 0.105;
            BPLow = 0.086;
            AQIHigh = 200;
            AQILow = 151;
        elseif conc >= 0.106 && conc <= 0.2
            BPHigh = 0.2;
            BPLow = 0.106;
            AQIHigh = 300;
            AQILow = 201;
        else
            error('O3 concentration values cannot exceed the value of 0.2.\n')
        end
    elseif isequal(pollut, 'SO2')
        conc = floor(conc);
        if conc <= 35
            BPHigh = 35;
            BPLow = 0;
            AQIHigh = 50;
            AQILow = 0;
        elseif conc >= 36 && conc <= 75
            BPHigh = 36;
            BPLow = 75;
            AQIHigh = 100;
            AQILow = 51;
        elseif conc >= 76 && conc <= 185
            BPHigh = 185;
            BPLow = 76;
            AQIHigh = 150;
            AQILow = 101;
        elseif conc >= 186 && conc <= 304
            BPHigh = 304;
            BPLow = 186;
            AQIHigh = 200;
            AQILow = 151;
        elseif conc >= 305 && conc <= 604
            BPHigh = 604;
            BPLow = 305;
            AQIHigh = 300;
            AQILow = 201;
        elseif conc >= 605 && conc <= 804
            BPHigh = 804;
            BPLow = 605;
            AQIHigh = 400;
            AQILow = 301;
        elseif conc >= 805 && conc <= 1004
            BPHigh = 1004;
            BPLow = 805;
            AQIHigh = 500;
            AQILow = 401;
        else
            error('SO2 concentration values cannot exceed the value of 1004.\n')
        end
    elseif isequal(pollut, 'CO')
        conc = floor(conc * 10) / 10;
        if conc <= 4.4
            BPHigh = 4.4;
            BPLow = 0;
            AQIHigh = 50;
            AQILow = 0;
        elseif conc >= 4.5 && conc <= 9.4
            BPHigh = 9.4;
            BPLow = 4.5;
            AQIHigh = 100;
            AQILow = 51;
        elseif conc >= 9.5 && conc <= 12.4
            BPHigh = 12.4;
            BPLow = 9.5;
            AQIHigh = 150;
            AQILow = 101;
        elseif conc >= 12.5 && conc <= 15.4
            BPHigh = 15.4;
            BPLow = 12.5;
            AQIHigh = 200;
            AQILow = 151;
        elseif conc >= 15.5 && conc <= 30.4
            BPHigh = 30.4;
            BPLow = 15.5;
            AQIHigh = 300;
            AQILow = 201;
        elseif conc >= 30.5 && conc <= 40.4
            BPHigh = 40.4;
            BPLow = 30.5;
            AQIHigh = 400;
            AQILow = 301;
        elseif conc >= 40.5 && conc <= 50.4
            BPHigh = 50.4;
            BPLow = 40.5;
            AQIHigh = 500;
            AQILow = 401;
        else
            error('CO concentration values cannot exceed the value of 50.4.\n')
        end
    end
    ranges = [AQIHigh, AQILow, BPHigh, BPLow];
end