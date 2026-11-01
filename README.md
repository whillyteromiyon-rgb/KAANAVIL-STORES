# KANAVIL STORES – Android app source

This is an updated Flutter app source project. It is **not yet an installable APK**.

## Included in this version
- KANAVIL STORES name and “Freshness for Healthy Life” tagline
- Vegetable and fruit catalogue sections, including the requested fruit list
- Grocery search and category filters
- Cart quantity controls
- WhatsApp order handoff to **+91 7736372947**
- Delivery-area list
- English / Malayalam interface toggle
- GitHub Actions workflow to build a release APK

## Important stock confirmation
The vegetable and fruit names are catalogue suggestions based on the shop owner's request. They are **not confirmation of live stock**. Confirm every item, spelling (especially “Kiran”), unit, price, and availability with **Cochin Trading Co., Pattimattom** before the app is shared with customers. The app currently asks the store to confirm availability and final prices on WhatsApp.

## Build the APK using GitHub Actions
1. Download and extract this ZIP.
2. Create a GitHub repository and upload all files from this folder.
3. Open the repository's **Actions** tab.
4. Select **Build KANAVIL STORES APK** and choose **Run workflow** (or push to `main`).
5. When the run finishes, open it and download the `kanavil-stores-android-apk` artifact.
6. Extract the downloaded artifact ZIP to get `app-release.apk`.
7. Install and test the APK on an Android phone before sharing it.

## Local build (if Flutter is installed)
Run `flutter create --platforms=android .`, then `flutter pub get`, then `flutter build apk --release`.

## Not yet implemented
This starter does not yet include live inventory/database, admin login/dashboard, online payment gateway, delivery tracking, push notifications, or a production order-management backend. These need additional development and setup before commercial launch.

## PhonePe QR payment option
The cart now shows the shop's PhonePe QR image and UPI ID `Q667834682@ybl`, with a choice of PhonePe/UPI QR or Cash on Delivery. The order is handed to WhatsApp `+91 7736372947` with the selected payment method. UPI payments are **not automatically verified**: the customer must send a payment screenshot and the shop must confirm the credit in its PhonePe Business account before accepting the order as paid. Never rely on a screenshot alone.
