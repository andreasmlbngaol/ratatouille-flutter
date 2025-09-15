import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moprog/auth/data/auth/refresh_token_response/refresh_token_response.dart';
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
          debugPrint("ApiClient: Calling: ${baseUrl + options.path}");
          final accessToken = tokenManager.accessToken; // langsung ambil dari singleton
          if(accessToken != null) {
            options.headers["Authorization"] = "Bearer $accessToken";
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final opts = error.requestOptions;

          if(error.response?.statusCode == HttpStatus.unauthorized && opts.extra["retried"] != true) {
            debugPrint("ApiClient: onError: Unauthorized");

            opts.extra["retried"] = true;

            final refreshToken = tokenManager.refreshToken;
            if(refreshToken == null) {
              return handler.next(error);
            }

            try {
              debugPrint("ApiClient: Refreshing token");
              final res = await _refreshDio.post(
                "/auth/refresh",
                data: {
                  "refresh_token": refreshToken
                }
              );

              if(res.statusCode == 200) {
                final newAccessToken = res.data["access_token"];
                final newRefreshToken = res.data["refresh_token"];
                await tokenManager.saveTokens(
                    RefreshTokenResponse(
                        accessToken: newAccessToken,
                        refreshToken: newRefreshToken
                    )
                );

                opts.headers["Authorization"] = "Bearer $newAccessToken";
                final cloneReq = await dio.fetch(opts);
                return handler.resolve(cloneReq);
              }
            } on DioException catch (e) {
              debugPrint("ApiClient: DioException ${e.response?.statusCode}");
              await tokenManager.clearTokens();
              return handler.next(error);
            }
          }

          handler.next(error);
        }
      )
    );
  }
}