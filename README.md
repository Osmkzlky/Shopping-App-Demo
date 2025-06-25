# 🛍️ Alışveriş Uygulaması – Flutter & Firebase

Flutter ile geliştirilmiş, Firebase destekli, görselleri ImageKit.io üzerinden yönetilen modern bir mobil alışveriş uygulaması.

---

## 📁 Proje Yapısı
<pre lang="markdown">

lib/
├── components/           # Yeniden kullanılabilir UI bileşenleri (örneğin: custom button, product card)
├── controllers/          # ViewModel veya iş mantığı sınıfları
├── helpers/              # Yardımcı fonksiyonlar, validator, extension vs.
├── models/               # Veri modelleri (User, Product vs.)
├── services/             # Firebase, ImageKit, auth servisleri
├── theme/                # Renk, yazı tipi ve tema dosyaları
├── views/                # Tüm sayfalar (home, login, cart vs.)
├── firebase_options.dart # Firebase yapılandırma dosyası (otomatik oluşturulur)
└── main.dart             # Uygulamanın giriş noktası

</pre>

## 🚀 Kurulum ve Çalıştırma
1. Flutter bağımlılıklarını yükle:
flutter pub get
2. Firebase yapılandırması:
	•	firebase_options.dart dosyasının otomatik oluşturulduğundan emin olun (flutterfire configure komutu ile).
	•	google-services.json dosyasını android/app/ klasörüne ekleyin.
	•	Gerekirse GoogleService-Info.plist dosyasını ios/Runner/ klasörüne ekleyin.
3. Uygulamayı çalıştır:
flutter run
## Kullanılan Teknolojiler
| Teknoloji       | Açıklama                                      |
|-----------------|-----------------------------------------------|
| 🧩 Flutter       | Mobil UI geliştirme framework’ü               |
| 🔥 Firebase      | Veritabanı ve kimlik doğrulama                |
| 🖼️ ImageKit.io   | Ürün resimlerinin CDN ile depolanması         |
| 🔐 Google Auth   | Güvenli kullanıcı giriş sistemi               |

## 📲 Özellikler

- 🔐 Firebase ile kullanıcı girişi ve kimlik doğrulama  
- 🛒 Ürün listeleme, detay sayfası ve favorilere ekleme  
- 🔄 Reaktif yapı (controller-view yapısı ile)  
- ✅ Flutter MVVM benzeri yapı kullanımı
- 💬Ürünlere yorum ekleme

🎥 Demo
🎬 [YouTube: Tanıtım Videosu İzle(Yüksek Çözünürlük)](https://youtu.be/B2UlXiQbi_w?si=l1bZyh1Hdd2dg04H)



https://github.com/user-attachments/assets/35cc7aee-f2ed-4b3b-a128-c3bd4f94b8cf



![a1](https://github.com/user-attachments/assets/b1e51105-4805-4b9c-9190-354d8b81d143)
![a2](https://github.com/user-attachments/assets/358eb169-d865-4790-9092-16be26617819)
![a3](https://github.com/user-attachments/assets/fd0e8ac3-3453-40bc-8adf-2586b1e57f7b)
![a5](https://github.com/user-attachments/assets/741312e9-e2e2-432a-a5c0-05e5963fd1b3)
![a4](https://github.com/user-attachments/assets/85cc2db8-defb-440f-8d2e-b18942780db2)




## 🤝 Katkı Sağlamak

Katkı sunmak istersen:

1. Fork oluştur  
2. Yeni bir branch aç (`feature/yenilik`)  
3. Değişiklikleri commit et  
4. Pull Request gönder 🚀




