clear all
close all
clc


% 參數設置
n = 200; % 初始種群大小
c = 50; % 需要進行交叉的染色體對數
m = 20; % 需要進行突變的染色體數
tg = 200; % 總代數
num_sites = 5; % 工地
% num_sites_with_factory = num_sites + 1; % 包括工廠的總工地數
t = 1; % 卡車數
s=100;%好的染色體
r=10;%number of chromosomes passing between runs每次運行之間傳遞的染色體數 比較佳的染色體
crossoverRate = 0.8; % 定義交配率
mutationRate = 0.8; % 突變率



%480->早上8點
time_windows = [480, 1020; 490, 1020; 485, 1020; 495, 1020; 490, 1020;0, 1440]; % 每個工地的時間窗(每個工地每天開始、結束時間),0-1440代表工廠全天開放
% route = [1, 2, 3, 4, 5]; % 染色體示例：工廠到工地的路徑

time = [
    30, 25;  % 去程到工地 1 需要 30 分鐘，回程需要 25 分鐘
    25, 20;  % 去程到工地 2 需要 25 分鐘，回程需要 20 分鐘
    40, 30;  % 去程到工地 3 需要 40 分鐘，回程需要 30 分鐘
    35, 30;  % 去程到工地 4 需要 35 分鐘，回程需要 30 分鐘
    20, 15;  % 去程到工地 5 需要 20 分鐘，回程需要 15 分鐘
    ];

% 定義各工地的參數
max_interrupt_time = [5, 5, 15,15,10]; % 工地最大容許中斷時間 (分鐘)
truck_max_interrupt_time = 25;
work_time = [20, 30, 25,20,15]; % 各工地施工時間 (分鐘)
demand_trips = [2, 1, 1, 1, 2]; % 各工地需求車次  7
penalty_rate_per_min = 30;% 每分鐘延遲的罰金


% start_time = [8*60, 8*60, 8*60+30]; % 各工地開始施工的時間 (以分鐘計算)
% travel_time_to = [30, 25, 40]; % 去程時間 (分鐘)
% travel_time_back = [25, 20, 30]; % 回程時間 (分鐘)
% penalty_site_value = 5; % 懲罰時間 (分鐘)




figure
title('Blue-Average      Red-Minimum');
xlabel('Generation')
ylabel('Objective Function Value')
hold on




[P,dispatch_times] = population(n, demand_trips, t, time_windows); % 初始化種群 P只包含派出順序 OK
for i = 1:tg
    % 初始化
    K = zeros(tg, 2); % 儲存適應度的矩陣



    % 評估操作 每個染色體的適應值 OK
    E = evaluation(P, t, time_windows, num_sites, dispatch_times, work_time, time, max_interrupt_time, truck_max_interrupt_time, demand_trips, penalty_rate_per_min); % 評估族群 P 中每個染色體的適應度


    % 選擇最好的染色體 目前設定選s個 OK
    [P, S, best_dispatch_times] = selection(P, E, s, dispatch_times);
    %P:選出來的染色體   S:適應值大小  best_dispatch_times:最好的派遣時間


    cr_num=0;
    dispatch_times_cross = [];
    dispatch_times_mutation = [];
    rand_crossover = rand();
    rand_mutation = rand();

    % 初始化
    C = []; % 初始化 C 為空矩陣
    M = []; % 初始化 M 為空矩陣

    %把好的作交配、變異
    % 交配操作
    for j = 1:(n-s)
        if cr_num < n-s % 扣除前面selection先選的
            rand_crossover = rand();
            if rand_crossover <= crossoverRate
                [C_temp, dispatch_times_cross_temp] = crossover(P, t, dispatch_times);

                % 添加交配后的两个新染色体
                C = [C; C_temp(1, :)];
                C = [C; C_temp(2, :)];

                % 添加交配后的派遣时间
                dispatch_times_cross = [dispatch_times_cross; dispatch_times_cross_temp(1, :)];
                dispatch_times_cross = [dispatch_times_cross; dispatch_times_cross_temp(2, :)];

                cr_num = cr_num + 2; % 更新 cr_num
            else
                % 保留兩個原染色體
                C = [C; P(2*j-1, :)]; % 保留第 2*i-1 個染色體
                dispatch_times_cross = [dispatch_times_cross; dispatch_times(2*j-1, :)]; % 保留第一個染色體及派遣時間

                if 2*i <= size(P,1) % 確保不超出數組長度，確保 i+1 對應的染色體存在
                    C = [C; P(2*j,:)]; % 保留第 2*i 個染色體
                    dispatch_times_cross = [dispatch_times_cross; dispatch_times(2*j, :)]; % 保留第二個染色體及派遣時間
                end

                cr_num = cr_num + 2; % 因為每次保留兩個染色體，所以增加 2
            end
        end
    end




    % 突變操作
    for k = 1:size(C, 1)
        if rand_mutation <= mutationRate
            [M_temp, dispatch_times_mutation_temp] = mutation(C(k, :), t, dispatch_times_cross(k, :));
            M = [M; M_temp];  % 添加突變後的染色體
            dispatch_times_mutation = [dispatch_times_mutation; dispatch_times_mutation_temp];  % 添加突變後的派遣時間
        else
            M = [M; C(k, :)];  % 只保留未突變的染色體
            dispatch_times_mutation = [dispatch_times_mutation; dispatch_times_cross(k, :)];  % 只保留未突變的派遣時間
        end
    end


    % 統整(selection、crossover、mutation)
    P=[P;M];
    dispatch_times=[best_dispatch_times;dispatch_times_mutation];



    %再次評估適應度 計算平均適應度最佳適應度
    E = evaluation(P, t, time_windows, num_sites, dispatch_times, work_time, time, max_interrupt_time, truck_max_interrupt_time, demand_trips, penalty_rate_per_min); % 評估族群 P 中每個染色體的適應度

    % 記錄適應度
    K(i, 1) = sum(E) / n; % 平均適應度
    K(i, 2) = min(E); % 最佳適應度

    % 畫圖
    plot(i,K(i, 1), 'b.');  % 畫出第i代的平均適應度
    hold on
    plot(i,K(i, 2), 'r.');  % 畫出第i代的最佳適應度
    drawnow
end


[minValue, index] = min(K(:, 2)); % 提取出最小適應度值
best_chromosome_dispatch_times=best_dispatch_times(index, :);
% 提取最佳適應度值和最優解
% 提取最佳染色體基因和最優解
best_chromosome = P(index, :); % 提取基因部分


% 更新 P2 包含基因和对应的调度时间
P2 = [best_chromosome, best_chromosome_dispatch_times];

disp('Best Chromosome:');
disp(best_chromosome);

disp('Best Dispatch Times:');
disp(best_chromosome_dispatch_times);

