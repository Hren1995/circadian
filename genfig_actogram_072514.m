[a,t] = actogram('/Volumes/Fly_Aging/Circadian/072514_095734');
plot(9.95+t/(60*60*1000),a)
xlabel('time (hrs. after midnight)','FontSize',12)
ylabel('active minutes during 20 minute window','FontSize',12)