import 'package:myputt/data/types/pdga_player_info.dart';
import 'package:web_scraper/web_scraper.dart';

class WebScraperService {
  Future<PDGAPlayerInfo?> getPDGAData(int? pdgaNumber) async {
    if (pdgaNumber != null) {
      final webScraper = WebScraper('https://www.pdga.com/');
      if (await webScraper.loadWebPage('player/$pdgaNumber').catchError((e) {
        print(e);
      })) {
        List<Map<String, dynamic>> nameHTML = webScraper
            .getElement('div.inside > div.panel-pane > div.pane-content', []);
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
        int? pdgaNum;
        String? name;
        String? location;
        String? classification;
        String? memberSince;
        int? rating;
        int? careerEvents;
        int? careerWins;
        double? careerEarnings;
        String? nextEvent;

        for (var item in nameHTML) {
          if (item['title'] != null) {
            final List<String> split = item['title'].split('#');
            print(split.first.split('\n').last);
            name = split.first.split('\n').last;
            print(split.last);
            if (int.tryParse(split.last) != null) {
              pdgaNum = int.parse(split.last);
            }
          }
          for (var item in locationHTML) {
            if (item['title'] != null) {
              final List<String> split = item['title'].split('Location: ');
              print(split.last);
              location = split.last;
            }
          }
          for (var item in classificationHTML) {
            if (item['title'] != null) {
              final List<String> split =
                  item['title'].split('Classification:  ');
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
              final List<String> split =
                  item['title'].split('Current Rating: ');
              print(split.last.split(' ').first);
              if (int.tryParse(split.last.split(' ').first) != null) {
                rating = int.parse(split.last.split(' ').first);
              }
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
              if (int.tryParse(split.last) != null) {
                careerWins = int.parse(split.last);
              }
            }
          }
          for (var item in careerEarningsHTML) {
            if (item['title'] != null) {
              final List<String> split =
                  item['title'].split('Career Earnings: ');
              final String rawString = split.last.split('\$').last;
              String commasRemoved = '';
              rawString.split('').forEach((ch) {
                if (ch != ',') {
                  commasRemoved += ch;
                }
              });
              print(commasRemoved);
              if (double.tryParse(commasRemoved) != null) {
                careerEarnings = double.parse(commasRemoved);
              }
            }
          }
          for (var item in nextEventHTML) {
            if (item['title'] != null) {
              final List<String> split = item['title'].split('Next Event: ');
              print(split.last);
              nextEvent = split.last;
            }
          }
          return PDGAPlayerInfo(
              pdgaNum: pdgaNum,
              name: name,
              careerWins: careerWins,
              location: location,
              classification: classification,
              memberSince: memberSince,
              rating: rating,
              careerEarnings: careerEarnings,
              careerEvents: careerEvents,
              nextEvent: nextEvent);
        }
      } else {
        print('pdga num is null');
        return null;
      }
    }
  }
}
