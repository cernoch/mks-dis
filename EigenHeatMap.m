S = zeros(16,16);

for p = 1:size(S,1)
    for d = 2:size(S,2)
        
        if d == 1
            q = 1;
        else
            q = floor( (p+1)/d );
        end
        
        S(p,d) = CountOwnKeys(p,d,q);

        if (0 <= q-1) && S(p,d) < CountOwnKeys(p,d,q-1)
            p
            d
            q
            error('Not optimal')
        end
        
        if (q+1 <= p) && S(p,d) < CountOwnKeys(p,d,q+1)
            p
            d
            q
            error('Not optimal')
        end
    end
end

if 1 == 0
    figure('Position', [0 0 650 600]);
    imagesc(log10(S(:,2:end)), 'XData', [2 size(S,2)])
    colormap(hsv)
    colorbar

    xlabel('d_max (number of depths)')
    ylabel('p (number of positions)')

    saveas(gcf, 'EigenHeatMap', 'pdf')
    matlab2tikz('EigenHeatMap.tikz')
end

if (1 == 1)
    %figure(2)
    %figure('Position', [0 0 650 600]);
    imagesc(log10(S(:,2:end)), 'XData', [2 size(S,2)])
    colormap(hsv)
    colorbar
    hold on
    
    contour(2:size(S,1), 1:size(S,2), log10(S(:,2:end)),'kx','ShowText','on')
    grid off
    
    hold off

    xlabel('d {(number of depths)}')
    ylabel('p {(number of positions)}')

    %saveas(gcf, 'EigenHeatCont', 'pdf')
    matlab2tikz('EigenHeatCont.tikz', 'width', '\textwidth', 'height', '\textwidth', 'extraAxisOptions', 'contour/draw color=black,contour/every contour label/.append style={every node/.style={black,fill=white}}');
    % 'width', '4in', 'height', '4in')
end
