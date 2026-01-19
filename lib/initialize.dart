import 'package:flutter/material.dart';
import 'package:qr_device/helpers/api_service.dart';
import 'package:qr_device/helpers/graphql_http_client.dart';
import 'package:qr_device/models/stamp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/secret.dart';

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: anonKey,
  );
  await Supabase.instance.client.auth.signInWithPassword(email: "haithamalaraj2004@gmail.com", password: "123456789h");
  final GraphqlHttpClient gqlClient = GraphqlHttpClient();
  stamps = await ApiService(gqlClient).fetchStamps();
  gqlClient.close();
}
