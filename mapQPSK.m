magn = sqrt(2)/2;
s = [[magn, magn]; [-1*magn, magn]; [-1*magn, -1*magn]; [magn, -1*magn]];
fs = [0.35, 0.2, 0.35, 0.1];

rng(0,'twister');
a = -2;
b = 2;
y1 = (b-a).*rand(5000,1) + a;
y2 = (b-a).*rand(5000,1) + a;
y = [y1 y2];

dum = size(y);
len = dum(1);

func = [];
colormap = [];

for i = 1:1:len
    if i == 1
        [dum1, dum2, dum3] = maximum_likelihood(y(i,:), s, fs);
        func = [dum1 dum2];
        colormap = [colormap dum3];
    else
        [dum1, dum2, dum3] = maximum_likelihood(y(i,:), s, fs);
        dum = [dum1 dum2];
        func = [func; dum];
        colormap = [colormap dum3];
    end
end

%so we need to assign colors based on how close their minimum distance is
%to the actual symbols...
scatter(y(:,1), y(:,2), [], colormap, 'filled');
title("Heatmap Based on Likelihood of Decided Symbol")
%the function doesn't account for ties/uncertainties
function [symbol_hat1, symbol_hat2, likelihood] = maximum_likelihood(y, s, fs)
    No = 1;
    dum = size(s);
    len = dum(1);
    closest = 0;
    hist = 0;
    for i = 1:1:len
        diff = y - s(i,:);
        imp = magnitude(diff(1,1), diff(1,2));
        imp = imp.^2;
        imp = imp ./ (No);
        imp = -1 .* imp;
        imp = exp(imp);
        imp = imp ./ pi;
        imp = imp ./ (No);
        imp = imp .* fs(i);

        if i == 1
            closest = 1;
            hist = imp;
        elseif imp > hist
            closest = i;
            hist = imp;
        end
    end
    symbol_hat1=s(closest,1);
    symbol_hat2=s(closest,2)
    likelihood = hist;
end

function distance = magnitude(x,y)
    s = (x^2)+(y^2);
    distance = sqrt(s);
end
