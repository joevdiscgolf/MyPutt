import 'package:myputt/data/types/pdga_player_info.dart';
import 'package:web_scraper/web_scraper.dart';

class WebScraperService {
  Future<PDGAPlayerInfo?> getPDGAData(int pdgaNumber) async {
    final webScraper = WebScraper('https://www.pdga.com/');
    if (await webScraper.loadWebPage('player/$pdgaNumber').catchError((e) {
      print(e);
    })) {
      List<Map<String, dynamic>> locationHTML =
          webScraper.getElement('li.location', []);
      List<Map<String, dynamic>> classificationHTML =
          webScraper.getElement('li.classification', []);
      List<Map<String, dynamic>> memberSinceHTML =
          webScraper.getElement('li.join-date', []);
      List<Map<String, dynamic>> ratingHTML =
          webScraper.getElement('li.current-rating', []);
      List<Map<String, dynamic>> careerEventsHTML =
          webScraper.getElement('li.career-events', []);
      List<Map<String, dynamic>> careerWinsHTML =
          webScraper.getElement('li.career-wins', []);
      List<Map<String, dynamic>> careerEarningsHTML =
          webScraper.getElement('li.career-earnings', []);
      List<Map<String, dynamic>> nextEventHTML =
          webScraper.getElement('li.next-event', []);

      // print('getPDGAData | $location\n');
      String? location;
      String? classification;
      String? memberSince;
      int? rating;
      int? careerEvents;
      int? careerWins;
      double? careerEarnings;
      String? nextEvent;

      for (var item in locationHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Location: ');
          print(split.last);
          location = split.last;
        }
      }
      for (var item in classificationHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Classification:  ');
          print(split.last);
          classification = split.last;
        }
      }
      for (var item in memberSinceHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Member Since: ');
          print(split.last);
          memberSince = split.last;
        }
      }
      for (var item in ratingHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Current Rating: ');
          print(split.last.split(' ').first);
          rating = int.parse(split.last.split(' ').first);
        }
      }
      for (var item in careerEventsHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Career Events: ');
          print(split.last);
          careerEvents = int.parse(split.last);
        }
      }
      for (var item in careerWinsHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Career Wins: ');
          print(split.last);
          careerWins = int.parse(split.last);
        }
      }
      for (var item in careerEarningsHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Career Earnings: ');
          print(split.last.split('\$').last);
          careerEarnings = double.parse(split.last.split('\$').last);
        }
      }
      for (var item in nextEventHTML) {
        if (item['title'] != null) {
          final List<String> split = item['title'].split('Next Event: ');
          print(split.last);
          nextEvent = split.last;
        }
      }
      if (location != null &&
          classification != null &&
          memberSince != null &&
          rating != null &&
          careerEvents != null &&
          careerWins != null &&
          careerEarnings != null &&
          nextEvent != null) {
        return PDGAPlayerInfo(
            careerWins: careerWins,
            location: location,
            classification: classification,
            memberSince: memberSince,
            rating: rating,
            careerEarnings: careerEarnings,
            careerEvents: careerEvents,
            nextEvent: nextEvent);
      } else {
        return null;
      }
    }
  }
}

// flutter: Location: Waterloo, Ontario, Canada
// flutter: Classification:  Professional
// flutter: Member Since: 2020
// flutter:  Current Rating: 984 (as of 12-Oct-2021)
// flutter: Career Events: 8
// flutter: Career Wins: 2
// flutter: Next Event: Foxwood Open
