% بسم الله الرحمن الرحيم  

% EE417 Course Project
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
s3 = [-d2/2, -d2/2];  % 001
s2 = [-d2/2, d2/2];  % 000
s4 = [d2/2, -d2/2];  % 101
s5 = [d1/2, d1/2];  % 110
s6 = [-d1/2, -d1/2];  % 010
s7 = [-d1/2, d1/2];  % 011
s8 = [d1/2, -d1/2];  % 111

Pe_symbol = [];
Bound_Q   = [];
Bound_exp = [];
Pe_bit = [];
EbN0dB_s = []; 

%% Loop over the different SNR
finalSNR = 12;
for EbN0dB = 6:2:finalSNR         % 'Part a' 

    EbN0 = 10^(EbN0dB/10);
    EsN0 = 3*EbN0;
    Bit_error = 0;
    Symbol_error = 0;
    T=0;

    while(Bit_error<100)
        
        sig_o = [];             % Original signal
        K = rand(1,Num_of_bits);
        Bit_o = round(K);
        % take every k bits as one symbol (k=3)
        for i= 1:1:Num_of_Symbols
        %%

            symbol = [Bit_o(1+3*(i-1)), Bit_o(2+3*(i-1)), Bit_o(3+3*(i-1))];
            % Gray coding
                if (symbol == [0,0,0])
                    sig_o = [sig_o;s2];
    
                elseif symbol == [0,0,1]
                    sig_o = [sig_o;s3];
    
                elseif symbol == [0,1,0]
                    sig_o = [sig_o;s6];
    
                elseif symbol == [0,1,1]
                    sig_o = [sig_o;s7];
    
                elseif symbol == [1,0,0]
                    sig_o = [sig_o;s1];
    
                elseif symbol == [1,0,1]
                    sig_o = [sig_o;s4];
    
                elseif symbol == [1,1,0]
                    sig_o = [sig_o;s5];
    
                elseif symbol == [1,1,1]
                    sig_o = [sig_o;s8];
    
                end
        end
        
        % Calculating the energy per symbol & Calculate the noise variance 

        %Avg energy per symbol
        Es = sum( sum(sig_o.*sig_o,2) )/Num_of_Symbols; 

        % as EsN0 increase N0 decrease
        N0 = Es/EsN0;    
        Noise = sqrt(N0/2).*randn(size(sig_o));
        
        % The received signal
        Rec = sig_o + Noise;
        q=1;
        
        sig_r = []; % Received signal 
        Bit_r = []; % Received bits
    
        % Applying MD
        for i=1:Num_of_Symbols
        %%
            e1 = sum( (Rec(i,:) - s1).*(Rec(i,:) - s1) ); % ||Rec(i) - s1||^2
            e2 = sum( (Rec(i,:) - s2).*(Rec(i,:) - s2) ); % taking the
            e3 = sum( (Rec(i,:) - s3).*(Rec(i,:) - s3) ); % difference than 
            e4 = sum( (Rec(i,:) - s4).*(Rec(i,:) - s4) ); % finding the energy
            e5 = sum( (Rec(i,:) - s5).*(Rec(i,:) - s5) ); % of the error signal
            e6 = sum( (Rec(i,:) - s6).*(Rec(i,:) - s6) );
            e7 = sum( (Rec(i,:) - s7).*(Rec(i,:) - s7) );
            e8 = sum( (Rec(i,:) - s8).*(Rec(i,:) - s8) ); 
            
            DE = [e1, e2, e3, e4, e5, e6, e7, e8];
            [~,I] = min(DE);
           
            if (I == 1) % 100
                temp2 = s1;
                Bit1 = 1; Bit2 = 0; Bit3 = 0;
    
            elseif (I == 2) % 000
                temp2 = s2;
                Bit1 = 0; Bit2 = 0; Bit3 = 0;
    
            elseif (I == 3) % 001
                temp2 = s3;
                Bit1 = 0; Bit2 = 0; Bit3 = 1;
            
            elseif (I == 4) % 101
                temp2 = s4;
                Bit1 = 1; Bit2 = 0; Bit3 = 1;
           
            elseif (I == 5) % 110
                temp2 = s5;
                Bit1 = 1; Bit2 = 1; Bit3 = 0;
            
            elseif (I == 6) % 010
                temp2 = s6;
                Bit1 = 0; Bit2 = 1; Bit3 = 0;
    
            elseif (I == 7) % 011
                temp2 = s7;
                Bit1 = 0; Bit2 = 1; Bit3 = 1;
    
            elseif (I == 8) % 111
                temp2 = s8;
                Bit1 = 1; Bit2 = 1; Bit3 = 1;
    
            end
    
            sig_r = [sig_r;temp2]; % accumulating the signals
            Bit_r = [Bit_r,Bit1,Bit2,Bit3]; % accumulating the Bits
            q=q+3;
        end
        Bit_error = Bit_error + sum(xor(Bit_r,Bit_o));
        Symbol_error = Symbol_error + nnz(sig_r - sig_o);
        T = T+1;

    end
%     to find the probability of error
    Pe_s = Symbol_error/(T*Num_of_Symbols);
    Pe_b  = Bit_error/(T*Num_of_bits);
    EbN0dB_s = [EbN0dB_s; EbN0dB];
    Pe_bit = [Pe_bit;Pe_b];
    Pe_symbol = [Pe_symbol;Pe_s];

    % Theortical bound
    Bound_Q = [Bound_Q;(M-1)*qfunc(d1/sqrt(2*N0))];
    Bound_exp = [Bound_exp;(M-1)*exp( -d1^2/(4*N0) )/( d1*sqrt(pi/N0) )];
end


%% Plotting 
figure(2)

h1 = semilogy(EbN0dB_s,Bound_exp,'-x','LineWidth',lin_width); hold on
h2 = semilogy(EbN0dB_s,Bound_Q,'-*','LineWidth',lin_width); hold on
h3 = semilogy(EbN0dB_s,Pe_symbol,'o','LineWidth',lin_width); hold on
h4 = semilogy(EbN0dB_s,Pe_bit,'x','LineWidth',lin_width);

h1.Color = [.7,.1,.1];
h2.Color = [.1,.6,.1];
h3.Color = [.1,.1,.8];
h4.Color = [.1,.1,.1];

xlabel ('Eb/N0 [dB]')
ylabel ('Probability of Error, P_e')
legend('SER bound (exp)','SER bound (qfunc)','SER','BER')
title('Error curve for 8-QAM')
grid on

%% Plotting the constellation
sz = 40;
figure(3)
H1 = scatter(sig_o(:,1),sig_o(:,2),sz,'MarkerEdgeColor',[.4 .4 0],...
              'MarkerFaceColor',[1 1 0]); grid on; hold on;
% Drawing the decision regions      
plot([0,3.4142],[3.4142,0],'--k','LineWidth',lin_width)
plot([0,-3.4142],[3.4142,0],'--k','LineWidth',lin_width)
plot([0,3.4142],[-3.4142,0],'--k','LineWidth',lin_width)
plot([0,-3.4142],[-3.4142,0],'--k','LineWidth',lin_width)

plot([0,0],[-4,4],'--k','LineWidth',lin_width)
plot([-4,4],[0,0],'--k','LineWidth',lin_width)

xlabel('In-Phase')
ylabel('Quadrature')
xlim([-4,4])
ylim([-4,4])
title('Constellation diagram for 8-QAM')
hold off

%% Constellation of the received signal
figure(4)
H2 = scatter(Rec(:,1),Rec(:,2),sz,'MarkerEdgeColor',[.4 .4 0],...
              'MarkerFaceColor',[1 1 0]); grid on; hold on;

% Drawing the decision regions      
plot([0,3.4142],[3.4142,0],'--k','LineWidth',lin_width)
plot([0,-3.4142],[3.4142,0],'--k','LineWidth',lin_width)
plot([0,3.4142],[-3.4142,0],'--k','LineWidth',lin_width)
plot([0,-3.4142],[-3.4142,0],'--k','LineWidth',lin_width)

plot([0,0],[-4,4],'--k','LineWidth',lin_width)
plot([-4,4],[0,0],'--k','LineWidth',lin_width)

xlabel('In-Phase')
ylabel('Quadrature')
xlim([-4,4])
ylim([-4,4])
title('Constellation diagram for 8-QAM')
hold off
title(['Constellation of received signal. ',num2str(EbN0dB),'dB'])


