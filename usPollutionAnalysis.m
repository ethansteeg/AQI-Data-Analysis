% Generates an AQI vs. time plot based on given particle concentration data
% and user-given parameters.

fprintf('<strong>This program will summarize AQI data for a given location and time that you will soon\nchoose. Please wait as the menus take time to load.</strong>')

% Reads the table and converts it into a structure.

data = readtable("pollution_us_2000_2016.csv");
data = table2struct(removevars(data, ["Var1", "StateCode", "CountyCode", "SiteNum", "Address", "County", "NO2Units", "NO21stMaxValue", "NO21stMaxHour", "NO2AQI", "O3Units", "O31stMaxValue", "O31stMaxHour", "O3AQI", "SO2Units", "SO21stMaxValue", "SO21stMaxHour", "SO2AQI", "COUnits", "CO1stMaxValue", "CO1stMaxHour", "COAQI"]));


% Asks the user for a specific state/region, country, and year. The user
% can choose to include all or any of these parameters in the data.
states = {};

for i = 1:size(data, 1)
    stateCheck = data(i).State;

    if isempty(find(strcmp(states,stateCheck), 1))
        states{size(states,1) + 1, 1} = stateCheck;
    end
end
clear stateCheck;
states = sort(states);
states{size(states,1) + 1, 1} = 'All of the above';

fprintf('\n\n<strong>State/region:</strong> ')

stateData = states{menu('Pick a state/region:', states), 1};

fprintf('%s', stateData)

if ~isequal(stateData, 'All of the above')
    cities = {};
    
    for i = 1:size(data,1)
        if isequal(data(i).State, stateData)
            cityCheck = data(i).City;

            if isempty(find(strcmp(cities,cityCheck), 1)) && ~isequal(cityCheck, 'Not in a city')
                cities{size(cities,1) + 1, 1} = cityCheck;
            end
        end
    end
    clear cityCheck;
    
    cities = sort(cities);

    cities{size(cities, 1) + 1, 1} = 'All of the above';

    fprintf('\n\n<strong>City:</strong> ')
    
    cityData = cities{menu('Pick a city:', cities), 1};

    fprintf('%s', cityData);
else
    cityData = 'All of the above';
end


years = [];

for i = 1:size(data, 1)
    if isequal(data(i).State, stateData) || isequal(stateData, 'All of the above')
        if isequal(data(i).City, cityData) || isequal(cityData, 'All of the above')
            yearCheck = year(data(i).DateLocal);
        
            if isempty(find(years == yearCheck, 1))
                years(size(years,1) + 1, 1) = yearCheck;
            end
        end
    end
end
clear yearCheck;
years = table2cell(array2table(years));
years{size(years, 1) + 1, 1} = 'All of the above';

fprintf('\n\n<strong>Year:</strong> ')

yearData = years{menu('Pick the year of interest:', years)};

if isequal(class(yearData), 'double')
    fprintf('%d', yearData)
else
    fprintf('%s', yearData)
end

fprintf('\n\n<strong>Please wait as we generate your plot. This may take a few minutes... or hours...</strong>')


% Finds the first and last day of the days within the user-define
% parameters.
firstDay = [];
lastDay = [];

for i = 1:size(data, 1)
    if isequal(data(i).State, stateData) || isequal(stateData, 'All of the above')
        if isequal(data(i).City, cityData) || isequal(cityData, 'All of the above')
            if isequal(year(data(i).DateLocal),yearData) || isequal(yearData, 'All of the above')
                if isempty(firstDay) && isempty(lastDay)
                    firstDay = data(i).DateLocal;
                    lastDay = data(i).DateLocal;
                else
                    if daysact(firstDay, data(i).DateLocal) < 0
                        firstDay = data(i).DateLocal;
                    elseif daysact(lastDay, data(i).DateLocal) > 0
                        lastDay = data(i).DateLocal;
                    end
                end
            end
        end
    end
end

% Creates a cell array of indices for each day, where the index of each
% cell array is (x - 1) days from the first day of the data to be analyzed.
days = cell(1,daysact(firstDay, lastDay) + 1);

for i = 1:size(data, 1)
    if isequal(data(i).State, stateData) || isequal(stateData, 'All of the above')
        if isequal(data(i).City, cityData) || isequal(cityData, 'All of the above')
            if daysact(firstDay, data(i).DateLocal) >= 0 && daysact(lastDay, data(i).DateLocal) <= 0
                if isempty(days{daysact(firstDay, data(i).DateLocal) + 1})
                    days{daysact(firstDay, data(i).DateLocal) + 1} = i;
                else
                    days{daysact(firstDay, data(i).DateLocal) + 1}(size(days{daysact(firstDay, data(i).DateLocal) + 1}, 2) + 1) = i;
                end
            end
        end
    end
end

% Creates AQI data using the concentration data from the defined array of indices.
AQI = zeros(1, size(days, 2));

for i = 1:size(days, 2)
    if ~isempty(days{i})
        for j = 1:size(days{i}, 2)
            AQI(i) = AQI(i) + calcAQI(data(days{i}(j)));
        end
        AQI(i) = AQI(i) / size(days{i}, 2);
    end
end


% Creates a vector for each day between the first and last day to be
% plotted.
x = 1:size(AQI, 2);


% Clears AQI data of any zero values.
for i = size(AQI, 2):-1:1
    if isempty(days{i})
        AQI(i) = [];
        x(i) = [];
    end
end


% Plots the data.
plotColorCode(x, AQI, firstDay, lastDay, stateData, cityData)
%plot(x, AQI, '*')
%xlabel('Days')
%ylabel('AQI')
%title('AQI Analysis')
%axis([1 max(x) 0 (max(AQI) + 1)])


% Creates a matrix that can later be used to create a regression analysis
% function.
regressionData = zeros(2, length(AQI));
regressionData(1,:) = AQI;
regressionData(2,:) = x;

fprintf('\n\n<strong>If you would like to work with your data using the Regression Learner toolbox,\nyou may use the generated ''regressionData'' structure to do so.</strong>\n')