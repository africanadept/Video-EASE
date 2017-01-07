%% IBO_140703_A_02_03
%% Static Plot

ekwebody=load('IBO_140703_A_02_03_EkweBody_fr1.mat');
ekwestick=load('IBO_140703_A_02_03_EkweStick_fr1.mat');
leftbeater=load('IBO_140703_A_02_03_LeftBeater_fr1.mat');
rightbeater=load('IBO_140703_A_02_03_RightBeater_fr1.mat');


[ekwe,n] = midi2nmat('IBO_140703_A_02_03_Ekwe.mid')
ekons=ekwe(:,6)
[udu,n] = midi2nmat('IBO_140703_A_02_03_Udu.mid')
udu(1,:)=[];
udons=udu(:,6)

eb=ekwebody.motion;
es=ekwestick.motion;
lb=leftbeater.motion;
rb=rightbeater.motion;

% figure()
% subplot(4,1,1)
% plot(eb(:,1),eb(:,3));
% hold on
% plot(es(:,1),es(:,3));
% title('EkweVertical')
% for i=1:numel(ekons)
% plot([ekons(i) ekons(i)], [min([es(:,3);eb(:,3)]), max([es(:,3);eb(:,3)])], 'k:');
% end
% axis ij
% axis tight
% hold off
%
% subplot(4,1,2)
% plot(lb(:,1),lb(:,2));
% hold on
% plot(rb(:,1),rb(:,2));
% title('UduHorizontal')
% for i=1:numel(udons)
% plot([udons(i) udons(i)], [min([lb(:,2);rb(:,2)]), max([lb(:,2);rb(:,2)])], 'k:');
% end
% hold off
% axis tight
%
% subplot(4,1,3)
% plot(lb(:,1),lb(:,3));
% hold on
% plot(rb(:,1),rb(:,3));
% title('UduVertical')
% for i=1:numel(udons)
% plot([udons(i) udons(i)], [min([lb(:,3);rb(:,3)]), max([lb(:,3);rb(:,3)])], 'k:');
% end
% hold off
% axis tight
% axis ij