function plotColorCode(x, y, firstDay, lastDay, state, city)
    % Plots AQI data and color-codes the data points based on their
    % corresponding range.
    greenX = [];
    greenY = [];
    yellowX = [];
    yellowY= [];
    orangeX = [];
    orangeY = [];
    redX = [];
    redY = [];

    maxAQI = 0;

    for i = 1:length(y)
        if y(i) >= 0 && y(i) <= 50
            greenX(size(greenX, 2) + 1) = x(i);
            greenY(size(greenY, 2) + 1) = y(i);
        elseif y(i) > 50 && y(i) <= 100
            yellowX(size(yellowX, 2) + 1) = x(i);
            yellowY(size(yellowY, 2) + 1) = y(i);
        elseif y(i) > 100 && y(i) <= 150
            orangeX(size(orangeX, 2) + 1) = x(i);
            orangeY(size(orangeY, 2) + 1) = y(i);
        else
            redX(size(redX, 2) + 1) = x(i);
            redY(size(redY, 2) + 1) = y(i);            
        end

        if y(i) > maxAQI
            maxAQI = y(i);
        end
    end

    clf
    hold on
    set(gca,'Color','k')
    plot(greenX, greenY, '*g')
    plot(yellowX, yellowY, '*y')
    plot(orangeX, orangeY, '*', 'Color', '#FFA500')
    plot(redX, redY, '*r')
    axis([0, x(size(x, 2)), 0, max(y) + 2])
    xlabel(sprintf('Days (%d/%d/%d - %d/%d/%d)', month(firstDay), day(firstDay), year(firstDay), month(lastDay), day(lastDay), year(lastDay)))
    ylabel('AQI')
    if isequal(state, 'All of the above')
        title('AQI Analysis for All Regions')
    elseif isequal(city, 'All of the above')
        title(sprintf('AQI Analysis for %s', state))
    else
        title(sprintf('AQI Analysis for %s, %s', city, state))
    end

    hold off
end