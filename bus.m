
%#################OTOMASYON TANIMI############
%Otobüs Firmalarý tarafýndan kullanýlan otomasyon sistemidir.
%Otobüs firmalarý;
%günlük sefer ekleyebilir,
%tüm rakip firmalarýna ait seferleri listeleyebilir,
%ekledikleri seferleri silebilir,
%seferler arasý genel arama yapabilir,
%genel indirim oranlarýna göre seferleri sýralayabilir,
%günün indirim kazanan firmasýný görüntüleyebilir,
% indirim oranlarýna göre istatistiksel verilerin grafiksel gösterimine
% ulaþabilir.


%#################OTOMASYON AÇIKLAMASI############

%Her firmaya ait bir özel id bulunur.(Genel ID dýþýndadýr).
%Silme iþlemlerini bu firmaId ile yapabilir.Bunun nedeni bir firmanýn diðer
%firmanýn seferini silmesinin önüne geçmektir.(Üye þifresi gibi düþünülebilir.)

%Ýndirimli Biletleri Sýralama  ve genel istatistiklik bölümlerinde, firmanýn seferlerini eklerken tanýmladýklarý indirim oraný dikkate alýnmaktadýr.

%Günün firmasýna tanýmlanan fýrsat indirimi bölümünde, günün en çok sefer
%tanýmlayan firmasýna,otomasyon tarafýndan , firmanýn o günkü en yüksek
%indirim oranlý seferinin indirim oranýna ek %5 indirim tanýmlanýr.





function bus
clc;
[sayi,~,tumu]=xlsread('seferler.xlsx');
%her silme sonucunda exel dosyasýnýn içeriði deðiþiyor.Bu nedenle gelen
%verileri güncel tutmam gerektiði için yenile fonksiyonunu oluþturdum.
[sayisalDegerler,firmaAdi,kalkisYeri,varisYeri,seferSaati]=yenile(sayi,tumu);
%end
sayisalDegerler(:,3:6)=[];
secim=-1;
fprintf('#############  Þehirler arasý sefer ekleyebileceðiniz ÞenTicket''a Hoþgeldiniz ############# \n');
fprintf('-------------  Aþaðýdaki Menüden Yapmak istediðiniz Ýþlemi Seçiniz -------------\n\n');
islemYapildi=0;
while(secim ~= 8)
    menu();
    secim=input(' Ýþleminiz:  ');
    if(isempty(secim)==0 )
        switch secim
            case 1
                fprintf('\n')
                listele(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati);
            case 2
                firma_adi   = input('Firma Adý Giriniz :','s');
                kalkis_yeri = input('Kalkýþ noktasý için bir il adý giriniz : ','s');
                varis_yeri  = input('Varýþ noktasý için bir il adý giriniz : ','s');
                sefer_saati = input('Sefer Saati : ','s');
                uzaklik     = input('Þehirler Arasý Mesafeyi Giriniz : ');
                indirim     = input('Ýndirim tanýmlamak istiyorsanýz yüzdelik olarak bir deðer giriniz. \n Ýndirim tanýmlamak istemiyorsanýz 0''a basýnýz. :');
                
                if(isempty(firma_adi) || isempty(kalkis_yeri) || isempty(varis_yeri) || isempty(sefer_saati) || isempty(uzaklik) || isempty(indirim))
                    fprintf('\n\n!!!!!!!!!!!Lütfen Bilgileri Eksiksiz Doldurunuz!!!!!!!!\n\n\n\n');
                else
                    [islemYapildi,firmaId,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=ekle(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,upper(firma_adi),upper(kalkis_yeri),upper(varis_yeri),sefer_saati,uzaklik,indirim);
                    fprintf('Ekleme Ýþlemi Baþarýlý!\n');
                    %Bir firmanýn birden fazla seferi var.bu nedenle
                    % 2. bir id tanýmlamam gerekiyor
                    fprintf('ÖNEMLÝ! Silme Ýþlemlerinde kullanacaðýnýz firmanýza özel tanýmlý kodunuz : %d \n',firmaId);
                    %end
                    fprintf('\n');
                end;
            case 3
                kod  = input('\nEkleme iþlemi sýrasýnda  firmanýza özel tanýmlanan kodunuzu giriniz : ');%bir firmaya ait birden fazla sefer var.ve firmalar içinde ayrý ayrý silme iþlemi yapýlabilsin diye her firmaya ait ayrý bir id var
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
                disp('Program Sonlandý.ÞenTicket''ý Tercih Ettiðiniz Ýçin Teþekkür Ederiz!');
                save Data.mat;
                break;
            otherwise
                disp('Lütfen Menüdeki Deðerlerden Birini Seçiniz!');
                
        end
    else
        disp('Lütfen Menüdeki Deðerlerden Birini Seçiniz!');
        pause(0.8);
        bus();
        
    end
    
end
end
function menu
fprintf(' 1-Seferleri Listele\n 2-Sefer Ekle\n 3-Sefer Sil\n 4-Sefer Ara\n 5-Ýndirimli Biletleri Sýrala \n 6-Günün Firmasýna Tanýmlanan Fýrsat Ýndirimi \n 7-Turizm Þirketlerine Ait Sefer Ýndirim Oranlarý Ýstatistiði(Günlük) \n 8-Programý Sonlandýr \n\n');
end
function [sayisalDegerler,firmaAdi,kalkisYeri,varisYeri,seferSaati]=yenile(sayi,tumu)
%bu fonk günceller olarak silme iþlemleri sonrasýnda nan degerileri olan
%satýrlarý siler
[x,y]=size(sayi);
sayisalDegerler=sayi;
silindi=0;
%tablonun yazý kýsmý yani ilk satýr kýrpýlýyor
tumu(1,:)=[];
if(isnan(tumu{1,1}))
    tumu(1,:)=[];
end
%end
for i=1:x
    %daha önce silme iþlemi yapýlmýssa i deðerini yani indisi azaltmam
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
%Sayýsal veriler için aralýk belirleme
id              = strcat('A',num2str(x+1));
firmaId         = strcat('B',num2str(x+1));
indirim         = strcat('G',num2str(x+1));
tutar           = strcat('J',num2str(x+1));
numeric_aralik  = strcat(id,':',firmaId);
numeric_aralik2 = strcat(indirim,':',tutar);

%end
%string veriler için aralýk belirleme
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
%km ye göre biletin fiyatýnýn hesaplandýðý fonksiyon
tutar=0;
if(indirim ~= 0 )
    tutar = km*0.4;% km basýna 0.4 tl
    indirim_tutari=(tutar*indirim)/100;
    indirimli=tutar-indirim_tutari;
else
    tutar=km*0.4;
    indirimli=tutar;
end
end
function listele(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati)
[x,y]=size(sayisalDegerler);
fprintf('ID \t  Firma Adý \t  Kalkýþ Yeri \t\t\t Varýþ Yeri \t\t Sefer Saati \t\t Ýndirim Oraný(Yüzde) \t Genel Tutar(TL) \t Ýndirimli Tutar(TL)');
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
% Dinamik Id Tanýmlamasý
sonID=max(sayisalDegerler(:,1));
newID=sonID+1;
%end
% indirimli ve genel bilet fiyatý hesaplama
[tutar,indirimli]=hesapla(uzaklik,indirim);
%end
[x,y]=size(firmaAdi) ;
varmi=0;

for i=1:x
    %firmaya özel id tanýmlanmasý(firmaId )
    newStr = strrep(firmaAdi(i),'Ý','I');
    cevap = strrep(upper(firma_adi),'Ý','I');
    %gelen firma adý sistemde varsa firmaId tablodan
    %getiriliyor.mesela þen turizm girildi sistemde bu firma adý tanýmlýydý ve firmaId si
    %1di.burda yeni eklenen þen turizm seferinin id 1 yapýlýyor.Yani Tüm
    %Þen Turizmlerin firmaId 'si 1 olur
    if(strcmp(newStr,cellstr(cevap)) && sayisalDegerler(i,2) ~= 0)
        firmaId=sayisalDegerler(i,2);
        sayisalDegerler(x+1,2) =firmaId;
        varmi=varmi+1;
        break;
    end
    %end
end
%gelen firma adý sistemde yoksa firmaId sutunun en büyüðü alýnýr ve bir
%atýrarak yeni bir firmaId oluþturulur
if(varmi == 0)
    max_id= max(sayisalDegerler(:,2));
    firmaId=max_id+1;
    sayisalDegerler(x+1,2) =firmaId;
end
%end
%not:firmaId ile Id farklý sutunlar.
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
islemYapildi=0;%menunun 6.þýkký için
end
function biletAra(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,kalkis_noktasi,varis_noktasi)
[x,y]=size(firmaAdi);
bulundu=0;

for i=1:x
    if(i==1)
        fprintf('\nID \t  Firma Adý \t  Kalkýþ Yeri \t\t\t Varýþ Yeri \t\t Sefer Saati \t\t Ýndirim Oraný(Yüzde) \t Genel Tutar(TL) \t Ýndirimli Tutar(TL)');
        fprintf('\n');
        disp('---------------------------------------------------------------------------------------------------------------------------------------------')
        fprintf('\n');
    end
    yeniKalkisYeri = strrep(kalkisYeri(i),'Ý','I');
    yeniVarisYeri = strrep(varisYeri(i),'Ý','I');
    if(strcmp(yeniKalkisYeri,cellstr(kalkis_noktasi)) && strcmp(yeniVarisYeri,cellstr(varis_noktasi)))
        fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{i},kalkisYeri{i},varisYeri{i},seferSaati{i},sayisalDegerler(i,3),sayisalDegerler(i,5),sayisalDegerler(i,6));
        bulundu=bulundu+1;
        fprintf('\n');
    end
end
if(bulundu==0)
    fprintf('\nArama Sonucu Bulunamadý!\n')
end
fprintf('\n');
end
function [islemYapildi,sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati]=sil(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati,kod)
[x,y]=size(sayisalDegerler);
bulundu=0;
fprintf('ID \t  Firma Adý \t  Kalkýþ Yeri \t\t\t Varýþ Yeri \t\t Sefer Saati \t\t Ýndirim Oraný(Yüzde) \t Genel Tutar(TL) \t Ýndirimli Tutar(TL)');
fprintf('\n');
for i=1:x
    if(sayisalDegerler(i,2) == kod && isnan(sayisalDegerler(i,2))== 0)
        bulundu=bulundu+1;
        fprintf('%d \t  %-15s \t %-15s \t %-15s \t  %-15s \t   %d \t\t\t\t\t   %.2f \t\t\t\t  %.2f ',sayisalDegerler(i,1),firmaAdi{i},kalkisYeri{i},varisYeri{i},seferSaati{i},sayisalDegerler(i,3),sayisalDegerler(i,5),sayisalDegerler(i,6));
        fprintf('\n');
    end
end
if(bulundu >0 )
    silinecekID  = input('\nSilmek istediðiniz sefere ait id numarasýný seçiniz : ');
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
    fprintf('Bu deger sistemde tanýmlý firmalar ile uyuþmuyor! Lütfen Tekrar Deneyin.');
    
end
islemYapildi=0;
end
function indirimSirala(sayisalDegerler,firmaAdi,varisYeri,kalkisYeri,seferSaati)
[x,y]=size(sayisalDegerler);
for i=1:x
    for j=i+1:x
        if(sayisalDegerler(i,3)<sayisalDegerler(j,3))
            %indirim oranýna göre sýrala
            bos=sayisalDegerler(i,3);
            sayisalDegerler(i,3)=sayisalDegerler(j,3);
            sayisalDegerler(j,3)=bos;
            %end
            %idleride ona göre sýrala
            bos1=sayisalDegerler(i,1);
            sayisalDegerler(i,1)=sayisalDegerler(j,1);
            sayisalDegerler(j,1)=bos1;
            %end
        end
    end
end
disp('###############################################  Ýndirim Oranýna Göre Çoktan Aza Sýralanmýþ Sefer Listesi  #######################################');
fprintf('\n\nID \t  Firma Adý \t  Kalkýþ Yeri \t\t\t Varýþ Yeri \t\t Sefer Saati \t\t Ýndirim Oraný(Yüzde) \t Genel Tutar(TL) \t Ýndirimli Tutar(TL)');
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
% p matrisinin ilk sutunu firma id, ikinci sutunu o firmaya ait toplam sefer sayýsý
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
% disp(p)%olusan 2 ye 2 lik matriste ilk sutun firma idsi, ikinci sutun o idye sahip firmaya ait toplam sefer sayýsý
[count,id] = max (p(:,2));
maxValue=0;indis=0;
%indirim oraný en yüksek firmanýn genel idsi ve indirim oraný bulunur
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
%daha önce menüden bu alan hiç seçilmemiþse hesaplar. daha önce seçilmiþse
%tekrar hesapla yaptýrýlmaz.
if(islemYapildi==0)
    indirimTutari = maxValue+5;% otomasyon tarafýndan günün en çok sefer yapan firmasýna,  seferleriden indirim oraný en yüksek olana, indirim oranýna ek  %5 indirim tanýmlanýr.
    indirimli=(sayisalDegerler(indis,5)*indirimTutari)/100;%genel fiyat * indirim oraný(yeni yüzdelik)/100
    sonFiyat=sayisalDegerler(indis,5)-indirimli;%genel tutardan indirimi çýkar
    sayisalDegerler(indis,3)=indirimTutari;% indirim oraný yeni indirim oraný olsun
    sayisalDegerler(indis,6)=sonFiyat;% indirimli fiyat yeni fiyat olsun
    
    %exel alaný güncellenecek. Güncellenecek hücrelerin oluþturulmasý
    indirimOraniCell           = strcat('G',num2str(indis+1));%tablonun ilk satýrý bilgi satýrý o yuzden indis+1
    indirimliTutarCell         = strcat('J',num2str(indis+1));
    %end
    xlswrite('seferler.xlsx',indirimTutari,1,indirimOraniCell);
    xlswrite('seferler.xlsx',sonFiyat,1,indirimliTutarCell);
else
    indirimTutari=(sayisalDegerler(indis,3));
    sonFiyat=(sayisalDegerler(indis,6));
    
end

fprintf('\n');
disp('########################################################################################### Günün Firmasýna Tanýmlanan Fýrsat Ýndirimi  ##################################################################################');
fprintf('\nID \t  Firma Adý \t  Kalkýþ Yeri \t\t\t Varýþ Yeri \t\t Sefer Saati  \t  Yeni Ýndirim Oranýyla Birlikte(+ Yüzde 5) \t Genel Tutar(TL) \t Eski Ýndirimli Tutar(TL) \t Yeni Ýndirimli Tutar(TL)');
fprintf('\n');
disp('---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------')
fprintf('\n%d \t  %-15s \t %-15s \t %-15s \t  %-25s \t   %d \t\t\t\t\t\t\t   %.2f \t\t\t\t  %.2f  \t\t\t\t  %.2f',sayisalDegerler(indis,1),firmaAdi{indis},kalkisYeri{indis},varisYeri{indis},seferSaati{indis},indirimTutari,sayisalDegerler(indis,5),eskiTutar,sonFiyat);
fprintf('\n\n');



end
function grafik(sayisalDegerler,firmaAdi)

p=[];k=[];firma={};count=0;sayac=0;toplam=0;
[x,y]=size(sayisalDegerler);
%2 ye 2 lik p matrisinde ilk sutun firmaId,ikinci sutun o firmanýn toplam sefer sayýsý
%2 ye 2 lik k matrisinde ilk sutun firmaId,ikinci sutun o firmanýn  indirim oranlarýnýn toplamý
%1 ye 1 lik firma matrisinde firmalarýn isimleri
for i=1:x
    for j=1:x
        if(sayisalDegerler(j,2) ==i)
            count=count+1;
            p(i,1)=i;%firmaId
            p(i,2)=count;%toplam sefer sayýsý
        end
    end
    count=0;
end

[px,py]=size(p);
for i=1:px
    for j=1:x
        %firma id si bu olanýn tüm indirim oranýný topla
        if(sayisalDegerler(j,2) == p(i,1))
            toplam=toplam+sayisalDegerler(j,3);
            sayac=sayac+1;
        end
        %end
    end
    k(i,1)=i;%firmaId
    k(i,2)=toplam; %firmaya ait toplam indirim
    toplam=0;% diðer firma için deðerleri sýfýrla
    sayac=0;% diðer firma için deðerleri sýfýrla
    
end
% k matrisi firmalara özel indirim oranlarýný toplamýný  yani
% grafiðin y eksenini tutuyordu. firma matrisi ise grafiðin x eksenini yani
% firmalarýn isimlerini tutuyor
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
title('Turizm Þirketlerine ait sefer indirim oranlarý toplamý (Günlük) ')
xlabel('Tuzim Þirketleri')
ylabel('Ýndirim Oraný(%)');
set (gca, 'xticklabel' , { firma{1,:} });
end
