function [Y, dispatch_times_new] = crossover(P, t, dispatch_times)
    % P = Population
    % dispatch_times = Matrix of dispatch times corresponding to the chromosomes
    % t = Length of dispatch times (number of time periods)
    
    [x1, y1] = size(P); % Size of the population and chromosomes

    % 隨機選擇兩個不同的染色體
    r1 = randi(x1, 1, 2);
    while r1(1) == r1(2) % 保證兩個選擇的染色體是不同的
        r1 = randi(x1, 1, 2);
    end
    
    % 選擇父染色體及其對應的派遣時間
    A1 = P(r1(1), :); % 第1個父代染色體
    A2 = P(r1(2), :); % 第2個父代染色體
    dispatch_times1 = dispatch_times(r1(1), :); % 第1個父代的派遣時間
    dispatch_times2 = dispatch_times(r1(2), :); % 第2個父代的派遣時間

    % 生成隨機的交配點
    random_number = rand();    
    crossover_point = ceil(random_number * (y1 - 1));

    % 染色體的交配操作
    B1 = A1(1:crossover_point); % 暫存 A1 的前半段
    A1(1:crossover_point) = A2(1:crossover_point); % 交叉前半段
    A2(1:crossover_point) = B1; % 交叉 A2 的前半段

    % 派遣時間的交配操作
    dispatch_crossover_point = ceil(random_number * (t - 1)); % 派遣時間的交配點
    B_dispatch_times = dispatch_times1(1:dispatch_crossover_point); % 暫存 dispatch_times1 的前半段
    dispatch_times1(1:dispatch_crossover_point) = dispatch_times2(1:dispatch_crossover_point); % 交叉前半段
    dispatch_times2(1:dispatch_crossover_point) = B_dispatch_times; % 交叉 dispatch_times2 的前半段

    % 將新染色體和派遣時間存入結果
    Y = [A1; A2]; % 回傳新的染色體對
    dispatch_times_new = [dispatch_times1; dispatch_times2]; % 回傳新的派遣時間

    % 顯示結果以便除錯
    disp('Chromosomes after Crossover:');
    disp(Y);
    disp('Dispatch Times after Crossover:');
    disp(dispatch_times_new);
end
