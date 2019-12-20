Fs = input('Enter The Sampling frequency of signal: ');

T1 = input('Enter The Start of time scale: ');

T2 = input('Enter The End of time scale: ');
if T2 < T1
    disp('T2 must be greater than T1'); 
    T2 = input('Enter The End of time scale: ');
end    

n = input('Enter The Number of the break points: ');

if n ~= 0
    %if function have break points
    pos = zeros(1,n); %position of break points
    for i = 1:1:n
        prompt=['The Position of the break point Number ' num2str(i) ' is '  ]; 
        p=input(prompt);
        pos(i)= p;
        if  pos(i) < T1 | pos(i) > T2  %if pos is't vaild, program ask to inter it again
           disp('Position of BP must be in range between(T1 and T2)');
           prompt=['The Valid Position of the  break point Number ' num2str(i) ' is ' ]; 
           p=input(prompt);
           pos(i)= p;
         end
     end
    
    Time_M = [T1 pos T2];   %Concatenation T1 , Matrix of position and T2
else
    Time_M = [T1 T2];
end
    

Ttot = [];  %Matrix of Total Time
Xtot = [];  %Matrix of Total function
for i = 0:1:n
  
    fprintf('Enter The Type symbol Of The part  %d   Function.\n',(i+1));
    disp(       '[D] for DC signal');
    disp(       '[R] for Ramp');
    disp(       '[P] for General order polynomial signal');
    disp(       '[E] for Exponential signal ');
    disp(       '[S] for Sinusoidal signal');
    F = input('You chose: ','s');  
    T_i = Time_M(i+1);
    T_f = Time_M(i+2);
    T = linspace(T_i,T_f,(T_f-T_i)*Fs);
    if F == 'D'    %Dc Signal
        Amp = input('Amplitude= ');
        X = Amp*ones(1,(T_f-T_i)*Fs);
    elseif F == 'R'  %Ramp Signal
        Slope = input('Slope= ');
        Intercept = input('Intercept= ');
        X= Slope*T + Intercept;
    elseif F == 'P'  %Polynomial signal
        Coff = input('Enter matrix of Amplitudes and Intercept: ');
        X = polyval(Coff,T);        
    elseif F == 'E'    %Exponential signal
        Amp = input('Amplitude= ');
        exponent = input('Exponent= ');
        X = Amp*exp(exponent*T); 
    elseif F == 'S'   %Sinusoidal signal
        Amp = input('Amplitude= ');
        freq = input('Frequency= ');
        phase = input('Phase= ');
        X = Amp*sin(2*pi*freq*T+phase);
    end   
    Xtot = [Xtot X];
    Ttot = [Ttot T];
    
end
figure; plot(Ttot,Xtot);    
 

%Optinal operation in the signal 
disp('Choose the operation you want to perform on the signal');
disp('Enter: [A] for Amplitude Scaling');
disp(       '[R] for Time reversal');
disp(       '[S] for Time shift');
disp(       '[E] for Expanding the signal');
disp(       '[C] for Compressing the signal');
disp(       '[N] for None');
str = input('You chose: ','s');
if str == 'A'
    Sc = input('Scale value= ');
    y = Sc*Xtot;
    T = Ttot;
elseif str == 'R'
    T = -1*Ttot;
    y = Xtot;
elseif str == 'S'   
    % f(t) = f(t-(sh_v))
    sh_v = input('Shift Value= ');
    y = Xtot;
    if sh_v > 0
        %shift to right
        T = Ttot + sh_v;
    elseif sh_v < 0
        %shift to left
        T = Ttot + sh_v;
    else
        T = Ttot
    end
elseif str == 'E'
    expan = input('Expanding value= ');
    T = expan*Ttot;
    y = Xtot;
elseif str == 'C'
    comp = input('Compressing value= ');
    T = Ttot/comp;
    y = Xtot;
elseif str == 'N'
    T = Ttot;
    y = Xtot;
else
    disp('Enter one of the letter which shown above');
end 

figure; plot(T,y);