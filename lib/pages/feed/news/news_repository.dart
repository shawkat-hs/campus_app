import 'dart:async';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

import 'package:campus_app/core/exceptions.dart';
import 'package:campus_app/core/failures.dart';
import 'package:campus_app/pages/feed/news/news_entity.dart';
import 'package:campus_app/pages/feed/news/news_datasource.dart';
import 'package:campus_app/utils/libre_translate_requests.dart';

class NewsRepository {
  final NewsDatasource newsDatasource;

  NewsRepository({required this.newsDatasource});

  /// Return a list of web news or a failure.
  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsfeed() {
    return getRemoteNewsfeedAndTranslate(translate: false);
  }

  Future<Either<Failure, List<NewsEntity>>> getRemoteNewsfeedAndTranslate({
    Locale appLocale = const Locale('de'),
    bool translate = true,
  }) async {
    try {
      final newsXml = await newsDatasource.getNewsfeedAsXml();
      final astaFeed = await newsDatasource.getAStAFeedAsJson();
      //final appFeed = await newsDatasource.getAppFeedAsJson();
      final newsXmlList = newsXml.findAllElements('item');

      final List<NewsEntity> entities = [];

      for (final e in astaFeed) {
        final entity = NewsEntity.fromJSON(json: e, copyright: ['© AStA']);
        final past = DateTime.now().subtract(const Duration(days: 21));

        if (entity.pubDate.compareTo(past) > 0) {
          entities.add(entity);
        }
      }

      //for (final e in appFeed) {
      //final entity = NewsEntity.fromJSON(json: e, copyright: ['© AStA']);
      //final past = DateTime.now().subtract(const Duration(days: 21));

      //if (entity.pubDate.compareTo(past) > 0) {
      //entities.add(entity);
      //}
      //}

      await Future.forEach(newsXmlList.map((news) => news), (XmlElement e) async {
        final link = e.getElement('link')!.innerText;
        final imageData = await newsDatasource.getImageDataFromNewsUrl(link);

        entities.add(NewsEntity.fromXML(e, imageData));
      });
      if (translate) {
        final translatedEntitiesFutures = entities.map((e) => translateNewsEntity(e, appLocale)).toList();
        final translatedEntities = await Future.wait(translatedEntitiesFutures);

        // Write entities to cache
        unawaited(newsDatasource
            .clearNewsEntityCache()
            .then((_) => newsDatasource.writeNewsEntitiesToCache(translatedEntities)));

        return Right(translatedEntities);
      } else {
        // write entities to cache
        unawaited(newsDatasource.clearNewsEntityCache().then((_) => newsDatasource.writeNewsEntitiesToCache(entities)));

        return Right(entities);
      }
    } catch (e) {
      switch (e.runtimeType) {
        case const (ServerException):
          return Left(ServerFailure());

        default:
          return Left(GeneralFailure());
      }
    }
  }

  /// Return a list of cached news or a failure.
  Either<Failure, List<NewsEntity>> getCachedNewsfeed() {
    try {
      final cachedNewsfeed = newsDatasource.readNewsEntitiesFromCach();
      return Right(cachedNewsfeed);
    } catch (e) {
      return Left(CachFailure());
    }
  }

  Future<NewsEntity> translateNewsEntity(NewsEntity entity, Locale appLocale) async {
    // Translate title
    final translatedTitle = await translateText(entity.title, 'auto', appLocale.languageCode);

    // Translate description
    final descriptionChunks = chunk(entity.description);
    final translatedDescriptionChunks = await Future.wait(
      descriptionChunks.map((chunk) {
        return translateText(chunk, 'auto', appLocale.languageCode);
      }),
    );
    final translatedDescription = translatedDescriptionChunks.join();

    // Translate content
    final contentChunks = chunk(entity.content);
    final translatedContentChunks = await Future.wait(
      contentChunks.map((chunk) {
        return translateText(chunk, 'auto', appLocale.languageCode);
      }),
    );
    final translatedContent = translatedContentChunks.join();

    final translatedEntity = NewsEntity(
      title: translatedTitle,
      description: translatedDescription,
      pubDate: entity.pubDate,
      imageUrl: entity.imageUrl,
      url: entity.url,
      content: translatedContent,
      author: entity.author,
      categoryIds: entity.categoryIds,
      copyright: entity.copyright,
      videoUrl: entity.videoUrl,
    );
    return translatedEntity;
  }

  List<String> chunk(String str) {
    final List<String> list = [];
    if (str.length <= 500) {
      list.add(str);
      return list;
    }
    const divisionIndex = 500;
    for (int i = 0; i < str.length; i += divisionIndex) {
      try {
        final tempString = str.substring(i, i + divisionIndex);
        list.add(tempString);
      } catch (e) {
        final tempString = str.substring(i);
        list.add(tempString);
        break;
      }
    }
    return list;
  }
}
