function yaxistight(varargin)
% yaxistight  Make y-axis tight.
%
% __Syntax__
%
%     grfun.yaxistight(Axes)
%
%
% __Input Arguments__
%
% * `Axes` [ numeric ] - Handles to axes objects whose vertical axes will
% be made tight.
%
%
% __Description__
%
% Behaviour of `grfun.yaxistight` differs from the standard function `axis`
% in that it disregards `grfun.vline`, `grfun.zeroline` and
% `grfun.highlight` objects when determining the minimum and maximum on the
% vertical axis.
%
%
% __Example__
%

% -IRIS Macroeconomic Modeling Toolbox.
% -Copyright (c) 2007-2017 IRIS Solutions Team.

if ~isempty(varargin) && all(ishghandle(varargin{1}))
    handlesToAxes = varargin{1}(:).';
    varargin(1) = [ ]; %#ok<NASGU>
else
    handlesToAxes = gca( );
end

%--------------------------------------------------------------------------

for ithAxes = handlesToAxes
    [yMin, yMax] = getActualYDataLimits(ithAxes);
    if isinf(yMin) && isinf(yMax)
        continue
    end
    if yMin>=yMax
        continue
    end
    set(ithAxes, 'YLim', [yMin, yMax], 'YLimMode', 'Manual');
end

end


function [yMin, yMax] = getActualYDataLimits(ax)
    obj = findobj(ax, ...
        '-property', 'YData', ...
        '-not', 'Tag', 'vline', ...
        '-not', 'Tag', 'hline', ...
        '-not', 'Tag', 'highlight' ...
    );
    yMin = Inf;
    yMax = -Inf;
    for i = 1 : numel(obj)
        ithObj = obj(i);
        ithYData = get(ithObj, 'YData');
        if isempty(ithYData)
            continue
        end
        yMin = min(yMin, min(ithYData(:)));
        yMax = max(yMax, max(ithYData(:)));
    end
end
