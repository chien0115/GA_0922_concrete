function repaired_chromosome = fix(chromosome, demand_trips)
num_sites = length(demand_trips);
site_counts = zeros(1, num_sites);

% 計算每個工地的訪問次數
% 突變操作
for k = 1:x1
    rand_mutation = rand();
    if rand_mutation <= mutationRate
        [M_temp, dispatch_times_mutation_temp] = mutation(C(k, :), t, dispatch_times_cross(k, :));
        M = [M; M_temp];  % 添加突變後的染色體
        dispatch_times_mutation = [dispatch_times_mutation; dispatch_times_mutation_temp];  % 添加突變後的派遣時間
    else
        M = [M; C(k, :)];  % 只保留未突變的染色體
        dispatch_times_mutation = [dispatch_times_mutation; dispatch_times_cross(k, :)];  % 只保留未突變的派遣時間
    end
end

% 修復突變後的染色體，避免連續派遣到同一工地
for k = 1:size(M, 1)
    M(k, :) = repair(M(k, :), demand_trips);
end
% 返回修復後的染色體
repaired_chromosome = chromosome;
end
