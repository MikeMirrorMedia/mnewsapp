import 'dart:convert';

import 'package:tv/helpers/apiBaseHelper.dart';
import 'package:tv/helpers/apiConstants.dart';
import 'package:tv/models/graphqlBody.dart';
import 'package:tv/models/storyListItemList.dart';

abstract class TabStoryListRepos {
  Future<StoryListItemList> fetchStoryList({bool withCount = true});
  Future<StoryListItemList> fetchNextPage({int loadingMorePage = 20});
  Future<StoryListItemList> fetchStoryListByCategorySlug(String slug);
  Future<StoryListItemList> fetchNextPageByCategorySlug(String slug, {int loadingMorePage = 20});
  Future<StoryListItemList> fetchPopularStoryList();
}

class TabStoryListServices implements TabStoryListRepos{
  ApiBaseHelper _helper = ApiBaseHelper();
  String postStyle;
  int skip = 0, first = 20;
  final String query = 
  """
  query (
    \$where: PostWhereInput,
    \$skip: Int,
    \$first: Int,
    \$withCount: Boolean!,
  ) {
    allPosts(
      where: \$where, 
      skip: \$skip, 
      first: \$first, 
      sortBy: [ publishTime_DESC ]
    ) {
      slug
      name
      heroImage {
        urlMobileSized
      }
    }
    _allPostsMeta(
      where: \$where,
    ) @include(if: \$withCount) {
      count
    }
  }
  """;
  
  TabStoryListServices({String postStyle, int first = 20}) {
    this.postStyle = postStyle;
    this.first = first;
  }

  @override
  Future<StoryListItemList> fetchStoryList({bool withCount = true}) async {
    Map<String, dynamic> variables = {
      "where": {
        "state": "published",
        "style_not_in": ["wide", "projects", "script", "campaign", "readr"],
      },
      "skip": skip,
      "first": first,
      'withCount': withCount,
    };

    if(postStyle != null) {
      variables["where"].addAll({"style": postStyle});
    }

    GraphqlBody graphqlBody = GraphqlBody(
      operationName: null,
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      graphqlApi,
      jsonEncode(graphqlBody.toJson()),
      headers: {
        "Content-Type": "application/json"
      }
    );

    StoryListItemList newsList = StoryListItemList.fromJson(jsonResponse['data']['allPosts']);
    if(withCount) {
      newsList.allStoryCount = jsonResponse['data']['_allPostsMeta']['count'];
    }

    return newsList;
  }

  @override
  Future<StoryListItemList> fetchNextPage({int loadingMorePage = 20}) async{
    skip = skip + first;
    first = loadingMorePage;
    return await fetchStoryList();
  }

  @override
  Future<StoryListItemList> fetchStoryListByCategorySlug(String slug, {bool withCount = true}) async {
    Map<String, dynamic> variables = {
      "where": {
        "state": "published",
        "style_not_in": ["wide", "projects", "script", "campaign", "readr"],
        "categories_some": {
          "slug": slug
        },
      },
      "skip": skip,
      "first": first,
      'withCount': withCount,
    };

    if(postStyle != null) {
      variables["where"].addAll({"style": postStyle});
    }
    
    GraphqlBody graphqlBody = GraphqlBody(
      operationName: null,
      query: query,
      variables: variables,
    );

    final jsonResponse = await _helper.postByUrl(
      graphqlApi,
      jsonEncode(graphqlBody.toJson()),
      headers: {
        "Content-Type": "application/json"
      }
    );

    StoryListItemList newsList = StoryListItemList.fromJson(jsonResponse['data']['allPosts']);
    if(withCount) {
      newsList.allStoryCount = jsonResponse['data']['_allPostsMeta']['count'];
    }

    return newsList;
  }

  @override
  Future<StoryListItemList> fetchNextPageByCategorySlug(String slug, {int loadingMorePage = 20}) async{
    skip = skip + first;
    first = loadingMorePage;
    return await fetchStoryListByCategorySlug(slug);
  }

  @override
  Future<StoryListItemList> fetchPopularStoryList() async{
    String jsonUrl;
    if(postStyle == 'videoNews') {
      jsonUrl = videoPopularListUrl;
    } else {
      jsonUrl = newsPopularListUrl;
    }

    final jsonResponse = await _helper.getByUrl(jsonUrl);
    StoryListItemList storyListItemList = StoryListItemList.fromJson(jsonResponse['report']);
    return storyListItemList;
  }
}
