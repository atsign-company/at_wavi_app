import 'dart:convert';

import 'package:at_wavi_app/model/twitter.dart';
import 'package:at_wavi_app/utils/constants.dart';
import 'package:at_wavi_app/view_models/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'nav_service.dart';

class TwitetrService {
  TwitetrService._();
  static final TwitetrService _instance = TwitetrService._();
  factory TwitetrService() => _instance;
  TwitterUser? twitterUser;
  // List<Tweet> tweetList = [];
  // will store twitter username and tweets for that username
  Map<String, List<Tweet>> searchedUserTweets = {};

  final String twitterEndpoint = 'https://api.twitter.com/2/';

  getTweets({String? searchedUsername}) async {
    String? username;
    if (searchedUsername != null) {
      username = searchedUsername;
    } else if (Provider.of<UserProvider>(NavService.navKey.currentContext!,
                    listen: false)
                .user !=
            null) {
      username = Provider.of<UserProvider>(NavService.navKey.currentContext!,
              listen: false)
          .user!
          .twitter
          .value;
    }
    // username = 'swyx';

    if (username == null) {
      return;
    }
    twitterUser = await getTwitterUser(username);
    if (twitterUser!.id != null) {
      // tweetList = await getTwitterRecentPosts(twitterUser!.id!);
      List<Tweet> tweetList = await getTwitterRecentPosts(twitterUser!.id!);
      searchedUserTweets[username] = tweetList;
    } else {
      searchedUserTweets[username] = [];
    }
  }

  Future<TwitterUser> getTwitterUser(String username) async {
    var headers = {
      'Authorization': 'Bearer ${MixedConstants.twitterBearerToken}',
    };
    var request = http.Request(
        'GET', Uri.parse('${twitterEndpoint}users/by/username/$username'));

    request.headers.addAll(headers);
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var user = jsonDecode(responseString);
      TwitterUser twitterUser;
      if (user['data'] != null) {
        twitterUser = TwitterUser.fromJson(user['data']);
      } else {
        twitterUser = TwitterUser(null, null, null);
      }
      return twitterUser;
    } else {
      var twitterUser = TwitterUser(null, null, null);
      return twitterUser;
    }
  }

  Future<List<Tweet>> getTwitterRecentPosts(String id) async {
    var tweetList = <Tweet>[];
    var headers = {
      'Authorization': 'Bearer ${MixedConstants.twitterBearerToken}',
    };
    var request =
        http.Request('GET', Uri.parse('${twitterEndpoint}users/$id/tweets'));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      var tweets = jsonDecode(responseString);
      if (tweets['data'] != null) {
        tweets['data'].forEach((el) {
          tweetList.add(Tweet.fromJson(el)!);
        });
      }
      return tweetList;
    } else {
      return [];
    }
  }
}
