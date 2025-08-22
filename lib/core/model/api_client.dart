import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moprog/core/model/token_manager.dart';

class ApiClient {
  static const baseUrl = "https://moprog.sanalab.live/api";
  final Dio dio;
  final Dio _refreshDio;
  final TokenManager tokenManager;

  ApiClient({required this.tokenManager})
      : dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {"Content-Type": "application/json"},
      )
  ),
  _refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {"Content-Type": "application/json"},
    )
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint("ApiClient: onRequest...");
          final accessToken = tokenManager.accessToken; // langsung ambil dari singleton
          if(accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          debugPrint("ApiClient: onError...");
          final opts = error.requestOptions;

          if(error.response?.statusCode == HttpStatus.unauthorized && opts.extra["retried"] != true) {
            opts.extra["retried"] = true;

            final refreshToken = tokenManager.refreshToken;
            if(refreshToken == null) {
              return handler.next(error);
            }

            try {
              final res = await _refreshDio.post(
                "refresh",
                data: {
                  "refresh_token": refreshToken
                }
              );

              final newAccessToken = res.data["access_token"];
              await tokenManager.saveAccessToken(newAccessToken);

              opts.headers["Authorization"] = "Bearer $newAccessToken";
              final cloneReq = await dio.fetch(opts);
              return handler.resolve(cloneReq);
            } catch (e) {

              await tokenManager.removeTokens();
              return handler.next(error);
            }
          }

          handler.next(error);
        }
      )
    );
  }
}