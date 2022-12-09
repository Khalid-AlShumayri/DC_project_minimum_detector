% Course Project

clear all;
close all;
clc;

C = 1;
M = 8;
k = 3;


for EbN0dB = 0:2:12          % 'Part a' , We need to change 20dB according to the file
    Bit_error = 0;
    Symbol_error = 0;
    T = 1;
    EbN0 = 10^(EbN0dB/10);
    EsN0 = 3*EbN0;
    
    while(Bit_error < 100)   
      
        % Generate random binary sequence with equal 1s and 0s   'Part b'
        Num_of_bits = 999;
        Num_of_Symbols = Num_of_bits/k;
        K = rand(1,Num_of_bits);
        B = round(K);
        
        % Mapping the generated bits to construct the given constellation 'Part c'
        
        d1 = 1;                    % the value of d1 is not final yet
        d2 = d1*(sqrt(2)+1);       % d2 depends on d1 
        
        s1 = -(d2/2) + (d2/2)*1i;  %100
        s2 = -(d1/2) + (d1/2)*1i;  %000
        s3 =  (d1/2) + (d1/2)*1i;  %001
        s4 =  (d2/2) + (d2/2)*1i;  %101
        s5 = -(d2/2) - (d2/2)*1i;  %110
        s6 = -(d1/2) - (d1/2)*1i;  %010
        s7 =  (d1/2) - (d1/2)*1i;  %011
        s8 =  (d2/2) - (d2/2)*1i;  %111
        
        j = 1;
        for i = 1:3:(Num_of_bits)
            if (B(i) == 0 && B(i+1) == 0 && B(i+2) == 0)
                S(j) = s2; 
             end
            if (B(i) == 0 && B(i+1) == 0 && B(i+2) == 1)
                S(j) = s3; 
             end
            if (B(i) == 0 && B(i+1) == 1 && B(i+2) == 0)
                S(j) = s6; 
             end
            if (B(i) == 0 && B(i+1) == 1 && B(i+2) == 1)
                S(j) = s7; 
             end
            if (B(i) == 1 && B(i+1) == 0 && B(i+2) == 0)
                S(j) = s1; 
             end
            if (B(i) == 1 && B(i+1) == 0 && B(i+2) == 1)
                S(j) = s4;
             end
            if (B(i) == 1 && B(i+1) == 1 && B(i+2) == 0)
                S(j) = s5; 
             end
            if (B(i) == 1 && B(i+1) == 1 && B(i+2) == 1)
                S(j) = s8; 
            end
           j = j+1;
        end
         
        % Calculating the energy per symbol & Calculate the noise variance 
        Es = abs(S).^2;
        N0 = Es/EsN0;
        Noise = sqrt(N0/2).*randn(size(S));
        
        % The received signal & Applying MD
        R = S + Noise;
        
        q=1;
        for i=1:Num_of_Symbols
        
        e1 = (real(R(i)) - real(s1))^2 + (imag(R(i)) - imag(s1))^2;   
        e2 = (real(R(i)) - real(s2))^2 + (imag(R(i)) - imag(s2))^2;
        e3 = (real(R(i)) - real(s3))^2 + (imag(R(i)) - imag(s3))^2;
        e4 = (real(R(i)) - real(s4))^2 + (imag(R(i)) - imag(s4))^2; 
        e5 = (real(R(i)) - real(s5))^2 + (imag(R(i)) - imag(s5))^2;
        e6 = (real(R(i)) - real(s6))^2 + (imag(R(i)) - imag(s6))^2;
        e7 = (real(R(i)) - real(s7))^2 + (imag(R(i)) - imag(s7))^2;
        e8 = (real(R(i)) - real(s8))^2 + (imag(R(i)) - imag(s8))^2; 
        
        DE = [e1 e2 e3 e4 e5 e6 e7 e8];
        [M,I] = min(DE);
        
        if (I == 1)
            Rec(i) = s1;
            Bit(q) = 1; Bit(q+1) = 0; Bit(q+2) = 0;
            q=q+3;
        end 
        if (I == 2)
            Rec(i) = s2;
            Bit(q) = 0; Bit(q+1) = 0; Bit(q+2) = 0;
            q=q+3;
        end 
        if (I == 3)
            Rec(i) = s3;
            Bit(q) = 0; Bit(q+1) = 0; Bit(q+2) = 1;
            q=q+3;
        end
        if (I == 4)
            Rec(i) = s4;
            Bit(q) = 1; Bit(q+1) = 0; Bit(q+2) = 1;
            q=q+3;
        end 
        if (I == 5)
            Rec(i) = s5;
            Bit(q) = 1; Bit(q+1) = 1; Bit(q+2) = 0;
            q=q+3;
        end
        if (I == 6)
            Rec(i) = s6;
            Bit(q) = 0; Bit(q+1) = 1; Bit(q+2) = 0;
            q=q+3;
        end 
        if (I == 7)
            Rec(i) = s7;
            Bit(q) = 0; Bit(q+1) = 1; Bit(q+2) = 1;
            q=q+3;
        end 
        if (I == 8)
            Rec(i) = s8;
            Bit(q) = 1; Bit(q+1) = 1; Bit(q+2) = 1;
            q=q+3;
         end
        end
        
        Bit_error = Bit_error + sum(xor(Bit,B));
        Symbol_error = Symbol_error + nnz(Rec - S);
        T = T+1;
    end
    
    BER(C) = Bit_error/(T*Num_of_bits);
    SER(C) = Symbol_error/(T*Num_of_Symbols);
    EbN0dB_s(C) = EbN0dB;
    C = C+1; 
end 

semilogy(EbN0dB_s,SER,'x',EbN0dB_s,BER,'o');
xlabel ('Eb/N0 dB')
ylabel ('Probability of Error, Pe')
legend('SER','BER')
grid on
scatterplot(S)
scatterplot(R)




