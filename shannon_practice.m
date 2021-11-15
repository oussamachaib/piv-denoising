close('all');
clear;

%% original signal

N=50; % number of samples
T = 1; % total duration
f = 50; % function frequency
fs = N/T; % sampling frequency
B = fs
fb = B/2

dt = 1/fs; % time resolution
df = fs/N; % frequency resolution

x = linspace(0,T,N); % x-axis
y = sin(2*pi*f*x); % function

figure();
subplot(131)
scatter(x,y,'r');
hold on;
plot(x,y,'b');
hold off;
xlim([0 T])

%% sampling / fs = 2fb = B

fs2 = B;
N2 = fs2*T;
ds = N/N2;

dt2 = 1/fs2; % time resolution
df2 = fs2/N2; % frequency resolution


x2=x(1,1:ds:N);
y2 = y(1,1:ds:N);

subplot(132)
scatter(x2,y2,'r');
hold on;
plot(x2,y2,'b');
hold off;
xlim([0 T])

%% sampling / fs < 2fb

fs3 = 5;
N3 = fs3*T;
ds3 = N/N3;

dt2 = 1/fs3; % time resolution
df2 = fs3/N3; % frequency resolution


x3=x(1,1:ds3:N);
y3 = y(1,1:ds3:N);

subplot(133)
scatter(x3,y3,'r');
hold on;
plot(x3,y3,'b');
hold off;
xlim([0 T])


% [PxxU,f] = pwelch(detrend(y),fs);
% figure()
% plot(f,PxxU/max(PxxU),'k-');
% xlabel('Frequency [Hz]');
% ylabel('Power spectral density [-]');
% set(gca,'FontName','TimesNewRoman','FontSize',20);


