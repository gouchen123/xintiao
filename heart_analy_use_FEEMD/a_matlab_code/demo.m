function [a, b, c, d] = demo(a, b, varargin)


c = 1;
d = 2;

for iAg = 1:length(varargin{1})
    if (iAg == 1)
        c = varargin{1}{iAg};
    end
end
c