
%#################OTOMASYON TANIMI############
%Otob�s Firmalar� taraf�ndan kullan�lan otomasyon sistemidir.
%Otob�s firmalar�;
%g�nl�k sefer ekleyebilir,
%t�m rakip firmalar�na ait seferleri listeleyebilir,
%ekledikleri seferleri silebilir,
%seferler aras� genel arama yapabilir,
%genel indirim oranlar�na g�re seferleri s�ralayabilir,
%g�n�n indirim kazanan firmas�n� g�r�nt�leyebilir,
% indirim oranlar�na g�re istatistiksel verilerin grafiksel g�sterimine
% ula�abilir.


%#################OTOMASYON A�IKLAMASI############

%Her firmaya ait bir �zel id bulunur.(Genel ID d���ndad�r).
%Silme i�lemlerini bu firmaId ile yapabilir.Bunun nedeni bir firman�n di�er
%firman�n seferini silmesinin �n�ne ge�mektir.(�ye �ifresi gibi d���n�lebilir.)

%�ndirimli Biletleri S�ralama  ve genel istatistiklik b�l�mlerinde, firman�n seferlerini eklerken tan�mlad�klar� indirim oran� dikkate al�nmaktad�r.

%G�n�n firmas�na tan�mlanan f�rsat indirimi b�l�m�nde, g�n�n en �ok sefer
%tan�mlayan firmas�na,otomasyon taraf�ndan , firman�n o g�nk� en y�ksek
%indirim oranl� seferinin indirim oran�na ek %5 indirim tan�mlan�r.





function bus
clc;
[sayi,~,tumu]=xlsread('seferler.xlsx');
%her silme sonucunda exel dosyas�n�n i�eri�i de�i�iyor.Bu nedenle gelen
%verileri g�ncel tutmam gerekti�i i�in yenile fonksiyonunu olu�turdum.
[sayisalDegerler,firmaAdi,kalkisYeri,varisYeri,seferSaati]=yenile(sayi,tumu);
%end
sayisalDegerler(:,3:6)=[];
secim=-1;
fprintf('#############  �ehirler aras� sefer ekleyebilece�iniz �enTicket''a Ho�geldiniz ############# \n');
fprintf('-------------  A�a��daki Men�den Yapmak istedi�iniz ��lemi Se�iniz -------------\n\n');
islemYapildi=0;
while(secim ~= 8)
    menu();
    secim=input(' ��leminiz:  ');
    if(isempty(secim)==0 )
        switch secim
            case 1
                fprintf('\n')
                listele(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati);
            case 2
                firma_adi   = input('Firma Ad� Giriniz :','s');
                kalkis_yeri = input('Kalk�� noktas� i�in bir il ad� giriniz : ','s');
                varis_yeri  = input('Var�� noktas� i�in bir il ad� giriniz : ','s');
                sefer_saati = input('Sefer Saati : ','s');
                uzaklik     = input('�ehirler Aras� Mesafeyi Giriniz : ');
                indirim     = input('�ndirim tan�mlamak istiyorsan�z y�zdelik olarak bir de�er giriniz. \n �ndirim tan�mlamak istemiyorsan�z 0''a bas�n�z. :');
                
                if(isempty(firma_adi) || isempty(kalkis_yeri) || isempty(varis_yeri) || isempty(sefer_saati) || isempty(uzaklik) || isempty(indirim))
                    fprintf('\n\n!!!!!!!!!!!L�tfen Bilgileri Eksiksiz Doldurunuz!!!!!!!!\n\n\n\n');
                else
                    [islemYapildi,firmaId,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=ekle(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,upper(firma_adi),upper(kalkis_yeri),upper(varis_yeri),sefer_saati,uzaklik,indirim);
                    fprintf('Ekleme ��lemi Ba�ar�l�!\n');
                    %Bir firman�n birden fazla seferi var.bu nedenle
                    % 2. bir id tan�mlamam gerekiyor
                    fprintf('�NEML�! Silme ��lemlerinde kullanaca��n�z firman�za �zel tan�ml� kodunuz : %d \n',firmaId);
                    %end
                    fprintf('\n');
                end;
            case 3
                kod  = input('\nEkleme i�lemi s�ras�nda  firman�za �zel tan�mlanan kodunuzu giriniz : ');%bir firmaya ait birden fazla sefer var.ve firmalar i�inde ayr� ayr� silme i�lemi yap�labilsin diye her firmaya ait ayr� bir id var
                fprintf('\n')
                [islemYapildi,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=sil(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,kod);
            case 4
                kalkis_noktasi = input('Nereden ? : ','s');
                varis_noktasi  = input('Nereye ?: ','s');
                biletAra(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,upper(kalkis_noktasi),upper(varis_noktasi));
            case 5
                indirimSirala(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati);
            case 6
                [sayisalDegerler]=gununFirmasiHesapla(islemYapildi,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati);
                islemYapildi=islemYapildi+1;
            case 7
                grafik(sayisalDegerler,firmaAdi);
                
            case 8
                disp('Program Sonland�.�enTicket''� Tercih Etti�iniz ��in Te�ekk�r Ederiz!');
                save Data.mat;
                break;
            otherwise
                disp('L�tfen Men�deki De�erlerden Birini Se�iniz!');
                
        end
    else
        disp('L�tfen Men�deki De�erlerden Birini Se�iniz!');
        pause(0.8);
        bus();
        
    end
    
end
end
function menu
fprintf(' 1-Seferleri Listele\n 2-Sefer Ekle\n 3-Sefer Sil\n 4-Sefer Ara\n 5-�ndirimli Biletleri S�rala \n 6-G�n�n Firmas�na Tan�mlanan F�rsat �ndirimi \n 7-Turizm �irketlerine Ait Sefer �ndirim Oranlar� �statisti�i(G�nl�k) \n 8-Program� Sonland�r \n\n');
end
function [sayisalDegerler,firmaAdi,kalkisYeri,varisYeri,seferSaati]=yenile(sayi,tumu)
%bu fonk g�nceller olarak silme i�lemleri sonras�nda nan degerileri olan
%sat�rlar� siler
[x,y]=size(sayi);
sayisalDegerler=sayi;
silindi=0;
%tablonun yaz� k�sm� yani ilk sat�r k�rp�l�yor
tumu(1,:)=[];
if(isnan(tumu{1,1}))
    tumu(1,:)=[];
end
%end
for i=1:x
    %daha �nce silme i�lemi yap�lm�ssa i de�erini yani indisi azaltmam
    %gerekiyor
    if( silindi==1 )
        if(isnan(sayi(i,:)) )
            sayisalDegerler(i-1,:)=[];
            tumu(i-1,:)=[];
        end
        %end
    else
        if(isnan(sayi(i,:)) )
            silindi=1;
            sayisalDegerler(i,:)=[];
            tumu(i,:)=[];
        end
    end
end
firmaAdi    = tumu(1:end,3);
kalkisYeri  = tumu(1:end,4);
varisYeri   = tumu(1:end,5);
seferSaati  = tumu(1:end,6);

end
function exeleYazdir(sayisal_veriler,string_veriler,x)
%Say�sal veriler i�in aral�k belirleme
id              = strcat('A',num2str(x+1));
firmaId         = strcat('B',num2str(x+1));
indirim         = strcat('G',num2str(x+1));
tutar           = strcat('J',num2str(x+1));
numeric_aralik  = strcat(id,':',firmaId);
numeric_aralik2 = strcat(indirim,':',tutar);

%end
%string veriler i�in aral�k belirleme
firma           = strcat('C',num2str(x+1));
saat            = strcat('F',num2str(x+1));
string_aralik   = strcat(firma,':',saat);
%end
xlswrite('seferler.xlsx',sayisal_veriler(1,1:2),numeric_aralik);
xlswrite('seferler.xlsx',sayisal_veriler(1,3:end),numeric_aralik2);
for i=1:4
    xlswrite('seferler.xlsx',string_veriler,1,string_aralik);
end
end
function [tutar,indirimli]=hesapla(km,indirim)
%km ye g�re biletin fiyat�n�n hesapland��� fonksiyon
tutar=0;
if(indirim ~= 0 )
    tutar = km*0.4;% km bas�na 0.4 tl
    indirim_tutari=(tutar*indirim)/100;
    indirimli=tutar-indirim_tutari;
else
    tutar=km*0.4;
    indirimli=tutar;
end
end
function listele(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati)
[x,y]=size(sayisalDegerler);
fprintf('ID \t  Firma Ad� \t  Kalk�� Yeri \t\t\t Var�� Yeri \t\t Sefer Saati \t\t �ndirim Oran�(Y�zde) \t Genel Tutar(TL) \t �ndirimli Tutar(TL)');
fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------------------------')
fprintf('\n');
for i=1:x
    fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{i},kalkisYeri{i},varisYeri{i},seferSaati{i},sayisalDegerler(i,3),sayisalDegerler(i,5),sayisalDegerler(i,6));
    fprintf('\n');
end
fprintf('\n');
end
function [islemYapildi,firmaId,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=ekle(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,firma_adi,kalkis_yeri,varis_yeri,sefer_saati,uzaklik,indirim)
% Dinamik Id Tan�mlamas�
sonID=max(sayisalDegerler(:,1));
newID=sonID+1;
%end
% indirimli ve genel bilet fiyat� hesaplama
[tutar,indirimli]=hesapla(uzaklik,indirim);
%end
[x,y]=size(firmaAdi) ;
varmi=0;

for i=1:x
    %firmaya �zel id tan�mlanmas�(firmaId )
    newStr = strrep(firmaAdi(i),'�','I');
    cevap = strrep(upper(firma_adi),'�','I');
    %gelen firma ad� sistemde varsa firmaId tablodan
    %getiriliyor.mesela �en turizm girildi sistemde bu firma ad� tan�ml�yd� ve firmaId si
    %1di.burda yeni eklenen �en turizm seferinin id 1 yap�l�yor.Yani T�m
    %�en Turizmlerin firmaId 'si 1 olur
    if(strcmp(newStr,cellstr(cevap)) && sayisalDegerler(i,2) ~= 0)
        firmaId=sayisalDegerler(i,2);
        sayisalDegerler(x+1,2) =firmaId;
        varmi=varmi+1;
        break;
    end
    %end
end
%gelen firma ad� sistemde yoksa firmaId sutunun en b�y��� al�n�r ve bir
%at�rarak yeni bir firmaId olu�turulur
if(varmi == 0)
    max_id= max(sayisalDegerler(:,2));
    firmaId=max_id+1;
    sayisalDegerler(x+1,2) =firmaId;
end
%end
%not:firmaId ile Id farkl� sutunlar.
varisYeri {x+1}        =varis_yeri;
firmaAdi  {x+1}        =firma_adi;
kalkisYeri{x+1}        =kalkis_yeri;
seferSaati{x+1}        =sefer_saati;
sayisalDegerler(x+1,1) =newID;
sayisalDegerler(x+1,3) =indirim;
sayisalDegerler(x+1,4) =uzaklik;
sayisalDegerler(x+1,5) =tutar;
sayisalDegerler(x+1,6) =indirimli;
[x,y]=size(firmaAdi) ;
sayisal_veriler=[newID firmaId indirim uzaklik tutar indirimli];
string_veriler ={firma_adi kalkis_yeri varis_yeri num2str(sefer_saati)};
exeleYazdir(sayisal_veriler,string_veriler,x);
fprintf('\n');
islemYapildi=0;%menunun 6.��kk� i�in
end
function biletAra(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,kalkis_noktasi,varis_noktasi)
[x,y]=size(firmaAdi);
bulundu=0;

for i=1:x
    if(i==1)
        fprintf('\nID \t  Firma Ad� \t  Kalk�� Yeri \t\t\t Var�� Yeri \t\t Sefer Saati \t\t �ndirim Oran�(Y�zde) \t Genel Tutar(TL) \t �ndirimli Tutar(TL)');
        fprintf('\n');
        disp('---------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\n');
    end
    yeniKalkisYeri = strrep(kalkisYeri(i),'�','I');
    yeniVarisYeri = strrep(varisYeri(i),'�','I');
    if(strcmp(yeniKalkisYeri,cellstr(kalkis_noktasi)) && strcmp(yeniVarisYeri,cellstr(varis_noktasi)))
        fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{i},kalkisYeri{i},varisYeri{i},seferSaati{i},sayisalDegerler(i,3),sayisalDegerler(i,5),sayisalDegerler(i,6));
        bulundu=bulundu+1;
        fprintf('\n');
    end
end
if(bulundu==0)
    fprintf('\nArama Sonucu Bulunamad�!\n')
end
fprintf('\n');
end
function [islemYapildi,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=sil(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,kod)
[x,y]=size(sayisalDegerler);
bulundu=0;
fprintf('ID \t  Firma Ad� \t  Kalk�� Yeri \t\t\t Var�� Yeri \t\t Sefer Saati \t\t �ndirim Oran�(Y�zde) \t Genel Tutar(TL) \t �ndirimli Tutar(TL)');
fprintf('\n');
for i=1:x
    if(sayisalDegerler(i,2) == kod && isnan(sayisalDegerler(i,2))== 0)
        bulundu=bulundu+1;
        fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{i},kalkisYeri{i},varisYeri{i},seferSaati{i},sayisalDegerler(i,3),sayisalDegerler(i,5),sayisalDegerler(i,6));
        fprintf('\n');
    end
end
if(bulundu >0 )
    silinecekID  = input('\nSilmek istedi�iniz sefere ait id numaras�n� se�iniz : ');
    fprintf('\n');
    for i=1:x
        if(sayisalDegerler(i,1) == silinecekID)
            
            ilk           = strcat('A',num2str(i+1));
            son           = strcat('J',num2str(i+1));
            aralik         = strcat(ilk,':',son);
            xlswrite('seferler.xlsx',{''},aralik);
            sayisalDegerler(i,:)=[];
            firmaAdi(i,:)=[];
            kalkisYeri(i,:)=[];
            varisYeri(i,:)=[];
            seferSaati(i,:)=[];
            break;
        end
    end
    listele(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati);
    fprintf('\n');
else
    fprintf('Bu deger sistemde tan�ml� firmalar ile uyu�muyor! L�tfen Tekrar Deneyin.');
    
end
islemYapildi=0;
end
function indirimSirala(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati)
[x,y]=size(sayisalDegerler);
for i=1:x
    for j=i+1:x
        if(sayisalDegerler(i,3)<sayisalDegerler(j,3))
            %indirim oran�na g�re s�rala
            bos=sayisalDegerler(i,3);
            sayisalDegerler(i,3)=sayisalDegerler(j,3);
            sayisalDegerler(j,3)=bos;
            %end
            %idleride ona g�re s�rala
            bos1=sayisalDegerler(i,1);
            sayisalDegerler(i,1)=sayisalDegerler(j,1);
            sayisalDegerler(j,1)=bos1;
            %end
        end
    end
end
disp('###############################################  �ndirim Oran�na G�re �oktan Aza S�ralanm�� Sefer Listesi  #######################################');
fprintf('\n\nID \t  Firma Ad� \t  Kalk�� Yeri \t\t\t Var�� Yeri \t\t Sefer Saati \t\t �ndirim Oran�(Y�zde) \t Genel Tutar(TL) \t �ndirimli Tutar(TL)');
fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------------------------')

for i=1:x
    id=sayisalDegerler(i,1);
    fprintf('\n');
    fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{id},kalkisYeri{id},varisYeri{id},seferSaati{id},sayisalDegerler(i,3),sayisalDegerler(id,5),sayisalDegerler(id,6));
    fprintf('\n');
end
fprintf('\n');
end
function [sayisalDegerler]=gununFirmasiHesapla(islemYapildi,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati)
% p matrisinin ilk sutunu firma id, ikinci sutunu o firmaya ait toplam sefer say�s�
p=[];
%end
count=0;
[x,y]=size(sayisalDegerler);
for i=1:x
    for j=1:x
        if(sayisalDegerler(j,2) ==i)
            count=count+1;
            p(i,1)=i;
            p(i,2)=count;
        end
    end
    count=0;
end
% disp(p)%olusan 2 ye 2 lik matriste ilk sutun firma idsi, ikinci sutun o idye sahip firmaya ait toplam sefer say�s�
[count,id] = max (p(:,2));
maxValue=0;indis=0;
%indirim oran� en y�ksek firman�n genel idsi ve indirim oran� bulunur
for i=1:x
    if(sayisalDegerler(i,2) == id)
        if(max (sayisalDegerler(i,3))>maxValue)
            maxValue=max (sayisalDegerler(i,3));
            indis=i;
        end
    end
end
%end
eskiTutar=sayisalDegerler(indis,6);
%daha �nce men�den bu alan hi� se�ilmemi�se hesaplar. daha �nce se�ilmi�se
%tekrar hesapla yapt�r�lmaz.
if(islemYapildi==0)
    indirimTutari = maxValue+5;% otomasyon taraf�ndan g�n�n en �ok sefer yapan firmas�na,  seferleriden indirim oran� en y�ksek olana, indirim oran�na ek  %5 indirim tan�mlan�r.
    indirimli=(sayisalDegerler(indis,5)*indirimTutari)/100;%genel fiyat * indirim oran�(yeni y�zdelik)/100
    sonFiyat=sayisalDegerler(indis,5)-indirimli;%genel tutardan indirimi ��kar
    sayisalDegerler(indis,3)=indirimTutari;% indirim oran� yeni indirim oran� olsun
    sayisalDegerler(indis,6)=sonFiyat;% indirimli fiyat yeni fiyat olsun
    
    %exel alan� g�ncellenecek. G�ncellenecek h�crelerin olu�turulmas�
    indirimOraniCell           = strcat('G',num2str(indis+1));%tablonun ilk sat�r� bilgi sat�r� o yuzden indis+1
    indirimliTutarCell         = strcat('J',num2str(indis+1));
    %end
    xlswrite('seferler.xlsx',indirimTutari,1,indirimOraniCell);
    xlswrite('seferler.xlsx',sonFiyat,1,indirimliTutarCell);
else
    indirimTutari=(sayisalDegerler(indis,3));
    sonFiyat=(sayisalDegerler(indis,6));
    
end

fprintf('\n');
disp('########################################################################################### G�n�n Firmas�na Tan�mlanan F�rsat �ndirimi  ##################################################################################');
fprintf('\nID \t  Firma Ad� \t  Kalk�� Yeri \t\t\t Var�� Yeri \t\t Sefer Saati  \t  Yeni �ndirim Oran�yla Birlikte(+ Y�zde 5) \t Genel Tutar(TL) \t Eski �ndirimli Tutar(TL) \t Yeni �ndirimli Tutar(TL)');
fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------')
fprintf('\n%d \t  %-15s \t %-15s \t %-15s \t  %-25s \t   %d \t\t\t\t\t\t\t   %.2f \t\t\t\t  %.2f  \t\t\t\t  %.2f',sayisalDegerler(indis,1),firmaAdi{indis},kalkisYeri{indis},varisYeri{indis},seferSaati{indis},indirimTutari,sayisalDegerler(indis,5),eskiTutar,sonFiyat);
fprintf('\n\n');



end
function grafik(sayisalDegerler,firmaAdi)

p=[];k=[];firma={};count=0;sayac=0;toplam=0;
[x,y]=size(sayisalDegerler);
%2 ye 2 lik p matrisinde ilk sutun firmaId,ikinci sutun o firman�n toplam sefer say�s�
%2 ye 2 lik k matrisinde ilk sutun firmaId,ikinci sutun o firman�n  indirim oranlar�n�n toplam�
%1 ye 1 lik firma matrisinde firmalar�n isimleri
for i=1:x
    for j=1:x
        if(sayisalDegerler(j,2) ==i)
            count=count+1;
            p(i,1)=i;%firmaId
            p(i,2)=count;%toplam sefer say�s�
        end
    end
    count=0;
end

[px,py]=size(p);
for i=1:px
    for j=1:x
        %firma id si bu olan�n t�m indirim oran�n� topla
        if(sayisalDegerler(j,2) == p(i,1))
            toplam=toplam+sayisalDegerler(j,3);
            sayac=sayac+1;
        end
        %end
    end
    k(i,1)=i;%firmaId
    k(i,2)=toplam; %firmaya ait toplam indirim
    toplam=0;% di�er firma i�in de�erleri s�f�rla
    sayac=0;% di�er firma i�in de�erleri s�f�rla
    
end
% k matrisi firmalara �zel indirim oranlar�n� toplam�n�  yani
% grafi�in y eksenini tutuyordu. firma matrisi ise grafi�in x eksenini yani
% firmalar�n isimlerini tutuyor
for i=1:px
    for j=1:x
        if(sayisalDegerler(j,2)==p(i,1))
            firma{1,i}=firmaAdi{j};
        end
    end
end
%end
indirimToplami=k(:,2);
h=figure;
Y=indirimToplami';
bar(Y,0.4,'FaceColor',[0.3010 0.7450 0.9330],'EdgeColor',[0 0.4470 0.7410],'LineWidth',2)
title('Turizm �irketlerine ait sefer indirim oranlar� toplam� (G�nl�k) ')
xlabel('Tuzim �irketleri')
ylabel('�ndirim Oran�(%)');
set (gca, 'xticklabel' , { firma{1,:} });
end
