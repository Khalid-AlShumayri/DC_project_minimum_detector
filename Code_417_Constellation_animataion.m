% بسم الله الرحمن الرحيم  

% Course Project
%%
clear all;
close all;
clc;

M = 8; % number of signals
k = 3; % number of bits per symbol

% Generate random binary sequence with equal 1s and 0s   'Part b'
Num_of_bits = 1002;
Num_of_Symbols = Num_of_bits/k;

%%
lin_width = 1.2;
LableFontsize = 13;
TitleFontsize = 14;
position = 19;
FigureWidth = 600;
Proportion = 1;
res = 600;

%%
% Mapping the generated bits to construct the given constellation 'Part c'
d1 = 2;                    % the value of d1 is not final yet
d2 = d1*(sqrt(2)+1);       % d2 depends on d1 

s1 = [d2/2, d2/2];  % 100
s4 = [-d2/2, -d2/2];  % 001
s2 = [-d2/2, d2/2];  % 000
s3 = [d2/2, -d2/2];  % 101
s5 = [d1/2, d1/2];  % 110
s6 = [-d1/2, -d1/2];  % 010
s7 = [-d1/2, d1/2];  % 011
s8 = [d1/2, -d1/2];  % 111

%% Loop over the different SNR
finalSNR = 12;
for EbN0dB = 8:2:finalSNR         % 'Part a' 

    EbN0 = 10^(EbN0dB/10);
    EsN0 = 3*EbN0;
%     Bit_error = 0;
    sig_o = [];             % Original signal

    %%% Received symbols
    Si_1 = [];  Si_2 = [];  Si_3 = [];  Si_4 = [];
    Si_5 = [];  Si_6 = [];  Si_7 = [];  Si_8 = [];
    %%% Counter for indesis
    counter_1 = []; counter_2 = []; counter_3 = []; counter_4 = [];
    counter_5 = []; counter_6 = []; counter_7 = []; counter_8 = [];
    %%%

    Rec = [];
    K = rand(1,Num_of_bits);
    Bit_o = round(K);

    % take every k bits as one symbol (k=3)
    for i = 1:1:Num_of_Symbols
    %%
        symbol = [Bit_o(1+3*(i-1)), Bit_o(2+3*(i-1)), Bit_o(3+3*(i-1))];

        % Gray coding
        if (symbol == [0,0,0])  % 000
            sig_o = [sig_o;s2];
            Si_2 = [Si_2;s2];
            counter_2 = [counter_2;i];

        elseif symbol == [0,0,1]% 001
            sig_o = [sig_o;s3];
            Si_3 = [Si_3;s3];
            counter_3 = [counter_3;i];

        elseif symbol == [0,1,0]% 010
            sig_o = [sig_o;s6];
            Si_6 = [Si_6;s6];
            counter_6 = [counter_6;i];

        elseif symbol == [0,1,1]% 011
            sig_o = [sig_o;s7];
            Si_7 = [Si_7;s7];
            counter_7 = [counter_7;i];

        elseif symbol == [1,0,0]% 100
            sig_o = [sig_o;s1];
            Si_1 = [Si_1;s1];
            counter_1 = [counter_1;i];

        elseif symbol == [1,0,1]% 101
            sig_o = [sig_o;s4];
            Si_4 = [Si_4;s4];
            counter_4 = [counter_4;i];

        elseif symbol == [1,1,0]% 110
            sig_o = [sig_o;s5];
            Si_5 = [Si_5;s5];
            counter_5 = [counter_5;i];

        elseif symbol == [1,1,1]% 111
            sig_o = [sig_o;s8];
            Si_8 = [Si_8;s8];
            counter_8 = [counter_8;i];

        end
    end

    % Calculating the energy per symbol & Calculate the noise variance 

    %Avg energy per symbol
    Es = sum( sum(sig_o.*sig_o,2) )/Num_of_Symbols; 

    % as EsN0 increase N0 decrease
    N0 = Es/EsN0;    
    Noise = sqrt(N0/2).*randn(size(sig_o));
    
    Rec = sig_o + Noise;
    % The received symbols
    Si_1 =Si_1+ Noise(randperm(size(Si_1,1)),:);  % adding noise to each class of symbols
    Si_2 =Si_2+ Noise(randperm(size(Si_2,1)),:);
    Si_3 =Si_3+ Noise(randperm(size(Si_3,1)),:);
    Si_4 =Si_4+ Noise(randperm(size(Si_4,1)),:);
    Si_5 =Si_5+ Noise(randperm(size(Si_5,1)),:);
    Si_6 =Si_6+ Noise(randperm(size(Si_6,1)),:);
    Si_7 =Si_7+ Noise(randperm(size(Si_7,1)),:);
    Si_8 =Si_8+ Noise(randperm(size(Si_8,1)),:);
    
    %%

    sig_d = []; % Decoded signal 
    Bit_r = []; % Received bits

    % Applying MDs
    q=1;
    for i=1:Num_of_Symbols
    %%
        e1 = sum( (Rec(i,:) - s1).*(Rec(i,:) - s1) ); % ||Rec(i) - s1||^2
        e2 = sum( (Rec(i,:) - s2).*(Rec(i,:) - s2) ); % taking the
        e3 = sum( (Rec(i,:) - s3).*(Rec(i,:) - s3) ); % difference then 
        e4 = sum( (Rec(i,:) - s4).*(Rec(i,:) - s4) ); % finding the energy
        e5 = sum( (Rec(i,:) - s5).*(Rec(i,:) - s5) ); % of the error signal
        e6 = sum( (Rec(i,:) - s6).*(Rec(i,:) - s6) );
        e7 = sum( (Rec(i,:) - s7).*(Rec(i,:) - s7) );
        e8 = sum( (Rec(i,:) - s8).*(Rec(i,:) - s8) ); 

        DE = [e1, e2, e3, e4, e5, e6, e7, e8];
        [~,I] = min(DE);

        if (I == 1) % 100
            temp2 = s1;
            Bit1 = [1,0,0];

        elseif (I == 2) % 000
            temp2 = s2;
            Bit1 = [0,0,0];

        elseif (I == 3) % 001
            temp2 = s3;
            Bit1 = [0,0,1];

        elseif (I == 4) % 101
            temp2 = s4;
            Bit1 = [1,0,1];

        elseif (I == 5) % 110
            temp2 = s5;
            Bit1 = [1,1,0];

        elseif (I == 6) % 010
            temp2 = s6;
            Bit1 = [0,1,0];

        elseif (I == 7) % 011
            temp2 = s7;
            Bit1 = [0,1,1];

        elseif (I == 8) % 111
            temp2 = s8;
            Bit1 = [1,1,1];

        end

        sig_d = [sig_d;temp2]; % accumulating the decoded signals
        Bit_r = [Bit_r,Bit1]; % accumulating the Bits
        q=q+3;
    end
    Bit_error = sum(xor(Bit_r,Bit_o));
    Symbol_error = nnz(sig_d - sig_o);

    figure(1)
    sz = 40;
    scatter(Si_1(:,1),Si_1(:,2),sz,'MarkerEdgeColor',[.4 .4 0],...
                  'MarkerFaceColor',[1 1 0]); grid on;hold on;
    scatter(Si_2(:,1),Si_2(:,2),sz,'MarkerEdgeColor',[.4 0 .4],...
                  'MarkerFaceColor',[1 0 1]); grid on;hold on;
    scatter(Si_3(:,1),Si_3(:,2),sz,'MarkerEdgeColor',[.8 0 .8],...
                  'MarkerFaceColor',[.5 0 .5]); grid on;hold on;
    scatter(Si_4(:,1),Si_4(:,2),sz,'MarkerEdgeColor',[.8 .8 0],...
                  'MarkerFaceColor',[.4 .5 0]); grid on;hold on;
    scatter(Si_5(:,1),Si_5(:,2),sz,'MarkerEdgeColor',[0 .5 .4],...
                  'MarkerFaceColor',[0 1 1]); grid on;hold on;
    scatter(Si_6(:,1),Si_6(:,2),sz,'MarkerEdgeColor',[0 .8 .8],...
                  'MarkerFaceColor',[0 .5 .4]); grid on;hold on;
    scatter(Si_7(:,1),Si_7(:,2),sz,'MarkerEdgeColor',[.2 .2 .2],...
                  'MarkerFaceColor',[.7 .7 .7]); grid on;hold on;          
    scatter(Si_8(:,1),Si_8(:,2),sz,'MarkerEdgeColor',[.5 .5 .5],...
                  'MarkerFaceColor',[.2 .2 .2]); grid on;hold on;
    
    % Drawing the decision regions      
    plot([-4,4],[0,0],'--k','LineWidth',lin_width)   
    plot([0,0],[-4,4],'--k','LineWidth',lin_width)
    
    plot([-4,-1.7071],[-1.7071,-1.7071],'--k','LineWidth',lin_width) 
    plot([-4,-1.7071],[1.7071,1.7071],'--k','LineWidth',lin_width) 
    
    plot([4,1.7071],[-1.7071,-1.7071],'--k','LineWidth',lin_width) 
    plot([4,1.7071],[1.7071,1.7071],'--k','LineWidth',lin_width) 
    
    plot([-1.7071,-1.7071],[-2.41,-1.7071],'--k','LineWidth',lin_width) 
    plot([1.7071,1.7071],[-2.41,-1.7071],'--k','LineWidth',lin_width) 
    plot([-1.7071,1.7071],[-2.41,-2.41],'--k','LineWidth',lin_width)
    
    plot([-1.7071,-1.7071],[1.7071,2.41],'--k','LineWidth',lin_width) 
    plot([1.7071,1.7071],[1.7071,2.41],'--k','LineWidth',lin_width) 
    plot([-1.7071,1.7071],[2.41,2.41],'--k','LineWidth',lin_width) 
    hold off

    set(gcf,'Position',[700,50,FigureWidth,FigureWidth*Proportion]) 
    xlabel('In-Phase')
    ylabel('Quadrature')
    xlim([-4,4])
    ylim([-4,4])
    title(['Constellation of the received signal. SNR = ',num2str(EbN0dB),'dB. BER= ',num2str(Bit_error)])
%     drawnow
    pause(5)
    if(EbN0dB ~= finalSNR)
    delete(figure(1))
    end

end