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
}
