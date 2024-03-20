function [y] = some_function(x)
    y = 0;
    for i = 1:x
        y = y + i;
        fprintf('%d\n', y)
    end
end