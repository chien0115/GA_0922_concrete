function [Y, dispatch_times_new2] = mutation(P, t, dispatch_times)
    % P = Population
    % dispatch_times = Matrix of dispatch times corresponding to the chromosomes

    [x1, y1] = size(P); % Population size (x1) and chromosome length (y1)
    
    % Randomly select a chromosome
    r1 = randi(x1); % Randomly select an index within the range of population size
    A1 = P(r1, 1:y1); % 取出选中的染色体 (派遣顺序)
    dispatch_times1 = dispatch_times(r1, :); % 取出对应的派遣时间

    % 定义派遣顺序的突变位置（仅限奇数位置）
    odd_positions = 1:2:y1; % 获取派遣顺序部分的所有奇数位置
    pos = randperm(length(odd_positions), 2); % 随机选择两个不同的奇数位置
    pos = odd_positions(pos); % 获取实际位置

    % 交换所选位置的值（调整派遣顺序）
    A1([pos(1), pos(2)]) = A1([pos(2), pos(1)]);

    % 同时对派遣时间进行突变
    if t >= 2
        pos_dispatch = randperm(t, 2); % 随机选择两个不同的位置
        dispatch_times1([pos_dispatch(1), pos_dispatch(2)]) = dispatch_times1([pos_dispatch(2), pos_dispatch(1)]); 
    end

    % 返回新的突变后的染色体和派遣时间
    Y = A1; % 只返回单个突变后的染色体
    dispatch_times_new2 = dispatch_times1; % 返回突变后的派遣时间

end
