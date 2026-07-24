// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Rihla';

  @override
  String get navHome => 'Главная';

  @override
  String get navExplore => 'Обзор';

  @override
  String get navBookings => 'Брони';

  @override
  String get navProfile => 'Профиль';

  @override
  String get language => 'Язык';

  @override
  String get getStarted => 'Начать';

  @override
  String get signIn => 'Войти';

  @override
  String get tagline => 'Ваши ворота в Красное море';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get greetingAfternoon => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get featured => 'Рекомендуем';

  @override
  String get popular => 'Популярное';

  @override
  String get restaurants => 'Лучшие рестораны';

  @override
  String get searchHint => 'Поиск впечатлений...';

  @override
  String get sortBy => 'Сортировать по';

  @override
  String get sortRelevance => 'Актуальность';

  @override
  String get sortTopRated => 'Высокий рейтинг';

  @override
  String get sortPriceLow => 'Цена: по возрастанию';

  @override
  String get sortPriceHigh => 'Цена: по убыванию';

  @override
  String get sortNewest => 'Новинки';

  @override
  String get noResults => 'Впечатления не найдены';

  @override
  String resultsCount(int count) {
    return '$count впечатлений в Хургаде.';
  }

  @override
  String get filters => 'Фильтры';

  @override
  String get reset => 'Сбросить';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get clearFilters => 'Очистить фильтры';

  @override
  String get priceRangeLabel => 'Диапазон цен';

  @override
  String get noResultsHelp => 'Измените фильтры или поисковый запрос';

  @override
  String showResultsCount(int count) {
    return 'Показать результаты: $count';
  }

  @override
  String get about => 'О туре';

  @override
  String get included => 'Что включено';

  @override
  String get itinerary => 'Маршрут';

  @override
  String get reviews => 'Отзывы';

  @override
  String get readMore => 'Читать далее';

  @override
  String get readLess => 'Свернуть';

  @override
  String get book => 'Забронировать';

  @override
  String get linkCopied => 'Ссылка скопирована';

  @override
  String photoIndicator(int current, int total) {
    return 'Фото $current из $total';
  }

  @override
  String get hotelPickup => 'Трансфер из отеля';

  @override
  String get freeCancellation => 'Бесплатная отмена';

  @override
  String get subscriberBadge => 'Подписчик';

  @override
  String get chooseDateTime => 'Выберите дату и время';

  @override
  String get adults => 'Взрослые';

  @override
  String get children => 'Дети';

  @override
  String spotsLeft(int count) {
    return '$count мест осталось';
  }

  @override
  String get soldOut => 'Мест нет';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get contactDetails => 'Контактные данные';

  @override
  String get fullName => 'Полное имя';

  @override
  String get primaryPhone => 'Основной телефон';

  @override
  String get backupPhone => 'Запасной телефон';

  @override
  String get hotel => 'Название отеля';

  @override
  String get specialRequests => 'Особые пожелания';

  @override
  String get email => 'Эл. почта';

  @override
  String get fieldRequired => 'Это поле обязательно';

  @override
  String get invalidPhoneNumber => 'Введите корректный номер телефона';

  @override
  String get orderSummary => 'Сводка заказа';

  @override
  String get payVendorNotice =>
      'Rihla не обрабатывает платежи. Полная стоимость оплачивается напрямую поставщику услуг наличными или через его платёжную систему по прибытии.';

  @override
  String get confirmBooking => 'Подтвердить бронирование';

  @override
  String creditNote(String type, int remaining) {
    return 'Используется ваш кредит «$type» — $remaining остаётся после этого бронирования';
  }

  @override
  String get total => 'Итого';

  @override
  String get bookingSubmitted => 'Бронирование отправлено!';

  @override
  String get download => 'Скачать билет';

  @override
  String get shareWhatsapp => 'Поделиться через WhatsApp';

  @override
  String get addCalendar => 'Добавить в календарь';

  @override
  String get bookAnother => 'Забронировать ещё одно впечатление';

  @override
  String get statusConfirmed => 'Подтверждено';

  @override
  String get referenceLabel => 'Номер бронирования';

  @override
  String get ticketNumberLabel => 'Номер билета';

  @override
  String get paymentDueNotice =>
      'Оплата производится напрямую поставщику услуг по прибытии.';

  @override
  String get totalTrips => 'Всего поездок';

  @override
  String get reviewsWritten => 'Написано отзывов';

  @override
  String get activeSubscription => 'Активная подписка';

  @override
  String get settings => 'Настройки';

  @override
  String get signOut => 'Выйти';

  @override
  String get cancel => 'Отмена';

  @override
  String get signOutConfirm => 'Вы действительно хотите выйти?';

  @override
  String get myBookings => 'Мои бронирования';

  @override
  String get mySubscription => 'Моя подписка';

  @override
  String get subscriptionPlans => 'Тарифные планы';

  @override
  String get paymentMethods => 'Сохранённые способы оплаты';

  @override
  String get notifications => 'Уведомления';

  @override
  String daysLeft(int days) {
    return 'Осталось $days дн.';
  }

  @override
  String get cancelBooking => 'Отменить бронирование';

  @override
  String get cancelConfirm =>
      'Вы действительно хотите отменить это бронирование?';

  @override
  String discountApplied(int pct) {
    return 'Скидка по подписке: -$pct%';
  }

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get statusCompleted => 'Завершено';

  @override
  String get active => 'Активна';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get expiryDate => 'Дата окончания';

  @override
  String get creditsRemainingHeader => 'Остаток кредитов';

  @override
  String creditRemaining(int count) {
    return 'Осталось $count';
  }

  @override
  String get creditUsed => '0 — использовано';

  @override
  String get refundRequest => 'Запрос на возврат';

  @override
  String purchaseConfirm(String plan, String price) {
    return 'Купить «$plan» за $price?';
  }

  @override
  String get purchaseSuccess => 'Подписка оформлена!';

  @override
  String validity(int days) {
    return 'Срок действия $days дн.';
  }

  @override
  String get confirm => 'Подтвердить';

  @override
  String get addCard => 'Добавить карту';

  @override
  String cardEndingIn(String brand, String last4) {
    return '$brand, оканчивающаяся на $last4';
  }

  @override
  String get cardNumber => 'Номер карты';

  @override
  String get expiry => 'Срок действия';

  @override
  String get cvv => 'CVV';

  @override
  String get add => 'Добавить';

  @override
  String get refundReasonLabel => 'Причина отмены';

  @override
  String get explanation => 'Подробное объяснение';

  @override
  String get submit => 'Отправить';

  @override
  String get refundReceived => 'Запрос на возврат получен';

  @override
  String get reasonNotSatisfied => 'Не удовлетворён сервисом';

  @override
  String get reasonChangedPlans => 'Изменились планы поездки';

  @override
  String get reasonFinancial => 'Финансовые причины';

  @override
  String get reasonTechnical => 'Техническая проблема';

  @override
  String get reasonOther => 'Другое';

  @override
  String get noActivePlan => 'Нет активной подписки';

  @override
  String get subscriptionRequired =>
      'Для бронирования нужна активная подписка. Выберите тариф, чтобы продолжить.';

  @override
  String get processingPayment => 'Обработка платежа...';

  @override
  String get enterPhoneTitle => 'Введите номер телефона';

  @override
  String get enterPhoneBody => 'Мы отправим вам код подтверждения по SMS.';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get sendingCode => 'Отправка…';

  @override
  String codeSentTo(String phone) {
    return 'Код отправлен на $phone';
  }

  @override
  String get authPrivacyNote =>
      'Мы используем этот номер только для уведомлений о ваших бронированиях.';

  @override
  String get phoneNumber => 'Номер телефона';

  @override
  String get completeProfileTitle => 'Заполните профиль';

  @override
  String get completeProfileBody =>
      'Укажите ваше имя, чтобы мы знали, кто бронирует.';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get otpTitle => 'Введите код подтверждения';

  @override
  String get otpHint =>
      'Демо-код: 123456 (попробуйте 000000, чтобы увидеть просроченный код)';

  @override
  String get otpExpired =>
      'Срок действия этого кода истёк — отправьте повторно';

  @override
  String otpRemaining(Object count) {
    return 'Осталось запросов кода сегодня: $count';
  }

  @override
  String get otpLimitReached =>
      'Достигнут дневной лимит кодов. Попробуйте завтра.';

  @override
  String get resendCode => 'Отправить код повторно';

  @override
  String get stepPhone => 'Телефон';

  @override
  String get stepCode => 'Код';

  @override
  String get phoneHeadline => 'Ваш номер телефона?';

  @override
  String get phoneSubline => 'Мы отправим код для подтверждения.';

  @override
  String get selectCountry => 'Выберите страну';

  @override
  String get searchCountryHint => 'Поиск страны';

  @override
  String otpSentTo(String number) {
    return 'Отправлено на $number';
  }

  @override
  String otpRequestsLeft(int count) {
    return 'Осталось запросов сегодня: $count';
  }

  @override
  String get otpDailyLimit => 'Дневной лимит достигнут';

  @override
  String resendIn(String time) {
    return 'Повторная отправка через $time';
  }

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get countryEgypt => 'Египет';

  @override
  String get countryGermany => 'Германия';

  @override
  String get countryRussia => 'Россия';

  @override
  String get countryUk => 'Великобритания';

  @override
  String get countryFrance => 'Франция';

  @override
  String get countryItaly => 'Италия';

  @override
  String get countrySpain => 'Испания';

  @override
  String get writeReview => 'Написать отзыв';

  @override
  String get yourRating => 'Ваша оценка';

  @override
  String get yourReview => 'Ваш отзыв';

  @override
  String get reviewHint =>
      'Поделитесь подробностями вашего опыта, чтобы помочь другим путешественникам.';

  @override
  String get reviewSubmitted => 'Отзыв отправлен. Спасибо!';

  @override
  String get signInRequiredTitle => 'Войдите, чтобы продолжить';

  @override
  String get signInRequiredBody =>
      'Создайте аккаунт или войдите, чтобы использовать эту функцию.';

  @override
  String get notNow => 'Не сейчас';

  @override
  String get guestModeTitle => 'Вы просматриваете как гость';

  @override
  String get guestModeBody =>
      'Войдите, чтобы бронировать впечатления, сохранять избранное и управлять поездками.';

  @override
  String get splashLocation => 'Хургада, Красное море';
}
